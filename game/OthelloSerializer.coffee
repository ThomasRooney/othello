module.exports = class OthelloSerializer
  constructor: (@othello) ->
    console.log "serialize", @othello

  serialize: ->
    currentPlayer: @othello.getNextPlayer()
    board:
      _serializeBoard()
    validMoves:
      _serializeValidMoves()
    score:
      _serializeScore()
    finished:
      @othello.isFinished()

  _serializeBoard = ->
    @othello.getBoard().iterate (x, y, player) ->
      x: x, y: y, player: player

  _serializeValidMoves = ->
    x: x, y: y for [x, y] in @othello.getValidMoves()

  _serializeScore = ->
    i: score for score, i in @othello.getScore()