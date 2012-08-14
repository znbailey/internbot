module.exports = (robot) ->
  robot.hear /^!bounce/, (msg) ->
    console.log "Bouncing internbot"
    msg.send "bounce bounce bounce"
    console.log robot
    #process.exit()
