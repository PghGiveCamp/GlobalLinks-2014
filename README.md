GlobalLinks-2014
================

[![Build Status](https://travis-ci.org/globallinks/volunteer-portal.svg?branch=master)](https://travis-ci.org/globallinks/volunteer-portal)
[![Coverage Status](https://coveralls.io/repos/globallinks/volunteer-portal/badge.png)](https://coveralls.io/r/globallinks/volunteer-portal)

## local development

Doing this should take care of everything for you, but YMMV:

``` bash
bundle install
bundle exec rake setup
```

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
```

### server

There are two web servers.  One for frontend development, and one
for serving the sinatra app.  The sinatra app is served via the
`./server` executable, which is the same executable used on heroku.


``` bash
# run the thing locally
./server
```

``` cmd
; or, on windows:
server
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
