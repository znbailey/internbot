#!/bin/bash

export HUBOT_IRC_NICK="myhubot"
export HUBOT_IRC_ROOMS="#room1,#room2"
export HUBOT_IRC_SERVER="" # IRC Server
export HUBOT_IRC_PORT="" # IRC port
#export HUBOT_IRC_DEBUG="true"
#export HUBOT_IRC_USESSL="true"
#export HUBOT_IRC_SERVER_FAKE_SSL="true"

nohup ./node_modules/hubot/bin/hubot -a irc &
