namespace Protonium.Widgets.Library {
    public class MainBox : Gtk.Box {
        public View current_view;

        Window window;
        BlurredImage background_image;
        GamesBox games_box;
        GameBox game_box;
        CollectionsBox collections_box;
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

            collections_box = new CollectionsBox () {
                visible = false,
            };

            background_overlay = new Gtk.Overlay () {
                child = background_image,
                vexpand = true,
            };
            background_overlay.add_overlay (games_box);
            background_overlay.add_overlay (game_box);
            background_overlay.add_overlay (collections_box);

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

        void update_library_bar_visibility () {
            window.bar_main_box.library_bar.set_visible (get_parent () != null && current_view != View.GAME);
        }

        public void load (Models.Games.Game game) {
            game_box.load (game);

            set_view (View.GAME);
        }

        public void set_view (View view) {
            this.current_view = view;

            games_box.set_visible (view == View.GAMES);

            if (view == View.GAMES) {
                window.set_window_title (_("Library"));
                window.bar_main_box.library_bar.set_active_tab (LibraryBar.Tab.ALL_GAMES);
            }

            game_box.set_visible (view == View.GAME);

            if (view == View.GAME)
                window.set_window_title (window.selected_game.name);

            collections_box.set_visible (view == View.COLLECTIONS);

            if (view == View.COLLECTIONS) {
                window.set_window_title (_("Collections"));
                window.bar_main_box.library_bar.set_active_tab (LibraryBar.Tab.COLLECTIONS);
            }
        }

        public enum View {
            GAMES,
            GAME,
            COLLECTIONS,
        }
    }
}