crypto = require('crypto')

exports.createUID = (players, name) ->
  uid = name.toLowerCase().replace /\s/g, ''

  if uid.length < 2
    return undefined

  i = 1
  while players[uid]?
    uid = uid[0..-2] + i
    i++

  current_date = (new Date()).valueOf().toString()
  random = Math.random().toString()
  hash = crypto.createHash('sha1').update(current_date + random).digest('hex')

  return [uid, hash]