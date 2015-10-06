BaseBot = require './BaseBot'
AStar = require '../ia/astar'

class MinerBot extends BaseBot
	start: ->
		@astar = new AStar(@state.board)
	move: (callback) ->
		console.log @state.hero.life;
		hero = @hero
		target = null
		if (hero.life >= 40)
			target = @_find_nearest_mine()
		if (target is null)
			target = @_find_nearest_tavern()

		console.log("Path from (#{hero.pos.x}, #{hero.pos.y}); to (#{target.pos.x}, #{target.pos.y})")
		path = @astar.find(hero.pos, target.pos)
		dir = AStar.pathToDir(path, target.pos)
		console.log(dir)
		callback(dir)

	_find_nearest_mine: ->
		target = null
		distance = Infinity
		for mine in @state.mines
			continue if mine.holder == @id
			newDist = AStar.manhattanDistance(@hero.pos, mine.pos)
			if (newDist < distance)
				target = mine
				distance = newDist
		return target

	_find_nearest_tavern: ->
		target = null
		distance = Infinity
		for tavern in @state.taverns
			newDistance = AStar.manhattanDistance(@hero.pos, tavern.pos)
			if distance > newDistance
				target = tavern
				distance = newDistance
		return target

module.exports = MinerBot;