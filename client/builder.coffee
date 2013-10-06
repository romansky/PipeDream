browserify = require 'browserify'
shim = require 'browserify-shim'
coffeeify = require 'coffeeify'
less = require 'less'
fs = require 'fs'
logr = require('node-logr').getLogger(__filename)

###
@param cb Function[err : Error, sourceStr: String]
@return String the JS source strigified
###
exports.js = (cb)->
	shim(browserify(),{
		jquery : { path: '../public/3rd/jquery/jquery-1.10.2.js', exports: '$' },
		stickit : { 
			path: '../public/3rd/stickit/backbone.stickit.js', 
			exports: null,
			depends: { jquery: '$', underscore: '_', backbone: 'Backbone' }
		}
	})
	.require(require.resolve('../public/3rd/underscore/underscore.js'), {expose: 'underscore' })
	.require(require.resolve('../public/3rd/backbone/backbone.js'), {expose: 'backbone' })
	.add(__dirname + '/src/coffee/Game.coffee')
	.transform(coffeeify)
	.bundle((err, resStr)-> 
		if err then cb(new Error(err), resStr)
		else cb(null, resStr)
	)

###
@param cb Function[err : Error, sourceStr: String]
@return String the css sources strigified
###
exports.css = (cb)->
	parser = new (less.Parser)({paths : [ __dirname + "/../public/3rd/bootstrap/less", __dirname + "./src/less" ] })

	cssSource = require.resolve(__dirname + "/src/less/game.less")
	cssString = fs.readFileSync cssSource, "utf8"

	parser.parse cssString, (err, tree)->
		if err 
			logr.error(err)
			cb(new Error(err), "")
		else cb(null, tree.toCSS())


###
@param jsSrcString
@param cssSrcString String the css 
@return String the html source
###
exports.html = (jsStr,cssStr)->
	"""
	<!DOCTYPE html>
	<html>
	<head>
		<meta content='width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0' name='viewport' />
		<meta name="viewport" content="width=device-width" />
		<meta http-equiv="X-UA-Compatible" content="IE=edge" />
		<meta charset="UTF-8" />
		<title>Pipe═Dream</title>
		<style>#{cssStr}</style>
	</head>
	<body>


	<div class="page-header">
		<h1 class="text-center"> ╦═╝║╔ Pipe═Dream ╗║╚═╦ </h1>
		<p class="lead"></p>
	</div>
	<div class="container">

		<div class="row" style="">
			<div class="col-md-7" id="board"></div>
			<div class="col-md-5" id="controls"></div>
	    </div>


	</div>

	<script>
	#{jsStr}
	</script>
	</body>
	</html>
	"""

