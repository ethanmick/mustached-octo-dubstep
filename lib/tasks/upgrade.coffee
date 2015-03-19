#
#
#
#

Building = require '../models/building'

module.exports = (params)->
  console.log 'UPGRADE BUILDING', params
  Building.upgrade(params.id)
