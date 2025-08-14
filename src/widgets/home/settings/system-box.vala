namespace Protonium.Widgets.Settings {
    public class SystemBox : Gtk.Box {
        public SystemBox () {
            Object (orientation: Gtk.Orientation.VERTICAL, spacing: 15);

            var title_label = new Gtk.Label (_("System")) {
                css_classes = { "title-label" },
            };

            var system = Utils.System.get_instance ();

            var hostname_label = new Gtk.Label (system.hostname);

            var hostname_row = new Adw.ActionRow () {
                title = _("Hostname"),
            };
            hostname_row.add_suffix (hostname_label);

            var os_name_label = new Gtk.Label (system.os_name);

            var os_name_row = new Adw.ActionRow () {
                title = _("OS Name"),
                css_classes = { "darker-row" },
            };
            os_name_row.add_suffix (os_name_label);

            var kernel_version_label = new Gtk.Label (system.kernel_version);

            var kernel_version_row = new Adw.ActionRow () {
                title = _("Kernel Version"),
            };
            kernel_version_row.add_suffix (kernel_version_label);

            var bios_version_label = new Gtk.Label (system.bios_version);

            var bios_version_row = new Adw.ActionRow () {
                title = _("BIOS Version"),
                css_classes = { "darker-row" },
            };
            bios_version_row.add_suffix (bios_version_label);

            var about_group = new Adw.PreferencesGroup () {
                title = _("About"),
            };
            about_group.add (hostname_row);
            about_group.add (os_name_row);
            about_group.add (kernel_version_row);
            about_group.add (bios_version_row);

            var cpu_vendor_label = new Gtk.Label (system.cpu.vendor);

            var cpu_vendor_row = new Adw.ActionRow () {
                title = _("CPU Vendor"),
            };
            cpu_vendor_row.add_suffix (cpu_vendor_label);

            var cpu_name_label = new Gtk.Label (system.cpu.name);

            var cpu_name_row = new Adw.ActionRow () {
                title = _("CPU Name"),
                css_classes = { "darker-row" },
            };
            cpu_name_row.add_suffix (cpu_name_label);

            var cpu_frequency_label = new Gtk.Label (system.cpu.frequency);

            var cpu_frequency_row = new Adw.ActionRow () {
                title = _("CPU Frequency"),
            };
            cpu_frequency_row.add_suffix (cpu_frequency_label);

            var cpu_physical_cores_label = new Gtk.Label (system.cpu.physical_cores);

            var cpu_physical_cores_row = new Adw.ActionRow () {
                title = _("CPU Phyisical Cores"),
                css_classes = { "darker-row" },
            };
            cpu_physical_cores_row.add_suffix (cpu_physical_cores_label);

            var cpu_logical_cores_label = new Gtk.Label (system.cpu.logical_cores);

            var cpu_logical_cores_row = new Adw.ActionRow () {
                title = _("CPU Logical Cores"),
            };
            cpu_logical_cores_row.add_suffix (cpu_logical_cores_label);

            var ram_size_label = new Gtk.Label (system.ram_size);

            var ram_size_row = new Adw.ActionRow () {
                title = _("RAM Size"),
                css_classes = { "darker-row" },
            };
            ram_size_row.add_suffix (ram_size_label);

            var hardware_group = new Adw.PreferencesGroup () {
                title = _("Hardware"),
            };
            hardware_group.add (cpu_vendor_row);
            hardware_group.add (cpu_name_row);
            hardware_group.add (cpu_frequency_row);
            hardware_group.add (cpu_physical_cores_row);
            hardware_group.add (cpu_logical_cores_row);
            hardware_group.add (ram_size_row);

            for (int i = 0; i < system.gpus.size; i++) {
                var gpu = system.gpus[i];

                var video_card_label = new Gtk.Label (gpu.name);

                var video_card_row = new Adw.ActionRow () {
                    title = _("Video Card"),
                };
                video_card_row.add_suffix (video_card_label);

                if (i > 0)
                    video_card_row.add_css_class ("darker-row");

                var video_driver_label = new Gtk.Label (gpu.driver);

                var video_driver_row = new Adw.ActionRow () {
                    title = _("Video Driver"),
                };
                video_driver_row.add_suffix (video_driver_label);

                if (i == 0)
                    video_driver_row.add_css_class ("darker-row");

                var vram_size_label = new Gtk.Label (gpu.vram);

                var vram_size_row = new Adw.ActionRow () {
                    title = _("VRAM Size"),
                };
                vram_size_row.add_suffix (vram_size_label);

                if (i > 0)
                    vram_size_row.add_css_class ("darker-row");

                hardware_group.add (video_card_row);
                hardware_group.add (video_driver_row);
                hardware_group.add (vram_size_row);
            }

            append (title_label);
            append (about_group);
            append (hardware_group);
            add_css_class ("system-box");
        }
    }
}