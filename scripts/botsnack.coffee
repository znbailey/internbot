module.exports = (robot) ->
  robot.hear /^botsnack/i, (msg) ->
    msg.send ":D"
