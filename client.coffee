request = require 'request';

class Client
  constructor: (options) ->
    @key = options.key
    @mode = options.mode or 'training'
    @n_turns = options.n_turns or 300
    @server = options.server or 'http://vindinium.org'
    @open_browser = options.open_browser or false
    @timeout_move = 15
    @timeout_connection = 1000 * 60
    @__bot = null
    @__play_url = null
  run: (bot) ->
    @__bot = bot
    @__connect()
  __connect: ->
    # Set up parametersSends a movement command to the server.
    if @mode is 'arena'
      endpoint = '/api/arena'
      params =
        key: @key
    else
      endpoint = '/api/training'
      params =
        key: @key
        turns: @n_turns
        map: 'm2'

    # Connect
    console.log "Trying to connect to #{@server + endpoint}"
    request.post { url: @server + endpoint, form: params, timeout: @timeout_connection }, @__on_connect

  __move: (action) ->
    # Sends a movement command to the server.
    request.post { url: @__play_url, form: { dir: action } }, @__on_move

  # Event handler methods (should be binded with ´=>´) 

  __on_connect: (err, response, body) =>
    # Is called when server answers the connection or timeout is reached.
    if err
      console.log "Could not connect."
      console.dir err
      return

    if response.statusCode isnt 200
      console.log "HTTP #{response.statusCode}"
      console.dir response
      return

    state = JSON.parse body
    console.log "Connected! Playing game at: #{state.viewUrl}"
    @__bot._start state
    @__play_url = state['playUrl']

    @__bot._move state, @__on_bot_action

  __on_move: (err, response, body) =>
    # Is called when server answers a movement request.
    if err
      console.log "Could not send request."
      console.dir err
      return

    if response.statusCode isnt 200
      console.log "HTTP #{response.statusCode}"
      console.dir response
      return

    state = JSON.parse body
    if not state.game.finished
      @__bot._move state, @__on_bot_action
    else
      @__bot._end()
      console.log "Game ended, watch replay on: #{state.viewUrl}"

  __on_bot_action: (action) =>
    # Is called when bot sends an action
    @__move action

module.exports = Client