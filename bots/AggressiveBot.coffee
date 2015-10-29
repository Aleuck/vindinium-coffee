BaseBot = require './BaseBot'
AStar = require '../ia/astar'

class AggressiveBot extends BaseBot
	start: ->
		@astar = new AStar(@state.board)
	move: (callback) ->
		console.log @state.hero.life;
		hero = @state.hero
		if (hero.life < 40)
			target = @_find_nearest_tavern()
		else
			target = @_get_best_target()
		console.log("Path from (#{hero.pos.x}, #{hero.pos.y}); to (#{target.pos.x}, #{target.pos.y})")
		path = @astar.find(hero.pos, target.pos)
		dir = AStar.pathToDir(path, target.pos)
		console.log(dir)
		callback(dir)

	_get_best_target: ->
		target = null
		for hero in @state.heroes
			continue if hero.id == @id
			if target is null or (hero.mineCount > target.mineCount and hero.life >= target.life)
				target = hero
		return target

	_find_nearest_tavern: ->
		target = null
		distance = Infinity
		for tavern in @state.taverns
			newDistance = AStar.manhattanDistance(@state.hero.pos, tavern.pos)
			if distance > newDistance
				target = tavern
				distance = newDistance
		return target

module.exports = AggressiveBot;