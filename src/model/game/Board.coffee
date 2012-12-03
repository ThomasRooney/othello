#
# Wrapper around the internal representation of a board.
# Provides iterators for accessing values and boundary checking.
#
module.exports = class Board

  constructor: (@width, @height)->
    @board = new Array @height
    for _, y in @board
      @board[y] = row = new Array @width
      for _, x in row
        row[x] = Board._empty

  iterateRows: (callback) ->
    callback y for y in [0...@height]

  iterateColumns: (callback) ->
    callback x for x in [0...@width]

  iterate: (callback) ->
    @iterateAll (pos, player) ->
      callback pos, player
    , (pos, player) =>
      not @isEmpty(pos)

  iterateAll: (callback, cond) ->
    result = []
    for row, y in @board
      for player, x in row
        if not cond? or cond [x, y], player
          result.push callback [x, y], player
    result

  get: ([x, y]) ->
    @board[y][x]

  isEmpty: (pos) ->
    @get(pos) == Board._empty

  isIn: ([x, y]) ->
    x in [0...@width] and y in [0...@height]

  set: ([x, y], player) ->
    @board[y][x] = player

  @_empty = -1

  _printBoard: ->
    (column.join(" ") for column in @board).join "\n"

  _fromPrint: (string) ->
    rows = string.split "\n"
    @iterateRows (y) =>
      row = rows[y].split " "
      @iterateColumns (x) =>
        @set [x, y], +row[x]