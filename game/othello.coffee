module.exports = class Othello
  OUTSIDE = -1
  EMPTY = 0
  WHITE = 1
  BLACK = 2

  DIRECTIONS = [
    [1, 0]
    [1, 1]
    [0, 1]
    [-1, 1]
    [-1, 0]
    [-1, -1]
    [0, -1]
  ]

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
    @board[middle][middle]         = WHITE
    @board[middle - 1][middle]     = BLACK
    @board[middle][middle - 1]     = BLACK
    @nextPlayer = BLACK

  setState: (@nextPlayer, @board) ->

  makeMove: (player, [x, y]) ->
    unless @isEmpty x, y
      return false
    unless @isNextPlayer player
      return false
    for direction in DIRECTIONS
      makeMoveInDirection direction, player, x, y, []

  makeMoveInDirection: (direction, player, pos, moves) ->
    newPos = @add pos direction
    cell = boardAt newPos
    if cell is EMPTY or cell is OUTSIDE
      []
    else if cell isnt player
      makeMoveInDirection direction, player, newPos, moves.concat newPos
    else
      moves


  add: ([x, y], [dx, dy]) ->
    [x + dx, y + dy]

  boardAt: ([x, y]) ->
    return OUTSIDE unless (x in [0..@size] and y in [0..@size])
    @board[x][y]

  isEmpty: (x, y) ->
    @board[x][y] == EMPTY

  isNextPlayer: (player) ->
    @nextPlayer == player

  printBoard: ->
    (column.join(" ") for column in @board).join "\n"

