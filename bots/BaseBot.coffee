RawBot = require './RawBot'
vi = require '../vindinium.coffe'

class BaseBot extends RawBot
  _start: (state) ->
    # Wrapper to start method.
    @id = state.hero.id
    @state = new vi.Game(state)
    hero = @state.heroes[@id-1]
    @start()
  _move: (state, callback) ->
    # Wrapper to move method.
    @state.update(state)
    @move(callback)

module.exports = BaseBot;