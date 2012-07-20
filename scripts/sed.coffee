{exec}   =  require  'child_process'

last_said = new Array()
sed_regexp = new RegExp "^s/(([^/]|(\\\\/))*)/(([^/]|(\\\\/))*)(/([gi]*))?$"

module.exports = (robot) ->
  robot.hear /^(([a-zA-Z_0-9]+):)?\s*(.+)$/, (request) ->
    {robot, message, match} = request
    message.user.name = message.user.name.toLowerCase()
    user = match[2]?.toLowerCase() || message.user.name

    lastMessage = last_said[user]

    result = sed_regexp.exec match[3]
    return (last_said[message.user.name] = match[3]) if not result

    return if not lastMessage?

    search = new RegExp result[1]
    replace = result[4]
    flags = result[8]

    message = lastMessage

    if flags? 
      if flags.search(/i/)? isnt -1
        search = new RegExp result[1].toLowerCase()
        message = message.toLowerCase()
      if flags.search(/g/)? isnt -1
        before = null
        while before != message
          before = message
          message = message.replace search, replace
    else
      message = message.replace search, replace

    return if not message
    request.send message
    last_said[user] = message
