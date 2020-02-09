# Localization

## `devise` & `devise-i18n`
`devise` provides a basic localization file when you run installation: `devise.en.yml`. This accounts for a large portion of the strings in Devise, but not all of them. To get complete translation of `devise` you must also include the `devise-i18n` gem and specify additional localizations. The localizations for `devise` are loosely organized through a wiki on the `devise` GitHub page and are community provided.

The localizations that come with `devise-i18n` are a strict superset of those that come with `devise`. Within the gem it bundles information for a significant number of locales. Translations are again community-provided.

To update the localizations, identify the language, key, and project.
1. Look at the URL to identify the locale.
2. Identify the key by running the application in i18n debug mode. (Only works locally.)
