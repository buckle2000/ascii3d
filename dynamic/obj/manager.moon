Camera  = require "Camera"
GS      = require "gamestate"
bump    = require "bump"
tactile = require "tactile"
util    = require "util"
Array   = require "Array"
Player  = require "obj.player"
Gamemap = require "obj.gamemap"
Color   = require "Color"
Signal = require "Signal"

class GameManager
  new: (...) =>
    @signal = Signal.new!
    @signal\register "ev_player_add", @\ev_player_add
    @signal\register "ev_player_move", @\ev_player_move
    @signal\register "ev_player_remove", @\ev_player_remove

  ev_player_add: (player, x, y, ...) =>

  ev_player_move: (player, x, y) =>

  ev_player_remove: (player) =>

  add_player_local: (control_scheme) =>
    
  add_player_network: (...) =>


local pworld, player, camera, gamemap, field
local walls, players
zoom_level = 16

control1 = {
  x: tactile.newControl!\addButtonPair(tactile.keys('left'), tactile.keys('right'))
  y: tactile.newControl!\addButtonPair(tactile.keys('up'), tactile.keys('down'))
}

control2 = {
  x: tactile.newControl!\addButtonPair(tactile.keys('s'), tactile.keys('f'))
  y: tactile.newControl!\addButtonPair(tactile.keys('e'), tactile.keys('d'))
}

state = {}

state.enter = (previous, _field) =>
  field = _field
  if not love.window.getFullscreen!
    love.window.setMode field.width * zoom_level, field.height * zoom_level
  pworld = bump.newWorld 1
  camera = Camera.new!
  camera\zoomTo zoom_level
  gamemap = Gamemap field.width, field.height
  players = Array!
  empty_spaces = Array!
  
  -- physics: add extra row/column beyond border
  for x=-1,field.width
    for y=-1,field.height
      if field\get(x%field.width, y%field.height) == 0
        -- wall
        pworld\add {}, x, y, 1, 1

  for x=0,field.width-1
    for y=0,field.height-1
      if field\get(x%field.width, y%field.height) == 0
        -- wall
        gamemap\set_terrain x, y, 0
      else
        -- empty space
        gamemap\set_terrain x, y, 1
        empty_spaces\push {x, y}

  p1i = math.random 0, empty_spaces.n-1
  p1i = empty_spaces\remove p1i
  p1 = Player pworld, p1i[1], p1i[2], Color.P1, control1
  players\push p1
  p2i = math.random 0, empty_spaces.n-1
  p2i = empty_spaces\remove p2i
  p2 = Player pworld, p2i[1], p2i[2], Color.P2, control2
  players\push p2

  camera\lookAt p1.x, p1.y

state.update = (dt) =>
  for i, ppppp in players\iter!
    ppppp\update dt
    gamemap\player_move ppppp, dt
    gamemap\update dt, ppppp.cellx, ppppp.celly

state.draw = =>
  camera\attach!
  for xxx=-1,1
    for yyy=-1,1
      lg.push!
      lg.translate xxx*gamemap.width, yyy*gamemap.width
      gamemap\draw!
      for i, ppppp in players\iter!
        ppppp\draw!
      if DEBUG
        for item in *pworld\getItems!
          f,g,h,j = pworld\getRect item
          lg.setLineWidth 0.01
          util.with_color Color.RED, ->
            lg.rectangle 'line', f,g,h,j
        -- for x=
        --   util.with_color Color.GREEN, ->
        --     lg.rectangle 'line', f,g,h,j
      lg.pop!
  camera\detach!
