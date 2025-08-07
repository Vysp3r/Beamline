namespace Protonium.Widgets {
    public class LibraryBar : Gtk.Box {
        Window window;

        public LibraryBar (Window window) {
            Object (
                hexpand: true,
                valign: Gtk.Align.START,
                orientation: Gtk.Orientation.HORIZONTAL,
                spacing: 0
            );

            var left_button = new Gtk.Button.from_icon_name ("xbox-lb-symbolic") {
                css_classes = { "flat" },
            };

            var left_spacer = new Gtk.Label (null) {
                hexpand = true,
            };

            var all_games_label = new Gtk.Label (null);
            all_games_label.set_markup ("<u>All games</u>");

            var all_games_button = new Gtk.Button () {
                css_classes = { "flat" },
                child = all_games_label,
            };

            var collections_label = new Gtk.Label (null);
            collections_label.set_markup ("Collections");

            var collections_button = new Gtk.Button () {
                css_classes = { "flat" },
                child = collections_label,
            };

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
    }
}