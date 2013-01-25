Request = require 'request'
Cheerio = require 'cheerio'
{ TextMessage } = require 'hubot'
_ = require 'underscore'
#Badwords = require '../lib/badwords'

clean = (str) ->
  str.replace(/(\s|\r|\n)+/g, ' ').replace(/(^\s)|(\s$)/g, '')

getRandomInt = (min, max) ->
  return Math.floor(Math.random() * (max - min + 1)) + min

module.exports = (robot) ->
  robot.hear /^!bash-hr$/, (msg) ->
    { message } = msg
    console.log robot.adapter
    nick = message.user.name
    #return robot.adapter.receive(new TextMessage({reply_to: nick, name: nick}, message.text)) if /^\#/.test msg.message.user.room
    url = "http://bash.org/?random"

    Request.get url, (err, res, body) ->
      return if res.statusCode isnt 200 or not /text\/html/.test res.headers['content-type']

      $ = Cheerio.load body

      quotes = $('.qt').map(-> $(this).text() )

      quote = _(quotes).chain()
        .shuffle()
        .find((quote) -> quote.split('\n').length <= 5)
        .value()

      return robot.adapter.bot.say(nick, quote)
      #msg.send quote if quote
