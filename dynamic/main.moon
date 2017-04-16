GS = require "gamestate"
require "poc"

export DEBUG = false
export TILE_SIZE = 16
  
love.load = ->
  GS.registerEvents!
  GS.switch require"state.generate"

love.update = (dt) ->
  export TIME_NOW = love.timer.getTime!

love.keypressed = (key) ->
  if key == '`'
    DEBUG = not DEBUG