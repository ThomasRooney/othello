$ ->
  myId = null
  hash = null

  #
  # Server - client communication
  #

  socket = io.connect 'http://obscure-caverns-8909.herokuapp.com'

  socket.on 'onlinePlayers', (players) ->
    $("#playerList").empty()
    console.log myId
    for player, name of players when player isnt myId
      $("#playerList").append """
        <li class='ui-state-default' data-uid='#{player}'>#{name}</li>"""
      $("#playerList").sortable 'refresh'

  $('#send').click ->
    socket.emit 'playerJoined', $('#input').val(), (success, data) ->
      if success
        console.log "Logged in", data
        myId = data.uid
        hash = data.hash
        $('#form').hide()
        $('#players').show()
        $('#content').show()

  socket.on 'challenged', (uid, byWho, accepted) ->
    console.log 'challenged', byWho
    accepted yes
    launch openTab(uid, byWho), uid

  socket.on 'update', (opponent, model) ->
    canvas = tabs.find("div[data-uid='#{opponent}'] .gameBoard")
    console.log "canvas", canvas
    updateBoard canvas, model

  #
  # UI reactions
  #

  $("#dropTo").droppable drop: (event, ui) ->
    ui.draggable.remove()
    uid = ui.draggable.data('uid')
    playerName = ui.draggable.text()

    challenge openTab(uid, playerName), uid

  challenge = (tab, player) ->
    tab.append "<h3>Challenging...</h3>"
    socket.emit 'challenging', myId, hash, player, (accepted) ->
      if accepted
        launch tab, player

  openTab = (uid, playerName) ->
    $("#playerList li[data-uid=#{uid}]").remove()
    tabId = "tabs-" + tabCounter
    li = """<li>
              <a href='##{tabId}'>#{playerName}</a>
            </li>"""

    tabs.find(".ui-tabs-nav").append li
    tabs.append """<div id='#{tabId}'
                        data-uid='#{uid}'
                        data-opponent='#{playerName}'></div>"""
    tabs.tabs 'refresh'
    tabs.tabs 'option', 'active', -1
    tabCounter++
    return $("##{tabId}")


  launch = (tab, uid) ->
    tab.empty()
    tab.append "<h3 class='whitePlayer'>Me</h3>"
    tab.append "<h3 class='blackPlayer'>#{tab.data 'opponent'}</h3>"
    tab.append "<canvas class='gameBoard' width='600' height='400' />"
    console.log "drawcanvas", tab.find(".gameBoard")
    drawBoard tab.find(".gameBoard"), uid

  #
  # Game drawing
  #

  class Board
    constructor: (@center, @tileSize, dimensions) ->
      @offset = tileSize.multiply(dimensions).divide 2
      @group = new Group
      for y in [0...dimensions.height]
        for x in [0...dimensions.width]
          at = center.add(new Point(x, y).multiply(@tileSize).subtract(@offset))
          path = new Path.Rectangle at, @tileSize
          @group.addChild path
      @stones = []

    setStyle: (style) ->
      @group.style = style

    rotateTo: (q, r) ->
      @group.rotate q, @center
      @group.scale 1, (180 - r) / 180, @center
      for stone in @stones
        stone.rotateTo q, r
        stone.moveTo stone.position.rotate(q, @center).scale 1, (180 - r) / 180, @center

    addStone: (stone) ->
      @stones.push stone

    place: (stone, pos) ->
      stone.moveTo (pos.multiply @tileSize).add(@center).subtract(@offset).add @tileSize.divide 2

    newStone: (type, x, y) ->
      stone =  new type
      @addStone stone
      @place stone, new Point x, y

  class Stone
    constructor: (tileSize, @height) ->
      center = new Point(tileSize.divide 2)
      offset = center.negate()
      @group = new Group
      @position = new Point 0, 0
      @top = new Path.Oval new Rectangle new Point(0, -height).add(offset), tileSize
      @middle = new Path.Rectangle new Point(0, center.y - height).add(offset), new Size(tileSize.width, height)
      @bottom = new Path.Oval new Rectangle offset, tileSize
      @group.addChildren [@bottom, @middle, @top]

    moveTo: (pos) ->
      @group.translate pos.subtract @position
      @position = pos

    rotateTo: (q, r) ->
      @top.scale 1, (180 - r) / 180
      @top.setPosition new Point(0, -@height * r / 180).add @position
      @middle.scale 1, r / 180, @position
      @bottom.scale 1, (180 - r) / 180

    setStyle: (top, bottom) ->
      @bottom.fillColor = @middle.fillColor = bottom
      @top.fillColor = top

  class WhiteStone extends Stone
    constructor: ->
      super new Size(45, 45), 20
      @setStyle '#f60', '#f40'

  class BlackStone extends Stone
    constructor: ->
      super new Size(45, 45), 20
      @setStyle '#07f', '#06f'

  prepareBoard = (canvas) ->
    paper.setup canvas.get(0)
    console.log new Point(canvas.width(), canvas.height()).divide(2)
    board = new Board new Point(canvas.width(), canvas.height()).divide(2), 
                      new Size(50, 50), new Size(8, 8)
    board.setStyle
      fillColor:  '#ddd'
      strokeColor:  '#aaa'
      strokeWidth:  1

    return board

  attachTools = (uid) ->
    tool = new Tool
    tool.onMouseOver = (event) ->
      console.log uid

  drawBoard = (canvas, uid) ->
    board = prepareBoard canvas
    attachTools uid
    board.rotateTo 50, 70
    view.draw()

  PlayerStones = [WhiteStone, BlackStone]

  updateBoard = (canvas, model) ->
    board = prepareBoard canvas
    for {x, y, player} in model.board
      console.log player, PlayerStones[player]
      board.newStone PlayerStones[player], x, y
    board.rotateTo 50, 70
    view.draw()

    #view.setOnFrame ->

  #
  # UI initialization
  #

  $("#playerList").sortable()
  tabCounter = 1
  tabs = $('#tabs')
  tabs.tabs()
  paper.install(window)