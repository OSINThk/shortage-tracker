# Localization

## Update a Localization Key

To update a localization you must identify the locale, key, and project.

1. Look at the URL to identify the locale. The first URL segment will be the locale. If there is no locale, the locale is the `default_locale` specified in `config/application.rb`.
2. Identify the key you are seeing by running the application in i18n debug mode.
3. Identify the project.
    1. Look for the key in `config/locales/shortage-tracker.en.yml`. If you find it, your project is `shortage-tracker`.
    2. Look for the key in `config/locales/devise.en.yml`. If you find it, your project is `devise`.
    3. If you do not locate the key inside of application code, your key is in an external source. Your project is likely either `devise-i18n` or `rails-i18n`. Review the links below to find their localization content.

The file you need to edit is `config/locales/${project}.${locale}.yml`. The key name will be split into pieces. Make sure you edit the correct key.

## i18n Debug Mode

To see the keys that are being used to render a page, append `?i18n=1` to the URL. This should work for all email messages triggered while in debug mode as well.

## Understanding `devise` & `devise-i18n`

`devise` provides a basic localization file when you run installation: `devise.en.yml`. This accounts for a large portion of the strings in `devise`, but not all of them. To get complete translation of `devise` you must also include the `devise-i18n` gem and specify additional localizations. The localizations for `devise` are loosely organized through a wiki on the `devise` GitHub page and are community provided.

The localizations that come with `devise-i18n` are a strict superset of those that come with `devise`. Within the gem it bundles information for a significant number of locales. These can be overridden by copying the contents into our repository at `config/locales/devise-i18n.${locale}.yml`. Translations are again community-provided.

## Understanding `rails-i18n`

`rails-i18n` provides built-in localizations for a tremendous number of languages for all of the Rails-supplied constructs. These can be overridden by copying the contents into our repository at `config/locales/rails-i18n.${locale}.yml`. Translations are ensured present by the Rails team.

## External Localization Data Sources

For keys you cannot locate in our project they likely come from one of these two sources:

- [`devise-i18n`](https://github.com/tigrish/devise-i18n/tree/master/rails/locales)
- [`rails-i18n`](https://github.com/svenfuchs/rails-i18n/tree/master/rails/locale)
