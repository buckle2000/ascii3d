lovernet = require 'lovernet'

NETWORK_PROTOCOL_VERSION = 0
local lnet

add_op = util.add_op

new_server = ->
  lnet = lovernet.new{type:lovernet.mode.server}
  storage = lnet\getStorage!
  storage.active_players = {}

  add_op lnet,
    'connect',
    {name: 'string', version: 'number'},
    (peer,arg,storage) =>
      if version ~= NETWORK_PROTOCOL_VERSION
        peer\disconnect!
        return false
      user = @getUser(peer)
      user.name = arg.name
      storage.active_players[user] = true
      return true

  add_op lnet,
    'disconnect',
    nil,
    (peer,arg,storage) =>
      user = @getUser(peer)
      storage.active_players[user] = nil
      return

  lnet._removeUser = (peer) =>
    user = @getUser(peer)
    storage = @getStorage!
    storage.active_players[user] = nil
    lovernet._removeUser @, peer
    return

  add_op lnet,
    'move',
    {x: 'number', y: 'number'},
    (peer,arg,storage) =>
      user = @getUser(peer)
      user.x, user.y = arg.x, arg.y
      return

  add_op lnet,
    'query',
    nil,
    (peer,arg,storage) =>
      user = @getUser(peer)
      info = {}
      for u, _ in pairs storage
        table.insert info, u
      info

  lnet

new_server
