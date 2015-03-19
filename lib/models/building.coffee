mongoose = require('mongoose-q')()
Q = require 'q'
uuid = require 'uuid'
Schema = mongoose.Schema
ObjectId = Schema.Types.ObjectId
future = require './future'


#
# Is a planet that is controlled by a player
#

BuildingSchema = new Schema
  name:
    type: String
  planet:
    type: ObjectId
    ref: 'Planet'
  level: Number

BuildingSchema.methods =

  _upgrade: ->
    @level++
    @saveQ()

  upgrade: ->
    d = new Date()
    d.setSeconds(d.getSeconds() + 5)
    task =
      name: uuid.v4()
      time: d
      opts:
        action: 'upgrade'
        id: @_id
    console.log 'SENDING', task
    future.schedule(task)

BuildingSchema.statics =

  upgrade: (id)->
    @findByIdQ(id).then (building)->
      building._upgrade()

module.exports = mongoose.model 'Building', BuildingSchema
