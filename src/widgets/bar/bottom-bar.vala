namespace Protonium.Widgets {
    public class BottomBar : Gtk.Box {
        Window window;
        Gtk.Button menu_button;
        Gtk.Button filter_button;
        Gtk.Button order_by_button;
        Gtk.Button options_button;
        Adw.ButtonContent select_button_content;

        public BottomBar (Window window) {
            Object (vexpand: false, valign: Gtk.Align.END);

            this.window = window;

            var menu_button_content = new Adw.ButtonContent () {
                icon_name = "xbox-guide-symbolic",
                label = _("Menu"),
            };

            menu_button = new Gtk.Button () {
                child = menu_button_content,
                css_classes = { "flat" },
            };
            menu_button.clicked.connect (menu_button_clicked);

            var spacer = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0) {
                hexpand = true,
            };

            var filter_button_content = new Adw.ButtonContent () {
                icon_name = "xbox-button-x-symbolic",
                label = _("Filter"),
            };

            filter_button = new Gtk.Button () {
                child = filter_button_content,
                css_classes = { "flat" },
            };
            filter_button.clicked.connect (filter_button_clicked);

            var order_by_button_content = new Adw.ButtonContent () {
                icon_name = "xbox-button-y-symbolic",
                label = _("Order by"),
            };

            order_by_button = new Gtk.Button () {
                child = order_by_button_content,
                css_classes = { "flat" },
            };
            order_by_button.clicked.connect (order_by_button_clicked);

            var options_button_content = new Adw.ButtonContent () {
                icon_name = "xbox-button-menu-symbolic",
                label = _("Options"),
            };

            options_button = new Gtk.Button () {
                child = options_button_content,
                css_classes = { "flat" },
            };
            options_button.clicked.connect (options_button_clicked);

            select_button_content = new Adw.ButtonContent () {
                icon_name = "xbox-button-a-symbolic",
                label = _("Select"),
            };

            var select_button = new Gtk.Button () {
                child = select_button_content,
                css_classes = { "flat" },
            };
            select_button.clicked.connect (select_button_clicked);

            var back_button_content = new Adw.ButtonContent () {
                icon_name = "xbox-button-b-symbolic",
                label = _("Back"),
            };

            var back_button = new Gtk.Button () {
                child = back_button_content,
                css_classes = { "flat" },
            };
            back_button.clicked.connect (back_button_clicked);
  
            add_css_class ("bottom-box");
            append (menu_button);
            append (spacer);
            append (filter_button);
            append (order_by_button);
            append (options_button);
            append (select_button);
            append (back_button);
        }

        void menu_button_clicked () {
            window.bar_main_box.menu_main_box.set_view (Menu.MainBox.View.MENU);
        }

        void filter_button_clicked () {
            window.bar_main_box.menu_main_box.set_view (Menu.MainBox.View.FILTER);
        }

        void order_by_button_clicked () {
            window.bar_main_box.menu_main_box.set_view (Menu.MainBox.View.ORDER_BY);
        }

        void options_button_clicked () {
            window.bar_main_box.menu_main_box.set_view (Menu.MainBox.View.OPTIONS);
        }

        void select_button_clicked () {
            if (window.previous_focused_widget == null)
                return;

            window.previous_focused_widget.activate ();

            window.previous_focused_widget = null;
        }

        void back_button_clicked () {
            if (window.bar_main_box.menu_main_box.current_view != Menu.MainBox.View.NONE) {
                window.bar_main_box.menu_main_box.set_view (Menu.MainBox.View.NONE);
            } else if (window.current_view == Window.View.SETTINGS) {
                window.set_view (Widgets.Window.View.LIBRARY);

                window.bar_main_box?.bottom_bar?.show_extra_buttons (true);
            } else {
                window.library_main_box.show_game_box (false);
            }
        }

        public void show_extra_buttons (bool show) {
            menu_button.set_visible (show);
            filter_button.set_visible (show);
            order_by_button.set_visible (show);
            options_button.set_visible (show);
        }
    }
}