namespace Protonium {
    int main (string[] args) {
        var settings = new GLib.Settings (Config.APP_ID);

        var language = Models.Language.get_languages ().first_match ((pred) => pred.lc == settings.get_enum ("language"));
        if (language != null && language.lc != Models.Language.LC.SYSTEM) 
            Environment.set_variable ("LANGUAGE", language.env, true);

        Intl.bindtextdomain (Config.APP_NAME, Config.LOCALE_DIR);
        Intl.bind_textdomain_codeset (Config.APP_NAME, "UTF-8");
        Intl.textdomain (Config.APP_NAME);

        var app = new Widgets.Application (settings);
        return app.run (args);
    }
}
