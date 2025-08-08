namespace Protonium.Widgets {
    public class Window : Adw.ApplicationWindow {
        public Gee.ArrayList<Models.Launchers.Launcher> launchers { get; set; }
        public Models.Games.Game selected_game { get; set; }
        public Gee.ArrayList<Models.Games.Game> displayed_games { get; set; }
        public Gee.ArrayList<string> genres { get; set; }
        public Gee.ArrayList<string> filter_genres { get; set; }
        public Gee.ArrayList<string> developers { get; set; }
        public Gee.ArrayList<string> filter_developers { get; set; }
        public OrderBy order_by { get; set; }
        public string search_text { get; set; }
        public bool is_onboarding_done { get; set; }
        public View current_view { get; set; }
        public Gtk.Widget focused_widget { get; set; }
        public Gtk.Widget previous_focused_widget { get; set; }

        Adw.HeaderBar header_bar;
        Onboarding.MainBox onboarding_main_box;
        Loading.MainBox loading_main_box;
        public Library.MainBox library_main_box;
        public Bar.MainBox bar_main_box;
        public Settings.MainBox settings_main_box;
        
        Adw.ToolbarView toolbar_view;

        public Window (Gtk.Application app) {
            Object (application: app);

            add_set_view_action ();

            displayed_games = new Gee.ArrayList<Models.Games.Game> ();
            genres = new Gee.ArrayList<string> ();
            filter_genres = new Gee.ArrayList<string> ();
            developers = new Gee.ArrayList<string> ();
            filter_developers = new Gee.ArrayList<string> ();

            header_bar = new Adw.HeaderBar ();

            toolbar_view = new Adw.ToolbarView ();
            toolbar_view.add_top_bar (header_bar);

            notify["focus-widget"].connect (focus_widget_changed);

            notify["fullscreened"].connect (fullscreened_changed);

            notify["selected-game"].connect (selected_game_changed);

            notify["search-text"].connect (update_displayed_games);

            notify["order-by"].connect (update_displayed_games);

            set_content (toolbar_view);
            set_size_request (980, 1155);
        }

        void add_set_view_action () {
			SimpleAction action = new SimpleAction ("set-view", VariantType.INT32);

			action.activate.connect ((variant) => {
                set_view ((View) variant.get_int32 ());
			});

			add_action (action);
		}

        public void set_view (View view) {
            if (current_view == view)
                return;

            current_view = view;

            switch (current_view) {
                case View.ONBOARDING:
                    set_window_title (_("Onboarding"));

                    if (onboarding_main_box == null)
                        onboarding_main_box = new Onboarding.MainBox (this);

                    toolbar_view.set_content (onboarding_main_box);
                    break;
                case View.LOADING:
                    set_window_title (_("Loading"));

                    if (loading_main_box == null)
                        loading_main_box = new Loading.MainBox (this);

                    toolbar_view.set_content (loading_main_box);
                    break;
                case View.LIBRARY:
                    set_window_title (_("Library"));

                    if (library_main_box == null)
                        library_main_box = new Library.MainBox (this); 

                    if (bar_main_box == null) {
                        bar_main_box = new Bar.MainBox (this);

                        update_displayed_games ();
                    }
                    
                    if (library_main_box.get_parent () == null)
                        bar_main_box.set_overlay_content (library_main_box);

                    if (bar_main_box.get_parent () == null)
                        toolbar_view.set_content (bar_main_box);
                    break;
                case View.SETTINGS:
                    set_window_title (_("Settings"));

                    if (settings_main_box == null)
                        settings_main_box = new Settings.MainBox (this); 

                    if (settings_main_box.get_parent () == null)
                        bar_main_box.set_overlay_content (settings_main_box);

                    if (bar_main_box.get_parent () == null)
                        toolbar_view.set_content (bar_main_box);
                    break;
                case View.NONE:
                    set_window_title ("");
                    toolbar_view.set_content (null);
                    break;
            }
        }
        
        void fullscreened_changed () {
            header_bar.set_visible (!fullscreened);
        }

        void focus_widget_changed () {
            previous_focused_widget = focused_widget;

            focused_widget = get_focus ();
        }

        void selected_game_changed () {
            library_main_box.load (selected_game);
        }

        public void set_window_title (string title) {
            set_title ("%s | %s".printf (title, Config.APP_NAME));
        }

        public void update_displayed_games () {
            var games = new Gee.ArrayList<Models.Games.Game> ();

            launchers.filter ((pred) => pred.source != Models.Launchers.Launcher.Source.NOT_INSTALLED).foreach ((launcher) => {
                games.add_all (launcher.games);
                
                return true;
            });

            Gee.Iterator<Models.Games.Game> iterator = null;

            if (search_text != null && search_text.length > 0) {
                iterator = games.filter ((game) => game.name.ascii_down ().contains (search_text.ascii_down ()));
            }

            if (filter_genres.size > 0) {
                if (iterator == null)
                    iterator = games.iterator ();

                iterator = iterator.filter ((game) => game.genres.contains_all_array (filter_genres.to_array ()));
            }

            if (filter_developers.size > 0) {
                if (iterator == null)
                    iterator = games.iterator ();

                iterator = iterator.filter ((game) => game.developers.contains_all_array (filter_developers.to_array ()));
            }

            if (iterator == null)
                iterator = games.iterator ();

            switch (order_by) {
                case OrderBy.NAME:
                    iterator = iterator.order_by ((a, b) => strcmp (a.name, b.name));
                    break;
                case OrderBy.LAST_PLAYED:
                    iterator = iterator.order_by ((a, b) => {
                        if (a.last_played < b.last_played)
                            return -1;
                        if (a.last_played > b.last_played)
                            return 1;
                        return 0;
                    });
                    break;
                case OrderBy.ADDED:
                    iterator = iterator.order_by ((a, b) => {
                        if (a.added < b.added)
                            return -1;
                        if (a.added > b.added)
                            return 1;
                        return 0;
                    });
                    break;
            }
            
            displayed_games.clear ();
            genres.clear ();
            developers.clear ();

            iterator.foreach ((game) => {
                foreach (var genre in game.genres) {
                    if (!genres.any_match ((pred) => str_equal (pred, genre))) {
                        genres.add (genre);
                        //message(genre);
                    }
                }       

                foreach (var developer in game.developers) {
                    if (!developers.any_match ((pred) => str_equal (pred, developer))) {
                        developers.add (developer);
                        //message(developer);
                    }
                }       

                return displayed_games.add (game);
            });

            notify_property ("displayed-games");
            notify_property ("genres");
            notify_property ("developers");
        }

        public enum OrderBy {
            NAME,
            LAST_PLAYED,
            ADDED,
        }

        public enum View {
            NONE,
            ONBOARDING,
            LOADING,
            LIBRARY,
            SETTINGS,
        }
    }
}