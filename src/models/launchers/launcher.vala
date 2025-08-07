namespace Protonium.Models.Launchers {
    public abstract class Launcher : Object {
        public Utils.Importers.Importer importer { get; private set; }
        public Gee.ArrayList<Games.Game> games { get; private set; }
        public string name { get; private set; }
        public string description { get; private set; }
        public string website { get; private set; }
        public string directory { get; private set; }
        public Source source { get; private set; }

        public enum Source {
            NOT_INSTALLED,
            SYSTEM,
            FLATPAK,
            SNAP,
        }
        
        protected Launcher (Utils.Importers.Importer importer, string name, string description, string website, string directory, Source source) {
            this.importer = importer;
            this.name = name;
            this.description = description;
            this.website = website;
            this.directory = directory;
            this.source = source;
        }

        public void load_games () {
            games = importer.import ();
        }

        public abstract void initialize ();

        public static Gee.ArrayList<Launcher> get_launchers () {
            var launchers = new Gee.ArrayList<Launcher> ();

            launchers.add_all (Steam.get_steam_launchers ());

            launchers.add_all (HeroicGamesLauncher.get_hgl_launchers ());

            return launchers;
        }
    }
}