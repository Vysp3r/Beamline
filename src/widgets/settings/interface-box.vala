namespace Protonium.Widgets.Settings {
    public class InterfaceBox : Gtk.Box {
        Gtk.Scale scaling_scale;
        Adw.PreferencesRow scaling_row;

        public InterfaceBox () {
            Object (orientation: Gtk.Orientation.VERTICAL, spacing: 15);

            var title_label = new Gtk.Label (_("Interface")) {
                css_classes = { "title-label" },
            };

            var enable_automatic_scaling_row = new Adw.SwitchRow () {
                title = _("Enable automatic scaling"),
            };

            Application.settings.bind ("enable-automatic-scaling",
                            enable_automatic_scaling_row,
                            "active",
                            SettingsBindFlags.DEFAULT);

            scaling_scale = new Gtk.Scale (Gtk.Orientation.HORIZONTAL, null);
            scaling_scale.set_increments (0.1, 0.1);
            scaling_scale.set_range (0.20, 5);
            scaling_scale.set_round_digits (2);
            scaling_scale.add_mark (1, Gtk.PositionType.TOP, null);
            scaling_scale.set_value (Application.settings.get_double ("scaling"));
            scaling_scale.value_changed.connect (scaling_scale_value_changed);

            var smaller_label = new Gtk.Label (_("Smaller")) {
                hexpand = true,
                halign = Gtk.Align.START,
            };

            var larger_label = new Gtk.Label (_("Larger"));

            var scaling_bottom_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
            scaling_bottom_box.append (smaller_label);
            scaling_bottom_box.append (larger_label);

            var scaling_box = new Gtk.Box (Gtk.Orientation.VERTICAL, 0) {
                margin_start = 15,
                margin_end = 15,
                margin_top = 15,
                margin_bottom = 15,
            };
            scaling_box.append (scaling_scale);
            scaling_box.append (scaling_bottom_box);

            scaling_row = new Adw.PreferencesRow () {
                child = scaling_box,
                visible = !Application.settings.get_boolean ("enable-automatic-scaling"),
            };

            Application.settings.changed["enable-automatic-scaling"].connect (enable_automatic_scaling_changed);

            var enable_background_row = new Adw.SwitchRow () {
                title = _("Enable blurred background"),
            };

            Application.settings.bind ("enable-blurred-background",
                            enable_background_row,
                            "active",
                            SettingsBindFlags.DEFAULT);

            var group = new Adw.PreferencesGroup ();
            group.add (enable_automatic_scaling_row);
            group.add (scaling_row);
            group.add (enable_background_row);

            append (title_label);
            append (group);
            add_css_class ("interface-box");
        }

        void enable_automatic_scaling_changed () {
            scaling_row.set_visible (!Application.settings.get_boolean ("enable-automatic-scaling"));
        }

        void scaling_scale_value_changed () {
            Application.settings.set_double ("scaling", scaling_scale.get_value ());
        }
    }
}