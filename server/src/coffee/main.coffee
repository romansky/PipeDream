express = require 'express'
logr = require('node-logr').getLogger('main')
serialport = require("serialport")
SerialPort = serialport.SerialPort

serialPort = new SerialPort("/dev/ttyACM0", {
        baudrate: 9600,
        dataBits: 8,
        parity: 'none',
        stopBits: 1,
        flowControl: false
})

serialPortDataBuffer = []

# serialPort.on "data", (data)->

# 		console.log("data from serial:",data.toString())

# 		if serialPortDataBuffer.length > 0 and data.toString()[0] == 'L'
# 			[0..35].forEach (i)->
# 				serialPort.write serialPortDataBuffer[i]
# 			serialPortDataBuffer = []




requireUncached = (module)->
 	delete require.cache[require.resolve(module)]
 	require(module)

cache = {}

serverPort = 3000

exports.run = ()->
	
	app = express()
	app.use(express.bodyParser())

	if 'development' == app.get('env')
		logr.info 'running in development mode'

	if 'production' == app.get('env')
		logr.info 'running in production mode'


	app.get '/', (req, res)->
		buildClient app.get('env'), (err, htmlStr)->
			if htmlStr
				res.send(htmlStr) 
			else
				res.send(err.toString())


	app.post '/set', (req,res)->
		sendToArduino(req.body.values.split(","))
		res.send("thanks!")


	if 'development' == app.get('env')
		app.get '/tests', (req, res)->
			testBuilder = require '../../../specs/client/testBuilder.coffee'
			testBuilder.testJs (err, testJs)->
				res.send( testBuilder.html(testJs) )



	# the static mapping needs to be last
	app.use(express.directory(__dirname + '/../../public'))
	app.use(express.static(__dirname + '/../../public'), {icons: true})

	logr.info "server is listening on port #{serverPort}"

	app.listen serverPort
	


buildClient = (env, cb)->
	if cache.html
		cb(cache.html(cb))
	else 
		clientBuilder = requireUncached(__dirname + '/../../../client/builder.coffee')
		clientBuilder.js (err, js)->
			if (err) then cb(err, null)
			else clientBuilder.css (err, css)->
				if (err) then cb(err, null)
				else 
					_html = clientBuilder.html(js, css)

					if 'development' == env
						cb(null, _html)

					if 'production' == env
						cache.html = _html
						buildClient(cb)


sendToArduino = (values)->
	
	setTimeout( ()->

		serialPort.write "L"

		ordered = []
		
		for o in [0..5]
			buffer = []
			for i in [0..5]
				buffer.push values[ (o * 6) + i ]
			if (o + 1) % 2 != 0 then buffer.reverse()
			ordered = ordered.concat buffer
			buffer = []

		ordered.forEach (v)->
			serialPort.write v


	, 1000)
