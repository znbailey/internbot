wins = [
  "http://badabingbadabambadaboom.files.wordpress.com/2011/04/charlie-sheen-winning-tshirt.jpg?w=604"
  "http://onstartups.com/Portals/150/images/charlie-sheen-winning-resized-600.jpg"
  "http://i1.sndcdn.com/artworks-000033774973-xsrty5-original.png?2479809"
  "http://meldilla.mywapblog.com/files/charlie-sheen-winning.jpg"
  "http://2.bp.blogspot.com/-8IEPahii4Qo/TvBxt3soC1I/AAAAAAAAA5g/PUAy9ODW4mY/s1600/Charlie%2BSheen%2Bwinning.png"
  "http://925.nl/images/2012-06/winning-charlie-sheen-sweatshirts_design.png"
  "http://www.pokernews.com/w/articles/4d75/e406c8b92.jpg"
]

module.exports = (robot) ->
  robot.hear /winning/i, (msg) ->
    msg.send msg.random wins
