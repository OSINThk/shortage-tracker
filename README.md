# shortage-tracker

This is a project of OSINThk.

## Setup

If new to Ruby, this is a Good Guide to [`How to install Ruby on Rails with rbenv on macOS `](https://www.digitalocean.com/community/tutorials/how-to-install-ruby-on-rails-with-rbenv-on-macos)
 
Works with [`rbenv`](https://github.com/rbenv/rbenv#homebrew-on-macos). May work with `rvm`.

An approximate macOS setup from basics:

```sh
brew install git rbenv postgres postgis

brew services start postgresql

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

# if error from rake db create
could not connect to server: No such file or directory
	Is the server running locally and accepting
	connections on Unix domain socket "/tmp/.s.PGSQL.5432"?
Couldn't create 'shortage_tracker_development' database. Please check your configuration.
rake aborted!
PG::ConnectionBad: could not connect to server: No such file or directory
	Is the server running locally and accepting
	connections on Unix domain socket "/tmp/.s.PGSQL.5432"?

Tasks: TOP => db:create
(See full trace by running task with --trace)

# do the following to fix: 
https://stackoverflow.com/questions/13573204/psql-could-not-connect-to-server-no-such-file-or-directory-mac-os-x#13573207

rails s
```

Sample request: `http://localhost:3000/maptest?lat=114.029&lon=22.344&dist=1500&since=2020-01-01`

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
