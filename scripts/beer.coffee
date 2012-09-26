{exec}   =  require  'child_process'
Request  =  require  'request'

apiKey = process.env.BEER_API_KEY

Request = Request.defaults {headers: {
  'User-Agent: internbot (https://github.com/anthonymarion/internbot)'
  'Content-Type: application/json; charset=utf-8'
}}

outputBeerDetails = (message, beer) ->
  message.send "[ #{beer.name} (#{beer.abv}% ABV#{if beer.organic is 'Y' then ' organic' else ''}) ] " +
    "#{beer.description}"
  console.log beer

findRandomBeer = (message) ->
  requestOptions =
    url: 'http://api.brewerydb.com/v2/beers'
    json: true
    qs:
      key: apiKey

  Request.get requestOptions, (err, res, body) ->
    console.log body
    # TODO

queryBeer = (message, queryString, callback) ->
  requestOptions =
    url: 'http://api.brewerydb.com/v2/beers'
    json: true
    qs:
      key: apiKey
      name: queryString

  Request.get requestOptions, (err, res, body) ->
    return console.log(err) if err
    return console.log('no body') if not body
    return console.log("recieved status code #{res.statusCode}") if res.statusCode isnt 200

    return message.send "Could not find a beer by that name!" if not body.totalResults

    outputBeerDetails message, message.random body.data

module.exports = (robot) ->
  robot.hear /(^!)?beer(.*)/, (msg) ->
    {match} = msg
    isBang = match[1] is '!'
    queryString = match[2]?.trim()

    return findRandomBeer msg if not isBang or queryString is ''
    return queryBeer msg, queryString
