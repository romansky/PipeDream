SerialPort = require('serialport').SerialPort
sp = new SerialPort("/dev/ttyUSB0", {parity: 'even', stopBits: 1, dataBits: 8}, false)
sp.open ->
	process.nextTick ()->
		sp.on "data", (data)->
			console.log "data: ", data.toString()
		sp.on "error", (err)->
			console.log err
		setTimeout( ()->
			sp.write "a123456789a\n", (err,len)->
				console.log "sending 2.."
				if err then console.log "err",err
		, 500)
