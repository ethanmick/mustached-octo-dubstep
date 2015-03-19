should = require('chai').should()
mongoose = require('mongoose-q')()
Building = require '../../lib/models/building'
db = null

describe 'Building', ->

  b = null
  before (done)->
    mongoose.connect('mongodb://localhost:27017/stupid_game');
    db = mongoose.connection

    b = new Building(name: 'Mine', level: 1, planet: null)
    b.saveQ().then ->
      done()
    .done()

  it 'should upgrade', (done)->
    @timeout(7000)
    b.upgrade()
    setTimeout ->
      Building.findByIdQ(b._id).then (aB)->
        aB.level.should.equal 2
        done()
      .done()
    , 6500


  after (done)->
    db.close -> done()
