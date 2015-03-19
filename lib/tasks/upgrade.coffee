#
#
#
#

Building = require '../models/building'

module.exports = (params)->
  Building.upgrade(params.id)
