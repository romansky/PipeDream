{ModBlock} = require './ModBlock.coffee'

exports.State = class State

	pipeMatrix : null
	listeners : null
	modBlock : null
	modBlockPos : null

	constructor : (@pipeMatrix)->
		@listeners = []


	register : (listener)=>
		@listeners.push listener
		@_notifyListener(listener)


	addModBlock : =>
		if not @modBlock
			@modBlockPos = @pipeMatrix.getAvailableBlockRowColumn()
			@modBlock = ModBlock.GetRandom()
			@modBlockChanged()


	modBlockChanged : =>
		newPipeMatrix = @pipeMatrix.placeModBlock(@modBlock, @modBlockPos[0], @modBlockPos[1])
		@updatePipeMatrix(newPipeMatrix)

	resetModBlock : =>
		@modBlock = null
		@modBlockPos = null
		@addModBlock()


	placeModBlock : (modBlock, row, column)=>
		@modBlock = modBlock
		@modBlockPos = [row, column]
		
	updatePipeMatrix : (newPipeMatrix)=>
		@pipeMatrix = newPipeMatrix
		@notify()

	notify : =>
		@listeners.forEach (lcb)=>
			@_notifyListener(lcb)

	_notifyListener : (listener)=>
		listener(@pipeMatrix)


	up : ()=> 
		if @modBlock and @modBlockPos[0] > 0 and @pipeMatrix.isBlockAvailable(@modBlockPos[0] - 2, @modBlockPos[1])
			@modBlockPos[0] -= 2
			@modBlockChanged()

	right : ()=>
		if @modBlock and @modBlockPos[1] < 4 and @pipeMatrix.isBlockAvailable(@modBlockPos[0], @modBlockPos[1] + 2)
			@modBlockPos[1] += 2
			@modBlockChanged()
	down : ()=>
		if @modBlock and @modBlockPos[0] < 4 and @pipeMatrix.isBlockAvailable(@modBlockPos[0] + 2, @modBlockPos[1])
			@modBlockPos[0] += 2
			@modBlockChanged()
	left : ()=>
		if @modBlock and @modBlockPos[1] > 0 and @pipeMatrix.isBlockAvailable(@modBlockPos[0], @modBlockPos[1] - 2)
			@modBlockPos[1] -= 2
			@modBlockChanged()
	set : ()=> 
		if @modBlock
			@pipeMatrix = @pipeMatrix.fillFromModBlock @modBlock, @modBlockPos[0], @modBlockPos[1]
			@resetModBlock()

	rotateLeft: ()=> 
		if @modBlock
			@modBlock = @modBlock.rotateLeft()
			@modBlockChanged()
	rotateRight : ()=> 
		if @modBlock
			@modBlock = @modBlock.rotateRight()
			@modBlockChanged()
