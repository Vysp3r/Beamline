namespace Protonium.Widgets.Library {
    public class GameBox : Gtk.Box {
        Models.Games.Game game;

        Window window;
        Gtk.Label title_label;
        Gtk.Label developer_label;
        Gtk.Label added_label;
        Gtk.Label last_played_label;
        Gtk.Button play_button;
        Image cover_image;

        public GameBox (Window window) {
            Object (halign: Gtk.Align.CENTER, hexpand: true, valign: Gtk.Align.CENTER, vexpand: true, spacing: 100);

            this.window = window;

            cover_image = new Image () {
                width_request = 300,
                height_request = 450,
                valign = Gtk.Align.CENTER,
                halign = Gtk.Align.END,
            };

            title_label = new Gtk.Label (null) {
                halign = Gtk.Align.START,
                css_classes = { "title-label" },
            };

            developer_label = new Gtk.Label (null) {
                halign = Gtk.Align.START,
                css_classes = { "developer-label" },
            };

            added_label = new Gtk.Label (null) {
                halign = Gtk.Align.START,
            };

            last_played_label = new Gtk.Label (null) {
                halign = Gtk.Align.START,
            };

            var play_button_content = new Adw.ButtonContent () {
                label = _("Play"),
                icon_name = "play-symbolic",
            };

            play_button = new Gtk.Button () {
                child = play_button_content,
            };
            play_button.clicked.connect (play_button_clicked);

            var edit_button = new Gtk.Button.from_icon_name ("edit-symbolic");

            var hide_button = new Gtk.Button.from_icon_name ("eye-x-symbolic");

            var remove_button = new Gtk.Button.from_icon_name ("trash-symbolic");

            var other_button = new Gtk.Button.from_icon_name ("open-menu-symbolic");

            var action_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 30) {
                valign = Gtk.Align.CENTER,
            };
            action_box.append (play_button);
            action_box.append (edit_button);
            action_box.append (hide_button);
            action_box.append (remove_button);
            action_box.append (other_button);

            var info_box = new Gtk.Box (Gtk.Orientation.VERTICAL, 30) {
                valign = Gtk.Align.CENTER,
            };
            info_box.append (title_label);
            info_box.append (developer_label);
            info_box.append (added_label);
            info_box.append (last_played_label);
            info_box.append (action_box);

            notify["visible"].connect (visible_changed);

            add_css_class ("game-box");
            append (cover_image);
            append (info_box);
        }

        public void load (Models.Games.Game game) {
            this.game = game;

            cover_image.unload ();

            if (game.cover_image_path != null)
                cover_image.load (game.cover_image_path);

            title_label.set_label (game.name);

            var developers = new StringBuilder ();
            var last_developer = game.developers.last ();
            game.developers.foreach ((developer) => {
                developers.append (developer);

                if (developer != last_developer)
                    developers.append (", ");

                return true;
            });
            developer_label.set_label (game.developers != null ? developers.str : _("Unknown"));

            added_label.set_label ("Added: Yesterday");

            last_played_label.set_label ("Last played: Today");
        }

        void play_button_clicked () {
            var success = game.play (get_root () as Gtk.Window);
        }

        void visible_changed () {
            window.home_main_box?.bottom_bar?.show_extra_buttons (!visible);
        }
    }
}