#
# Main game logic class with following responsibilities:
#
#  keep track of which player's turn it is'
#    + nextPlayer
#  keep track of state of the board
#    + getBoard
#  decide on validity of moves
#    + getValidMoves
#    + isValidMove
#  keep track of state of the game
#    + getScore
#    + isFinished
#  change state of the game
#    + constructor
#    + skipMove
#    + makeMove
#
module.exports = class Othello
  constructor: (@board, @players) ->

  getNextPlayer: ->
    @players.player()

  isNextPlayer: (player) ->
    @players.player() is player

  isFinished: ->
    someoneCanPlay = false
    @players.iterate (player) =>
      someoneCanPlay = someoneCanPlay or @canPlay(player)
    return not someoneCanPlay

  canPlay: (player) ->
    @getValidMoves(player).length > 0

  getBoard: ->
    @board

  getScore: ->
    scores = new Array @players.getCount()
    for _, player in scores
      scores[player] = 0
    @board.iterate ([x, y], player) ->
      scores[player]++
    return scores

  skipMove: ->
    @players.nextPlayer()

  makeMove: (x, y, valid, invalid) ->
    if (toFlip = @_stonesToFlip [x, y]).length > 0
      @_flip toFlip
      @players.nextPlayer()
      valid?()
    else
      invalid?()

  getValidMoves: (player)->
    @board.iterateAll (pos) ->
      pos
    , (pos) =>
      @_stonesToFlip(pos, player).length > 0

  _stonesToFlip: (pos, player = @players.player()) ->
    unless @board.isIn(pos) and @board.isEmpty(pos)
      return []
    toBeFlipped = for direction in Othello._directions
      @_moveInDirection direction, player, pos, [pos]
    [].concat toBeFlipped...

  _moveInDirection: (direction, player, pos, toFlip) ->
    newPos = @_add pos, direction
    if not @board.isIn(newPos) or @board.isEmpty(newPos)
      []
    else if @board.get(newPos) isnt player
      @_moveInDirection direction, player, newPos, toFlip.concat [newPos]
    else if toFlip.length > 1
      toFlip
    else
      []

  _add: ([x, y], [dx, dy]) ->
    [x + dx, y + dy]

  _flip: (toFlip, player = @players.player()) ->
    for pos in toFlip
      @board.set pos, player
    true

  @_directions = [
    [ 1, 0], [ 1,  1], [0,  1], [-1,  1]
    [-1, 0], [-1, -1], [0, -1], [ 1, -1]
  ]