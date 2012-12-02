
#
# Module dependencies.
#


express    = require('express')
store      = require('./routes/store')
user       = require('./routes/user')
http       = require('http')
path       = require('path')
util       = require('./apputil')

app = express()

app.configure ->
  app.set('port', process.env.PORT || 3000)
  app.set('views', __dirname + '/views')
  app.set('view engine', 'jade')
  app.use(express.favicon())
  app.use(express.logger('dev'))
  app.use(express.bodyParser())
  app.use(express.methodOverride())
  app.use(app.router)
  app.use(require('stylus').middleware(__dirname + '/public'))
  app.use(express.static(path.join(__dirname, 'public')))

app.configure 'development', ->
  app.use(express.errorHandler())

app.get('/', store.home)
app.get('/users', user.list)

server = http.createServer(app).listen app.get('port'), ->
  console.log("Express server listening on port " + app.get('port'))


io = require('socket.io').listen(server)
players = 
  'tom1': 'Tom Hardy'
  'm6': 'Michal Srb'

hashes = {}
sockets = {}

io.sockets.on 'connection', (socket) ->

  socket.emit 'onlinePlayers', players

  socket.on 'playerJoined', (name, successIs) ->
    [uid, hash] = util.createUID players, name
    if !uid?
      successIs false, "User name too short"
    else
      players[uid] = name
      hashes[uid] = hash
      successIs true, uid: uid, hash: hash
      socket.broadcast.emit 'onlinePlayers', players
      sockets[uid] = socket

  socket.on 'challenging', (from, hash, against, successIs) ->
    if hashes[from] isnt hash
      successIs false, "Authentication failed"
    else if !sockets[against]?
      successIs false, "Openent isnt online"
    else
      sockets[against].emit 'challenged', players[from], (accepted) ->
        if accepted
          successIs true
        else
          successIs false, "Challenge rejected"