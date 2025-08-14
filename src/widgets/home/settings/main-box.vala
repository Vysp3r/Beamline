namespace Protonium.Widgets.Settings {
    public class MainBox : Gtk.Box {
        Window window;
        GeneralBox general_box;
        SystemBox system_box;
        InternetBox internet_box;
        PowerBox power_box;
        AudioBox audio_box;
        LibraryBox library_box;
        InterfaceBox interface_box;
        Gtk.ScrolledWindow content_scrolled_window;
        Adw.NavigationSplitView navigation_split_view;

        public MainBox (Window window) {
            Object (hexpand: true, vexpand: true);

            this.window = window;
            
            var sidebar_box = new SidebarBox ();
            sidebar_box.set_view.connect (set_view);

            var sidebar_page = new Adw.NavigationPage (sidebar_box, "sidebar");

            content_scrolled_window = new Gtk.ScrolledWindow () {
                hexpand = true,
                vexpand = true,
                hscrollbar_policy = Gtk.PolicyType.NEVER,
            };

            var content_page = new Adw.NavigationPage (content_scrolled_window, "content");

            navigation_split_view = new Adw.NavigationSplitView () {
                sidebar = sidebar_page,
                hexpand = true,
                content = content_page,
            };

            set_view (View.GENERAL);

            add_css_class ("settings-main-box");
            append (navigation_split_view);
        }

        public void set_view (View view) {
            switch (view) {
                case View.GENERAL:
                    if (general_box == null)
                        general_box = new GeneralBox ();
                    
                    content_scrolled_window.set_child (general_box);
                    break;
                case View.SYSTEM:
                    if (system_box == null)
                        system_box = new SystemBox ();
                    
                    content_scrolled_window.set_child (system_box);
                    break;
                case View.INTERNET:
                    if (internet_box == null)
                        internet_box = new InternetBox (window);
                    
                    content_scrolled_window.set_child (internet_box);
                    break;
                case View.POWER:
                    if (power_box == null)
                        power_box = new PowerBox ();
                    
                    content_scrolled_window.set_child (power_box);
                    break;
                case View.AUDIO:
                    if (audio_box == null)
                        audio_box = new AudioBox ();
                    
                    content_scrolled_window.set_child (audio_box);
                    break;
                case View.LIBRARY:
                    if (library_box == null)
                        library_box = new LibraryBox (window);
                    
                    content_scrolled_window.set_child (library_box);
                    break;
                case View.INTERFACE:
                    if (interface_box == null)
                        interface_box = new InterfaceBox ();
                    
                    content_scrolled_window.set_child (interface_box);
                    break;
            }
        }

        public enum View {
            GENERAL,
            SYSTEM,
            INTERNET,
            POWER,
            AUDIO,
            LIBRARY,
            INTERFACE,
        }
    }
}