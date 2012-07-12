{exec}   =  require  'child_process'
Request  =  require  'request'
$        =  require  'jquery'

module.exports = (robot) ->
  robot.hear /https?\:\/\/[a-zA-Z0-9\-\.]+\.[a-zA-Z]{2,3}(\/\S*)?/, (req) ->
    {robot, message, match} = req
    url = match[0]

    return if message.user.name is 'Parbot'
    return if message.match(/.pardot.com/) isnt null

    Request.get url, (err, response, body) ->
      return if not body
      try
        title = $(body)?.find('title')?.text()?.replace /[\s\n\r\t]+/g, ' '
        return if not title
        req.send "Title: #{title}"
      catch err
        console.log err
        return
