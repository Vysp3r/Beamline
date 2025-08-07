namespace Protonium.Utils {
    public class Web {
        static string get_user_agent () {
            return "%s/%s".printf (Config.APP_NAME, Config.APP_VERSION);
        }

        public static string? get_request (string url) {
            try {
                var session = new Soup.Session ();
                session.set_user_agent (get_user_agent ());

                var message = new Soup.Message ("GET", url);

                Bytes bytes = session.send_and_read (message, null);

                return (string) bytes.get_data ();
            } catch (Error e) {
                message (e.message);
                return null;
            }
        }

        public static async bool download_image (string url, string path) {
            try {
                var session = new Soup.Session ();
                session.set_user_agent (get_user_agent ());

                var request = new Soup.Message ("GET", url);

                var response = yield session.send_and_read_async (request, Priority.DEFAULT, null);

                var file = GLib.File.new_for_path (path);
                var output_stream = yield file.create_async (FileCreateFlags.REPLACE_DESTINATION);
                yield output_stream.write_async (response.get_data ());

                return true;
            } catch (Error e) {
                warning (e.message);
            }

            return false;
        }
    }
}