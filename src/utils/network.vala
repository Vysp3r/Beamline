namespace Protonium.Utils {
    public class Network : Object {
        static Network? instance = null;

        NM.Client client = null;
        public Gee.ArrayList<Device> devices;
        public Device last_connected_device;
        public NM.AccessPoint last_access_point;
        public ulong last_access_point_signal_id;

        Network() {
            try {
                client = new NM.Client();

                devices = new Gee.ArrayList<Device> ();

                last_connected_device = null;

                refresh_devices ();

                client.notify["devices"].connect (refresh_devices);
            } catch (Error e) {
                warning (e.message);
            }
        }

        void refresh_devices () {
            foreach (var nm_device in client.get_devices ()) {
                if (!(nm_device is NM.DeviceWifi || nm_device is NM.DeviceEthernet) || devices.any_match ((pred) => pred.self == nm_device))
                    continue;

                var device = new Device () {
                    self = nm_device,
                    signal_connected_top_bar = false,
                    signal_connected_internet_box = false,
                };

                devices.add (device);
            }
        }

        public class Device {
            public NM.Device self;
            public bool signal_connected_top_bar;
            public bool signal_connected_internet_box;
        }

        public struct IPv4Info {
            public string address;
            public string subnet_mask;
        }

        public struct ConnectionInfo {
            public string name;
            public string mac;
            public string method;
            public IPv4Info[] ipv4;
            public string[] ipv6;
        }

        public ConnectionInfo get_connection_info (NM.ActiveConnection active_connection) {
            var connection_info = ConnectionInfo ();

            connection_info.name = active_connection.get_id();

            var connection = active_connection.get_connection ();

            var setting_ip4config= connection.get_setting_ip4_config ();
            string ipv4_method = setting_ip4config != null ? setting_ip4config.method : "unknown";
            connection_info.method = ipv4_method == "auto" ? "DHCP" : "Static/Other";

            foreach (var device in active_connection.get_devices()) {
                connection_info.mac = device.get_hw_address ();

                var ip4config = device.get_ip4_config();
                
                if (ip4config != null) {
                    var addresses = ip4config.get_addresses();

                    connection_info.ipv4 = new IPv4Info[addresses.length];

                    for (var i = 0; i < addresses.length; i++) {
                        connection_info.ipv4[i] = IPv4Info ();

                        connection_info.ipv4[i].address = addresses[i].get_address ();

                        uint32 prefix = addresses[i].get_prefix();

                        connection_info.ipv4[i].subnet_mask = prefix_to_netmask(prefix);
                    }
                }

                var ip6config = device.get_ip6_config ();

                if (ip6config != null) {
                    var addresses = ip6config.get_addresses();
                    
                    connection_info.ipv6 = new string[addresses.length];

                    for (var i = 0; i < addresses.length; i++) {
                        connection_info.ipv6[i] = addresses[i].get_address ();
                    }
                }

                break;
            }

            return connection_info;
        }

        string prefix_to_netmask (uint32 prefix) {
            int64 mask = 0xffffffff << (32 - prefix);
            return "%lld.%d.%d.%d".printf(
                (mask >> 24) & 0xff,
                (mask >> 16) & 0xff,
                (mask >> 8) & 0xff,
                mask & 0xff
            );
        }

        public static Network get_instance() {
            if (instance == null)
                instance = new Network();

            return instance;
        }
    }
}