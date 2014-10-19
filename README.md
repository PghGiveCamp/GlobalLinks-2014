GlobalLinks-2014
================

[![Build Status](https://travis-ci.org/globallinks/volunteer-portal.svg?branch=master)](https://travis-ci.org/globallinks/volunteer-portal)
[![Coverage Status](https://coveralls.io/repos/globallinks/volunteer-portal/badge.png)](https://coveralls.io/r/globallinks/volunteer-portal)

## local development

There is a Vagrantfile provided that should get you to a runnable state:
```bash
vagrant up
```

Otherwise:

Doing this should take care of everything for you, but YMMV:

``` bash
bundle install
bundle exec rake setup
```

If your local database gets into a funky state, it can be reset
like so:

``` bash
bundle exec rake reset
```

### required configuration

The following env vars are required for the application to work.
There are some defaults available in
[`.example.env`](./.example.env), which may be copied into `.env`
for use within the vagrant box:

``` bash
cp -v .example.env .env
```

* `DATABASE_URL` - the postgresql database URL
* `SALT` - the salt used for server-side password hashing
* `SMTP_HOST` - smtp host (e.g. "smtp.gmail.com")
* `SMTP_PORT` - smtp port (e.g. 587)
* `SMTP_TLS` - should we use tls?  ("true"/"false")
* `SMTP_USERNAME` - smtp username (e.g. "whatever.username")
* `SMTP_PASSWORD` - smtp password
* `SMTP_AUTH` - smtp auth type (e.g. "plain")
* `SMTP_DOMAIN` - smtp domain (e.g. "localhost.localdomain")

### database setup

You'll have to ensure there is a postgresql database available for
local development.  The server requires that `DATABASE_URL` is set.


``` bash
# Set the DATABASE_URL var in your local environment file.
echo DATABASE_URL='postgres://globallinks:globallinks@localhost:5432/globallinks' >> .env

# Or, export the DATABASE_URL var to your current shell environment.
export DATABASE_URL='postgres://globallinks:globallinks@localhost:5432/globallinks'

# e.g.:
createdb globallinks

# To load volunteer data from the CSV file
./server
^C
psql globallinks < load_volunteers.sql

```

### server

There are two web servers.  One for frontend development, and one
for serving the sinatra app.  The sinatra app is served via the
`./server` executable, which is the same executable used on heroku.


``` bash
# run the thing locally
./server
```

#### client

For client development, `npm install` once to get all dev
dependencies, then `npm start` to run the server. It will
print a banner with current host name and port. While running,
any changes to files in `src/client/` will be compiled
immediately.

When ready to release a static client built, run
`grunt writeClient` (might need to have grunt-cli installed
globally). This will write a half-dozen static assets to `www/`.
