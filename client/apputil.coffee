exports.createUID = (players, name) ->
  uid = name.toLowerCase().replace /\s/g, ''

  if uid.length < 2
    return undefined

  i = 1
  while players[uid]?
    uid = uid[0..-2] + i
    i++

  return uid