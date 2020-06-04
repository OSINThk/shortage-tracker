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

Sign up for a [maxmind account](https://www.maxmind.com) in order to get a license key.

Sample request: `http://localhost:3000/maptest?lat=114.029&lon=22.344&dist=1500&since=2020-01-01`

Hints for setup (MacOS):

1. Visit https://gorails.com/setup/osx/10.14-mojave
2. MacOS: You might need to `mv /usr/local/include /usr/local/include_old` to install Ruby 2.5.1. Also you might need to do `sudo xcode-select --switch /Library/Developer/CommandLineTools`.
3. If you can't find `bundle` try `rbenv exec gem update --system` followed by `rbenv exec bundle update --bundler`.
4. Use `rbenv exec` in front of gem/bundle commands if in doubt.
5. You might need to manually create `/usr/local/var/postgres` and give it the right permissions, then restart PG using `brew services restart postgres`

Anything that you find incomplete in the setup, please help us document!

## Contributing

Join the [Telegram group chat](https://t.me/joinchat/Aig7CRa2KapdIcMJX21--A) to get started. There you can keep up with what is happening and who is doing what. You may lay claim to individual tasks from the below TODO list.

Please see the Issues tab in Github for information on contributing.