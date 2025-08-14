namespace Protonium.Widgets.Menu {
    public class MenuBox : Gtk.Box {
        Window window;

        public MenuBox (Window window) {
            Object (
                vexpand: true,
                hexpand: false,
                orientation: Gtk.Orientation.VERTICAL,
                halign: Gtk.Align.START,
                spacing: 15,
                width_request: 400
            );

            this.window = window;

            var top_spacer = new Gtk.Label (null) {
                vexpand = true,
            };

            var library_button_content = new Adw.ButtonContent () {
                label = _("Library"),
                icon_name = "books-symbolic",
            };

            var library_button = new Gtk.Button () {
                child = library_button_content,
            };
            library_button.clicked.connect (library_button_clicked);

            var settings_button_content = new Adw.ButtonContent () {
                label = _("Settings"),
                icon_name = "cog-symbolic",
            };

            var settings_button = new Gtk.Button () {
                child = settings_button_content,
            };
            settings_button.clicked.connect (settings_button_clicked);

            var power_button_content = new Adw.ButtonContent () {
                label = _("Power"),
                icon_name = "power-2-symbolic",
            };

            var power_button = new Gtk.Button () {
                child = power_button_content,
            };
            power_button.clicked.connect (power_button_clicked);

            var bottom_spacer = new Gtk.Label (null) {
                vexpand = true,
            };

            add_css_class ("menu-box");
            append (top_spacer);
            append (library_button);
            append (settings_button);
            append (power_button);
            append (bottom_spacer);
        }

        void library_button_clicked () {
            window.home_main_box.menu_main_box.set_view (Menu.MainBox.View.NONE);

            window.home_main_box.set_view (Home.MainBox.View.LIBRARY);
        }

        void settings_button_clicked () {
            window.home_main_box.menu_main_box.set_view (Menu.MainBox.View.NONE);
            
            window.home_main_box.set_view (Home.MainBox.View.SETTINGS);
        }

        void power_button_clicked () {
            window.home_main_box.menu_main_box.set_view (Menu.MainBox.View.POWER);
        }
    }
}