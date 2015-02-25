mongoose = require('mongoose-q')()
Q = require 'q'
Schema = mongoose.Schema
ObjectId = Schema.Types.ObjectId
Agenda = require './agenda'

#
# Is a planet that is controlled by a player
#

BuildingSchema = new Schema
  name: {type: String}
  planet: {type: ObjectId, ref: 'Planet'}
  level: Number


  upgrade: ->
    #erm...

module.exports = mongoose.model 'Building', BuildingSchema
