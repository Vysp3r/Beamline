namespace Protonium.Models {
    public class Language : Object {
        public string name { get; private set; }
        public string env { get; private set; }
        public LC lc { get; private set; }

        public Language (string name, string env, LC lc) {
            this.name = name;
            this.env = env;
            this.lc = lc;
        }

        public static Gee.ArrayList<Language> get_languages () {
            var languages = new Gee.ArrayList<Language> ();

            languages.add (new Language (_("System"), "system", LC.SYSTEM));
            languages.add (new Language (_("English"), "en", LC.ENGLISH));
            languages.add (new Language (_("French"), "fr", LC.FRENCH));

            return languages;
        }

        public enum LC {
            SYSTEM,
            ENGLISH,
            FRENCH,
        }
    }
}