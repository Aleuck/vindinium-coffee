
DIR_NEIGHBORS = [
	{ x:  0, y:  1 };
	{ x:  0, y: -1 };
	{ x:  1, y:  0 };
	{ x: -1, y:  0 };
]

searchNode = (heap, pos) ->
	for i in [0...heap.length]
		p = heap[i];
		if p.x == pos.x and p.y == pos.y
			return i;
	return false

manhattanDistance = (p1, p2) -> (Math.abs(p1.x - p2.x) + Math.abs(p1.y - p2.y))


compareNodes = (e1, e2) -> e1.f - e2.f

insert = (array, element, funCmp) ->
	first = 0
	selected = 0
	last = array.length
	while first < last
		selected = Math.floor(Math.random() * (last - first)) + first;
		cmp = funCmp(element, array[selected])
		if cmp < 0
			first = selected + 1
			selected = first
		if cmp > 0
			last = selected
		if cmp == 0
			first = selected
			last = selected
	array.splice(selected,0,element);

remove = (array) -> array.pop();

class AStar
	constructor: (board, h) ->
		@board = board
		@h = h || manhattanDistance
		@costMove = 1
		@costAvoid = 1
		@obstacles = ['mine', 'wall', 'tavern']
	_cmp: (a, b) -> a.f - b.f
	find: (source, target) ->
		h = @h
		open = []
		closed = []
		source.g = 0
		source.h = @h(source, target)
		source.f = source.g + source.h
		costMove = @costMove
		costAvoid = @costAvoid
		board = @board
		insert(open, source, compareNodes)
		#Heap.push(open, source, @_cmp)
		adjacent = false
		if board.tiles[target.x][target.y].type in @obstacles
			adjacent = true
			#console.log("adjacent")
		while open.length > 0
			#current = Heap.pop(open, @_cmp)
			current = remove(open)
			#console.log("insert (#{current.x}, #{current.y}}) on closed")
			insert(closed, current, compareNodes)
			#Heap.push(closed, current, @_cmp)
			break if current.x == target.x and current.y == target.y
			break if adjacent and manhattanDistance(current, target) <= 1
			for dir in DIR_NEIGHBORS
				x = current.x + dir.x
				y = current.y + dir.y
				selected = { x:x, y:y }
				continue if not @_checkBoundaries(x,y)
				continue if board.tiles[x][y].type in @obstacles
				continue if searchNode(closed, selected) != false
				selected.g = current.g + costMove
				selected.h = h(selected, target)
				selected.f = selected.g + selected.h
				selected.parent = current
				# find the index of current node already existing in open list, if any
				item = searchNode(open, selected)
				if item == false
					# insert new node into open list
					insert(open, selected, compareNodes)
				else
					# node already in the list
					# check if the value is better
					if open[item].f > selected.f
						# remove old node from open list
						open.splice(item, 1)
						# insert new node into open list
						insert(open, selected, compareNodes)
		# build path
		path = [current]
		while current.parent
			current = current.parent
			path.push(current)
		path
		# closed
	_checkBoundaries: (x, y) ->
		return false if x < 0 or x >= @board.size or y < 0 or y >= @board.size
		return true

module.exports = AStar
