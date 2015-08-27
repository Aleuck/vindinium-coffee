class RawBot
  id: null
  state: null

  _start: (state) ->
    # Wrapper to start method.
    @id = state.hero.id
    @state = state
    @start()

  _move: (state, callback) ->
    # Wrapper to move method.
    @state = state
    @move(callback)

  _end: () ->
    # Wrapper to end method.
    @end()

  start: ->
    # Called when the game starts.

  move: (callback) ->
    # Called when the game requests a move from this bot.

  end: ->
    # Called after the game finishes.

module.exports = RawBot;