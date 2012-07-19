{exec}   =  require  'child_process'
Request  =  require  'request'
$        =  require  'jquery'

Request = Request.defaults {headers: {'User-Agent: internbot (https://gist.github.com/0c4348776ddeec695441)'}}

module.exports = (robot) ->
  robot.hear /https?\:\/\/[a-zA-Z0-9\-\.]+\.[a-zA-Z]{2,3}(\/\S*)?/, (req) ->
    {robot, message, match} = req
    url = match[0]

    return if message.user.name is 'Parbot'
    return if message.match(/.pardot.com/) isnt null
    return if message.match(/pardot.atlassian.net/) isnt null
    return if message.match(/whattoe.at/) isnt null

    Request.get url, (err, response, body) ->
      return if not body
      try
        if message.match(/twitter.com\/[^\/]*\/status\/[\d]*$/) isnt null
          tweet = $(body)?.find('js-tweet-text')?.text()?.replace /[\s\n\r\t]+/g, ' '
          return req.send "Tweet: #{tweet}" if tweet
        title = $(body)?.find('title')?.text()?.replace /[\s\n\r\t]+/g, ' '
        return if not title
        req.send "Title: #{title}"
      catch err
        console.log err
        return
