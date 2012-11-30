$ ->
  socket = io.connect 'http://localhost:3000'
  socket.on 'news', (data) ->
    console.log data
    socket.emit 'my other event', my: 'data'

  $('#send').click ->
    console.log $('#input').val()
    socket.emit 'message event', "Michal", $('#input').val()