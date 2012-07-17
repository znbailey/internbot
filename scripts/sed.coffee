{exec}   =  require  'child_process'

last_said = new Array()
sed_regexp = /^(s[^a-zA-Z0-9].*)$/
sed_binary = 'sed'

module.exports = (robot) ->
  robot.hear /^(([a-zA-Z_0-9]+):)?\s*(.+)$/, (request) ->
    {robot, message, match} = request
    message.user.name = message.user.name.toLowerCase()
    user = match[2]?.toLowerCase() || message.user.name

    lastMessage = last_said[user]

    result = sed_regexp.exec match[3]
    return (last_said[message.user.name] = match[3]) if not result

    return if not lastMessage?

    command = "echo '#{lastMessage.replace /'/g, "'\"'\"'"}' | #{sed_binary} -e' #{result[1].replace /'/g, "'\"'\"'"}'"
    exec command, (error, stdout, stderr) ->
      return if error

      sanitized_stdout = stdout.split(String.fromCharCode(10))[0]
      return if not sanitized_stdout?

      request.send sanitized_stdout

      last_said[user] = sanitized_stdout
