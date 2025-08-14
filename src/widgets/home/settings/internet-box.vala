namespace Protonium.Widgets.Settings {
    public class InternetBox : Gtk.Box {
        Window window;
        Adw.PreferencesGroup networks_group;
        Gee.ArrayList<Adw.ActionRow> network_rows;

        public InternetBox (Window window) {
            Object (orientation: Gtk.Orientation.VERTICAL, spacing: 15);

            this.window = window;

            network_rows = new Gee.ArrayList<Adw.ActionRow> ();

            var title_label = new Gtk.Label (_("Internet")) {
                css_classes = { "title-label" },
            };

            networks_group = new Adw.PreferencesGroup () {
                title = _("Active networks"),
            };

            notify["parent"].connect (update_active_networks);

            Utils.Network.get_instance ().notify["devices"].connect (update_network_devices);

            update_network_devices ();

            append (title_label);
            append (networks_group);
            add_css_class ("internet-box");
        }

        void update_network_devices () {
            Utils.Network.get_instance ().devices.filter ((pred) => !pred.signal_connected_internet_box).foreach ((device) => {
                device.self.notify["state"].connect(update_active_networks);

                return true;
            });
        }

        void update_active_networks () {
            network_rows.foreach ((row) => {
                networks_group.remove (row);

                return true;
            });

            network_rows.clear ();

            var network = Utils.Network.get_instance ();

            foreach (var device in network.devices) {
                var active_connection = device.self.get_active_connection ();

                if (active_connection == null)
                    continue;

                var connection_info = network.get_connection_info (active_connection);

                var row = new Adw.ActionRow () {
                    title = connection_info.name,
                    activatable = true,
                };
                row.activated.connect (() => network_row_activated (connection_info));

                network_rows.add (row);
                    
                networks_group.add (row);
            }
        }

        void network_row_activated (Utils.Network.ConnectionInfo connection_info) {
            window.home_main_box.menu_main_box.connection_box.load (connection_info);

            window.home_main_box.menu_main_box.set_view (Menu.MainBox.View.CONNECTION);
        }
    }
}