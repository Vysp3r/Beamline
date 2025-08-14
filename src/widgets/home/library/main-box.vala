namespace Protonium.Widgets.Library {
    public class MainBox : Gtk.Box {
        public View current_view;

        Window window;
        public GamesBox games_box;
        public GameBox game_box;
        CollectionsBox collections_box;

        public MainBox (Window window) {
            Object (orientation: Gtk.Orientation.VERTICAL, vexpand: true);

            this.window = window;

            games_box = new GamesBox (window);

            game_box = new GameBox (window) {
                visible = false,
            };

            collections_box = new CollectionsBox () {
                visible = false,
            };

            append (games_box);
            append (game_box);
            append (collections_box);
            add_css_class ("library-main-box");
        }

        public void set_view (View view) {
            this.current_view = view;

            games_box.set_visible (view == View.GAMES);

            if (view == View.GAMES) {
                window.set_window_title (_("Library"));
                window.home_main_box.library_bar.set_active_tab (LibraryBar.Tab.ALL_GAMES);
            }

            game_box.set_visible (view == View.GAME);

            if (view == View.GAME)
                window.set_window_title (window.selected_game.name);

            collections_box.set_visible (view == View.COLLECTIONS);

            if (view == View.COLLECTIONS) {
                window.set_window_title (_("Collections"));
                window.home_main_box.library_bar.set_active_tab (LibraryBar.Tab.COLLECTIONS);
            }
        }

        public enum View {
            GAMES,
            GAME,
            COLLECTIONS,
        }
    }
}