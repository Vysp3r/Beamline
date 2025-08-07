namespace Protonium.Widgets.Library {
    public class MainBox : Gtk.Box {
        Window window;
        BlurredImage background_image;
        GamesBox games_box;
        GameBox game_box;
        Gtk.Overlay background_overlay;

        public MainBox (Window window) {
            Object (orientation: Gtk.Orientation.VERTICAL);

            this.window = window;

            background_image = new BlurredImage () {
                hexpand = true,
                vexpand = true,
            };

            Application.settings.bind ("enable-blurred-background",
                            background_image,
                            "visible",
                            SettingsBindFlags.GET);

            games_box = new GamesBox (window);
            games_box.notify["visible"].connect (update_library_bar_visibility);
            games_box.game_selected.connect (game_selected);

            game_box = new GameBox (window) {
                visible = false,
            };

            background_overlay = new Gtk.Overlay () {
                child = background_image,
                vexpand = true,
            };
            background_overlay.add_overlay (games_box);
            background_overlay.add_overlay (game_box);

            notify["parent"].connect (update_library_bar_visibility);

            append (background_overlay);
            add_css_class ("dashboard-main-box");
        }

        void game_selected (Models.Games.Game? game) {
            if (game != null)
                background_image.load (game.background_image_path);
            else
                background_image.unload ();

            window.bar_main_box.menu_main_box.load (game);
        }

        public void show_game_box (bool show) {
            games_box.set_visible (!show);

            game_box.set_visible (show);

            window.set_window_title (show ? window.selected_game.name : _("Library"));
        }

        public void load (Models.Games.Game game) {
            game_box.load (game);

            show_game_box (true);
        }

        void update_library_bar_visibility () {
            window.bar_main_box.library_bar.set_visible (get_parent () != null && games_box.get_visible ());
        }
    }
}