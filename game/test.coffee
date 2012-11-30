Othello = require './othello'

log = console.log

tests = []
addTest = (name, test) ->
  tests.push [name, test]

addTest "Testing empty board size 2", ->
  game = new Othello 2
  game.printBoard() == """0 0
                          0 0"""

addTest "Testing empty board size 8", ->
  game = new Othello 8
  game.printBoard() == """0 0 0 0 0 0 0 0
                          0 0 0 0 0 0 0 0
                          0 0 0 0 0 0 0 0
                          0 0 0 0 0 0 0 0
                          0 0 0 0 0 0 0 0
                          0 0 0 0 0 0 0 0
                          0 0 0 0 0 0 0 0
                          0 0 0 0 0 0 0 0"""

for [name, test] in tests
  if !test()
    console.log name + " failed"