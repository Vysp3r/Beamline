namespace Protonium.Widgets.Bar {
    public class MainBox : Gtk.Box {
        Window window;
        public Menu.MainBox menu_main_box;
        public TopBar top_bar;
        public BottomBar bottom_bar;
        public LibraryBar library_bar;
        Gtk.Overlay main_overlay;

        public MainBox (Window window) {
            this.window = window;
            
            menu_main_box = new Menu.MainBox (window);

            top_bar = new TopBar (window);

            bottom_bar = new BottomBar (window);

            library_bar = new LibraryBar (window);

            main_overlay = new Gtk.Overlay () {
                hexpand = true,
                vexpand = true,
            };
            main_overlay.add_overlay (menu_main_box);
            main_overlay.add_overlay (top_bar);
            main_overlay.add_overlay (bottom_bar);
            main_overlay.add_overlay (library_bar);

            append (main_overlay);
            add_css_class ("bar-main-box");
        }

        public void set_overlay_content (Gtk.Widget widget) {
            window.bar_main_box?.bottom_bar?.show_extra_buttons (widget is Library.MainBox);

            main_overlay.set_child (widget);
        }
    }
}