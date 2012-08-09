Request = require 'request'

module.exports = (robot) ->
  robot.hear /^!php (.*)$/, (msg) ->
    Request.get "http://us2.php.net/manual-lookup.php?pattern=#{encodeURIComponent msg}", (err, res, body) ->
      console.log res
      console.log "Status code: #{res.statusCode}"
