namespace Protonium.Utils {
    public class Filesystem {
        public static string? get_file_content (string path, bool use_uri = false) {
            try {
                File file = File.new_for_path (path);

                uint8[] contents;
                
                file.load_contents (null, out contents, null);

                return (string) contents;
            } catch (Error e) {
                warning (e.message);
            }

            return null;
        }

        public static string? find_file_in_directory (string source_path, string filename) {
            try {
                Dir dir = Dir.open (source_path);
                string? current_filename = null;
                while ((current_filename = dir.read_name ()) != null) {
                    var path = "%s/%s".printf (source_path, current_filename);

                    if (current_filename == filename && FileUtils.test (path, FileTest.IS_REGULAR)) {
                        return path;
                    }

                    if (FileUtils.test (path, FileTest.IS_DIR)) {
                        var result = find_file_in_directory (path, filename);

                        if (result != null)
                            return result;
                     }
                }
            } catch (Error e) {
                warning (e.message);
            }

            return null;
        }

        public static string? find_first_file_from_type_in_directory (string source_path, string filetype) {
            try {
                Dir dir = Dir.open (source_path);
                string? current_filename = null;
                while ((current_filename = dir.read_name ()) != null) {
                    var path = "%s/%s".printf (source_path, current_filename);

                    if (current_filename.contains (filetype) && FileUtils.test (path, FileTest.IS_REGULAR)) {
                        return path;
                    }

                    if (FileUtils.test (path, FileTest.IS_DIR)) {
                        var result = find_first_file_from_type_in_directory (path, filetype);

                        if (result != null)
                            return result;
                     }
                }
            } catch (Error e) {
                warning (e.message);
            }

            return null;
        }

        public static string[]? list_files_from_type_in_directory (string source_path, string filetype) {
            var files = new string[0];

            try {
                Dir dir = Dir.open (source_path);
                string? current_filename = null;
                while ((current_filename = dir.read_name ()) != null) {
                    var path = "%s/%s".printf (source_path, current_filename);

                    if (current_filename.contains (filetype) && FileUtils.test (path, FileTest.IS_REGULAR)) {
                        files.resize (files.length + 1);
                        
                        files[files.length - 1] = path;
                    }
                }
            } catch (Error e) {
                warning (e.message);
            }

            return files;
        }

        public static void create_file (string path, string? content = null) {
            try {
                var file = File.parse_name (path);

                FileOutputStream os = file.create (FileCreateFlags.NONE);

                if (content != null)
                    os.write (content.data);
            } catch (Error e) {
                warning (e.message);
            }
        }

        public static bool delete_file (string path) {
            try {
                var file = GLib.File.new_for_path (path);
                return file.delete ();
            } catch (Error e) {
                warning (e.message);
            }

            return false;
        }

        public static bool create_directory (string path) {
            try {
                var directory = GLib.File.new_for_path (path);

                return directory.make_directory ();
            } catch (Error e) {
                warning (e.message);
            }

            return false;
        }

        public static Gdk.Texture? get_texture_from_file (string path) {
            try {
                return Gdk.Texture.from_filename (path);
            } catch (Error e) {
                warning (e.message);
            }

            return null;
        }

        public static Gdk.Texture? get_texture_from_bytes (string path) {
            try {
                return Gdk.Texture.from_filename (path);
            } catch (Error e) {
                warning (e.message);
            }

            return null;
        }
    }
}
