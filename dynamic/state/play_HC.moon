Camera  = require "Camera"
GS      = require "gamestate"
HC      = require "HC"
tactile = require "tactile"
util    = require "util"

local pworld, player, field, camera
local walls
player_radius = 0.3

control = {
  x: tactile.newControl!\addButtonPair(tactile.keys'left', tactile.keys'right')
  y: tactile.newControl!\addButtonPair(tactile.keys'up', tactile.keys'down')
}

state = {}

state.enter = (previous, _field) =>
  field = _field
  pworld = HC.new 4
  camera = Camera.new!
  camera\zoomTo 16
  player_added = false
  walls = {}

  for x=0,field.width-1
    for y=0,field.height-1
      if field\get(x, y) == 0
        -- wall
        table.insert walls, pworld\rectangle x, y, 1, 1
      else
        -- empty space
        if not player_added
          player = pworld\circle x+.5, y+.5, player_radius
          player_added = true

state.draw = =>
  px, py = player\center!
  camera\lookAt px, py
  camera\attach!
  -- for x=0,field.width-1
  --   for y=0,field.height-1
  --     thing = field\get x,y
  --     if thing == 1
  --       love.graphics.rectangle 'fill', x, y, 1, 1
  util.with_color {255,12,53}, ->
    for shape in *walls
      shape\draw 'fill'
  util.with_color {255,255,256}, ->
    love.graphics.circle 'fill', px, py, player_radius
  camera\detach!

state.update = (dt) =>
  control.x\update!
  control.y\update!
  dt *= 10
  player\move control.x\getValue!*dt, control.y\getValue!*dt
  util.collide_HC pworld, player
      -- other\move( separating_vector.x/2,  separating_vector.y/2)
  -- TODO player move

state.keypressed = (key) =>
  switch key
    when 'escape'
      GS.switch require"state.generate", gen.field

state