# shortage-tracker

This is a project of OSINThk.

## Setup

If new to Ruby, this is a Good Guide to [`How to install Ruby on Rails with rbenv on macOS`](https://www.digitalocean.com/community/tutorials/how-to-install-ruby-on-rails-with-rbenv-on-macos)

Works with [`rbenv`](https://github.com/rbenv/rbenv#homebrew-on-macos). May work with `rvm`.

An approximate macOS setup from basics:

```sh
brew install git rbenv postgres postgis redis

brew services start postgresql
brew services start redis

# do in this order
rbenv init
rbenv install 2.5.1
gem install bundler rails

git clone git@github.com:OSINThk/shortage-tracker.git
cd shortage-tracker

# check to make sure that the versions are correct before doing bundle install
$ ruby -v
$ rails -v

# if rails -v fails, with error message: Gem::GemNotFoundException, update gems
$ gem update --system

bundle install

# check to make sure your yarn packages are up to date
# $ yarn install --check-files

rake db:create && rake db:migrate
rake maxmind

# Map won't render until you've added the Mapbox API key to .env -- ask in the Telegram chat for it

rails s
```

Sign up for a [maxmind account](https://www.maxmind.com/en/geolite2/signup) in order to get a license key.

Sample request: `http://localhost:3000/maptest?lat=114.029&lon=22.344&dist=1500&since=2020-01-01`

Hints for setup (MacOS):

1. Visit https://gorails.com/setup/osx/10.14-mojave
2. MacOS: You might need to `mv /usr/local/include /usr/local/include_old` to install Ruby 2.5.1. Also you might need to do `sudo xcode-select --switch /Library/Developer/CommandLineTools`.
3. If you can't find `bundle` try `rbenv exec gem update --system` followed by `rbenv exec bundle update --bundler`.
4. Use `rbenv exec` in front of gem/bundle commands if in doubt.
5. You might need to manually create `/usr/local/var/postgres` and give it the right permissions, then restart PG using `brew services restart postgres`

Anything that you find incomplete in the setup, please help us document!

## Heroku Setup

Here are steps for setting this up on Heroku:

Prerequisites:

1. Create a Heroku App and connect it to a Github repo (it will need to be in an organization you are part of, so you may have to Fork this repo). See [here](https://devcenter.heroku.com/articles/github-integration) for more info.
2. Install the Heroku CLI as you will need it to interact with your App. See [here](https://devcenter.heroku.com/categories/command-line) for more info.
3. Install PostgreSQL, which is the database used by this app. You will need this to interact with the db on Heroku through the Heroku CLI. See [here](https://www.postgresql.org/) for more info.
4. Sign up for a Maxmind account. [This link](https://www.maxmind.com/en/geolite2/signup) should be the quickest way to sign up. Once you've done so, go to your account under Services | My License Key and generate a license key.

Once you have the above, run these steps to install PostGIS (required for the geographic info)

1. `heroku psql --app <app name from Heroku>` should open up the pqsl command line and connect you to your Heroku psql instance. You should see `--> Connecting to postgresql-encircled-91293` and you can verify that db name in the Heroku webpage.
2. run `create extension postgis;` from that command line.
3. once that is done, verify it is installed by running `SELECT postgis_version();` and ensuring it returns a valid version string, indicating it is installed.

Lastly, set a Heroku config var for your Maxmind license key: `heroku config:set MAXMIND_LICENSE_KEY=<license key> --app <app name>`

Once these are done your app should deploy successfully. If you have questions or issues, join the Telegram group chat below for help.

## Contributing

Join the [Telegram group chat](https://t.me/joinchat/Aig7CRa2KapdIcMJX21--A) to get started. There you can keep up with what is happening and who is doing what. You may lay claim to individual tasks from the below TODO list.

Once we have more than one regular contributor we will use a GitHub PR workflow to organize getting work into the application.

## TODO

This is a list of things that can be done to improve the application:

- [ ] Improve error pages.
- [ ] Button to center the homepage map using device location.
- [ ] Report#new/Report#edit: populate coordinates via map selection.
- [ ] Host our own tiles.
- [ ] :omniauthable
- [ ] Inline reporting interface.
- [ ] Fix tests now that pundit is in place.
- [ ] Design for each page (mobile device focused)
- [ ] Clustering of data on the server.
- [ ] Implement CI via GitHub Actions.
- [ ] Photo upload.
- [ ] Implement language tag normalization.
- [ ] Product taxonomy.

### Localization Needing Translations
- [ ] All products in the database.
- [ ] `app/views/pages/about.zh-CN.html.erb`
- [ ] `app/views/pages/about.zh-HK.html.erb`
- [ ] `app/views/pages/about.zh-TW.html.erb`
- [ ] `config/locales/active-record.zh-CN.yml`
- [ ] `config/locales/active-record.zh-HK.yml`
- [ ] `config/locales/active-record.zh-TW.yml`
- [ ] `config/locales/shortage-tracker.zh-CN.yml`
- [ ] `config/locales/shortage-tracker.zh-HK.yml`
- [ ] `config/locales/shortage-tracker.zh-TW.yml`
- [ ] `public/404.zh-CN.yml`
- [ ] `public/404.zh-HK.yml`
- [ ] `public/404.zh-TW.yml`
- [ ] `public/422.zh-CN.yml`
- [ ] `public/422.zh-HK.yml`
- [ ] `public/422.zh-TW.yml`
- [ ] `public/500.zh-CN.yml`
- [ ] `public/500.zh-HK.yml`
- [ ] `public/500.zh-TW.yml`

### The World is not Enough Bugfix

A longitude of greater than 180º or less than -180º will break the loading behavior. At extremely zoomed out levels these numbers will appear. This will be related to the Great Circle Bugfix.

### Great Circle Bugfix

All `ST_MakeEnvelope` requests that span >= 180º will take the shorter side around the globe. Split all `ST_MakeEnvelope` calls into polygons that ensure they cover the correct areas. This will be related to the The World is not Enough Bugfix.

### Filtered Data Bugfix

If the filtered set increases in scope (for example, becomes unfiltered after being filtered for all previous requests) all previous cursor data loads need to be adjusted for that condition change.

In other words, they need to be run with the more-permissive filter to explicitly re-add filtered out values. For example:

1. `~2020-02-04T16:22:27~114.1,22.5,114.2,22.6~7 => 719a480`
2. `719a480~2020-02-04T16:23:52~114.1,22.5,114.2,22.6~" => 79dda18`

3. Loaded reports if and only if they contained product 7.
4. Region didn't change, should get only new reports and reports matching query 1 that _did not_ contain product 7.

Currently Step 2 will only get new reports; it will not expand the scope of previous queries.

This should be implemented by creating a new merged chain using the multiple parents feature of cursors.
