'use strict'

Hapi = require 'hapi'
Q = require 'q'
mongoose = require('mongoose-q')()
config = require './config/config'
Agenda = require './lib/models/agenda'

server = new Hapi.Server(
  debug: { request: ['error'] }
)
server.connection port: config.port, address: config.host

###
Plugins
###

server.register require('hapi-auth-bearer-token'), (err)->

  server.auth.strategy 'simple', 'bearer-access-token',
    validateFunc: (token, callback)->
      # For convenience, the request object can be accessed
      # from `this` within validateFunc.
      request = this

      # Use a real strategy here,
      # comparing with a token from your database for example
      if token is '1234'
        callback null, true, token: token
      else
        callback null, false, token: token

server.on 'internalError', (request, err)->
  console.log err

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


start = ->
  console.log 'Attempting to start Hapi server.'
  deferred = Q.defer()
  server.start ->
    console.log 'Server started at: ', server.info.uri
    deferred.resolve()
  deferred.promise

mongo().then ->
  start()
