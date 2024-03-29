url = require("url")

module.exports.createClient = module.exports.connect = (mqtt_url) ->
  parsed_url = url.parse(mqtt_url or process.env.MQTT_URL or "mqtt://localhost:1883")
  parsed_auth = (parsed_url.auth or "").split(":")
  options = if parsed_url.auth then {username:parsed_auth[0], password:parsed_auth[1]} else {}
  mqtt = require("mqtt").createClient(parsed_url.port, parsed_url.hostname, options)
  mqtt
