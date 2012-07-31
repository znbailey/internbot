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

    console.log "Starting request"
    Request.get url, (err, response, body) ->
      console.log "Request returned"
      return if not body
      try
        console.log "jQuerying..."
        body = $ body
        console.log "jQuerying done"
        if message.match(/twitter.com\/[^\/]*\/status\/[\d]*$/) isnt null
          console.log "twitter matched, grabbing .js-tweet-text"
          tweet = body?.find('.js-tweet-text')?.text()?.replace /[\s\n\r\t]+/g, ' '
          return req.send "Tweet: #{tweet}" if tweet
        console.log "no twitter matched, grabbing title"
        title = body?.find('title')?.text()?.replace /[\s\n\r\t]+/g, ' '
        return if not title
        req.send "Title: #{title}"
      catch err
        console.log err
        return
