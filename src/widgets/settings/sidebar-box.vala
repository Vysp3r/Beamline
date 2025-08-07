namespace Protonium.Widgets.Settings {
    public class SidebarBox : Gtk.Box {
        public signal void set_view (MainBox.View view);

        public SidebarBox () {
            Object (width_request: 400, spacing: 15, orientation: Gtk.Orientation.VERTICAL);

            var general_button_content = new Adw.ButtonContent () {
                label = _("General"),
                icon_name = "cog-symbolic",
                halign = Gtk.Align.START,
            };

            var general_button = new Gtk.Button () {
                child = general_button_content,
            };
            general_button.clicked.connect (general_button_clicked);

            var system_button_content = new Adw.ButtonContent () {
                label = _("System"),
                icon_name = "desktop-analytics-symbolic",
                halign = Gtk.Align.START,
            };

            var system_button = new Gtk.Button () {
                child = system_button_content,
            };
            system_button.clicked.connect (system_button_clicked);

            var top_separator = new Gtk.Separator (Gtk.Orientation.HORIZONTAL);
            
            var internet_button_content = new Adw.ButtonContent () {
                label = _("Internet"),
                icon_name = "wifi-4-symbolic",
                halign = Gtk.Align.START,
            };

            var internet_button = new Gtk.Button () {
                child = internet_button_content,
            };
            internet_button.clicked.connect (internet_button_clicked);

            var power_button_content = new Adw.ButtonContent () {
                label = _("Power"),
                icon_name = "power-2-symbolic",
                halign = Gtk.Align.START,
            };

            var power_button = new Gtk.Button () {
                child = power_button_content,
            };
            power_button.clicked.connect (power_button_clicked);

            var audio_button_content = new Adw.ButtonContent () {
                label = _("Audio"),
                icon_name = "headphones-symbolic",
                halign = Gtk.Align.START,
            };

            var audio_button = new Gtk.Button () {
                child = audio_button_content,
            };
            audio_button.clicked.connect (audio_button_clicked);

            var bottom_separator = new Gtk.Separator (Gtk.Orientation.HORIZONTAL);

            var library_button_content = new Adw.ButtonContent () {
                label = _("Library"),
                icon_name = "books-symbolic",
                halign = Gtk.Align.START,
            };

            var library_button = new Gtk.Button () {
                child = library_button_content,
            };
            library_button.clicked.connect (library_button_clicked);

            var interface_button_content = new Adw.ButtonContent () {
                label = _("Interface"),
                icon_name = "desktop-2-symbolic",
                halign = Gtk.Align.START,
            };

            var interface_button = new Gtk.Button () {
                child = interface_button_content,
            };
            interface_button.clicked.connect (interface_button_clicked);

            append (general_button);
            append (system_button);
            append (top_separator);
            append (internet_button);
            append (power_button);
            append (audio_button);
            append (bottom_separator);
            append (interface_button);
            append (library_button);
            add_css_class ("sidebar-box");
        }

        void general_button_clicked () {
            set_view (Settings.MainBox.View.GENERAL);
        }

        void system_button_clicked () {
            set_view (Settings.MainBox.View.SYSTEM);
        }

        void internet_button_clicked () {
            set_view (Settings.MainBox.View.INTERNET);
        }

        void power_button_clicked () {
            set_view (Settings.MainBox.View.POWER);
        }

        void audio_button_clicked () {
            set_view (Settings.MainBox.View.AUDIO);
        }

        void library_button_clicked () {
            set_view (Settings.MainBox.View.LIBRARY);
        }

        void interface_button_clicked () {
            set_view (Settings.MainBox.View.INTERFACE);
        }
    }
}