Twit  =  require 'twit'
_     =  require 'underscore'

T = new Twit
  consumer_key:         process.env.TWITTER_CONSUMER_KEY
  consumer_secret:      process.env.TWITTER_CONSUMER_SECRET
  access_token:         process.env.TWITTER_ACCESS_TOKEN
  access_token_secret:  process.env.TWITTER_ACCESS_TOKEN_SECRET

Commands = [
  { command: /^!antijoke/, user: 'antijokecat' }
  { command: /^!uberfact/, user: 'uberfacts' }
  { command: /^!borat/,    user: 'devops_borat' }
  { command: /^!grimlock/, user: 'fakegrimlock' }
  { command: /^!nph/,      user: 'ActuallyNPH' }
  { command: /^!drunkhulk/, user: 'DrunkHulk' }
  { command: /^!batman/, user: 'God_Damn_Batman' }
  { command: /^!bender/, user: 'bender' }
  { command: /^!deathstar/, user: 'DeathStarPR' }
  { command: /^!yoda/, user: 'yoda' }
]

module.exports = (robot) ->
  for command in Commands
    do (command) ->
      robot.hear command.command, (msg) ->
        T.get 'statuses/user_timeline', { screen_name: command.user, exclude_replies: 'true' }, (err, reply) ->
          return console.log err if err
          tweet = _(reply).chain().shuffle().first().value()?.text
          msg.send tweet


  robot.hear /^!twitter (\w+)/, (msg) ->
    console.log 'Fetching recent tweets', msg.match[1]
    T.get 'statuses/user_timeline', { screen_name: msg.match[1], exclude_replies: 'true' }, (err, reply) ->
      return console.log err if err
      tweet = _(reply).chain().shuffle().first().value()?.text
      msg.send tweet
