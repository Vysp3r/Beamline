namespace Protonium.Widgets.Settings {
    public class GeneralBox : Gtk.Box {
        Adw.ComboRow language_row;
        Gtk.Label warning_label;

        public GeneralBox () {
            Object (orientation: Gtk.Orientation.VERTICAL, spacing: 15);

            var title_label = new Gtk.Label (_("General")) {
                css_classes = { "title-label" },
            };

            var language_list_store = new ListStore (typeof (Models.Language));

            foreach (var language in Models.Language.get_languages ())
                language_list_store.append (language);

            var language_selection_model = new Gtk.SingleSelection (language_list_store);

            var language_factory = new Gtk.SignalListItemFactory ();
            language_factory.setup.connect (language_factory_setup);
            language_factory.bind.connect (language_factory_bind);

            language_row = new Adw.ComboRow () {
                title = _("Set prefered language"),
            };
            language_row.set_factory (language_factory);
            language_row.set_model (language_selection_model);
            language_row.set_selected (Application.settings.get_enum ("language"));
            language_row.notify["selected-item"].connect (language_row_selected_item_changed);

            var clock_row = new Adw.SwitchRow () {
                title = _("24-hour clock"),
                subtitle = _("Always display timestamps in 24-hour format"),
                css_classes = { "darker-row" },
            };

            Application.settings.bind ("twenty-four-hour-clock",
                            clock_row,
                            "active",
                            SettingsBindFlags.DEFAULT);

            var group = new Adw.PreferencesGroup ();
            group.add (language_row);
            group.add (clock_row);

            warning_label = new Gtk.Label (_("Changing the language requires the application to be restarted")) {
                visible = false,
            };

            append (title_label);
            append (group);
            append (warning_label);
            add_css_class ("general-box");
        }

		void language_factory_bind (Object object) {
            var list_item = object as Gtk.ListItem;

			var language = list_item.get_item() as Models.Language;

            list_item.get_data<Gtk.Label> ("name-label").set_label (language.name);
        }

        void language_factory_setup (Object object) {
			var list_item = object as Gtk.ListItem;

            var name_label = new Gtk.Label (null);

            list_item.set_data ("name-label", name_label);

			list_item.set_child(name_label);
        }

        void language_row_selected_item_changed () {
            var language = language_row.get_selected_item () as Models.Language;

            Application.settings.set_enum ("language", language.lc);

            warning_label.set_visible (true);
        }
    }
}