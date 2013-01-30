Twit  =  require 'twit'
_     =  require 'underscore'

T = new Twit
  consumer_key:         process.env.TWITTER_CONSUMER_KEY
  consumer_secret:      process.env.TWITTER_CONSUMER_SECRET
  access_token:         process.env.TWITTER_ACCESS_TOKEN
  access_token_secret:  process.env.TWITTER_ACCESS_TOKEN_SECRET

Commands = [
  { command: /^!antijoke/, user: 'antijokecat' }
  { command: /^!uberfact/, user: 'ubrerfacts' }
]

module.exports = (robot) ->
  for command in Commands
    robot.hear command.command, (msg) ->
      T.get 'statuses/user_timeline', { screen_name: command.user }, (err, reply) ->
        return console.log err if err
        tweet = _(reply).chain().shuffle().first().value()?.text
        msg.send tweet
