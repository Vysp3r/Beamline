namespace Protonium.Widgets {
    public class TopBar : Gtk.Box {
        bool search_entry_has_focus;

        Window window;
        Gtk.Entry search_entry;
        Gtk.Button internet_button;
        Gtk.Label battery_percentage_label;
        Gtk.Image battery_icon;
        Gtk.Label time_label;

        public TopBar (Window window) {
            Object (
                hexpand: true,
                valign: Gtk.Align.START,
                orientation: Gtk.Orientation.HORIZONTAL,
                spacing: 0
            );

            this.window = window;

            search_entry = new Gtk.Entry () {
                hexpand = true,
                focus_on_click = true,
            };
            search_entry.notify["has-focus"].connect(search_entry_focused);
            search_entry.notify["text"].connect(search_entry_text_changed);

            internet_button = new Gtk.Button () {
                focusable = true,
            };
            internet_button.clicked.connect (internet_button_clicked);

            refresh_network_devices ();

            Utils.Network.get_instance ().notify["devices"].connect (refresh_network_devices);

            append (search_entry);
            append (internet_button);

            var system = Utils.System.get_instance ();

            if (system.battery.device != null) {
                battery_percentage_label = new Gtk.Label (null);

                battery_icon = new Gtk.Image ();

                var battery_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 15);
                battery_box.append (battery_percentage_label);
                battery_box.append (battery_icon);

                Application.settings.changed["show-battery-percentage"].connect (show_battery_percentage_changed);

                var battery_button = new Gtk.Button () {
                    child = battery_box,
                    focusable = true,
                };
                battery_button.clicked.connect (battery_button_clicked);

                system.battery.device.notify["percentage"].connect (battery_percentage_changed);
                system.battery.device.notify["state"].connect (battery_state_changed);

                show_battery_percentage_changed ();
                battery_percentage_changed ();
                battery_state_changed ();

                append (battery_button);
            }

            time_label = new Gtk.Label (null);

            Application.settings.changed["twenty-four-hour-clock"].connect (update_time_label);

            update_time_label ();

            Timeout.add_seconds (60 - (new DateTime.now_local()).get_second (), () => {
                update_time_label ();

                Timeout.add_seconds(60, () => {
                    update_time_label ();

                    return true;
                });

                return false;
            });

            append (time_label);
            add_css_class ("top-box");
        }

        void search_entry_focused () {
            search_entry_has_focus = !search_entry_has_focus;
            
            if (search_entry_has_focus) {
                search_entry.set_icon_from_icon_name (Gtk.EntryIconPosition.PRIMARY, "search-2-symbolic");
                search_entry.set_icon_from_icon_name (Gtk.EntryIconPosition.SECONDARY, null);
            } else {
                search_entry.set_icon_from_icon_name (Gtk.EntryIconPosition.SECONDARY, "search-2-symbolic");
                search_entry.set_icon_from_icon_name (Gtk.EntryIconPosition.PRIMARY, null);
            }

            search_entry.set_placeholder_text (search_entry_has_focus ? _("Search for games") : null);
        }

        void search_entry_text_changed () {
            window.search_text = search_entry.get_text ();

            if (window.bar_main_box.menu_main_box.current_view != Menu.MainBox.View.NONE)
                window.bar_main_box.menu_main_box.set_view (Menu.MainBox.View.NONE);
        }

        void internet_button_clicked () {
            window.bar_main_box.menu_main_box.set_view (Menu.MainBox.View.NONE);
 
            window.set_view (Window.View.SETTINGS);

            window.settings_main_box.set_view (Settings.MainBox.View.INTERNET);
        }

        void battery_button_clicked () {
            window.bar_main_box.menu_main_box.set_view (Menu.MainBox.View.NONE);

            window.set_view (Window.View.SETTINGS);

            window.settings_main_box.set_view (Settings.MainBox.View.POWER);
        }

        void battery_percentage_changed () {
            var system = Utils.System.get_instance ();

            battery_percentage_label.set_label ("%.0f%%".printf (system.battery.device.percentage));

            switch (system.battery.device.state) {
                case Up.DeviceState.DISCHARGING:
                    if (system.battery.device.percentage > 90)
                        battery_icon.set_from_icon_name ("battery-4-symbolic");
                    else if (system.battery.device.percentage > 75)
                        battery_icon.set_from_icon_name ("battery-3-symbolic");
                    else if (system.battery.device.percentage > 50)
                        battery_icon.set_from_icon_name ("battery-2-symbolic");
                    else if (system.battery.device.percentage > 25)
                        battery_icon.set_from_icon_name ("battery-1-symbolic");
                    else
                        battery_icon.set_from_icon_name ("battery-symbolic");
                    break;
                default:
                    break;
            }
        }

        void battery_state_changed () {
            switch (Utils.System.get_instance ().battery.device.state) {
                case Up.DeviceState.FULLY_CHARGED:
                case Up.DeviceState.CHARGING:
                    battery_icon.set_from_icon_name ("battery-charging-symbolic");
                    break;
                default:
                    battery_percentage_changed ();
                    break;
            }
        }

        void show_battery_percentage_changed () {
            battery_percentage_label.set_visible (Application.settings.get_boolean ("show-battery-percentage"));
        }

        void update_time_label () {
            var now = new DateTime.now_local();

            time_label.set_text(Application.settings.get_boolean ("twenty-four-hour-clock") ? now.format("%H:%M") : now.format("%I:%M %p"));
        }

        void refresh_network_devices () {
            var network = Utils.Network.get_instance ();

            bool found_active_connection = false;

            if (network.last_access_point != null && network.last_access_point_signal_id != -1) {
                network.last_access_point.disconnect (network.last_access_point_signal_id);

                network.last_access_point = null;
                    
                network.last_access_point_signal_id = -1;
            }

            foreach (var device in network.devices) {
                if (!device.signal_connected_top_bar) {
                    device.self.notify["state"].connect(() => update_internet_button (device));

                    device.signal_connected_top_bar = true;
                }

                if (device.self.get_active_connection () == null)
                    continue;
                
                network.last_connected_device = device;

                update_internet_button (device);

                found_active_connection = true;
            }

            if (found_active_connection)
                return;

            if (Utils.Network.get_instance ().last_connected_device?.self is NM.DeviceEthernet)
                internet_button.set_icon_name ("network-off-symbolic");
            else
                internet_button.set_icon_name ("wifi-off-symbolic");
        }

        void update_internet_button (Utils.Network.Device device) {
            var network = Utils.Network.get_instance ();

            if (device.self is NM.DeviceWifi) {
                switch (device.self.state) {
                    case NM.DeviceState.ACTIVATED:
                        var wifi_device = device.self as NM.DeviceWifi;

                        var active_ap = wifi_device.get_active_access_point();

                        if (active_ap != network.last_access_point) {
                            wifi_cleanup ();
                        }

                        if (active_ap == null) {
                            internet_button.set_icon_name ("wifi-off-symbolic");
                        } else {
                            network.last_access_point = active_ap;
                            
                            network.last_access_point_signal_id = active_ap.notify["strength"].connect (() => update_wifi (active_ap));

                            update_wifi (active_ap);
                        }
                        break;
                    default:
                        wifi_cleanup ();

                        internet_button.set_icon_name ("wifi-off-symbolic");
                        break;
                }
            }

            if (device.self is NM.DeviceEthernet) {
                switch (device.self.state) {
                    case NM.DeviceState.ACTIVATED:
                        internet_button.set_icon_name ("network-symbolic");
                        break;
                    default:
                        internet_button.set_icon_name ("network-off-symbolic");
                        break;
                }
            }
        }

        void wifi_cleanup () {
            var network = Utils.Network.get_instance ();

            if (network.last_access_point != null && network.last_access_point_signal_id != -1) {
                network.last_access_point.disconnect (network.last_access_point_signal_id);

                network.last_access_point = null;
                    
                network.last_access_point_signal_id = -1;
            }
        }

        void update_wifi (NM.AccessPoint active_ap) {
            if (active_ap.strength > 75)
                internet_button.set_icon_name ("wifi-4-symbolic");
            else if (active_ap.strength > 50)
                internet_button.set_icon_name ("wifi-3-symbolic");
            else if (active_ap.strength > 25)
                internet_button.set_icon_name ("wifi-2-symbolic");
            else
                internet_button.set_icon_name ("wifi-1-symbolic");
        }
    }
}