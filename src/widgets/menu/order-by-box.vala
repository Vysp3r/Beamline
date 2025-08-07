namespace Protonium.Widgets.Menu {
    public class OrderByBox : Gtk.Box {
        Window window;
        Adw.SwitchRow name_row;
        Adw.SwitchRow last_played_row;
        Adw.SwitchRow added_row;

        public OrderByBox (Window window) {
            Object (
                valign: Gtk.Align.CENTER,
                halign: Gtk.Align.CENTER,
                spacing: 15,
                orientation: Gtk.Orientation.VERTICAL,
                width_request: 500
            );

            this.window = window;

            var title_label = new Gtk.Label (_("Order by")) {
                css_classes = { "title-label" },
            };

            name_row = new Adw.SwitchRow () {
                title = _("Name"),
                active = true,
            };
            name_row.notify["active"].connect(name_row_activated);

            last_played_row = new Adw.SwitchRow () {
                title = _("Last played"),
            };
            last_played_row.notify["active"].connect(last_played_row_activated);

            added_row = new Adw.SwitchRow () {
                title = _("Added"),
            };
            added_row.notify["active"].connect(added_row_activated);

            var order_by_group = new Adw.PreferencesGroup ();
            order_by_group.add (name_row);
            order_by_group.add (last_played_row);
            order_by_group.add (added_row);

            append (title_label);
            append (order_by_group);
            add_css_class ("order-by-box");
        }

        void name_row_activated () {
            if (!name_row.get_active ()) {
                if (!last_played_row.get_active () && !added_row.get_active ())
                    last_played_row.set_active (true);

                return;
            }

            window.order_by = Window.OrderBy.NAME;

            last_played_row.set_active (false);
            added_row.set_active (false);
        }

        void last_played_row_activated () {
            if (!last_played_row.get_active ()) {
                if (!name_row.get_active () && !added_row.get_active ())
                    name_row.set_active (true);

                return;
            }

            window.order_by = Window.OrderBy.LAST_PLAYED;

            name_row.set_active (false);
            added_row.set_active (false);
        }

        void added_row_activated () {
            if (!added_row.get_active ()) {
                if (!name_row.get_active () && !last_played_row.get_active ())
                    name_row.set_active (true);

                return;
            }

            window.order_by = Window.OrderBy.ADDED;

            name_row.set_active (false);
            last_played_row.set_active (false);
        }
    }
}