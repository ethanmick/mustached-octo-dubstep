'use strict'

Hapi = require 'hapi'
Q = require 'q'
mongoose = require('mongoose-q')()
PORT = 8502

##################################################################
#                             Start                              #
##################################################################

mongo = ->
  deferred = Q.defer()
  mongoose.connect('mongodb://localhost:27017/stupid_game');
  db = mongoose.connection

  db.on 'error', (err)->
    deferred.reject(err)

  db.once 'open', ->
    deferred.resolve()
  deferred.promise

server = new Server(port: PORT)
start = ->
  console.log 'Attempting to start Hapi server.'
  server.routes()
.then ->
  server.start()
.then ->
  mongo()
.then ->
  console.log 'Started...'
