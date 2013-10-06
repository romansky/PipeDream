jquery = require 'jquery'

exports.Overlay = class Overlay
		$container : null
		newGameCB : null

		$overlay : null

		constructor : (@$container,@newGameCB)->
			@$overlay = jquery(html)
			@$container.append @$overlay
			@$overlay.find(".btn").bind "click", ()=>
				@hide()
				@newGameCB()

		hide : =>
			@$overlay.hide()



html = """
<div class="overlay center-text">
	<div class="curtain"></div>
	<div class="btn btn-success start">START</div>
</div>
"""