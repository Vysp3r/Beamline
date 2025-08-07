namespace Protonium.Widgets.Settings {
    public class InterfaceBox : Gtk.Box {
        Adw.ComboRow resolution_row;

        public InterfaceBox () {
            Object (orientation: Gtk.Orientation.VERTICAL, spacing: 15);

            var title_label = new Gtk.Label (_("Interface")) {
                css_classes = { "title-label" },
            };

            var enable_automatic_scaling_row = new Adw.SwitchRow () {
                title = _("Enable automatic scaling"),
            };

            Application.settings.bind ("enable-automatic-scaling",
                            enable_automatic_scaling_row,
                            "active",
                            SettingsBindFlags.DEFAULT);

            var resolution_list_store = new ListStore (typeof (Models.Resolution));

            foreach (var resolution in Models.Resolution.get_resolutions ())
                resolution_list_store.append (resolution);

            var resolution_selection_model = new Gtk.SingleSelection (resolution_list_store);

            var resolution_factory = new Gtk.SignalListItemFactory ();
            resolution_factory.setup.connect (resolution_factory_setup);
            resolution_factory.bind.connect (resolution_factory_bind);

            resolution_row = new Adw.ComboRow () {
                title = _("Targeted resolution"),
                subtitle = _("Choose the resolution that best fits your screen"),
                visible = !Application.settings.get_boolean ("enable-automatic-scaling"),
            };
            resolution_row.set_factory (resolution_factory);
            resolution_row.set_model (resolution_selection_model);
            resolution_row.set_selected (Application.settings.get_enum ("resolution"));
            resolution_row.notify["selected-item"].connect (resolution_row_selected_item_changed);

            Application.settings.changed["enable-automatic-scaling"].connect (enable_automatic_scaling_changed);

            var enable_background_row = new Adw.SwitchRow () {
                title = _("Enable blurred background"),
            };

            Application.settings.bind ("enable-blurred-background",
                            enable_background_row,
                            "active",
                            SettingsBindFlags.DEFAULT);

            var group = new Adw.PreferencesGroup ();
            group.add (enable_automatic_scaling_row);
            group.add (resolution_row);
            group.add (enable_background_row);

            append (title_label);
            append (group);
            add_css_class ("interface-box");
        }

        void enable_automatic_scaling_changed () {
            resolution_row.set_visible (!Application.settings.get_boolean ("enable-automatic-scaling"));
        }

        void resolution_factory_bind (Object object) {
            var list_item = object as Gtk.ListItem;

			var resolution = list_item.get_item() as Models.Resolution;

            list_item.get_data<Gtk.Label> ("name-label").set_label (resolution.name);
        }

        void resolution_factory_setup (Object object) {
			var list_item = object as Gtk.ListItem;

            var name_label = new Gtk.Label (null);

            list_item.set_data ("name-label", name_label);

			list_item.set_child(name_label);
        }

        void resolution_row_selected_item_changed () {
            var resolution = resolution_row.get_selected_item () as Models.Resolution;

            Application.settings.set_enum ("resolution", resolution.size);
        }
    }
}