module.exports = (robot) ->
  robot.hear /more you know/i, (msg) ->
    msg.send "http://i957.photobucket.com/albums/ae55/mttrek360/the_more_you_know2.jpg"
