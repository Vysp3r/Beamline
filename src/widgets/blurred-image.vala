namespace Protonium.Widgets {
    public class BlurredImage : Gtk.Widget {
        Gdk.Texture? _texture;

        public Gdk.Texture? texture {
            get { return _texture; }
            set {
                _texture = value;

                queue_draw();
            }
        }

        public BlurredImage () {
            Object (focusable: true);
        }

        public void load (string image_path) {
            new Thread<void> ("load_blurred_image", () => {
                texture = Utils.Filesystem.get_texture_from_file (image_path);
            });
        }

        public void unload () {
            texture = null;
        }

        public override void snapshot (Gtk.Snapshot snapshot) {
            if (texture == null)
                return;

            var rect = Graphene.Rect();
            rect.init (0, 0, get_width (), get_height ());

            snapshot.push_blur (90);

            snapshot.append_scaled_texture(texture, Gsk.ScalingFilter.TRILINEAR,  rect);

            snapshot.pop();
        }
    }
}