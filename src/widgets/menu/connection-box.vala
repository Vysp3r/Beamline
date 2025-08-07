namespace Protonium.Widgets.Menu {
    public class ConnectionBox : Gtk.Box {
        Gee.ArrayList<Adw.ActionRow> ipv4_rows;
        Gee.ArrayList<Adw.ActionRow> ipv6_rows;

        Gtk.Label name_label;
        Gtk.Label status_label;
        Gtk.Label mac_label;
        Gtk.Label ip_assignment_label;
        Adw.PreferencesGroup ipv4_group;
        Adw.PreferencesGroup ipv6_group;

        public ConnectionBox () {
            Object (
                valign: Gtk.Align.CENTER,
                halign: Gtk.Align.CENTER,
                spacing: 15,
                orientation: Gtk.Orientation.VERTICAL,
                width_request: 750
            );

            ipv4_rows = new Gee.ArrayList<Adw.ActionRow> ();

            ipv6_rows = new Gee.ArrayList<Adw.ActionRow> ();

            name_label = new Gtk.Label (null) {
                css_classes = { "title-label" },
            };

            status_label = new Gtk.Label (null);

            var status_row = new Adw.ActionRow () {
                title = _("Status"),
            };
            status_row.add_suffix (status_label);

            mac_label = new Gtk.Label (null);

            var mac_row = new Adw.ActionRow () {
                title = _("MAC Address"),
            };
            mac_row.add_suffix (mac_label);

            var group = new Adw.PreferencesGroup ();
            group.add (status_row);
            group.add (mac_row);

            ip_assignment_label = new Gtk.Label (null);

            var ip_assignment_row = new Adw.ActionRow () {
                title = _("IP Address Assignment"),
            };
            ip_assignment_row.add_suffix (ip_assignment_label);

            ipv4_group = new Adw.PreferencesGroup () {
                title = _("IPv4 Addresses"),
            };
            ipv4_group.add (ip_assignment_row);

            ipv6_group = new Adw.PreferencesGroup () {
                title = _("IPv6 Addresses"),
            };

            append (name_label);
            append (group);
            append (ipv4_group);
            append (ipv6_group);
            add_css_class ("connection-box");
        }

        public void load (Utils.Network.ConnectionInfo connection_info) {
            status_label.set_label (_("Connected"));

            name_label.set_label (connection_info.name);

            mac_label.set_label (connection_info.mac);

            ip_assignment_label.set_label (connection_info.method);

            ipv4_rows.foreach ((row) => {
                ipv4_group.remove (row);

                return true;
            });

            ipv4_rows.clear ();

            foreach (var ipv4 in connection_info.ipv4) {
                var ip_address_label = new Gtk.Label (ipv4.address);

                var ip_address_row = new Adw.ActionRow () {
                    title = _("IP Address"),
                };
                ip_address_row.add_suffix (ip_address_label);

                var subnet_mask_label = new Gtk.Label (ipv4.subnet_mask);

                var subnet_mask_row = new Adw.ActionRow () {
                    title = _("Subnet Mask"),
                };
                subnet_mask_row.add_suffix (subnet_mask_label);

                ipv4_rows.add (ip_address_row);
                ipv4_rows.add (subnet_mask_row);

                ipv4_group.add (ip_address_row);
                ipv4_group.add (subnet_mask_row);
            }

            ipv6_rows.foreach ((row) => {
                ipv6_group.remove (row);

                return true;
            });

            ipv6_rows.clear ();

            foreach (var ipv6 in connection_info.ipv6) {
                var ip_address_label = new Gtk.Label (ipv6);

                var ip_address_row = new Adw.ActionRow () {
                    title = _("IP Address"),
                };
                ip_address_row.add_suffix (ip_address_label);

                ipv6_rows.add (ip_address_row);

                ipv6_group.add (ip_address_row);
            }
        }
    }
}