module.exports = (app, config)->
  app.get '/contact', (q, r)->
    r.json
      "id": "003L000000QrpX4IAJ",
      "volunteer_status": "Active",
      "salutation": null,
      "first_name": "Jenn",
      "last_name": "Doe",
      "address": "123 Doe St",
      "city": "Pittsburgh",
      "state": "Pa",
      "zip": "15205",
      "country": null,
      "last_checkin": null,
      "checked_in": false,
      "username": null,
      "home_phone": "(345) 678-9123",
      "mobile_phone": null,
      "work_phone": null,
      "preferred_email_type": null,
      "preferred_email": null,
      "home_email": null,
      "alternate_email": null,
      "work_email": null,
      "volunteer_hours": "0.0",
      "emergency_name": null,
      "emergency_phone": null,
      "emergency_relationship": null,
      "emergency_phone_type": null,
      "checked_in": true
  app.post '/contact', (q, r)->
    r.status(200).send()
  app.post '/contact/checkin', (q, r)->
    r.status(200).send()
  app.post '/contact/checkout', (q, r)->
    r.status(200).send()
  app.post '/login', (q, r)->
    if q.body.password is 'password'
      r.json { username: q.body.username }
    else
      r.status(401).send()
  console.log 'Adding /user'
  app.post '/user', (q, r)->
    if q.body.email.indexOf('notfound') > -1
      return r.status(404).send()
    if q.body.username.indexOf('conflicting') > -1
      return r.status(409).send()
    if q.body.password isnt 'password'
      return r.status(401).send()
    else
      return r.status(201).json( { username: q.body.username } )
  app.post '/request_reset_password', (q, r)->
    r.status(200).send()
