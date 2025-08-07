namespace Protonium.Widgets.Onboarding {
    public class WelcomePage : Gtk.Widget {
        Adw.StatusPage welcome_status_page;

        public WelcomePage () {
            welcome_status_page = new Adw.StatusPage () {
                title = _("Welcome to %s").printf (Config.APP_NAME),
                description = _("A simple and modern game launcher"),
                icon_name = Config.APP_ID,
            };
            welcome_status_page.set_parent (this);

            var bin_layout = new Gtk.BinLayout ();

            set_layout_manager (bin_layout);
            set_hexpand (true);
            set_vexpand (true);

            destroy.connect (welcome_page_on_destroy);
        }

        void welcome_page_on_destroy () {
            welcome_status_page.unparent ();
			welcome_status_page.destroy ();
		}
    }
}