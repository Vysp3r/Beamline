namespace Protonium.Widgets.Onboarding {
    public class ControllerPage : Gtk.Widget {
        Adw.StatusPage controller_status_page;

        public ControllerPage () {
            controller_status_page = new Adw.StatusPage () {
                title = _("Optimized for gamepads"),
                description = _("The application was designed from the ground up to be use with a gamepad while still being easy to use with a keyboard/mouse"),
                icon_name = "controller-symbolic",
            };
            controller_status_page.set_parent (this);

            var bin_layout = new Gtk.BinLayout ();

            set_layout_manager (bin_layout);
            set_hexpand (true);
            set_vexpand (true);

            destroy.connect (controller_page_on_destroy);
        }

        void controller_page_on_destroy () {
            controller_status_page.unparent ();
			controller_status_page.destroy ();
		}
    }
}