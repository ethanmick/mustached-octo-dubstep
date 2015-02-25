#
#
#
#
Agenda = require './agenda'
uuid = require('uuid').v4

class Schedulable

  constructor: ->


  # signature of (job, done)
  schedule: (job)->
    name = uuid()
    job: Agenda.define(name, job), name: name



module.exports = Schedulable
