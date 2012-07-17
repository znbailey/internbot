module.exports = (robot) ->
  robot.hear /do.* it live/i, (msg) ->
    msg.send "http://rationalmale.files.wordpress.com/2011/09/doitlive.jpeg"
