# shortage-tracker

This is a project of OSINThk. 

## Setup

Works with [`rbenv`](https://github.com/rbenv/rbenv#homebrew-on-macos). May work with `rvm`.

An approximate macOS setup from basics:

```sh
brew install git rbenv postgres postgis

brew services start postgresql

rbenv init
rbenv install 2.5.1
gem install bundler rails

git clone git@github.com:OSINThk/shortage-tracker.git
cd shortage-tracker
bundle install

rake db:create && rake db:migrate
rails s
```

Anything that you find incomplete in the setup, please help us document!

## Contributing

Ping @nathanhammond to get started, he will pair with you to get your machine set up and figure out where to focus. Will use a GitHub PR workflow once there is more than one contributor. Telegram group link.
https://t.me/joinchat/Aig7CRa2KapdIcMJX21--A
