namespace Protonium.Utils.Importers {
    public abstract class Importer : Object {
        protected string directory { get; private set; }

        protected Importer (string directory) {
            this.directory = directory;
        }

        public abstract Gee.ArrayList<Models.Games.Game>? import ();
    }
}