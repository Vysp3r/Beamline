namespace Protonium.Widgets {
    public class LibraryBar : Gtk.Box {
        public Tab current_tab;

        Window window;
        Gtk.Label all_games_label;
        Gtk.Label collections_label;

        public LibraryBar (Window window) {
            Object (
                hexpand: true,
                valign: Gtk.Align.START,
                orientation: Gtk.Orientation.HORIZONTAL,
                spacing: 0
            );

            this.window = window;

            var left_button = new Gtk.Button.from_icon_name ("xbox-lb-symbolic") {
                css_classes = { "flat" },
            };

            var left_spacer = new Gtk.Label (null) {
                hexpand = true,
            };

            all_games_label = new Gtk.Label (null);
            all_games_label.set_markup ("<u>All games</u>");

            var all_games_button = new Gtk.Button () {
                css_classes = { "flat" },
                child = all_games_label,
            };
            all_games_button.clicked.connect (all_games_button_clicked);

            collections_label = new Gtk.Label (null);
            collections_label.set_markup ("Collections");

            var collections_button = new Gtk.Button () {
                css_classes = { "flat" },
                child = collections_label,
            };
            collections_button.clicked.connect (collections_button_clicked);

            var right_spacer = new Gtk.Label (null) {
                hexpand = true,
            };

            var right_button = new Gtk.Button.from_icon_name ("xbox-rb-symbolic") {
                css_classes = { "flat" },
            };

            append (left_button);
            append (left_spacer);
            append (all_games_button);
            append (collections_button);
            append (right_spacer);
            append (right_button);
            add_css_class ("library-bar");
        }

        void all_games_button_clicked () {
            window.home_main_box.library_main_box.set_view (Library.MainBox.View.GAMES);
        }

        void collections_button_clicked () {
            window.home_main_box.library_main_box.set_view (Library.MainBox.View.COLLECTIONS);
        }

        public void set_active_tab (Tab tab) {
            this.current_tab = tab;

            all_games_label.set_markup (tab == Tab.ALL_GAMES ? "<u>%s</u>".printf (_("All games")) : _("All games"));

            collections_label.set_markup (tab == Tab.COLLECTIONS ? "<u>%s</u>".printf (_("Collections")) : _("Collections"));
        }

        public enum Tab {
            ALL_GAMES,
            COLLECTIONS,
        }
    }
}