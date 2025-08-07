namespace Protonium.Models.Launchers {
    public class Steam : Launcher {
        public Steam (string directory, Launcher.Source source) {
            base (
                new Utils.Importers.Steam (directory),
                "Steam",
                "The ultimate destination for playing, discussing, and creating games.",
                "https://store.steampowered.com/",
                directory,
                source
            );
        }

        public override void initialize () {
            var steam_path = "%s/steam".printf (Widgets.Application.data_path);
            if (!FileUtils.test (steam_path, FileTest.IS_DIR))
                Utils.Filesystem.create_directory (steam_path);

            var steam_info_path = "%s/info".printf (steam_path);
            if (!FileUtils.test (steam_info_path, FileTest.IS_DIR))
                Utils.Filesystem.create_directory (steam_info_path);
        }

        public static Gee.ArrayList<Launcher> get_steam_launchers () {
            var launchers = new Gee.ArrayList<Launcher> ();

            var directories = new Gee.HashMap<string, Launcher.Source> ();
            directories.set ("%s/.local/share/Steam".printf (Environment.get_home_dir ()), Source.SYSTEM);
            directories.set ("%s/.steam/debian-installation".printf (Environment.get_home_dir ()), Source.SYSTEM);
            directories.set ("%s/.var/app/com.valvesoftware.Steam/data/Steam".printf (Environment.get_home_dir ()), Source.FLATPAK);
            directories.set ("%s/snap/steam/common/.steam/root".printf (Environment.get_home_dir ()), Source.SNAP);

            foreach (var directory in directories) {
                if (FileUtils.test (directory.key, FileTest.EXISTS)) {
                    var launcher = new Steam (directory.key, directory.value);

                    launchers.add (launcher);
                }
            }

            if (launchers.is_empty) {
                var launcher = new Steam ("", Source.NOT_INSTALLED);

                launchers.add (launcher);
            }

            return launchers;
        }
    }
}