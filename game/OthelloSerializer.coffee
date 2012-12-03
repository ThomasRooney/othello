module.exports = class OthelloSerializer
  constructor: (@othello) ->

  serialize: ->
    currentPlayer: @othello.getNextPlayer()
    board:
      @_serializeBoard()
    validMoves:
      @_serializeValidMoves()
    score:
      @othello.getScore()
    finished:
      @othello.isFinished()

  _serializeBoard: ->
    @othello.getBoard().iterate ([x, y], player) ->
      x: x, y: y, player: player

  _serializeValidMoves: ->
    x: x, y: y for [x, y] in @othello.getValidMoves()