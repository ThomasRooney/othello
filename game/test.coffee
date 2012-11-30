Othello = require './othello'

log = console.log

tests = []
addTest = (name, test) ->
  tests.push [name, test]

addTest "Testing empty board size 2", ->
  game = new Othello 2
  game.printBoard() == """0 0
                          0 0"""

addTest "Testing empty board size 4", ->
  game = new Othello 4
  game.printBoard() == """0 0 0 0
                          0 0 0 0
                          0 0 0 0
                          0 0 0 0"""

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

addTest "Testing default board size 2", ->
  game = new Othello 2
  game.initialState()
  game.printBoard() == """1 2
                          2 1"""

addTest "Testing default board size 4", ->
  game = new Othello 4
  game.initialState()
  game.printBoard() == """0 0 0 0
                          0 1 2 0
                          0 2 1 0
                          0 0 0 0"""

addTest "Testing default board size 8", ->
  game = new Othello 8
  game.initialState()
  game.printBoard() == """0 0 0 0 0 0 0 0
                          0 0 0 0 0 0 0 0
                          0 0 0 0 0 0 0 0
                          0 0 0 1 2 0 0 0
                          0 0 0 2 1 0 0 0
                          0 0 0 0 0 0 0 0
                          0 0 0 0 0 0 0 0
                          0 0 0 0 0 0 0 0"""


for [name, test] in tests
  if !test()
    console.log name + " failed"