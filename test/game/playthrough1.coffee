'use strict'
#
# Ethan Mick
# 2015
#
# Simulate the creation of the game world, and then someone playing
# through some of it
#

should = require('chai').should()
mongoose = require('mongoose-q')()
Q = require 'q'
Galaxy = require '../../lib/models/galaxy'
SolarSystem = require '../../lib/models/solar_system'
User = require '../../lib/models/user'
db = null

describe 'The Game 1', ->

  before (done)->
    mongoose.connect('mongodb://localhost:27017/stupid_game');
    db = mongoose.connection
    Q.all([
      User.removeQ({})
      Galaxy.removeQ({})
      SolarSystem.removeQ({})
    ]).then ->
      done()

  g = null
  it 'should create a galaxy', (done)->
    g = new Galaxy(name: 'Andromeda')
    g.systems = []
    g.saveQ().then ->
      done()

  it 'should add a solar system to the galaxy', (done)->
    ss = new SolarSystem({
      name: 'great-system'
      location: 1
      slots: 15
      planets: []
      galaxy: g
    })
    ss.saveQ().then ->
      ss.galaxy.should.be.ok
      done()

  user = null
  it 'should create a new user', (done)->
    User.register('cooluser420', 'testing').then (user)->
      User.findOne(username: 'cooluser420')
        .populate('planet')
        .execQ()
    .then (u)->
      user = u
      should.exist user
      done()

  planet = null
  it 'should show the planet info', ->
    planet = user.planet
    planet.name.should.equal 'New Planet'
    planet.buildings.should.have.length 5

  it 'should let the user build a metal mine', (done)->
    mine = new MetalMine()
    planet.build()

  after (done)->
    db.close -> done()
