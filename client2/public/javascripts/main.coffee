$ ->
  socket = io.connect 'http://localhost:3000'
  socket.on 'news', (data) ->
    console.log data
    socket.emit 'my other event', my: 'data'

  $('#send').click ->
    console.log $('#input').val()
    socket.emit 'message event', "Michal", $('#input').val()

  paper.install(window)

  canvas = $('#gameBoard')
  size = new Size canvas.width(), canvas.height()

  Tetragon =
    create: (@center, @size) ->
      @path = new Path.Rectangle center.subtract(size.divide(2)), size
      @points = for segment in @path.segments
        segment.point.clone()
      return @path

    rotateTo: (q, r) ->
      for segment, i in @path.segments
        fromCenter = (@points[i].rotate q, @center).subtract @center
        {x, y} = (fromCenter.multiply new Point 1, (180 - r) / 180).add @center
        console.log x, y
        segment.point.set x, y

  paper.setup canvas.get(0)
  for y in [1..8]
    for x in [1..8]
      path = Tetragon.create new Point(x * 50, y * 50), new Size(50, 50)
      path.fillColor = '#ddd'
      path.strokeColor = 'black'
      path.strokeWidth = 1
      Tetragon.rotateTo 0, 0
      view.draw()
