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