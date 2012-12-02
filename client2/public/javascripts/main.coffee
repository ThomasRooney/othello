$ ->
  myId = null
  hash = null

  socket = io.connect 'http://localhost:3000'

  socket.on 'onlinePlayers', (data) ->
    $("#playerList").empty()
    console.log myId
    for player, name of data when player isnt myId
      $("#playerList").append """<li class='ui-state-default' data-uid='#{player}'>
                                    #{name}
                                  </li>"""
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

  socket.on 'challenged', (byWho, accepted) ->
    console.log 'challenged', byWho
    prompt = $("#challengePrompt")
    prompt.dialog "option", "title", byWho
    prompt.dialog "option", "buttons", "Accept": ->
        accepted yes
        prompt.dialog("close")
      "Decline": ->
        accepted no
        prompt.dialog("close")
    prompt.dialog("open")


  $("#playerList").sortable()

  console.log $("#challengePrompt")
  $("#challengePrompt").dialog
    autoOpen: false
    modal: true
    buttons: {
        "Ok": function() {
            var text1 = $("#txt1");
            var text2 = $("#txt2");
            //Do your code here
            text1.val(text2.val().substr(1,9));
            $(this).dialog("close");
        },
        "Cancel": function() {
            $(this).dialog("close");
        }
    }
  #$("#challengePrompt").dialog("open")

  tabCounter = 1
  tabs = $('#tabs')
  tabs.tabs()
  $("#dropTo").droppable drop: (event, ui) ->
    ui.draggable.remove()
    uid = ui.draggable.data('uid')
    playerName = ui.draggable.text()

    id = "tabs-" + tabCounter
    li = """<li>
              <a href='##{id}'>#{playerName}</a>
            </li>"""

    tabs.find(".ui-tabs-nav").append li
    tabs.append "<div id='#{id}'></div>"
    tabs.tabs 'refresh'
    tabs.tabs 'option', 'active', -1
    tabCounter++

    challenge $("##{id}"), uid
    #drawBoard $("##{id} .gameBoard")

  challenge = (tab, player) ->
    tab.html "<h3>Challenging...</h3>"
    socket.emit 'challenging', myId, hash, player, (accepted) ->
      if accepted
        tab.html """<canvas class='gameBoard' width='600' height='600' />"""

  paper.install(window)

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

  drawBoard = (canvas) ->
    paper.setup canvas.get(0)
    board = new Board new Point(300, 300), new Size(50, 50), new Size(8, 8)
    board.setStyle
      fillColor:  '#ddd'
      strokeColor:  '#aaa'
      strokeWidth:  1
    board.newStone WhiteStone, 3, 3
    board.newStone BlackStone, 3, 4
    board.newStone WhiteStone, 4, 4
    board.newStone BlackStone, 4, 3
    board.rotateTo 50, 70
    view.draw()

    #view.setOnFrame ->
