logr = require('node-logr').getLogger('cake')

handleExecErrors = (err, stdout, stderr)->
	if err then logr.error err
	logr.info "Test results below: \n\n" + ( if err then stdout + stderr else stdout || "" )

task 'run', ->
	logr.info "starting server.."
	require('./server/src/coffee/main').run()
