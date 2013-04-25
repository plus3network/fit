java = require 'java'
{join} = require 'path'

java.classpath.push join __dirname, "../external/FitToJson.jar"

module.exports = fit =
  bufferToByteArray: (buf) -> 
    bArr = Array.prototype.slice.call buf, 0
    jbArr = bArr.map (b) -> java.newByte b
    return java.newArray "byte", jbArr
  
  parse: (buf, cb) ->
    return cb new Error "Invalid Buffer" unless Buffer.isBuffer buf
    
    bArr = fit.bufferToByteArray buf

    java.newInstance "ws.plus3.fit.FitToJson", bArr, (err, FitToJson) ->
      return cb err if err?
      FitToJson.getJSON (err, res) ->
        return cb err if err?
        try
          res = JSON.parse res
        catch e
          return cb e
        cb null, res