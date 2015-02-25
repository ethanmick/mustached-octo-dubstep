#
#
#
#
Schedulable = require 'schedulable'

output =
  1: 20
  2: 40
  3: 75
  4: 100
  5: 100

class MetalMine extends Schedulable

  constructor: ->
    @level = 1

  upgrade: ->
    @update().then =>
      @checkRequirements()
    .then =>
      @_upgrade()

  _upgrade: ->
    {name, job} = @schedule =>
      @level++
    @schedule(name)


module.exports = MetalMine
