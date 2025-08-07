namespace Protonium.Widgets.Settings {
    public class LibraryBox : Gtk.Box {
        Window window;
        Adw.PreferencesGroup installed_group;
        Adw.PreferencesGroup uninstalled_group;

        public LibraryBox (Window window) {
            Object (orientation: Gtk.Orientation.VERTICAL, spacing: 15);

            this.window = window;

            var title_label = new Gtk.Label (_("Library")) {
                css_classes = { "title-label" },
            };

            installed_group = new Adw.PreferencesGroup () {
                title = _("Installed"),
                description = _("Launchers present on your system"),
            };

            uninstalled_group = new Adw.PreferencesGroup () {
                title = _("Not installed"),
                description = _("Launchers not present on your system"),
            };

            update_launchers ();

            append (title_label);
            append (installed_group);
            append (uninstalled_group);
            add_css_class ("library-box");
        }

        void update_launchers () {
            uint installed_count = 0;
            uint not_installed_count = 0;

            foreach (var launcher in window.launchers) {
                if (launcher.source != Models.Launchers.Launcher.Source.NOT_INSTALLED)
                    add_installed_launcher (launcher, installed_count++);
                else
                    add_not_installed_launcher (launcher, not_installed_count++);
            }
        }

        void add_installed_launcher (Models.Launchers.Launcher launcher, uint position) {
            var game_count_label = new Gtk.Label (null) {
                css_classes = { "game-count-label" },
            };

            update_game_count_label (game_count_label, launcher);

            launcher.games.notify["size"].connect (() => update_game_count_label (game_count_label, launcher));

            var reload_button = new Gtk.Button.from_icon_name ("reload-symbolic") {
                tooltip_text = _("Reload launcher games"),
                height_request = 50,
                width_request = 50,
                valign = Gtk.Align.CENTER,
            };
            reload_button.clicked.connect (() => reload_button_clicked (launcher));

            var directory_button = new Gtk.Button.from_icon_name ("directory-2-symbolic") {
                tooltip_text = _("Open launcher directory"),
                height_request = 50,
                width_request = 50,
                valign = Gtk.Align.CENTER,
            };
            directory_button.clicked.connect (() => directory_button_clicked (launcher.directory));

            var action_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 15);
            action_box.append (reload_button);
            action_box.append (directory_button);

            var row = new Adw.ActionRow () {
                title = launcher.name,
            };
            row.add_suffix (game_count_label);
            row.add_suffix (action_box);

            switch (launcher.source) {
                case Models.Launchers.Launcher.Source.SYSTEM:
                    row.set_subtitle (_("System"));
                    break;
                case Models.Launchers.Launcher.Source.FLATPAK:
                    row.set_subtitle (_("Flatpak"));
                    break;
                case Models.Launchers.Launcher.Source.SNAP:
                    row.set_subtitle (_("Snap"));
                    break;
            }

            if (position % 2 != 0)
                row.add_css_class ("darker-row");

            installed_group.add (row);
        }

        void add_not_installed_launcher (Models.Launchers.Launcher launcher, uint position) {
            var website_button = new Gtk.Button.from_icon_name ("www-symbolic") {
                tooltip_text = _("Open launcher website"),
                height_request = 50,
                width_request = 50,
                valign = Gtk.Align.CENTER,
            };
            website_button.clicked.connect (() => website_button_clicked (launcher.website));

            var action_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 15);
            action_box.append (website_button);
 
            var row = new Adw.ActionRow () {
                title = launcher.name,
                subtitle = launcher.description,
            };
            row.add_suffix (action_box);

            if (position % 2 != 0)
                row.add_css_class ("darker-row");

            uninstalled_group.add (row);
        }

        void update_game_count_label (Gtk.Label label, Models.Launchers.Launcher launcher) {
            label.set_label (_("%i games").printf (launcher.games.size));
        }

        void website_button_clicked (string website) {
            Utils.System.get_instance ().open_uri (get_root () as Gtk.Window, website);
        }

        void directory_button_clicked (string directory) {
            Utils.System.get_instance ().open_uri (get_root () as Gtk.Window, "file://%s".printf (directory));
        }

        void reload_button_clicked (Models.Launchers.Launcher launcher) {

        }
    }
}