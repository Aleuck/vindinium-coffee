directions = {
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
    @generate game
    @update game
  turn: 0
  maxTurns: 0
  finished: false
  update: (gameSrc) ->
    tiles = gameSrc.board.tiles
    for mine in @mines
      objStr = tiles.substr (2 * mine.pos.x + 2 * @board.size * mine.pos.y), 2
      holder = parseInt(objStr[1])
      holder = 0 if isNaN(holder)
      mine.holder = holder;
    for hero in @heroes
      @board.tiles[hero.pos.x][hero.pos.y] = @empty
    for heroSrc in gameSrc.heroes
      idx = heroSrc.id - 1
      hero = @heroes[idx]
      hero.update(heroSrc)
      @board.tiles[hero.pos.x][hero.pos.y] = hero
      @board.tiles[hero.spawnPos.x][hero.spawnPos.y].spawnPoint = true;
  generate: (gameSrc) ->
    tiles = gameSrc.board.tiles
    #@heroes = new Hero(hero) for hero in gameSrc.heroes
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
            mine = new Mine(x, y, 0)
            @board.tiles[x][y] = mine
            @mines.push mine
          when '@'
            heroIdx = parseInt(objStr[1]) - 1
            hero = new Hero(gameSrc.heroes[heroIdx])
            @heroes[heroIdx] = hero
            @board.tiles[x][y] = hero
          when ' '
            @board.tiles[x][y] = Object.create(@empty)
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
  update: (hero) ->
    @elo = hero.elo
    @life = hero.life
    @gold = hero.gold
    @mineCount = hero.mineCount
    @pos = { x: hero.pos.y, y: hero.pos.x }
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
  toString: -> '$'+ (@holder || '-')

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
  directions: directions
}