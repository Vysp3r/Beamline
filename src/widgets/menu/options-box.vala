namespace Protonium.Widgets.Menu {
    public class OptionsBox : Gtk.Box {
        Window window;
        Gtk.Label name_label;
        
        public OptionsBox (Window window) {
            Object (
                valign: Gtk.Align.CENTER,
                halign: Gtk.Align.CENTER,
                spacing: 15,
                orientation: Gtk.Orientation.VERTICAL,
                width_request: 500
            );

            this.window = window;

            name_label = new Gtk.Label (null) {
                css_classes = { "title-label" },
                lines = 2,
                wrap = true,
            };

            var play_button_content = new Adw.ButtonContent () {
                label = _("Play"),
                icon_name = "play-symbolic",
            };

            var play_button = new Gtk.Button () {
                child = play_button_content,
            };
            play_button.clicked.connect (play_button_clicked);

            var edit_button_content = new Adw.ButtonContent () {
                label = _("Edit"),
                icon_name = "edit-symbolic",
            };

            var edit_button = new Gtk.Button () {
                child = edit_button_content,
            };
            edit_button.clicked.connect (edit_button_clicked);

            var hide_button_content = new Adw.ButtonContent () {
                label = _("Hide"),
                icon_name = "eye-x-symbolic",
            };

            var hide_button = new Gtk.Button () {
                child = hide_button_content,
            };
            hide_button.clicked.connect (hide_button_clicked);

            var remove_button_content = new Adw.ButtonContent () {
                label = _("Remove"),
                icon_name = "trash-symbolic",
            };

            var remove_button = new Gtk.Button () {
                child = remove_button_content,
            };
            remove_button.clicked.connect (remove_button_clicked);

            append (name_label);
            append (play_button);
            append (edit_button);
            append (hide_button);
            append (remove_button);
            add_css_class ("options-box");
        }

        public void load (Models.Games.Game? game) {
            if (game == null)
                return;

            name_label.set_label (game.name);
        }

        void play_button_clicked () {
            message ("Play");
        }

        void edit_button_clicked () {
            message ("Edit");
        }

        void hide_button_clicked () {
            message ("Hide");
        }

        void remove_button_clicked () {
            message ("Remove");
        }
    }
}