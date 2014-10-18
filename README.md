GlobalLinks-2014
================

[![Build Status](https://travis-ci.org/PghGiveCamp/GlobalLinks-2014.svg?branch=master)](https://travis-ci.org/PghGiveCamp/GlobalLinks-2014)

## local development

### database setup

You'll have to ensure there is a postgresql database available for
local development.  The server requires that `DATABASE_URL` is set.


``` bash
# Set the DATABASE_URL var in your local environment file.
echo DATABASE_URL='postgres://localhost:5432/globallinks' >> .env

# Or, export the DATABASE_URL var to your current shell environment.
export DATABASE_URL='postgres://localhost:5432/globallinks'

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
