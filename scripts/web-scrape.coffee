{exec}   =  require  'child_process'
Request  =  require  'request'
$        =  require  'jquery'

Request = Request.defaults {headers: {'User-Agent: internbot (https://github.com/anthonymarion/internbot)'}}

module.exports = (robot) ->
  robot.hear /https?\:\/\/[a-zA-Z0-9\-\.]+\.[a-zA-Z]{2,3}(\/\S*)?/, (req) ->
    console.log "Matched a url"
    {robot, message, match} = req
    url = match[0]

    return if message.user.name is 'Parbot'
    return if message.match(/.pardot.com/) isnt null
    return if message.match(/pardot.atlassian.net/) isnt null
    return if message.match(/whattoe.at/) isnt null

    Request.get url, (err, res, body) ->
      return if not body

      console.log res.headers['content-type']

      return if res.statusCode isnt 200 or not /text\/html/.test res.headers['content-type']

      try
        body = $ body
        if message.match(/twitter.com\/[^\/]*\/status\/[\d]*$/) isnt null
          tweet = body?.find('.js-tweet-text')?.first()?.text()?.replace /[\s\n\r\t]+/g, ' '
          return req.send "Tweet: #{tweet}" if tweet
        title = body?.find('title')?.text()?.replace /[\s\n\r\t]+/g, ' '
        return if not title
        req.send "Title: #{title}"
      catch err
        return console.log err
