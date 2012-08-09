Request = require 'request'
$ = require 'jquery'

module.exports = (robot) ->
  robot.hear /^!php (.*)$/, (msg) ->
    search = msg.match[1].replace /_/g, '-'
    url = "http://us2.php.net/manual/en/function.#{search}.php"

    Request.get url, (err, res, body) ->
      if res.statusCode isnt 200 or not /text\/html/.test res.headers['content-type']
        msg.send 'Could not find a page for that php function'

      body = $(body)
      proto = body.find('div.methodsynopsis.dc-description').text().replace /(\s\s)|\n|\r/g, ' '
      desc = body.find('p.para.rdfs-comment').text().replace /(\s\s)|\n|\r/g, ' '

      msg.send proto
      msg.send desc
      msg.send "(#{url})"

