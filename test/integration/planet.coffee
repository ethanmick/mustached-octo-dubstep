should = require('chai').should()
mongoose = require('mongoose-q')()
Planet = require '../../lib/models/planet'
db = null

describe 'Planet', ->

  before (done)->
    mongoose.connect('mongodb://localhost:27017/stupid_game');
    db = mongoose.connection
    Planet.removeQ({}).then ->
      done()

  it 'should exist', ->
    should.exist Planet

  it 'should have 5 null buildings on creation', (done)->
    p = new Planet(name: 'PLANET')
    p.saveQ().then ->
      p.buildings.should.have.length 5
      for b in p.buildings
        should.not.exist b
      done()
    .done()



  after (done)->
    db.close -> done()
