Othello = require './Othello'
Board = require './Board'
Players = require './Players'

centerSquare = (board) ->
  x = board.width / 2 - 1
  y = board.height / 2 - 1
  board.set [x,     y    ], 0
  board.set [x + 1, y    ], 1
  board.set [x,     y + 1], 1
  board.set [x + 1, y + 1], 0

module.exports =
  traditional: ->
    o = new Othello new Board(8, 8), new Players(2, 1)
    centerSquare o.board
    o

  smallTraditional: ->
    o = new Othello new Board(4, 4), new Players(2, 1)
    centerSquare o.board
    o
