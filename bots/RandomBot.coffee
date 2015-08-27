RawBot = require './RawBot'
class RandomBot extends RawBot
  start: () ->
  move: (callback) -> 
    movements = ['Stay', 'North', 'West', 'East', 'South']
    action = movements[Math.floor Math.random() * movements.length]
    callback action
  end: () ->

module.exports = RandomBot;