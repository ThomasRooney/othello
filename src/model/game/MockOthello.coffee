Board = require './Board'

module.exports = class MockOthello
  constructor: ->
    @turnsLeft = 0
    @board = new Board 8, 8
    @nextPlayer = 0

  getNextPlayer: ->
    @nextPlayer

  getBoard: ->
    @board

  isFinished: ->
    @turnsLeft <= 0

  getScore: ->
    [
      2 + Math.floor Math.random() * 63
      2 + Math.floor Math.random() * 63
    ]

  makeMove: (x, y, valid, invalid) ->
    if x in [0...8] and y in [0...8]
      @nextPlayer = Math.abs 1 - @nextPlayer
      @turnsLeft--
      valid()
    else
      invalid()


#  constructor: ->
#    middle = @board.size / 2
#    @board.set [middle - 1, middle - 1] = Board.WHITE
#    @board.set [middle,     middle]     = Board.WHITE
#    @board.set [middle - 1, middle]     = Board.BLACK
#    @board.set [middle,     middle - 1] = Board.BLACK
#    @nextPlayer = Board.BLACK