namespace Protonium.Widgets.Onboarding {
    public class DonePage : Gtk.Widget {
        Window window;
        Adw.StatusPage done_status_page;

        public DonePage (Window window) {
            this.window = window;

            var finish_button = new Gtk.Button.with_label (_("Access %s").printf (Config.APP_NAME)) {
                halign = Gtk.Align.CENTER,
                css_classes = { "pill", "suggested-action" },
            };
            finish_button.clicked.connect (done_button_clicked);

            done_status_page = new Adw.StatusPage () {
                title = _("Done"),
                description = _("You can now enjoy the application!"),
                icon_name = "confetti-symbolic",
                child = finish_button,
            };
            done_status_page.set_parent (this);

            var bin_layout = new Gtk.BinLayout ();

            set_layout_manager (bin_layout);
            set_hexpand (true);
            set_vexpand (true);

            destroy.connect (done_page_on_destroy);
        }

        void done_page_on_destroy () {
            done_status_page.unparent ();
			done_status_page.destroy ();
		}

        void done_button_clicked () {
            window.is_onboarding_done = true;

            activate_action_variant ("win.set-view", Window.View.LOADING);
        }
    }
}