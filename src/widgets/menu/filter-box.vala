namespace Protonium.Widgets.Menu {
    public class FilterBox : Gtk.Box {
        Window window;
        Adw.PreferencesGroup genres_group;
        Gee.ArrayList<Adw.SwitchRow> genres_rows;
        Adw.PreferencesGroup developers_group;
        Gee.ArrayList<Adw.SwitchRow> developers_rows;

        public FilterBox (Window window) {
            Object (valign: Gtk.Align.CENTER, halign: Gtk.Align.CENTER);

            this.window = window;

            genres_rows = new Gee.ArrayList<Adw.SwitchRow> ();

            developers_rows = new Gee.ArrayList<Adw.SwitchRow> ();

            var title_label = new Gtk.Label (_("Filters")) {
                css_classes = { "title-label" },
            };

            genres_group = new Adw.PreferencesGroup () {
                title = _("Genres"),
            };

            developers_group = new Adw.PreferencesGroup () {
                title = _("Developers"),
            };

            var group_box = new Gtk.Box (Gtk.Orientation.VERTICAL, 15);
            group_box.append (title_label);
            group_box.append (genres_group);
            group_box.append (developers_group);

            var scrolled_window = new Gtk.ScrolledWindow () {
                height_request = 700,
                width_request = 500,
                child = group_box,
                hscrollbar_policy = Gtk.PolicyType.NEVER,
                vscrollbar_policy = Gtk.PolicyType.AUTOMATIC,
            };

            window.notify["genres"].connect (window_genres_changed);

            window.notify["developers"].connect (window_developers_changed);

            append (scrolled_window);
            add_css_class ("filter-box");
        }

        void window_genres_changed () {
            var rows_to_delete = new Gee.ArrayList<Adw.SwitchRow> ();

            genres_rows.filter ((row) => {
                return !window.genres.contains (row.title);
            }).foreach ((row) => {
                genres_group.remove (row);

                rows_to_delete.add (row);

                return true;
            });

            genres_rows.remove_all (rows_to_delete);

            window.genres.foreach ((genre) => {
                var matched = genres_rows.any_match ((row) => str_equal (row.title, genre));
                if (matched)
                    return true;

                var row = new Adw.SwitchRow () {
                    title = Markup.escape_text (genre),
                };
                row.notify["active"].connect (() => genre_row_active_changed(row));

                genres_group.add (row);

                genres_rows.add (row);

                return true;
            });
        }

        void window_developers_changed () {
            var rows_to_delete = new Gee.ArrayList<Adw.SwitchRow> ();

            developers_rows.filter ((row) => {
                return !window.developers.contains (row.title);
            }).foreach ((row) => {
                developers_group.remove (row);

                rows_to_delete.add (row);

                return true;
            });

            developers_rows.remove_all (rows_to_delete);

            window.developers.foreach ((developer) => {
                var matched = developers_rows.any_match ((row) => str_equal (row.title, developer));
                if (matched)
                    return true;

                var row = new Adw.SwitchRow () {
                    title = Markup.escape_text (developer),
                };
                row.notify["active"].connect (() => developer_row_active_changed(row));

                developers_group.add (row);

                developers_rows.add (row);

                return true;
            });
        }

        void genre_row_active_changed (Adw.SwitchRow row) {
            var matched = window.filter_genres.any_match ((pred) => pred == row.title);

            if (row.get_active () && !matched)
                window.filter_genres.add (row.title);

            if (!row.get_active () && matched)
                window.filter_genres.remove (row.title);

            window.update_displayed_games ();
        }

        void developer_row_active_changed (Adw.SwitchRow row) {
            var matched = window.filter_developers.any_match ((pred) => pred == row.title);

            if (row.get_active () && !matched)
                window.filter_developers.add (row.title);

            if (!row.get_active () && matched)
                window.filter_developers.remove (row.title);

            window.update_displayed_games ();
        }
    }
}