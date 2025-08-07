namespace Protonium.Widgets.Onboarding {
    public class LaunchersPage : Gtk.Widget {
        Adw.StatusPage launchers_status_page;

        public LaunchersPage () {
            var steam_button = new Gtk.Button.with_label ("Steam");

            var ea_app_button = new Gtk.Button.with_label ("EA app ");

            var ubisoft_connect_button = new Gtk.Button.with_label ("Ubisoft Connect ");

            var battles_net_button = new Gtk.Button.with_label ("Battles.net");

            var epic_games_launcher__button = new Gtk.Button.with_label ("Epic Games Launcher");

            var hgl_button = new Gtk.Button.with_label ("Heroic Games Launcher");

            var lutris_button = new Gtk.Button.with_label ("Lutris");

            var bottles_button = new Gtk.Button.with_label ("Bottles");

            var winezgui_button = new Gtk.Button.with_label ("WineZGUI");

            var itch_button = new Gtk.Button.with_label ("Itch");

            var legendary_button = new Gtk.Button.with_label ("Legendary");

            var retroarch_button = new Gtk.Button.with_label ("RetroArch");

            var wrap_box = new Adw.WrapBox () {
                child_spacing = 15,
                line_spacing = 15,
                align = 0.5f,
            };
            wrap_box.append (steam_button);
            wrap_box.append (ea_app_button);
            wrap_box.append (ubisoft_connect_button);
            wrap_box.append (battles_net_button);
            wrap_box.append (epic_games_launcher__button);
            wrap_box.append (hgl_button);
            wrap_box.append (lutris_button);
            wrap_box.append (bottles_button);
            wrap_box.append (winezgui_button);
            wrap_box.append (itch_button);
            wrap_box.append (legendary_button);
            wrap_box.append (retroarch_button);

            var clamp = new Adw.Clamp () {
                child = wrap_box,
                maximum_size = 700,
            };

            launchers_status_page = new Adw.StatusPage () {
                title = _("Play games from your favorite launchers easily"),
                icon_name = "books-symbolic",
                child = clamp,
            };
            launchers_status_page.set_parent (this);

            var bin_layout = new Gtk.BinLayout ();

            set_layout_manager (bin_layout);
            set_hexpand (true);
            set_vexpand (true);

            destroy.connect (launchers_page_on_destroy);
        }

        void launchers_page_on_destroy () {
            launchers_status_page.unparent ();
			launchers_status_page.destroy ();
		}
    }
}