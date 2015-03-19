#
# Ethan Mick
# 2015
#

Future = require('future-client')
Client = Future.Client
Client.connect()

Client.socket.on 'task', (task)->
  console.log 'GOT TASK', task
  action = require "../tasks/#{task.opts.action}"
  console.log 'action', action
  action(task.opts)

module.exports = Future
