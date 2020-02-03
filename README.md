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

Join the [Telegram group chat](https://t.me/joinchat/Aig7CRa2KapdIcMJX21--A) to get started. There you can keep up with what is happening and who is doing what. You may lay claim to individual tasks from the below TODO list.

Once we have more than one regular contributor we will use a GitHub PR workflow to organize getting work into the application.

## TODO

This is a list of many of the remaining steps to get this application into a shippable state:

### MVP

#### Backend

- [ ] Implement root/bootstrapping user.
- [ ] :omniauthable

#### Data Provisioning

Use the Maps controller as a home for this.

- [ ] All reports within lat/long/time bounds.
- [ ] All reports for a particular product within lat/long/time bounds.

#### Frontend

- [ ] Report#new/Report#edit: populate coordinates via location services or map selection.
- [ ] Populate the map homepage with values from reports.
  - [ ] update `handleResize()` to intelligently diff the map pins to minimize render time

### Followup

- [ ] Internationalization/Localization.
- [ ] Fix tests now that pundit is in place.
- [ ] Design for each page (mobile device focused)
- [ ] Clustering of data on the server.
- [ ] Implement CI via GitHub Actions.
- [ ] Photo upload.
- [ ] Product taxonomy.
