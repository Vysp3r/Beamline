namespace Protonium.Models {
    public class Resolution : Object {
        public string name { get; private set; }
        public Size size { get; private set; }

        public Resolution (string name, Size size) {
            this.name = name;
            this.size = size;
        }

        public static Gee.ArrayList<Resolution> get_resolutions () {
            var resolutions = new Gee.ArrayList<Resolution> ();

            resolutions.add (new Resolution (_("720p (HD)"), Size.HD));
            resolutions.add (new Resolution (_("1080p (FHD)"), Size.FULL_HD));
            resolutions.add (new Resolution (_("1440p (QHD)"), Size.QUAD_HD));
            resolutions.add (new Resolution (_("2560p (UHD)"), Size.ULTRA_HD));
            
            return resolutions;
        }

        public enum Size {
            HD,
            FULL_HD,
            QUAD_HD,
            ULTRA_HD,
        }
    }
}