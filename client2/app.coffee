
#
# Module dependencies.
#


express    = require('express')
store      = require('./routes/store')
user       = require('./routes/user')
http       = require('http')
path       = require('path')

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

io             = require('socket.io').listen(server)

io.sockets.on 'connection', (socket) ->
  socket.emit 'news', hello: 'world'
  socket.on 'my other event', (data) ->
    console.log data

  socket.on 'message event', (from, msg) ->
    console.log "I received a private message by #{from} saying #{msg}"
