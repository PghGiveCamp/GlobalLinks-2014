GlobalLinks-2014
================

[![Build Status](https://travis-ci.org/PghGiveCamp/GlobalLinks-2014.svg?branch=master)](https://travis-ci.org/PghGiveCamp/GlobalLinks-2014)

## local development

### database setup

You'll have to ensure there is a postgresql database available for
local development.  The server requires that `DATABASE_URL` is set.

``` bash
# set the DATABASE_URL var, which you'll probably want to do
# somewhere more permanent than in an interactive shell.
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
