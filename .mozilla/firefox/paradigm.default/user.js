user_pref("browser.newtab.preload", false);
user_pref("browser.newtabpage.enabled", false);
user_pref("browser.newtabpage.enhanced", false);
user_pref("browser.showQuitWarning", true);
user_pref("browser.startup.homepage", "file:///home/paradigm/.blank");
user_pref("browser.tabs.closeWindowWithLastTab", false);

user_pref("browser.formfill.enable", false);
user_pref("browser.urlbar.autocomplete.enabled", false);
user_pref("browser.urlbar.searchSuggestionsChoice", false);
user_pref("browser.urlbar.suggest.bookmark", false);
user_pref("browser.urlbar.suggest.history", false);
user_pref("browser.urlbar.suggest.openpage", false);
user_pref("extensions.formautofill.addresses.enabled", false);

user_pref("browser.download.dir", "/dev/shm");
user_pref("browser.download.folderList", 2);
user_pref("browser.download.lastDir", "/dev/shm");
user_pref("general.autoScroll", true);
user_pref("general.smoothScroll", false);

user_pref("network.cookie.cookieBehavior", 1);
user_pref("network.cookie.lifetimePolicy", 1);
user_pref("places.history.enabled", false);
user_pref("privacy.donottrackheader.enabled", true);
user_pref("privacy.history.custom", true);
user_pref("privacy.trackingprotection.enabled", true);
user_pref("signon.rememberSignons", false);

user_pref("browser.autofocus", false);

user_pref("security.sandbox.content.level", 2); // allow cross-stratum fonts

user_pref("browser.defaultenginename", "Google");
user_pref("browser.defaultenginename.US", "Google");

user_pref("browser.feeds.showFirstRunUI", false);
user_pref("browser.newtabpage.introShown", true);

user_pref("extensions.pocket.enabled", false);
user_pref("experiments.enabled", false); /* Opt out of experiments */
user_pref("experiments.manifest.uri", ""); /* Opt out of experiments */
user_pref("experiments.supported", false); /* Opt out of experiments */
user_pref("experiments.activeExperiment", false); /* Opt out of experiments */
user_pref("experiments.activeExperiment", false); /* Prevent Mozilla from opting you into tests silently. */
user_pref("network.allow-experiments", false); /* Blocks the URL used for system add-on updates */
user_pref("extensions.pocket.enabled", false); /* Disable Pocket */
user_pref("dom.flyweb.enabled", false); /* Disable Flyweb */
user_pref("extensions.shield/*ecipe-client.enabled", false); /* Disable Shield Telemetry system */
user_pref("extensions.shield/*ecipe-client.api_url", ""); /* Disable Shield Telemetry system */
