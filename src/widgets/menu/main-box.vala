namespace Protonium.Widgets.Menu {
    public class MainBox : Gtk.Box {
        public View current_view;

        Window window;
        MenuBox menu_box;
        PowerBox power_box;
        FilterBox filter_box;
        OrderByBox order_by_box;
        OptionsBox options_box;
        public ConnectionBox connection_box;
        Gtk.Overlay menu_overlay;

        public MainBox (Window window) {
            Object (visible: false);

            this.window = window;

            menu_box = new MenuBox (window) {
                visible = false,
            };
            
            power_box = new PowerBox () {
                visible = false,
            };

            filter_box = new FilterBox (window) {
                visible = false,
            };

            order_by_box = new OrderByBox (window) {
                visible = false,
            };

            options_box = new OptionsBox (window) {
                visible = false,
            };

            connection_box = new ConnectionBox () {
                visible = false,
            };

            menu_overlay = new Gtk.Overlay () {
                hexpand = true,
                vexpand = true,
            };
            menu_overlay.add_overlay (menu_box);
            menu_overlay.add_overlay (power_box);
            menu_overlay.add_overlay (filter_box);
            menu_overlay.add_overlay (order_by_box);
            menu_overlay.add_overlay (options_box);
            menu_overlay.add_overlay (connection_box);
            
            append (menu_overlay);
            add_css_class ("menu-main-box");
        }

        public void load (Models.Games.Game? game) {
            options_box.load (game);
        }

        public void set_view (View view) {
            this.current_view = view;

            set_visible (view != View.NONE);

            window.bar_main_box?.bottom_bar?.show_extra_buttons (view == View.NONE && window.current_view == Window.View.LIBRARY);

            menu_box.set_visible (view == View.MENU);

            power_box.set_visible (view == View.POWER);

            filter_box.set_visible (view == View.FILTER);

            order_by_box.set_visible (view == View.ORDER_BY);
            
            options_box.set_visible (view == View.OPTIONS);

            connection_box.set_visible (view == View.CONNECTION);
        }

        public enum View {
            NONE,
            MENU,
            FILTER,
            ORDER_BY,
            OPTIONS,
            POWER,
            CONNECTION,
        }
    }
}