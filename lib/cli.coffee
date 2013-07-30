async      = require("async")
dd         = require("./dd")
os         = require("os")
program    = require("commander")
thermostat = require("./thermostat")
util       = require("util")

program
  .version(require("../package.json").version)
  .usage('[options] <slug url>')
  .option('-c, --concurrency <num>', 'number of thermostats', process.env.THERMOSTATS_PER_PROCESS || 5)
  .option('-j, --jitter <ms>', 'startup jitter', process.env.STARTUP_JITTER || 5000)
  .option('-m, --mqtt <url>', 'mqtt endpoint', process.env.MQTT_URL)

module.exports.thermostats = []

module.exports.execute = (args) ->
  program.parse(args)
  for i in [0..(program.concurrency-1)]
    dd.delay Math.floor(Math.random() * parseInt(program.jitter)), ->
      module.exports[i] = thermostat.init(program.service)
      module.exports[i].start()
