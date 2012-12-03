class LetterBoard
  constructor: (@board) ->

  iterateRows: (callback) ->
    @board.iterateRows callback

  iterateColumns: (callback) ->
    @board.iterateColumns (x) ->
      callback @toLabel x

  iterate: (callback) ->
    @board.iterate (x, y, player) ->
      callback @toLabel(x), y, player

  get: (x, y) ->
    @board.get fromLabel(x), y

  fromLabel: (x) ->
    x.charCodeAt(0) - ChessBoard.aCode

  toLabel: (x) ->
    ChessBoard.labels[x]

  @aCode = "a".charCodeAt 0
  @labels = for i in [0...26]
    @aCode + i