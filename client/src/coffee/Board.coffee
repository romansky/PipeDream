{PipeMatrix} = require './PipeMatrix.coffee'
jquery = require 'jquery'

exports.Board = class Board

	$board : null

	constructor : (@$board,state)->
		state.register @stateChange

	stateChange : (pipeMatrix)=>
		@drawMatrix pipeMatrix

	drawMatrix : (pipeMatrix)=>
		@$board.empty()

		$table = jquery "<table class='board-table'/>"
		@$board.append $table
		pipeMatrix.getMatrix().forEach (r)->
			$tr = jquery "<tr/>"
			$table.append $tr
			r.forEach (c)->
				$td = jquery "<td/>"
				$tr.append $td
				$td.addClass switch c
					when PipeMatrix.CellType.empty		then "empty"
					when PipeMatrix.CellType.filled 	then "filled"
					when PipeMatrix.CellType.active		then "active"
					when PipeMatrix.CellType.inactive	then "inactive"












