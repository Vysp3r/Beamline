namespace Protonium.Models.Launchers {
    public class HeroicGamesLauncher : Launcher {
        public HeroicGamesLauncher (string directory, Launcher.Source source) {
            base (
                new Utils.Importers.HeroicGamesLauncher (directory),
                "Heroic Games Launcher",
                _("A games launcher for GOG, Amazon and Epic Games for Linux, Windows and macOS."),
                "https://heroicgameslauncher.com/",
                directory,
                source
            );
        }

        public override void initialize () {

        }

        public static Gee.ArrayList<Launcher> get_hgl_launchers () {
            var launchers = new Gee.ArrayList<Launcher> ();

            if (launchers.is_empty) {
                var launcher = new HeroicGamesLauncher ("", Launcher.Source.NOT_INSTALLED);

                launchers.add (launcher);
            }

            return launchers;
        }
    }
}