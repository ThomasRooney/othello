module.exports = class Othello
  EMPTY = 0
  WHITE = 1
  BLACK = 2

  constructor: (@size) ->
    if @size % 2 != 0 or @size < 2
      throw "Invalid size, size must be even and at least 2"
    @createBoard()

  createBoard: ->
    @board = new Array @size
    for _, x in @board
      @board[x] = column = new Array @size
      for _, y in column
        column[y] = EMPTY

  initialState: ->
    middle = @size / 2
    @board[middle - 1][middle - 1] = WHITE
    @board[middle][middle] = WHITE
    @board[middle - 1][middle] = WHITE
    @board[middle - 1][middle - 1] = WHITE

  printBoard: ->
    (column.join(" ") for column in @board).join "\n"

