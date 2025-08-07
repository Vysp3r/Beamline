namespace Protonium.Widgets.Library {
    public class GamesBox : Gtk.Box {
        Window window;
        ListStore list_store;
        Gtk.SingleSelection selection_model;
        Gtk.GridView game_grid_view;

        public signal void game_selected (Models.Games.Game game);

        public GamesBox (Window window) {
            this.window = window;

            list_store = new ListStore (typeof (Models.Games.Game));

            selection_model = new Gtk.SingleSelection (list_store);
            selection_model.notify["selected-item"].connect (selection_model_selected_item_changed);

            var factory = new Gtk.SignalListItemFactory ();
            factory.setup.connect (factory_setup);
            factory.bind.connect (factory_bind);
            factory.unbind.connect (factory_unbind);

            game_grid_view = new Gtk.GridView (selection_model, factory){
                orientation = Gtk.Orientation.VERTICAL,
                enable_rubberband = false,
                single_click_activate = false,
            };
            game_grid_view.activate.connect (game_grid_view_activated);

            var scrolled_window = new Gtk.ScrolledWindow () {
                vexpand = true,
                hexpand = true,
                overlay_scrolling = true,
                kinetic_scrolling = true,
                hscrollbar_policy = Gtk.PolicyType.NEVER,
                vscrollbar_policy = Gtk.PolicyType.AUTOMATIC,           
            };
            scrolled_window.set_child (game_grid_view);

            window.notify["displayed-games"].connect (globals_displayed_games_changed);

            append (scrolled_window);
        }

        void factory_unbind (GLib.Object object) {
            var list_item = object as Gtk.ListItem;

            list_item.get_data<GameRow.MainBox> ("game-row-main-box").unload ();
        }

		void factory_bind (Object object) {
            var list_item = object as Gtk.ListItem;

			var game = list_item.get_item() as Models.Games.Game;

            list_item.get_data<GameRow.MainBox> ("game-row-main-box").load (game);
        }

        void factory_setup (Object object) {
			var list_item = object as Gtk.ListItem;

            var game_row_main_box = new GameRow.MainBox (window);
            game_row_main_box.left_clicked.connect (() => game_row_main_box_left_clicked (list_item.get_position ()));

            list_item.set_data ("game-row-main-box", game_row_main_box);

			list_item.set_child(game_row_main_box);
        }

        void game_grid_view_activated (uint pos) {
            window.selected_game = selection_model.get_item (pos) as Models.Games.Game;
        }

        void selection_model_selected_item_changed  () {
            var game = selection_model.get_selected_item () as Models.Games.Game;

            game_selected (game);
        }

        void globals_displayed_games_changed () {
            list_store.remove_all ();

            window.displayed_games.foreach ((game) => {
                list_store.append (game);
                
                return true;
            });
        }

        void game_row_main_box_left_clicked (uint position) {
            selection_model.set_selected (position);

            window.bar_main_box.menu_main_box.set_view (Menu.MainBox.View.OPTIONS);
        }
    }
}