Othello = require './Othello'
Board = require './Board'
Players = require './Players'

module.exports = class TraditionalOthello extends Othello
  constructor: ->
    super new Board(8, 8), new Players(2, 1)
    @board.set [3, 3], 0
    @board.set [4, 3], 1
    @board.set [3, 4], 1
    @board.set [4, 4], 0