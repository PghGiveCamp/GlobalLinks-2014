module.exports = (app, config)->
  app.get '/contact', (q, r)->
    r.json
      name: "David Souther"
      address:
        street: "401 Taylor St"
        city: "Pittsburgh"
        state: "PA"
        zip: "15224"
      home:
        email: 'davidsouther@gmail.com'
      work: {}
      cell:
        phone: "406 545 9223"
      emergency:
        name: "Annie Levine"
        relationship: "Fiancee"
      waiver:
        clause1: no
        clause2: no
        photo: no
        all: no
  app.post '/contact', (q, r)->
    r.status(200).send()
    app.post '/contact/checkin', (q, r)->
    r.status(200).send()
  app.post '/contact/checkout', (q, r)->
    r.status(200).send()
