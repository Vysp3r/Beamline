namespace Protonium.Utils {
    public class Parser {
        public static Json.Node? get_json_node_from_json (string json) {
            try {
                var node = Json.from_string (json);
                
                if (node != null)
                    return node;
            } catch (Error e) {
                warning (e.message);
            }

            return null;
        }

        public static VDF.Node? get_vdf_node_from_file (string path) {
            try {
                var file = GLib.File.new_for_path (path);
                var input_stream = file.read ();
                var reader = new DataInputStream (input_stream);
                string line;
                string current_object = null;
                var node = new VDF.Node ("root");

                while ((line = reader.read_line (null)) != null) {
                    line = line.strip ();

                    if (line.has_prefix ("}")) {
                        current_object = null;
                    } else if (line.has_prefix ("{")) {
                        current_object = line.replace ("{", "").replace ("{", "");
                    } else if (current_object != null) {
                        var parts = line.split ("\"");
                        if (parts.length >= 4) {
                            string property = parts[1];
                            string value = parts[3];

                            node.set (property, value);
                        }
                    }
                }

                input_stream.close ();

                return node;
            } catch (Error e) {
                message ("Error: %s\n", e.message);

                return null;
            }
        }
    }
}