module.exports = (robot) ->
  robot.hear /^!source/i, (msg) ->
    msg.send "https://github.com/anthonymarion/internbot"
