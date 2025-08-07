namespace Protonium.Utils.Importers {
    public class HeroicGamesLauncher : Importer {
        public HeroicGamesLauncher (string directory) {
            base (directory);
        }

        public override Gee.ArrayList<Models.Games.Game>? import () {
            var games = new Gee.ArrayList<Models.Games.Game> ();

            return (owned) games;
        }
    }
}