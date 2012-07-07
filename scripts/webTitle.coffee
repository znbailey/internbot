{exec}   =  require  'child_process'
Request  =  require  'request'
jsdom    =  require  'jsdom'

module.exports = (robot) ->
  robot.hear /https?\:\/\/[a-zA-Z0-9\-\.]+\.[a-zA-Z]{2,3}(\/\S*)?/, (req) ->
    {robot, message, match} = req
    url = match[0]

    Request.get url, (err, response, body) ->
      jsdom.env { html: body, scripts: ['https://ajax.googleapis.com/ajax/libs/jquery/1.7.2/jquery.min.js'] }, (err, window) ->
        return if err
        title = window.jQuery('title').text().replace /[\s\n\r\t]+/g, ' '
        return if not title
        req.send "Title: #{title}"
