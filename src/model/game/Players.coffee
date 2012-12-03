#
# Represents a set of players, identified by integers from 0. Provides
# an iterator and keeps track of a one current player.
#
module.exports = class Players
  constructor: (@count, initialPlayer) ->
    @currentPlayer = initialPlayer

  getCount: ->
    @count

  player: ->
    @currentPlayer

  nextPlayer: ->
    @currentPlayer = @_playerAfter @currentPlayer

  _playerAfter: (player) ->
    (player + 1) % @count

  iterate: (callback) ->
    player = firstPlayer = @currentPlayer
    loop
      callback player
      if (player = @_playerAfter player) is firstPlayer
        break