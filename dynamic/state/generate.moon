GS        = require "gamestate"
Generator = require "convchain.generator"
Array2D   = require "Array2D"
util      = require "util"
o_tiles   = require "tiles"

local gen
receptorSize = 3
temperature = 0.3
sample = util.load_sample "sample/city-cave.png"

state = {}

state.enter = =>
  love.keyboard.setKeyRepeat true
  gen = Generator sample, receptorSize, temperature, 64,64

state.leave = =>
  love.keyboard.setKeyRepeat false

purge = (field) ->
  -- TODO ensure connectivity

state.keypressed = (key) =>
  switch key
    when 'i'
      gen\iterate!
    when 's'
      gen\iterateRandom!
    when 'r'
      gen\randomizeField!
    when 'p'
      purge gen.field
    when 'return'
      GS.switch require"state.play", gen.field

state.draw = =>
  for x=0,gen.width-1
    for y=0,gen.height-1
      thing = gen.field\get x,y
      if thing == 1
        lg.rectangle 'fill', x * 8, y * 8, 8,8
  lg.draw o_tiles.img, 16+1024, 16
  for i=1,o_tiles.atlas.n
    lg.draw o_tiles.img, o_tiles.atlas[i], i*16+1024, 0 

state