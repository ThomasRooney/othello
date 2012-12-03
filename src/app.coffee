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
  app.set('port', process.env.PORT)
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

require('./controller')(server)