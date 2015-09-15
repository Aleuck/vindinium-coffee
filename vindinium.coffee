Directions = {
  'Stay':  0,
  'North': 1,
  'South': 2,
  'East':  3,
  'West':  4,
  '0': 'Stay',
  '1': 'North',
  '2': 'South',
  '3': 'East',
  '4': 'West',
}

class Game
  constructor: (game) ->
    @id = game.id
    @heroes = []
    @taverns = []
    @mines = []
    @board = new Board game.board.size
    @wall = new Wall
    @empty = new Empty
    @update game
  turn: 0
  maxTurns: 0
  finished: false
  update: (gameSrc) ->
    tiles = gameSrc.board.tiles
    @heroes = new Hero(hero) for hero in gameSrc.heroes
    for y in [0 ... @board.size] by 1
      for x in [0 ... @board.size] by 1
        objStr = tiles.substr (2 * x + 2 * @board.size * y), 2
        switch objStr[0]
          when '#'
            @board.tiles[x][y] = @wall
          when '['
            tavern = new Tavern(x, y)
            @board.tiles[x][y] = tavern
            @taverns.push tavern
          when '$'
            holder = parseInt(objStr[1]) - 1
            holder = 0 if isNaN(holder)
            mine = new Mine(x, y, holder)
            @board.tiles[x][y] = mine
            @mines.push mine
          when '@'
            @board.tiles[x][y] = @empty
            heroIdx = parseInt(objStr[1]) - 1
            hero = new Hero(gameSrc.heroes[heroIdx])
            @heroes[heroIdx] = hero
            @board.tiles[x][y] = hero
          when ' '
            @board.tiles[x][y] = @empty
class Board
  constructor: (boardSize) ->
    @size = boardSize
    @tiles = ([] for i in (Array @size))
  spawn: (hero) ->
  size: 0
  tiles: null
  toString: -> 
    string = ''
    for y in [0 .. @size - 1] by 1
      string += '\n'
      for x in [0 .. @size - 1] by 1
        string += @tiles[x][y].toString()
    string

class Hero
  constructor: (hero) ->
    @id = hero.id
    @name = hero.name
    @userId = hero.userId
    @elo = hero.elo
    @life = hero.life
    @gold = hero.gold
    @mineCount = hero.mineCount
    @pos = { x: hero.pos.y, y: hero.pos.x }
    @spawnPos = { x: hero.spawnPos.y, y: hero.spawnPos.x }
    @crashed = hero.crashed
    @lastDir = hero.lastDir
  type: 'hero'
  id: 0
  name: "Hero"
  userId: ''
  elo: 0
  pos: null
  toString: -> "@#{@id}"

class Mine
  constructor: (x, y, holder) ->
    @pos = { x: x, y: y }
    @holder = holder
  type: 'mine'
  holder: null
  pos: null
  toString: -> '$'+ (@holder | '-')

class Empty
  type: 'empty'
  toString: -> '  '

class Wall
  type: 'wall'
  toString: -> '##'

class Tavern
  constructor: (x, y) ->
    @pos = { x: x, y: y }
  type: 'tavern'
  pos: null
  toString: -> '[]'

module.exports = {
  Game: Game,
  Board: Board,
  Hero: Hero,
  Mine: Mine,
  Wall: Wall,
}

game = {
   "game":{
      "id":"s2xh3aig",
      "turn":1100,
      "maxTurns":1200,
      "heroes":[
         {
            "id":1,
            "name":"vjousse",
            "userId":"j07ws669",
            "elo":1200,
            "pos":{
               "x":5,
               "y":6
            },
            "life":60,
            "gold":0,
            "mineCount":0,
            "spawnPos":{
               "x":5,
               "y":6
            },
            "crashed":true
         },
         {
            "id":2,
            "name":"vjousse",
            "userId":"j07ws669",
            "elo":1200,
            "pos":{
               "x":12,
               "y":6
            },
            "life":100,
            "gold":0,
            "mineCount":0,
            "spawnPos":{
               "x":12,
               "y":6
            },
            "crashed":true
         },
         {
            "id":3,
            "name":"vjousse",
            "userId":"j07ws669",
            "elo":1200,
            "pos":{
               "x":12,
               "y":11
            },
            "life":80,
            "gold":0,
            "mineCount":0,
            "spawnPos":{
               "x":12,
               "y":11
            },
            "crashed":true
         },
         {
            "id":4,
            "name":"vjousse",
            "userId":"j07ws669",
            "elo":1200,
            "pos":{
               "x":4,
               "y":8
            },
            "lastDir": "South",
            "life":38,
            "gold":1078,
            "mineCount":6,
            "spawnPos":{
               "x":5,
               "y":11
            },
            "crashed":false
         }
      ],
      "board":{
         "size":18,
         "tiles":"##############        ############################        ##############################    ##############################$4    $4############################  @4    ########################  @1##    ##    ####################  []        []  ##################        ####        ####################  $4####$4  ########################  $4####$4  ####################        ####        ##################  []        []  ####################  @2##    ##@3  ########################        ############################$-    $-##############################    ##############################        ############################        ##############"
      },
      "finished":true
   },
   "hero":{
      "id":4,
      "name":"vjousse",
      "userId":"j07ws669",
      "elo":1200,
      "pos":{
         "x":4,
         "y":8
      },
      "lastDir": "South",
      "life":38,
      "gold":1078,
      "mineCount":6,
      "spawnPos":{
         "x":5,
         "y":11
      },
      "crashed":false
   },
   "token":"lte0",
   "viewUrl":"http://localhost:9000/s2xh3aig",
   "playUrl":"http://localhost:9000/api/s2xh3aig/lte0/play"
}

AStar = require './ia/astar'

game = new Game game.game

console.log game
console.log game.board.toString()

astar = new AStar(game.board)
path = astar.find(game.heroes[0].pos, game.heroes[1].pos)

space = "  "
symbol = "++"
grid = []
for x in [0...game.board.size] by 1
  grid[x] = []
  for y in [0...game.board.size] by 1
    grid[x][y] = space

for pos in path
  grid[pos.y][pos.x] = symbol

for line in grid
  console.log(line.join '')