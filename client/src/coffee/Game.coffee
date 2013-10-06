{BaseRouter} = require './BaseRouter.coffee'
{Board} = require './Board.coffee'
{Controls} = require './Controls.coffee'
{State} = require './State.coffee'
{PipeMatrix} = require './PipeMatrix.coffee'
{Overlay} = require './Overlay.coffee'
jquery = require 'jquery'

exports.Game = class Game extends BaseRouter

	state : null
	board : null
	controls : null
	overlay : null
	
	initialize: ()->

		pm = PipeMatrix.New()
		@state = new State(pm)

		@board = new Board(jquery("#board"), @state)
		@controls = new Controls(jquery("#controls"), @state, @onSet)

		@overlay = new Overlay(jquery(".container"),@newGame)
		

	newGame : =>
		@state.addModBlock()
		
	onSet : =>
		jquery.post "http://192.168.43.80:3000/set", {"values": @state.pipeMatrix.getSerialized().join(",") }





# Start the application
Game = new Game()