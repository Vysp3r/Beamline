namespace Protonium.Utils {
    public class CSS : Object {
        static CSS? instance = null;

        Gtk.CssProvider css_provider;
        public double scale_factor { get; set; }

        CSS () {
            var display = Gdk.Display.get_default ();

            css_provider = new Gtk.CssProvider ();

            Gtk.StyleContext.add_provider_for_display (display, css_provider, Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION);

            Widgets.Application.settings.bind ("scale-factor",
                            this,
                            "scale_factor",
                            SettingsBindFlags.GET);

            Widgets.Application.settings.changed["scale-factor"].connect (load);

            load ();
        }

        public void load () {
            try {
                var file = File.new_for_uri ("resource://com/vysp3r/Beamline/css/style.css");
                var stream = file.read();
                var data_input = new DataInputStream(stream);

                var font_size = "font-size: ";
                var icon_size = "icon-size: ";
                
                var px = "px;";
                var modified_css_string_builder = new StringBuilder ();
                string? line;
                while ((line = data_input.read_line(null)) != null) {
                    if (line.contains (font_size)) {
                        var start_pos = line.index_of (font_size, 0) + font_size.length;
                        var end_pos = line.index_of (px, start_pos);
                        var value = line.substring (start_pos, end_pos - start_pos);
                        line = line.replace (value, "%f".printf (double.parse (value) * scale_factor));
                    }

                    if (line.contains (icon_size)) {
                        var start_pos = line.index_of (icon_size, 0) + icon_size.length;
                        var end_pos = line.index_of (px, start_pos);
                        var value = line.substring (start_pos, end_pos - start_pos);
                        line = line.replace (value, "%f".printf (double.parse (value) * scale_factor));
                    }

                    modified_css_string_builder.append (line);
                }

                css_provider.load_from_string (modified_css_string_builder.str);
            } catch (Error e) {
                warning (e.message);
            }
        }

        public static CSS get_instance() {
            if (instance == null)
                instance = new CSS();

            return instance;
        }
    }
}