namespace Protonium.Models.Games {
    public abstract class Game : Object {
        public string name { get; set; }
        public int64 last_played { get; set; }
        public int64 added { get; set; }
        public string? short_description { get; set; }
        public string? release_date { get; set; }
        public Gee.ArrayList<string>? genres { get; set; }
        public Gee.ArrayList<string>? developers { get; set; }
        public string? cover_image_path{ get; set; }
        public string? background_image_path { get; set; }

        protected Game (string name) {
            this.name = name;
        }

        public abstract bool play (Gtk.Window window);
    }
}