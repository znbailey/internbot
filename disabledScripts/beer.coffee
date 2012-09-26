{exec}   =  require  'child_process'
Request  =  require  'request'

Request = Request.defaults {headers: {
  'User-Agent: internbot (https://github.com/anthonymarion/internbot)'
  'Content-Type: application/json; charset=utf-8'
}}

outputBeerDetails = (message, beerDetails) ->
  console.log beerDetails
  # TODO

findRandomBeer = (message) ->
  requestOptions = 
    url: 'https://api.openbeerdatabase.com/v1/beers.json'
    json: true

  Request.get requestOptions, (err, res, body) ->
    console.log body
    # TODO

queryBeer = (message, queryString, callback) ->
  requestOptions =
    url: 'https://api.openbeerdatabase.com/v1/beers.json'
    json: true
    qs:
      query: queryString

  Request.get requestOptions, (err, res, body) ->
    return console.log(err) if err
    return console.log('no body') if not body
    return console.log("recieved status code #{res.statusCode}") if res.statusCode isnt 200

    console.log body

module.exports = (robot) ->
  robot.hear /(^!)?beer(.*)/, (req) ->
    {message, match} = req
    isBang = match[1] is '!'
    queryString = match[2]?.trim()

    return findRandomBeer message if not isBang or queryString is ''
    return queryBeer message, queryString
