module.exports = (app, config)->
  app.use require('st')({
    url: 'assets/'
    path: __dirname
    index: no
    dot: no
    passthrough: no
    gzip: no
  })
