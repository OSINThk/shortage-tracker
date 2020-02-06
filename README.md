# shortage-tracker

This is a project of OSINThk.

## Setup

Works with [`rbenv`](https://github.com/rbenv/rbenv#homebrew-on-macos). May work with `rvm`.

An approximate macOS setup from basics:

```sh
brew install git rbenv postgres postgis redis

brew services start postgresql
brew services start redis

rbenv init
rbenv install 2.5.1
gem install bundler rails

git clone git@github.com:OSINThk/shortage-tracker.git
cd shortage-tracker
bundle install

rake db:create && rake db:migrate
rake maxmind

rails s
```

Sign up for a [maxmind account](https://www.maxmind.com) in order to get a license key.

Sample request: `http://localhost:3000/maptest?lat=114.029&lon=22.344&dist=1500&since=2020-01-01`

Hints for setup (MacOS):
1. Visit https://gorails.com/setup/osx/10.14-mojave
2. MacOS: You might need to `mv /usr/local/include /usr/local/include_old` to install Ruby 2.5.1.  Also you might need to do `sudo xcode-select --switch /Library/Developer/CommandLineTools`.
3. If you can't find `bundle` try `rbenv exec gem update --system` followed by `rbenv exec bundle update --bundler`.
4. Use `rbenv exec` in front of gem/bundle commands if in doubt.
5. You might need to manually create `/usr/local/var/postgres` and give it the right permissions, then restart PG using `brew services restart postgres`

Anything that you find incomplete in the setup, please help us document!

## Contributing

Join the [Telegram group chat](https://t.me/joinchat/Aig7CRa2KapdIcMJX21--A) to get started. There you can keep up with what is happening and who is doing what. You may lay claim to individual tasks from the below TODO list.

Once we have more than one regular contributor we will use a GitHub PR workflow to organize getting work into the application.

## TODO

This is a list of things that can be done to improve the application:

- [ ] Improve error pages.
- [ ] Button to center the homepage map using device location.
- [ ] Report#new/Report#edit: populate coordinates via map selection.
- [ ] Missing Map Tiles at high zoom levels. (New tile provider?)
- [ ] :omniauthable
- [ ] Internationalization/Localization.
- [ ] Inline reporting interface.
- [ ] Fix tests now that pundit is in place.
- [ ] Design for each page (mobile device focused)
- [ ] Clustering of data on the server.
- [ ] Implement CI via GitHub Actions.
- [ ] Photo upload.
- [ ] Product taxonomy.

### The World is not Enough Bugfix

A longitude of greater than 180º or less than -180º will break the loading behavior. At extremely zoomed out levels these numbers will appear. This will be related to the Great Circle Bugfix.

### Great Circle Bugfix

All `ST_MakeEnvelope` requests that span >= 180º will take the shorter side around the globe. Split all `ST_MakeEnvelope` calls into polygons that ensure they cover the correct areas. This will be related to the The World is not Enough Bugfix.

### Filtered Data Bugfix

If the filtered set increases in scope (for example, becomes unfiltered after being filtered for all previous requests) all previous cursor data loads need to be adjusted for that condition change.

In other words, they need to be run with the more-permissive filter to explicitly re-add filtered out values. For example:

1. `~2020-02-04T16:22:27~114.1,22.5,114.2,22.6~7 => 719a480`
2. `719a480~2020-02-04T16:23:52~114.1,22.5,114.2,22.6~" => 79dda18`

1. Loaded reports if and only if they contained product 7.
2. Region didn't change, should get only new reports and reports matching query 1 that *did not* contain product 7.

Currently Step 2 will only get new reports; it will not expand the scope of previous queries.

This should be implemented by creating a new merged chain using the multiple parents feature of cursors.
