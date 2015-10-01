BaseBot = require './BaseBot'
class AggressiveBot extends BaseBot
	start: ->
	move: (callback) ->
		console.log @state.hero.life;
	_get_best_target: ->
		target = NULL
		for hero in @state.heroes
			continue if hero.id == @id
			if target is NULL or hero.mineCount > target.mineCount
				target = hero
		return target

