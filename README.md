GlobalLinks-2014
================

[![Build Status](https://travis-ci.org/PghGiveCamp/GlobalLinks-2014.svg?branch=master)](https://travis-ci.org/PghGiveCamp/GlobalLinks-2014)

## local development

### database setup

You'll have to ensure there is a postgresql database available for
local development.  The server will look for `DATABASE_URL` and
fall back to a passwordless database named `globallinks`.  Take a
look at [`./lib/globallinks.rb`](lib/globallinks.rb) for details.

``` bash
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
