namespace Protonium.Utils.Importers {
    public class Steam : Importer {
        public Steam (string directory) {
            base (directory);
        }

        public override Gee.ArrayList<Models.Games.Game>? import () {
            var manifest_directories = get_manifest_directories ();
            if (manifest_directories == null)
                return null;

            var games = new Gee.ArrayList<Models.Games.Game> ();

            foreach (var manifest_directory in manifest_directories) {
                var manifests = get_manifests (manifest_directory);
                if (manifests == null)
                    return null;

                foreach (var manifest in manifests) {
                    var node = Parser.get_vdf_node_from_file (manifest);
                    if (node == null)
                        return null;

                    var appid = node["appid"].get_string ();
                    var name = node["name"].get_string ();
                    var installdir = node["installdir"].get_string ();
                    var last_played = node["LastPlayed"].get_string ();

                    var install_path = "%s/common/%s".printf (manifest_directory, installdir);
                    if (!FileUtils.test (install_path, FileTest.IS_DIR))
                        continue;

                    var info_path = "%s/steam/info/%s.json".printf (Widgets.Application.data_path, appid);

                    string info_json = null;
                    if (FileUtils.test (info_path, FileTest.EXISTS))
                        info_json = Filesystem.get_file_content (info_path, false);
                    else
                        info_json = Web.get_request ("https://store.steampowered.com/api/appdetails?appids=%s".printf (appid));
                    if (info_json == null)
                        continue;
                    
                    var info_node = Parser.get_json_node_from_json (info_json);
                    if (info_node == null)
                        continue;
                    
                    var store_object = info_node.get_object ();
                    if (store_object == null)
                        continue;

                    if (!store_object.has_member (appid))
                        continue;
                    var main_object = store_object.get_object_member (appid);
                    if (!main_object.has_member ("data"))
                        continue;
                    var data_object = main_object.get_object_member ("data");

                    if (!FileUtils.test (info_path, FileTest.EXISTS))
                        Filesystem.create_file (info_path, info_json);

                    var short_description = data_object.has_member ("short_description") ? data_object.get_string_member ("short_description") : null;

                    var release_date_object = data_object.has_member ("release_date") ? data_object.get_object_member ("release_date") : null;
                    
                    string release_date = null;
                    if (release_date_object != null)
                        release_date = release_date_object.has_member ("date") ? release_date_object.get_string_member ("date") : null;

                    Gee.ArrayList<string> genres = null;
                    if (data_object.has_member ("genres")) {
                        var genres_array = data_object.get_array_member ("genres");
                        genres = new Gee.ArrayList<string> ();
                        for (int i = 0; i < genres_array.get_length (); i++) {
                            var genre_object = genres_array.get_object_element (i);

                            genres.add (genre_object.get_string_member ("description"));
                        }
                    }

                    Gee.ArrayList<string> developers = null;
                    if (data_object.has_member ("developers")) {
                        var developers_array = data_object.get_array_member ("developers");
                        developers = new Gee.ArrayList<string> ();
                        for (int i = 0; i < developers_array.get_length (); i++) {
                            developers.add(developers_array.get_string_element (i));
                        }
                    }

                    var game = new Models.Games.Steam (name, appid) {
                        short_description = short_description,
                        release_date = release_date,
                        genres = genres,
                        developers = developers,
                    };

                    string images_path = "/home/vysp3r/.steam/steam/appcache/librarycache/%s".printf (game.id);

                    string[] cover_filenames = {
                        "library_600x900_2x.jpg",
                        "library_600x900.jpg",
                        "library_capsule.jpg"
                    };

                    foreach (var cover_filename in cover_filenames) {
                        game.cover_image_path = Filesystem.find_file_in_directory (images_path, cover_filename);

                        if (game.cover_image_path != null)
                            break;
                    }

                    if (game.cover_image_path == null) {
                        game.cover_image_path = Filesystem.find_first_file_from_type_in_directory (images_path, "jpg");

                        if (game.cover_image_path == null)
                            warning ("Cover image failed to load for %s (%s).".printf (game.name, game.id));
                    }

                    string[] background_filenames = {
                        "library_header.jpg",
                        "library_hero.jpg",
                        "header.jpg"
                    };
    
                    foreach (var background_filename in background_filenames) {
                        game.background_image_path = Filesystem.find_file_in_directory (images_path, background_filename);

                        if (game.background_image_path != null)
                            break;
                    }

                    if (game.background_image_path == null)
                        warning ("Background image failed to load for %s (%s).".printf (game.name, game.id)); 

                    games.add (game);
                }
            }

            

            return (owned) games;
        }

        string[]? get_manifests (string manifest_directory) {
            var manifests = new string[0];

            var files = Filesystem.list_files_from_type_in_directory (manifest_directory, ".acf");
            if (files == null || files.length == 0)
                return null;
                
            for (var i = 0; i < files.length; i++) {
                manifests.resize (manifests.length + 1);
                        
                manifests[manifests.length - 1] = files[i];

                // message(manifests[manifests.length - 1]);
            }

            return manifests;
        }

        string[]? get_manifest_directories () {
            var manifest_directories = new string[0];

            //TODO Get that file from the launcer model (this import process must be run for each instance of steam found)
            var node = Parser.get_vdf_node_from_file ("%s/steamapps/libraryfolders.vdf".printf (directory));
            if (node == null)
                return null;
            
            node.filter ((entry) => {
                return str_equal (entry.key, "path");
            }).foreach ((entry)=>{
                manifest_directories.resize (manifest_directories.length + 1);
                        
                manifest_directories[manifest_directories.length - 1] = "%s/steamapps".printf (entry.value.get_string ());

                // message(manifest_directories[manifest_directories.length - 1]);

                return true;
            });

            return manifest_directories;
        }
    }
}