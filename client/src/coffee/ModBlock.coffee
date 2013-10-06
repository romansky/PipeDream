
exports.ModBlock = class ModBlock

	_cells : null

	@GetRandom : ->
		numActive = Math.round(Math.random()) + 2
		newBlock = new ModBlock()
		newBlock._cells = 
			[0,1].map (r)=>
				[0,1].map (c)=>
					if numActive > 0
						numActive -= 1
						true
					else
						false
		newBlock


	rotateLeft : =>
		newBlock = new ModBlock()
		newBlock._cells = 
			[0,1].map (r)=>
				[0,1].map (c)=>	
					switch "#{r}#{c}"
						when "00" then @_cells[0][1]
						when "10" then @_cells[0][0]
						when "11" then @_cells[1][0]
						when "01" then @_cells[1][1]
		newBlock

	rotateRight : =>
		@rotateLeft().rotateLeft().rotateLeft()

	getCells : => @_cells