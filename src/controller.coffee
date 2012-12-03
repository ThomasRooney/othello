# Model classes
OthelloFactory = require './model/game/OthelloFactory'
OthelloSerializer  = require './model/game/OthelloSerializer'

module.exports = (server) ->

  # Attach to a server
  io = require('socket.io').listen(server)

  # Local storage
  players = {} # uid: full name
  sockets = {} # uid: socket

  # Client connected
  io.sockets.on 'connection', (socket) ->

    # Sent list of online players
    socket.emit 'onlinePlayers', players

    # Registering a new player
    uid = null
    socket.on 'playerJoined', (name, successIs) ->
      uid = createUID name
      if !uid?
        successIs false, "User name too short"
      else
        players[uid] = name
        successIs true, uid
        socket.broadcast.emit 'onlinePlayers', players
        sockets[uid] = socket

    # Player disconnected
    socket.on 'disconnect', ->
      delete players[uid]
      socket.broadcast.emit 'onlinePlayers', players

    # Player challenged another
    socket.on 'challenging', (against, successIs) ->
      if !sockets[against]?
        successIs false, "Opponent isn't online"
      else
        sockets[against].emit 'challenged', uid, players[uid], (accepted) ->
          if accepted
            successIs true
            launchGame [[uid, against], [against, uid]]
          else
            successIs false, "Challenge rejected"

  launchGame = (gamePlayers) ->
    game = OthelloFactory.traditional()
    gameModel = new OthelloSerializer game

    update gamePlayers, gameModel

    for [player, opponent], i in gamePlayers
      socket = sockets[player]
      do (i) ->
        socket.on "makeMove #{opponent}", ({x, y}) ->
          console.log player, opponent, game
          if game.isNextPlayer i
            game.makeMove x, y, ->
              if not game.isFinished() and not game.canPlay()
                game.skipMove()
              update gamePlayers, gameModel
            , ->
              console.log "invalid move"

  update = (gamePlayers, gameModel) ->
    for [player, opponent], i in gamePlayers
      socket = sockets[player]
      socket.emit 'update', i, opponent, gameModel.serialize()
    return

  createUID = (name) ->
    uid = name.toLowerCase().replace /\s/g, ''

    if uid.length < 2
      return undefined

    i = 1
    while players[uid]?
      uid = uid[0..-2] + i
      i++

    return uid