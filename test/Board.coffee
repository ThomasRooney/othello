Board = require '../game/Board'

describe "A playing Board of some size", ->

  it "should start empty", ->
    board = new Board(2, 2)._printBoard()
    expect(board).toBe """-1 -1
                          -1 -1"""
  it "should have first argument as width", ->
    board = new Board(4, 1)._printBoard()
    expect(board).toBe """-1 -1 -1 -1"""

  describe "accessors of a Board", ->

    board = null

    beforeEach ->
      board = new Board 4, 4

    it "isIn should check for boundaries", ->
      expect(board.isIn [0, 0]).toBe true
      expect(board.isIn [3, 3]).toBe true
      expect(board.isIn [-1, 0]).toBe false
      expect(board.isIn [0, -1]).toBe false
      expect(board.isIn [-1, -1]).toBe false
      expect(board.isIn [4, 1]).toBe false
      expect(board.isIn [4, 4]).toBe false
      expect(board.isIn [1, 4]).toBe false
      expect(board.isIn [-220, -34]).toBe false
      expect(board.isIn [20, 34]).toBe false

    it "isEmpty should return true for empty fields", ->
      expect(board.isEmpty [1, 1]).toBe true
      board.set [2, 2], 1
      expect(board.isEmpty [2, 2]).toBe false

    it "set should set a player in a field", ->
      board.set [1, 1], 1
      expect(board.get [1, 1]).toBe 1

  describe "iterators of a Board", ->

    board = null

    beforeEach ->
      board = new Board 3, 2

    it "iterateRows should return row indices", ->
      indices = (board.iterateRows (y) -> y).join " "
      expect(indices).toBe "0 1"

    it "iterateColumns should return column indices", ->
      indices = (board.iterateColumns (x) -> x).join " "
      expect(indices).toBe "0 1 2"

    it "iterate should call only on nonempty", ->
      stones = board.iterate ([x, y], player) -> player
      expect(stones).toEqual []

    it "iterateAll should call all fields", ->
      stones = board.iterateAll ([x, y], player) -> 1
      expect(stones).toEqual [1, 1, 1, 1, 1, 1]

    it "iterate should collect all results", ->
      board.set [1, 0], 1
      board.set [1, 1], 2
      sums = board.iterate ([x, y], player) -> [x, y, player]
      expect(sums).toContain [1, 0, 1]
      expect(sums).toContain [1, 1, 2]

    it "_printBoard and _fromPrint shold work together", ->
      board.set [1, 0], 1
      text = board._printBoard()
      board._fromPrint text
      expect(board._printBoard()).toEqual text
