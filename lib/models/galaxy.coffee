#
# Ethan Mick
# 2015
#

mongoose = require('mongoose-q')()
Schema = mongoose.Schema
ObjectId = Schema.Types.ObjectId

Galaxy = new Schema
  name:
    type: String
  systems: [
    {
      type: ObjectId
      ref: 'SolarSystem'
    }
  ]

module.exports = mongoose.model 'Galaxy', Galaxy
