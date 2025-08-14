namespace Protonium.Widgets.Library {
    public class GameRow : Gtk.Widget {
        Window window;
        Image image;
        Gtk.Overlay overlay;

        public signal void left_clicked ();

        public GameRow (Window window) {
            this.window = window;

            var hover_box = new Gtk.Box (Gtk.Orientation.VERTICAL, 0) {
                hexpand = true,
                vexpand = true,
            };

            var steam_image = new Gtk.Image.from_icon_name ("brand-steam-symbolic") {
                halign = Gtk.Align.END,
                valign = Gtk.Align.START,
            };
            
            image = new Image ();

            overlay = new Gtk.Overlay ();
            overlay.set_parent (this);
            overlay.set_child (image);
            overlay.add_overlay (hover_box);
            overlay.add_overlay (steam_image);

            destroy.connect (game_destroyed);

            var gesture_click = new Gtk.GestureClick () {
                button = 3,
            };

            gesture_click.released.connect (gesture_click_released);

            Utils.CSS.get_instance ().notify["scale-factor"].connect (scale_factor_changed);

            scale_factor_changed ();

            var bin_layout = new Gtk.BinLayout ();

            add_controller (gesture_click);
            set_layout_manager (bin_layout);
            add_css_class ("game-row-main-box");
        }

        public void load (Models.Games.Game game) {
            image.load (game.cover_image_path);
        }

        public void unload () {
            image.unload ();
        }

        void game_destroyed () {
            overlay.unparent ();
			overlay.destroy ();
		}

        void gesture_click_released () {
            left_clicked ();
        }

        void scale_factor_changed () {
            image.width_request = (int)(300 * Utils.CSS.get_instance ().scale_factor);
            image.height_request = (int)(450 * Utils.CSS.get_instance ().scale_factor);
        }
    }
}