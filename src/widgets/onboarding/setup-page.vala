namespace Protonium.Widgets.Onboarding {
    public class SetupPage : Gtk.Widget {
        public signal void done ();

        Gtk.Button proceed_button;
        Gtk.ProgressBar progress_bar;
        Adw.StatusPage setup_status_page;

        public SetupPage () {
            proceed_button = new Gtk.Button.with_label (_("Start setup")) {
                halign = Gtk.Align.CENTER,
                css_classes = { "pill", "suggested-action" },
            };
            proceed_button.clicked.connect (proceed_button_clicked);

            progress_bar = new Gtk.ProgressBar () {
                visible = false,
                width_request = 350,
            };

            var setup_box = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
            setup_box.set_halign (Gtk.Align.CENTER);
            setup_box.append (proceed_button);
            setup_box.append (progress_bar);

            setup_status_page = new Adw.StatusPage () {
                title = _("Almost ready"),
                description = _("We need some time to set everything up..."),
                icon_name = "automation-symbolic",
                child = setup_box,
            };
            setup_status_page.set_parent (this);

            var bin_layout = new Gtk.BinLayout ();

            set_layout_manager (bin_layout);
            set_hexpand (true);
            set_vexpand (true);

            destroy.connect (setup_page_on_destroy);
        }

        void setup_page_on_destroy () {
            setup_status_page.unparent ();
			setup_status_page.destroy ();
		}

        void proceed_button_clicked () {
            proceed_button.set_visible (false);

            progress_bar.set_visible (true);

            setup.begin ((obj, res) => {
                var success = setup.end (res);
                if (!success)
                    message("ERROR!");

                progress_bar.set_visible (false);

                proceed_button.set_visible (true);

                proceed_button.set_sensitive (false);
                
                done ();
            });
        }

        async bool setup () {
            SourceFunc callback = setup.callback;

            bool output = false;
            new Thread<void> ("setup", () => {
                int counter = 0;

                for (var i = 0; i <= 100; i++) {
                    counter++;
                    progress_bar.pulse ();
                    Thread.usleep (50000);
                }

                output = true;

                Idle.add ((owned) callback, Priority.DEFAULT);
            });

            yield;
            return output;
        }
    }
}