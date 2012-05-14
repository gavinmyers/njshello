http = require "http"
redis = require "redis"
Single = require("./single")

http.createServer( (req, res) ->
  client = redis.createClient()

  people = []
  client.get "people", (err,cres) ->
    people = if cres == null then [] else JSON.parse cres

    people.push new Single 'Mary', Math.floor(Math.random() * 100), Math.floor(Math.random() * 10) < 8
    people.push new Single 'Red', Math.floor(Math.random() * 100), Math.floor(Math.random() * 10) < 6

    client.set "people", JSON.stringify(people), redis.print

    console.log client.get "people"
    console.log JSON.stringify(people)

    msg = "<h1>GOOD MORNING...</h1>"

    for person in people
      msg += "<hr/>Hello, <b>#{person.name}</b>, how are you today?<br/>I hear you are #{person.age} year(s) old.<br/>"
      msg += if person.dead then "I'm sorry to hear about your... <span style='color:red'>death</span>!" else "Glad to know that you are alive!"

    msg += "<h1>THAT IS ALL FOR NOW</h1>"

    res.writeHead 200, "Content-Type": "text/html"
    res.end msg

).listen 8000

console.log 'Server running at http://127.0.0.1:8000/'
