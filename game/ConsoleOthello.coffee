TraditionalOthello = require './TraditionalOthello'
program = require 'commander'

class ConsoleOthello
  constructor: ->
    @game = new TraditionalOthello
    @players = [
      name: "Michal"
      stone: "w"
    ,
      name: "Tom"
      stone: "b"
    ]
    @game.board._fromPrint """0 0 0 0 0 0 0 1
                              0 0 0 0 0 0 0 1
                              0 0 0 0 0 0 0 1
                              0 0 0 0 0 0 0 1
                              0 0 0 0 0 0 0 1
                              0 0 0 0 0 0 1 -1
                              0 0 0 0 0 0 0 1
                              0 0 0 0 0 0 0 1"""

  nextTurn: ->
    if not @gameFinished()
      @printBoard()
      if @game.canPlay()
        @askForMove()
      else
        @skipPlayer()

  skipPlayer: ->
    console.log "#{@players[@game.getNextPlayer()].name} " + 
                "doesn't have any valid moves to make."
    @game.skipMove()
    @nextTurn()

  askForMove: ->
    player = @players[@game.getNextPlayer()]
    console.log "#{player.name}(#{player.stone}), " +
                   " where would you like to place next stone?"
    program.prompt "X:  ", Number, (x) =>
      program.prompt "Y:  ", Number, (y) =>
        @game.makeMove x, y, (=> @nextTurn()), =>
          console.log "You can't place your stone there!"
          @askForMove()

  gameFinished: ->
    if @game.isFinished()
      @printBoard()
      console.log "Game has ended, final scores:"
      score = @game.getScore()
      for i, {name} of @players
        console.log "#{name}: #{score[i]}"
      process.exit()
    false

  printBoard: ->
    board = @game.getBoard()
    columnNumbers = board.iterateColumns (x) ->
      x
    rows = board.iterateRows (y) =>
      row = board.iterateColumns (x) =>
        player = board.get [x, y]
        {stone} = @players[player] ? {}
        stone ? "_"
      "#{y} #{row.join " "}"
    console.log """  #{columnNumbers.join " "}
                   #{rows.join "\n"}"""

game = new ConsoleOthello
game.nextTurn()