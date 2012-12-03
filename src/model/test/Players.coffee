Players = require '../game/Players'

describe "A Players class", ->

  it "getCount should return set number of players", ->
    expect(new Players(3, 0).getCount()).toBe 3

  it "nextPlayer should iterate through players", ->
    players = new Players 3, 1
    expect(players.nextPlayer()).toBe 2
    expect(players.nextPlayer()).toBe 0
    expect(players.nextPlayer()).toBe 1
