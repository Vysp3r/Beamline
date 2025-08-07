namespace Protonium.Utils {
    public class System {
        static System? instance = null;

        public string hostname;
        public string os_name;
        public string kernel_version;
        public string bios_version;
        public CPU cpu;
        public string ram_size;
        public Gee.ArrayList<GPU> gpus;
        public Battery battery;
        Xdp.Portal portal;

        System () {
            hostname = Environment.get_host_name ();
            os_name = Environment.get_os_info ("PRETTY_NAME");
            kernel_version = get_kernel_version ();
            bios_version = get_bios_version ();
            cpu = new CPU ();
            ram_size = get_ram_size ();
            gpus = GPU.get_gpus ();
            battery = new Battery ();
            portal = new Xdp.Portal ();
        }        

        string get_kernel_version () {
            try {
                string[] argv = {"uname", "-r"};
                string output;
                int status;
                Process.spawn_sync(
                    null,
                    argv,
                    null,
                    SpawnFlags.SEARCH_PATH,
                    null,
                    out output,
                    null,
                    out status
                );
                if (status == 0) {
                    return output.strip();
                } else {
                    warning ("Failed to get kernel version (status %d)\n", status);
                }
            } catch (Error e) {
                warning (e.message);
            }
            return _("Unknown");
        }

        string get_bios_version () {
            string path = "/sys/class/dmi/id/bios_version";
            try {
                string bios_version;
                    
                FileUtils.get_contents(path, out bios_version);
                    
                return bios_version.strip();
            } catch (Error e) {
                warning (e.message);
            }
            return _("Unknown");
        }

        string get_ram_size () {
            try {
                string contents;
                    
                FileUtils.get_contents("/proc/meminfo", out contents);
                foreach (string line in contents.split("\n")) {
                    if (line.has_prefix("MemTotal:")) {
                        string[] parts = line.split(":", 2);
                        if (parts.length == 2) {
                            string value_kb_str = parts[1].strip().split(" ")[0];
                            ulong value_kb = ulong.parse(value_kb_str);
                            double value_gb = value_kb / 1024.0 / 1024.0;
                            return "%.2f GB".printf (value_gb);
                        }
                    }
                }
            } catch (Error e) {
                warning (e.message);
            }
            return _("Unknown");
        }

        public class CPU {
            public string vendor;
            public string name;
            public string frequency;
            public string physical_cores;
            public string logical_cores;

            public CPU () {
                vendor = get_vendor ();
                name = get_name ();
                frequency = get_frequency ();
                physical_cores = get_physical_cores ();
                logical_cores = "%u".printf (GLib.get_num_processors ());
            }

            string get_vendor () {
                try {
                    string cpuinfo;
                    
                    FileUtils.get_contents("/proc/cpuinfo", out cpuinfo);

                    foreach (string line in cpuinfo.split("\n")) {
                        if (line.has_prefix("vendor_id")) {
                            string[] parts = line.split(":", 2);
                            if (parts.length == 2) {
                                return parts[1].strip();
                            }
                        }
                    }
                } catch (Error e) {
                    warning (e.message);
                }

                return _("Unknown");
            }

            string get_name () {
                try {
                    string cpuinfo;
                    
                    FileUtils.get_contents("/proc/cpuinfo", out cpuinfo);

                    foreach (string line in cpuinfo.split("\n")) {
                        if (line.has_prefix("model name")) {
                            string[] parts = line.split(":", 2);
                            if (parts.length == 2) {
                                return parts[1].strip();
                            }
                        }
                    }
                } catch (Error e) {
                    warning (e.message);
                }

                return _("Unknown");
            }

            string get_frequency () {
                try {
                    string cpuinfo_max_freq;
                    
                    FileUtils.get_contents("/sys/devices/system/cpu/cpu0/cpufreq/cpuinfo_max_freq", out cpuinfo_max_freq);

                    double hz;
                    bool parsed = double.try_parse(cpuinfo_max_freq.strip(), out hz);

                    return parsed ? "%.2f GHz".printf (hz / 1000000.0) : _("Unknown");
                } catch (Error e) {
                    warning (e.message);
                }

                return _("Unknown");
            }

            string get_physical_cores () {
                try {
                    string contents;
                    
                    FileUtils.get_contents("/proc/cpuinfo", out contents);

                    var unique_cores = new HashTable<string, bool>(str_hash, str_equal);

                    string physical_id = "";
                    string core_id = "";

                    foreach (string line in contents.split("\n")) {
                        if (line.has_prefix("physical id")) {
                            physical_id = line.split(":", 2)[1].strip();
                        } else if (line.has_prefix("core id")) {
                            core_id = line.split(":", 2)[1].strip();
                        } else if (line.strip() == "") {
                            if (physical_id != "" && core_id != "") {
                                string key = "%s-%s".printf(physical_id, core_id);
                                unique_cores.insert(key, true);
                            }
                            physical_id = "";
                            core_id = "";
                        }
                    }

                    return unique_cores.size ().to_string ();
                } catch (Error e) {
                    warning (e.message);
                }

                return _("Unknown");
            }
        }

        public class GPU {
            public string name;
            public string driver;
            public string vram;

            public static Gee.ArrayList<GPU>?  get_gpus () {
                try {
                    string[] argv = {"lspci", "-k"};
                    string output;
                    int status;

                    Process.spawn_sync(
                        null,
                        argv,
                        null,
                        SpawnFlags.SEARCH_PATH,
                        null,
                        out output,
                        null,
                        out status
                    );

                    if (status == 0) {
                        var gpus = new Gee.ArrayList<GPU> ();
                    
                        GPU? gpu = null;

                        foreach (string line in output.split("\n")) {
                            if (line.contains("VGA compatible controller") || line.contains("3D controller")) {
                                gpu = new GPU ();

                                gpu.name = line.split ("controller:", 2)[1].strip ();
                                
                                if (gpu.name.down ().contains ("nvidia")) {
                                    gpu.vram = get_nvidia_gpu_vram ();
                                    gpu.driver = get_nvidia_gpu_driver ();
                                } else {
                                    gpu.vram = _("Unknown");
                                    gpu.driver = _("Unknown");
                                }

                                if (!gpus.any_match ((pred) => str_equal (pred.name, gpu.name)))
                                    gpus.add (gpu);
                            }
                        }
                        
                        return gpus;
                    } else {
                        warning ("lspci failed with status %d", status);
                    }
                } catch (Error e) {
                    warning (e.message);
                }

                return null;
            }

            static string get_nvidia_gpu_vram () {
                try {
                    string[] argv = {"nvidia-smi", "--query-gpu=memory.total", "--format=csv,noheader,nounits"};
                    string output;
                    int status;

                    Process.spawn_sync(
                        null,
                        argv,
                        null,
                        SpawnFlags.SEARCH_PATH,
                        null,
                        out output,
                        null,
                        out status
                    );
                    
                    if (status == 0) {
                        int mb;

                        bool parsed = int.try_parse (output.strip (), out mb);

                        if (parsed)
                            return "%.0f GB".printf (mb / 1000);
                    }
                } catch (Error e) {
                    warning (e.message);
                }

                return _("Unknown");
            }

            static string get_nvidia_gpu_driver () {
                try {
                    string[] argv = {"nvidia-smi", "--query-gpu=driver_version", "--format=csv,noheader"};
                    string output;
                    int status;

                    Process.spawn_sync(
                        null,
                        argv,
                        null,
                        SpawnFlags.SEARCH_PATH,
                        null,
                        out output,
                        null,
                        out status
                    );
                    
                    if (status == 0) {
                        return output.strip ();
                    }
                } catch (Error e) {
                    warning (e.message);
                }

                return _("Unknown");
            }
        }

        public class Sound {
            public enum Type {
                SINK,
                SOURCE,
            }

            public static uint get_volume (Type type) {
                try {
                    string[] argv = {"pactl", "get-%s-volume".printf (type == Type.SINK ? "sink" : "source"), "@DEFAULT_%s@".printf (type == Type.SINK ? "SINK" : "SOURCE")};
                    string output;
                    int status;

                    Process.spawn_sync(
                        null,
                        argv,
                        null,
                        SpawnFlags.SEARCH_PATH,
                        null,
                        out output,
                        null,
                        out status
                    );

                    var lines = output.split("\n");
                    foreach (var line in lines) {
                        if (line.contains("Volume:")) {
                            var tokens = line.split(" ");
                            foreach (var token in tokens) {
                                if (token.contains("%")) {
                                    uint volume;

                                    bool parsed = uint.try_parse (token.replace ("%", ""), out volume);

                                    if (parsed)
                                        return volume;
                                }
                            }
                        }
                    }
                } catch (Error e) {
                    warning ("Failed to get %s volume: %s", type == Type.SINK ? "sink" : "source", e.message);
                }

                return 0;
            }

            public static bool set_volume (Type type, uint volume) {
                try {
                    string[] argv = {"pactl", "set-sink-volume", "@DEFAULT_SINK@", "%u".printf (volume) + "%"};
                    int status;

                    Process.spawn_sync(
                        null,
                        argv,
                        null,
                        SpawnFlags.SEARCH_PATH,
                        null,
                        null,
                        null,
                        out status
                    );

                    return status == 0;
                } catch (Error e) {
                    warning ("Failed to set sink volume: %s", e.message);
                }

                return false;
            }
        }

        public class Battery {
            public Up.Device device = null;

            public Battery () {
                Up.Client client = new Up.Client();

                foreach (Up.Device device in client.get_devices()) {
                    if (device.kind == Up.DeviceKind.BATTERY && device.power_supply) {
                        this.device = device;
                        break;
                    }
                }
            }
        }

        public static System get_instance() {
            if (instance == null)
                instance = new System();

            return instance;
        }

        public void open_uri (Gtk.Window window, string uri, Xdp.OpenUriFlags flags = Xdp.OpenUriFlags.NONE) {
            Xdp.Parent parent = Xdp.parent_new_gtk (window);

            portal.open_uri.begin (
                parent,
                uri,
                flags,
                null,
                null
            );
        }
    }
}