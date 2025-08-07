namespace Protonium.Widgets.Onboarding {
    public class MainBox : Gtk.Widget {
        SetupPage setup_page;
        DonePage done_page;
        Adw.Carousel carousel;
        Gtk.Button previous_button;
        Gtk.Button next_button;
        Gtk.Overlay overlay;

        public MainBox (Window window) {
            var welcome_page = new WelcomePage ();

            var controller_page = new ControllerPage ();

            var launchers_page = new LaunchersPage ();

            setup_page = new SetupPage ();
            setup_page.done.connect (setup_page_done);

            done_page = new DonePage (window);

            carousel = new Adw.Carousel () {
                hexpand = true,
                vexpand = true,
                allow_mouse_drag = true,
                allow_scroll_wheel = true,
                allow_long_swipes = true,
            };
            carousel.page_changed.connect (carousel_page_changed);
            carousel.append (welcome_page);
            carousel.append (controller_page);
            carousel.append (launchers_page);
            carousel.append (setup_page);

            var carousel_indicator = new Adw.CarouselIndicatorLines () {
                carousel = carousel,
            };

            previous_button = new Gtk.Button.from_icon_name ("go-previous-symbolic"){
                tooltip_text = _("Previous"),
                halign = Gtk.Align.START,
                valign = Gtk.Align.CENTER,
                css_classes = { "circular", "previous-button" },
            };
            previous_button.clicked.connect (previous_button_clicked);

            next_button = new Gtk.Button.from_icon_name ("go-next-symbolic") {
                tooltip_text = _("Next"),
                halign = Gtk.Align.END,
                valign = Gtk.Align.CENTER,
                css_classes = { "circular", "suggested-action", "next-button" },
            };
            next_button.clicked.connect (next_button_clicked);

            var carousel_box = new Gtk.Box (Gtk.Orientation.VERTICAL, 15) {
                css_classes = { "carousel-box" },
            };
            carousel_box.append (carousel);
            carousel_box.append (carousel_indicator);

            overlay = new Gtk.Overlay ();
            overlay.set_parent (this);
            overlay.set_child (carousel_box);
            overlay.add_overlay (previous_button);
            overlay.add_overlay (next_button);

            var bin_layout = new Gtk.BinLayout ();

            set_layout_manager (bin_layout);

            destroy.connect (main_box_on_destroy);

            carousel_page_changed(0);
            add_css_class ("onboarding-main-box");
        }

        void main_box_on_destroy () {
            overlay.unparent ();
			overlay.destroy ();
		}

        void carousel_page_changed (uint index) {
            previous_button.set_visible (index > 0);
            next_button.set_visible (index != carousel.get_n_pages () - 1);
        }

        void previous_button_clicked () {
            var index = (uint) carousel.get_position();
            var previous_page = carousel.get_nth_page(index - 1);
            carousel.scroll_to(previous_page, true);
        }

        void next_button_clicked () {
            var index = (uint) carousel.get_position();
            var next_page = carousel.get_nth_page(index + 1);
            carousel.scroll_to(next_page, true);
        }

        void setup_page_done () {
            carousel.append (done_page);

            next_button_clicked ();
        }
    }
}