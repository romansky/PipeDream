
exports.PipeMatrix = class PipeMatrix

	@CellType : {
		"empty"
		"filled"

		"active"
		"inactive"
	}
	
	_matrix : null

	getMatrix : => @_matrix

	@New : ->

		pm = new PipeMatrix()

		pm._matrix = 
			[0..5].map (r)->
				[0..5].map (c)->
					PipeMatrix.CellType.empty

		pm


	getAvailableBlockRowColumn : =>
		nextAvail = if @isBlockAvailable(0,0) then [0,0]
		else if @isBlockAvailable(0,2) then [0,2]
		else if @isBlockAvailable(0,4) then [0,4]
		else if @isBlockAvailable(2,0) then [2,0]
		else if @isBlockAvailable(2,2) then [2,2]
		else if @isBlockAvailable(2,4) then [2,4]
		else if @isBlockAvailable(4,0) then [4,0]
		else if @isBlockAvailable(4,2) then [4,2]
		else if @isBlockAvailable(4,4) then [4,4]
		else null
		
		nextAvail



	isBlockAvailable : (row, column) =>
		@_matrix[row][column] != PipeMatrix.CellType.filled and
			@_matrix[row][column + 1] != PipeMatrix.CellType.filled and
			@_matrix[row + 1][column] != PipeMatrix.CellType.filled and
			@_matrix[row + 1][column + 1] != PipeMatrix.CellType.filled

	placeModBlock : (modBlock, row, column)=>
		if @isBlockAvailable(row, column)
			newPipeMatrix = PipeMatrix.New()
			@mergeMatrixes newPipeMatrix._matrix, @_matrix

			newPipeMatrix._matrix[row][column] = if modBlock.getCells()[0][0] then PipeMatrix.CellType.active else PipeMatrix.CellType.inactive
			newPipeMatrix._matrix[row + 1][column] = if modBlock.getCells()[1][0] then PipeMatrix.CellType.active else PipeMatrix.CellType.inactive
			newPipeMatrix._matrix[row][column + 1] = if modBlock.getCells()[0][1] then PipeMatrix.CellType.active else PipeMatrix.CellType.inactive
			newPipeMatrix._matrix[row + 1][column + 1] = if modBlock.getCells()[1][1] then PipeMatrix.CellType.active else PipeMatrix.CellType.inactive
			newPipeMatrix
		else @

	fillFromModBlock : (modBlock, row, column)=>
		if @isBlockAvailable(row, column)
			newPipeMatrix = PipeMatrix.New()
			@mergeMatrixes newPipeMatrix._matrix, @_matrix

			[0,1].forEach (r)=>
				[0,1].forEach (c)=>
					newPipeMatrix._matrix[row + r][column + c] = if modBlock.getCells()[r][c] then PipeMatrix.CellType.filled else PipeMatrix.CellType.empty
			newPipeMatrix
		else @


	mergeMatrixes : (dst,src)->
		src.forEach (r,ri)->
			r.forEach (c,ci)->
				if c == PipeMatrix.CellType.filled
					dst[ri][ci] = c

	getSerialized: =>
		res = []
		@_matrix.forEach (r)->
			r.forEach (c)->
				res.push switch c
					when PipeMatrix.CellType.empty		then 0
					when PipeMatrix.CellType.filled 	then 1
					when PipeMatrix.CellType.active		then 2
					when PipeMatrix.CellType.inactive	then 3
		res


