Othello = require '../game/Othello'

Board = require '../game/Board'
Players = require '../game/Players'

describe "An Othello game", ->

  othello = null

  beforeEach ->
    othello = new Othello new Board(4, 4), new Players(3, 1)

  it "getNextPlayer should give player on turn", ->
    expect(othello.getNextPlayer()).toBe 1

  it "getScore should return 0 with empty board", ->
    expect(othello.getScore()).toEqual [0, 0, 0]

  it "getValidMoves should return 0 with empty board", ->
    expect(othello.getValidMoves().length).toBe 0

  describe "computation of getValidMoves", ->

    beforeEach ->
      board = othello.board
      board._fromPrint """0 -1 -1 -1
                          -1 1 -1 -1
                          -1 -1 -1 -1
                          -1 -1 -1 -1"""
      othello.players.currentPlayer = 0

    it "_add adds positions together", ->
      expect(othello._add [23, 24], [2, 5]).toEqual [25, 29]

    it "_moveInDirection to add stones to flip", ->
      expect(othello._moveInDirection [-1, -1], 0, [2, 2], [[2, 2]]).toEqual [[2, 2], [1, 1]]

    it "_stonesToFlip should return stones to flip when played", ->
      expect(othello._stonesToFlip [2, 2]).toEqual [[2, 2], [1, 1]]

    it "getValidMoves should return valid moves", ->
      expect(othello.getValidMoves()).toEqual [[2, 2]]

  it "getValidMoves should return valid moves even for more than two players", ->
    board = othello.board
    board._fromPrint """0 1 1 1
                        1 1 1 1
                        1 2 1 1
                        1 -1 1 1"""
    expect(othello.getValidMoves()).toEqual [[1, 3]]

  it "isFinished should true when board is empty", ->
    expect(othello.isFinished()).toBe true

  it "isFinished should false when there are possible moves", ->
    board = othello.board
    board._fromPrint """0 1 1 1
                        1 1 1 1
                        1 2 1 1
                        1 -1 1 1"""
    expect(othello.isFinished()).toBe false

  it "isFinished should be true when board is full", ->
    board = othello.board
    board._fromPrint """0 1 1 1
                        1 1 1 1
                        1 2 1 1
                        1 1 1 1"""
    expect(othello.isFinished()).toBe true

  it "isFinished should be false when other players can play", ->
    board = othello.board
    board._fromPrint """0 1 1 1
                        1 1 1 1
                        -1 1 1 1
                        1 1 1 1"""
    expect(othello.canPlay(0)).toBe true
    expect(othello.isFinished()).toBe false

  describe "computation of makeMove", ->

    beforeEach ->
      othello = new Othello new Board(4, 4), new Players(3, 1)
      board = othello.board
      board._fromPrint """-1 -1 -1 -1
                          -1 1 2 -1
                          -1 2 1 -1
                          -1 -1 -1 -1"""

    it "_flip should flip list of positions", ->
      othello._flip [[2, 0], [2, 1]], 1
      expect(othello.board._printBoard()).toBe """-1 -1 1 -1
                                                  -1 1 1 -1
                                                  -1 2 1 -1
                                                  -1 -1 -1 -1"""



    it "makeMove should update the game state", ->
      othello.makeMove 2, 0
      expect(othello.board._printBoard()).toBe """-1 -1 1 -1
                                                  -1 1 1 -1
                                                  -1 2 1 -1
                                                  -1 -1 -1 -1"""

  it "getScore should return players' score", ->
    board = othello.board
    board._fromPrint """0 1 1 1
                        1 1 1 1
                        1 2 1 1
                        1 -1 1 1"""
    expect(othello.getScore()).toEqual [1, 13, 1]