#
# Ethan Mick
# 2015
#

mongoose = require('mongoose-q')()
Schema = mongoose.Schema
ObjectId = Schema.Types.ObjectId

SolarSystem = new Schema
  name:
    type: String
  location: Number
  slots: Number
  planets: [
    {
      type: ObjectId
      ref: 'Planet'
    }
  ]
  galaxy:
    type: ObjectId
    ref: 'Galaxy'

module.exports = mongoose.model 'SolarSystem', SolarSystem
