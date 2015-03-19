#
# Ethan Mick
# 2015
#

FutureClient = require 'future-client'
client = new FutureClient()

client.socket.on 'task', (task)->
  console.log 'GOT TASK', task
  action = require "../tasks/#{task.opts.action}"
  console.log 'action', action
  action(task.opts)

module.exports = client
