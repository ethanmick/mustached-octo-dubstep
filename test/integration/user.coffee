should = require('chai').should()
mongoose = require('mongoose-q')()
User = require '../../lib/models/user'
MongoClient = require('mongodb').MongoClient
db = null

describe 'user', ->

  before (done)->
    mongoose.connect('mongodb://localhost:27017/stupid_game');
    db = mongoose.connection
    User.removeQ({}).then ->
      done()

  it 'should exist', ->
    should.exist User

  it 'should register', (done)->
    User.register('ethan', 'testing').then (user)->
      user.username.should.equal 'ethan'
      user.password.should.not.equal 'testing'
      done()
    .done()

  it 'should not register a user already taken', (done)->
    User.register('ethan', 'testing').fail ->
      done()

  it 'should compare passwords', (done)->
    User.findOneQ(username: 'ethan').then (user)->
      user.comparePassword('testing')
    .then ->
      done()

  it 'should fail on the wrong password', (done)->
    User.findOneQ(username: 'ethan').then (user)->
      user.comparePassword('derp')
    .fail (err)->
      err.message.should.equal 'Incorrect username or password'
      done()

  it 'should give a new user a planet', (done)->
    User.register('ethan2', 'testing').then (user)->
      user.username.should.equal 'ethan2'
      User.findOne(username: 'ethan2')
        .populate('planet')
        .execQ()
    .then (user)->
      user.planet.should.be.ok
      user.planet.name.should.equal 'New Planet'
      done()
    .done()


  after (done)->
    db.close -> done()
