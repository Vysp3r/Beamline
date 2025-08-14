namespace Protonium.Widgets {
    public class Image : Gtk.Widget {
        public bool use_texture_size;
        Gdk.Texture _texture;
        public Gdk.Texture texture {
            get { return _texture; }
            set {
                _texture = value;

                queue_draw();
            }
        }

        public void load (string image_path) {
            new Thread<void> ("load_image", () => {
                texture = Utils.Filesystem.get_texture_from_file (image_path);
            });
        }

        public void unload () {
            texture = null;
        }

        public override void snapshot (Gtk.Snapshot snapshot) {
            if (texture == null)
                return;

            var width  = use_texture_size ? texture.get_width () : get_width ();

            var height = use_texture_size ? texture.get_height () : get_height ();

            if (use_texture_size) {
                width_request = width;
                height_request = height;
            }
                
            var rect = Graphene.Rect();
            rect.init (0, 0, width, height);
 
            snapshot.append_scaled_texture(texture, Gsk.ScalingFilter.TRILINEAR,  rect);
        }
    }
}