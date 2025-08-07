namespace Protonium.Models.Games {
    public class Steam : Game {
        public string id { get; set; }

        public Steam (string name, string id) {
            base (name);

            this.id = id;
        }

        public override bool play (Gtk.Window window) {
            Utils.System.get_instance ().open_uri (window, "steam://rungameid/%s".printf (id));

            return true;
        }
    }
}