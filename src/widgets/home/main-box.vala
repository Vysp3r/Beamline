namespace Protonium.Widgets.Home {
    public class MainBox : Gtk.Box {
        public View current_view;

        Window window;
        public Menu.MainBox menu_main_box;
        public TopBar top_bar;
        public BottomBar bottom_bar;
        public LibraryBar library_bar;
        public Library.MainBox library_main_box;
        public Settings.MainBox settings_main_box;
        BlurredImage background_image;

        public MainBox (Window window) {
            this.window = window;
            
            menu_main_box = new Menu.MainBox (window);

            top_bar = new TopBar (window);

            library_bar = new LibraryBar (window);

            library_main_box = new Library.MainBox (window);

            settings_main_box = new Settings.MainBox (window);

            bottom_bar = new BottomBar (window);

            var content_box = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
            content_box.append (library_main_box);
            content_box.append (settings_main_box);

            var content_overlay = new Gtk.Overlay () {
                hexpand = true,
                vexpand = true,
                child = content_box,
            };
            content_overlay.add_overlay (menu_main_box);

            var main_box = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
            main_box.append (top_bar);
            main_box.append (library_bar);
            main_box.append (content_overlay);
            main_box.append (bottom_bar);
 
            background_image = new BlurredImage () {
                hexpand = true,
                vexpand = true,
            };

            Application.settings.bind ("enable-blurred-background",
                            background_image,
                            "visible",
                            SettingsBindFlags.GET);

            var background_overlay = new Gtk.Overlay () {
                hexpand = true,
                vexpand = true,
                child = background_image,
            };
            background_overlay.add_overlay (main_box);

            window.notify["selected-game"].connect (selected_game_changed);
            
            append (background_overlay);
            add_css_class ("bar-main-box");
        }

        void selected_game_changed () {
            if (window.selected_game != null)
                background_image.load (window.selected_game.background_image_path);
            else
                background_image.unload ();
        }

        public void set_view (View view) {
            current_view = view;

            if (view == View.SETTINGS)
                background_image.unload ();
                
            if (view == View.LIBRARY)
                selected_game_changed ();

            bottom_bar.show_extra_buttons (view == View.LIBRARY);

            library_bar.set_visible (view == View.LIBRARY);

            library_main_box.set_visible (view == View.LIBRARY);

            settings_main_box.set_visible (view == View.SETTINGS);
        }
        

        public enum View {
            LIBRARY,
            SETTINGS,
        }
    }
}