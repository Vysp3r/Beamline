namespace Protonium.Widgets.Menu {
    public class PowerBox : Gtk.Box {
        public PowerBox () {
            Object (
                orientation: Gtk.Orientation.VERTICAL,
                spacing: 15,
                halign: Gtk.Align.CENTER,
                valign: Gtk.Align.CENTER,
                width_request: 500
            );

            var title_label = new Gtk.Label (_("Power")) {
                css_classes = { "title-label" },
            };

            var suspend_button = new Gtk.Button.with_label (_("Suspend system"));
            suspend_button.clicked.connect (suspend_button_clicked);

            var turn_off_button = new Gtk.Button.with_label (_("Turn off system"));
            turn_off_button.clicked.connect (turn_off_button_clicked);

            var restart_button = new Gtk.Button.with_label (_("Restart system"));
            restart_button.clicked.connect (restart_button_clicked);

            var exit_button = new Gtk.Button.with_label (_("Exit"));
            exit_button.clicked.connect (exit_button_clicked);

            append (title_label);
            append (suspend_button);
            append (turn_off_button);
            append (restart_button);
            append (exit_button);
            add_css_class ("power-box");
        }

        void suspend_button_clicked () {
            message ("Suspend");
        }

        void turn_off_button_clicked () {
            message ("Turn off");
        }

        void restart_button_clicked () {
            message ("Restart");
        }

        void exit_button_clicked () {
            message ("Exit");
        }
    }
}