dd   = require("./dd")
log  = require("./logger").init("mc-thermostat.thermostat")
url  = require("url")
uuid = require("node-uuid")

module.exports.Thermostat = class Thermostat

  constructor: (@service) ->
    @settings =
      "id":       uuid.v1()
      "interval": 3000
      "external": -1
      "desired":  -1
      "cooling":  false
      "warming":  false

  start: ->
    log.start "start", (log) =>
      @mqtt   = require("./mqtt-url").connect(@service)
      @mqtt.on "error", (err) ->
        log.error err
      @mqtt.on "connect", =>
        @tick()
      @ticker = dd.every @settings.interval, (=> @tick())
      log.success()

  stop: ->
    log.start "stop", (log) =>
      clearInterval @ticker
      delete @mqtt
      log.success()

  tick: ->
    log.start "tick", (log) =>
      @mqtt.publish "tick", JSON.stringify(@settings), (err) ->
        return log.error(err) if err
        #log.success()

module.exports.init = (args...) ->
  new Thermostat(args...)
