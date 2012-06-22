jerk     =  require  'jerk'
Request  =  require  'request'
jsdom    =  require  'jsdom'
{exec}   =  require  'child_process'
_        =  require  'underscore'

last_said = new Array()
sed_regexp = /^(s[^a-zA-Z0-9].*)$/
sed_binary = 'sed'

options =
  server: process.env.SEDBOT_SERVER || 'chat.freenode.net'
  nick: process.env.SEDBOT_NICK || 'sedbot'
  port: process.env.SEDBOT_PORT || '6667'
  flood_protection: true
  channels: [process.env.SEDBOT_CHANNEL || "#yourchannel"]

intern_bot = jerk (j) ->
  j.watch_for /^(.+)$/, (message) ->
    result = sed_regexp.exec message.match_data[1]

    return (last_said[message.user] = message.match_data[1]) if not result

    return if not last_said[message.user]?

    command = "echo '#{last_said[message.user].replace /'/g, "'\"'\"'"}' | #{sed_binary} -e' #{result[1].replace /'/g, "'\"'\"'"}'"
    exec command, (error, stdout, stderr) ->
      return if error

      sanitized_stdout = stdout.split(String.fromCharCode(10))[0]
      return if not sanitized_stdout?

      message.say sanitized_stdout

      last_said[message.user] = sanitized_stdout

  ###
  j.watch_for /^!def (.+)$/, (message) ->
    term = message.match_data[1]
    return if not term
    Request.get "http://en.wikipedia.org/w/index.php?search=#{term}", (err, response, body) ->
      console.log err if err
      console.log response
      return message.say("Could not find definition") if err
      jsdom.env { html: body, scripts: ['http://code.jquery.com/jquery-1.6.min.js'] }, (err, window) ->
        console.log err if err
        return message.say("Could not find definition") if err
        def = window.jQuery('#mw-content-text').children('p').first().text()
        console.log def
        return message.say("Could not find definition") if not def
        message.say "#{term}: #{def}"
  ###

  ###
    key = '8836rcvm2brieyx7v4bo0gxw3gcrkrct0fzsrvet66'
    Request.get "http://api-pub.dictionary.com/v001?vid=#{key}&q=#{term}&type=define&site=dictionary", (err, response, body) ->
      console.log err if err
      return message.say("Could not find definition") if err

      console.log body
  ###

  ### Urban dictionary
    Request.get "http://www.urbandictionary.com/define.php?term=#{term}", (err, response, body) ->
      return message.say("Could not find definition") if err

      jsdom.env { html: body, scripts: ['http://code.jquery.com/jquery-1.6.min.js'] }, (err, window) ->
        return message.say("Could not find definition") if err
        def = window.jQuery('div.definition').first().text()
        return message.say("Could not find definition") if not def

        message.say "#{term}: #{def}"
  ###
  currentVote = null
  votes = {}
  voted = {}
  j.watch_for /^!vote-start/, (message) ->
    if currentVote isnt null
      return message.say "Cannot start new vote, one is already in progress."
    else
      currentVote = message.match_data[1]
      votes = {}
      voted = {}
      message.say "Vote started. !vote <option> to vote"

  j.watch_for /^!vote (.+)$/, (message) ->
    if currentVote is null
      return message.say "No vote in progress"
    if voted[message.user] is undefined
      if votes[message.match_data[1]] isnt undefined
        votes[message.match_data[1]]++
      else
        votes[message.match_data[1]] = 1
      voted[message.user] = true
    else
      message.say "You voted already, #{message.user}!"

  j.watch_for /^!vote-status$/, (message) ->
    _.forEach votes, (value, key) ->
      message.say "#{key}: #{value} votes"

  j.watch_for /^!vote-end$/, (message) ->
    if currentVote isnt null
      message.say "Vote ended, results:"
      _.forEach votes, (value, key) ->
        message.say "#{key}: #{value} votes"

      currentVote = null
      votes = {}
      voted = {}
    else
      message.say "No vote in progress"

  j.watch_for /^!vote-help/, (message) ->
    message.say "Available commands: !vote-start !vote !vote-status !vote-end"

intern_bot.connect options
