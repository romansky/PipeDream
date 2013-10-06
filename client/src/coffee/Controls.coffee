jquery = require 'jquery'

exports.Controls = class Controls

	@Buttons : {
		"buttonUp"
		"buttonRight"
		"buttonDown"
		"buttonLeft"
		"buttonSet"
		"buttonRLeft"
		"buttonRRight"
	}

	$container : null
	state : null
	setCB : null

	constructor : (@$container,@state,@setCB)->
		@state.register @stateChange
		@$container.off "click", "div"
		@$container.on "click", "div", @_clickedButton

	stateChange : (pipeMatrix)=>
		@_redraw(pipeMatrix)
		@setCB()

	_redraw : (pipeMatrix) =>
		@$container.empty()
		@$container.append html

	_clickedButton : (el)=>
		el.stopPropagation()
		btnClass = jquery(el.currentTarget).attr("class").split(" ")[2]
		if btnClass and /button/.test(btnClass)
			@handleButton btnClass

	handleButton : (btn)=>
		switch btn
			when Controls.Buttons.buttonUp		then @state.up()
			when Controls.Buttons.buttonRight	then @state.right()
			when Controls.Buttons.buttonDown	then @state.down()
			when Controls.Buttons.buttonLeft	then @state.left()
			when Controls.Buttons.buttonRLeft	then @state.rotateLeft()
			when Controls.Buttons.buttonRRight	then @state.rotateRight()
			when Controls.Buttons.buttonSet		then @state.set()

		



html = """
<div class="row">
	<div class="row">
		<div class="col-md-4"></div>
		<div class="col-md-4 btn #{Controls.Buttons.buttonUp}">UP</div>
		<div class="col-md-4"></div>
	</div>
	<div class="row">
		<div class="col-md-4 btn #{Controls.Buttons.buttonLeft}">LEFT</div>
		<div class="col-md-4 btn #{Controls.Buttons.buttonSet}">SET</div>
		<div class="col-md-4 btn #{Controls.Buttons.buttonRight}">RIGHT</div>
	</div>
	<div class="row">
		<div class="col-md-4"></div>
		<div class="col-md-4 btn #{Controls.Buttons.buttonDown}">Down</div>
		<div class="col-md-4"></div>
	</div>
</div>
<div class="row">
	<div class="col-md-6 btn #{Controls.Buttons.buttonRLeft}">R_LEFT</div>
	<div class="col-md-6 btn #{Controls.Buttons.buttonRRight}">R_RIGHT</div>
</div>
"""
