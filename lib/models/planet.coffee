mongoose = require('mongoose-q')()
Q = require 'q'
Schema = mongoose.Schema
ObjectId = Schema.Types.ObjectId
Building = require './building'

NUMBER_OF_BUILDINGS = 5

#
# Is a planet that is controlled by a player
#

PlanetSchema = new Schema
  name: {type: String, default: 'New Planet'}
  user: {type: ObjectId, ref: 'User'}
  buildings: [type: ObjectId, ref: 'Building', default: []]


PlanetSchema.pre 'save', (next)->
  return next() unless @isNew
  @buildings[i] = null for i in [0...NUMBER_OF_BUILDINGS]
  next()

PlanetSchema.methods =

  upgrade: (i)->
    building = @buidings[i]
    return unless building
    Building.findOneByIdQ(building).then (b)->
      b.upgrade()




module.exports = mongoose.model 'Planet', PlanetSchema
