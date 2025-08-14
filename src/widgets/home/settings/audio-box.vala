namespace Protonium.Widgets.Settings {
    public class AudioBox : Gtk.Box {
        Gtk.Scale output_scale;
        Gtk.Scale input_scale;

        public AudioBox () {
            Object (orientation: Gtk.Orientation.VERTICAL, spacing: 15);

            var title_label = new Gtk.Label (_("Audio")) {
                css_classes = { "title-label" },
            };

            var output_icon = new Gtk.Image.from_icon_name ("volume-symbolic");

            output_scale = new Gtk.Scale (Gtk.Orientation.HORIZONTAL, null) {
                hexpand = true,
            };
            output_scale.set_increments (1, 1);
            output_scale.set_range (0, 100);

            var output_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 15){
                css_classes = { "scale-box" },
            };
            output_box.append (output_icon);
            output_box.append (output_scale);

            var output_row = new Adw.PreferencesRow ();
            output_row.set_child (output_box);

            var output_group = new Adw.PreferencesGroup () {
                title = _("Output"),
            };
            output_group.add (output_row);

            var input_icon = new Gtk.Image.from_icon_name ("microphone-2-symbolic");

            input_scale = new Gtk.Scale (Gtk.Orientation.HORIZONTAL, null) {
                hexpand = true,
            };
            input_scale.set_increments (1, 1);
            input_scale.set_range (0, 100);

            update_volume ();

            output_scale.value_changed.connect (() => {
                Utils.System.Sound.set_volume (Utils.System.Sound.Type.SINK, (uint) output_scale.get_value ());
            });
            
            input_scale.value_changed.connect (() => {
                Utils.System.Sound.set_volume (Utils.System.Sound.Type.SOURCE, (uint) input_scale.get_value ());
            });

            var input_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 15) {
                css_classes = { "scale-box" },
            };
            input_box.append (input_icon);
            input_box.append (input_scale);

            var input_row = new Adw.PreferencesRow ();
            input_row.set_child (input_box);

            var input_group = new Adw.PreferencesGroup () {
                title = _("Input"),
            };
            input_group.add (input_row);

            var ui_sound_row = new Adw.SwitchRow () {
                title = _("Enable UI sounds"),
            };

            Application.settings.bind ("enable-ui-sound",
                            ui_sound_row,
                            "active",
                            SettingsBindFlags.DEFAULT);

            var general_group = new Adw.PreferencesGroup () {
                title = _("General"),
            };
            general_group.add (ui_sound_row);
            
            notify["parent"].connect (parent_changed);
            
            append (title_label);
            append (output_group);
            append (input_group);
            append (general_group);
            add_css_class ("audio-box");
        }

        void parent_changed () {
            if (get_parent () == null)
                return;

            Timeout.add (100, () => {
                update_volume ();

                return get_parent () != null;
            });
        }

        void update_volume () {
            output_scale.set_value (Utils.System.Sound.get_volume (Utils.System.Sound.Type.SINK));
            input_scale.set_value (Utils.System.Sound.get_volume (Utils.System.Sound.Type.SOURCE));
        }
    }
}