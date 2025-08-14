namespace Protonium.Widgets.Settings {
    public class PowerBox : Gtk.Box {
        public PowerBox () {
            Object (orientation: Gtk.Orientation.VERTICAL, spacing: 15);

            var title_label = new Gtk.Label (_("Power")) {
                css_classes = { "title-label" },
            };

            var battery_row = new Adw.SwitchRow () {
                title = _("Battery percentage"),
                subtitle = _("Show battery percentage in header"),
            };

            Application.settings.bind ("show-battery-percentage",
                            battery_row,
                            "active",
                            SettingsBindFlags.DEFAULT);

            var group = new Adw.PreferencesGroup ();
            group.add (battery_row);

            append (title_label);
            append (group);
            add_css_class ("power-box");
        }
    }
}