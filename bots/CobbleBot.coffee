BaseBot = require './BaseBot'
AStar = require '../ia/astar'

class CobbleBot extends BaseBot
	start: ->
		@astar = new AStar(@state.board)
	move: (callback) ->
		console.log @state.hero.life;
		me = @state.hero
		target = null
		if (me.life > 50)
			target = @_get_best_target()
		if target == null
			target = @_find_nearest_tavern()
		console.log("Path from (#{me.pos.x}, #{me.pos.y}); to (#{target.pos.x}, #{target.pos.y})")
		path = @astar.find(me.pos, target.pos)
		dir = AStar.pathToDir(path, target.pos)
		console.log(dir)
		callback(dir)

	_get_best_target: ->
		target = null
		me = @state.hero
		for hero in @state.heroes
			continue if hero.id == @id
			if me.life >= hero.life
				if target == null or hero.mineCount > target.mineCount
					target = hero
		return target

	_find_nearest_tavern: ->
		target = null
		distance = Infinity
		for tavern in @state.taverns
			newDistance = AStar.manhattanDistance(@state.hero.pos, tavern.pos, @avoidPlayersHeuristic)
			if distance > newDistance
				target = tavern
				distance = newDistance
		return target
	avoidPlayersHeuristic: (p1, p2) =>
		value = AStar.manhattanDistance(p1, p2)
		for hero in @state.heroes
			if AStar.manhattanDistance(p1,hero.pos) <= 2
				value += 6
		for tavern in @state.taverns
			if AStar.manhattanDistance(p1,tavern.pos) <= 1
				value -= 2
		return value

module.exports = CobbleBot;