Agenda = require 'agenda'
module.exports = agenda = new Agenda db: { address: 'localhost:27017/agenda-example'}
agenda.start()
