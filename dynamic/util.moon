export lg = love.graphics
export vec2 = require "vector2"
o_tiles = require "tiles"

Array2D   = require "Array2D"

local util

util = {
  round: (x) -> math.floor(x+0.5)

  draw_tile: (tile_name, x, y, color) ->
    lg.setColor color\love_unpack!
    lg.draw o_tiles.img, o_tiles[tile_name], util.round(x*TILE_SIZE), util.round(y*TILE_SIZE)

  draw_tile_depth: (tile_name, x, y, cx, cy, depth, color) ->
    xx = x + (cx-x) * depth
    yy = y + (cy-y) * depth
    lg.setColor color\love_unpack!
    lg.draw o_tiles.img, o_tiles[tile_name], util.round(xx*TILE_SIZE), util.round(yy*TILE_SIZE)

  load_sample: (image_name) ->
    img = lg.newImage(image_name)
    imgdata = img\getData!
    sample = Array2D(img\getDimensions!)

    for x=0,sample.width-1
      for y=0,sample.height-1
        r,g,b,a = imgdata\getPixel x, y
        if r == 0  -- black
          sample\set x, y, 0
        else  -- white
          sample\set x, y, 1
    sample

  with_color: (color, f) ->
    r,g,b,a = lg.getColor!
    if color.love_table == nil
      lg.setColor color
    else
      lg.setColor color\love_unpack!
    f!
    lg.setColor r,g,b,a

  unit_rect: (x, y, color) ->
    lg.setColor color\love_unpack!
    lg.rectangle 'fill', x, y, 1, 1

  rect: (x, y, width, height, color) ->
    lg.setColor color\love_unpack!
    lg.rectangle 'fill', x, y, width, height

  collide_HC: (pworld, shape) ->
    for i=0,3
      collisions = pworld\collisions(shape)
      totalx, totaly = 0, 0
      for other, separating_vector in pairs collisions
        totalx += separating_vector.x
        totaly += separating_vector.y
      shape\move(totalx, totaly)

  move: (pworld, shape, dx, dy) ->
    x, y = pworld\getRect shape
    pworld\move shape, dx+x, dy+y, -> 'bypass'

  add_op: (op_name, op_valid, op_process) =>
    @addOp op_name
    if op_valid ~= nil
      @addValidateOnServer op_valid
    @addProcessOnServer op_process
    return

  todir: {
    [0]: vec2  1,  0
    [1]: vec2  1,  1
    [2]: vec2  0,  1
    [3]: vec2 -1,  1
    [4]: vec2 -1,  0
    [5]: vec2 -1, -1
    [6]: vec2  0, -1
    [7]: vec2  1, -1
  }

  fromdir: (v) ->
    x, y = v\unpack!

    if x < 0
      if y < 0
        return 5
      if y == 0
        return 4
      if y > 0
        return 3

    if x == 0
      if y < 0
        return 6
      if y == 0
        return 'zero'
      if y > 0
        return 2

    if x > 0
      if y < 0
        return 7
      if y == 0
        return 0
      if y > 0
        return 1

}

util