#
#
#
#
#
Hapi = require 'Hapi'
Q = require 'q'

class Server

  constructor: (opts)->
    @server = new Hapi.Server({
      connections:
        routes:
          payload:
            timeout: no
          cors:
            origin: ['*']
          timeout:
            server: no
            socket: no
    })
    @server.connection(opts)

  routes: ->
    register = Q.nbind(@server.register, @server)
    register({
      register: require('hapi-router-coffee')
      options:
        routesDir: "#{__dirname}/routes/"
    }).then =>
      register(require('hapi-auth-bearer-token'))

  start: ->
    Q.nbind(@server.start, @server)()

module.exports = Server
