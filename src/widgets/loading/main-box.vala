namespace Protonium.Widgets.Loading {
    public class MainBox : Gtk.Box {
        bool done;

        Window window;
        Gtk.ProgressBar progress_bar;

        public MainBox (Window window) {
            this.window = window;

            progress_bar = new Gtk.ProgressBar () {
                halign = Gtk.Align.CENTER,
                hexpand = false,
                width_request = 350,
            };

            var status_page = new Adw.StatusPage () {
                title = _("Loading..."),
                description = "%s %s".printf(_("Taking longer than normal?"), _("Make sure to report this on GitHub.")),
                icon_name = "sandglass-symbolic",
                child = progress_bar,
                vexpand = true,
                hexpand = true,
            };

            Timeout.add_full (Priority.DEFAULT, 75, () => {
                progress_bar.pulse ();

                return !done;
            });
            
            load.begin ((obj, res) => {
                done = true;

                window.set_view (Window.View.HOME);

                window.home_main_box.set_view (Home.MainBox.View.LIBRARY);
            });

            append (status_page);
        }

        async void load () {
            SourceFunc callback = load.callback;

            Utils.Network.get_instance ();

            new Thread<void> ("load", () => {
                window.launchers = Models.Launchers.Launcher.get_launchers ();

                foreach (var launcher in window.launchers) {
                    launcher.initialize ();

                    launcher.load_games ();
                }

                Utils.System.get_instance ();

                Idle.add ((owned) callback, Priority.DEFAULT);
            });

            yield;
        }
    }
}

