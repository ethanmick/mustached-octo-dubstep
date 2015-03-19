mongoose = require('mongoose-q')()
Q = require 'q'
uuid = require 'uuid'
Schema = mongoose.Schema
ObjectId = Schema.Types.ObjectId
Task = require('./future').Task

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
    Task.inSeconds(5, opts: {action: 'upgrade', id: @_id}, yes)

BuildingSchema.statics =

  upgrade: (id)->
    @findByIdQ(id).then (building)->
      building._upgrade()

module.exports = mongoose.model 'Building', BuildingSchema
