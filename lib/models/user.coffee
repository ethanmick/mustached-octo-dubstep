mongoose = require('mongoose-q')()
Q = require 'q'
bcrypt = require 'bcrypt'
Boom = require 'boom'
BadRequest = Boom.badRequest
Schema = mongoose.Schema
ObjectId = Schema.ObjectId
Planet = require './planet'
SALT_WORK_FACTOR = 10

UserSchema = new Schema
  username: {type: String, required: true, unique: yes, lowercase: yes}
  password: {type: String, required: true}
  planet: {type: ObjectId, ref: 'Planet'}
  accessToken: String

###
 * BCrypt Middleware to hash the password given before the user is saved.
 * This is never called explicitly.
###
UserSchema.pre 'save', (next)->
  return next() unless @isModified 'password'

  bcrypt.genSalt SALT_WORK_FACTOR, (err, salt)=>
    return next(err) if err
    bcrypt.hash @password, salt, (err, hash)=>
      return next(err) if err
      @password = hash
      next()

UserSchema.statics =

  register: (username, password)->
    throw BadRequest 'Username is required!' unless username
    throw BadRequest 'Password is required!' unless password

    newUser = new this(username: username, password: password)
    newUser.saveQ().then ->
      newUser.setup()
    .then ->
      newUser


UserSchema.methods =

  ###
   * Compares a given password with the user's password.
   * Uses bcrypt and hashes the given password.
   *
   * @candidatePassword The given password to compare
   * @cb The callback with the result. cb(error, isMatch)
  ###
  comparePassword: (candidatePassword)->
    compare = Q.denodeify(bcrypt.compare)
    compare(candidatePassword, @password).then (matched)->
      throw new Error('Incorrect username or password') unless matched
      matched


  ###
   * Creates the session token for the user.
   * Utilizes the crypto library to generate the token, from the docs it:
   * 'Generates cryptographically strong pseudo-random data'
   * We then change that to a hex string for nice representation.
  ###
  generateRandomToken: ->
    require('crypto').randomBytes(48).toString('hex')


  ###
  * Sets ups the user's account (only done on creation of the user)
  ###
  setup: ->
    p = new Planet(user: this)
    @planet = p
    Q.all([p.saveQ(), @saveQ()])

module.exports = mongoose.model 'User', UserSchema
