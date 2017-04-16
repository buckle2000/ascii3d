Array2d = require "Array2d"
Color = require "Color"
util = require "util"
FOV = require("rotLove").FOV.Precise

class Visit
  LASTING: math.pi
  new: (@player) =>
    @time_init = TIME_NOW
    @color = @player.color\clone!

  -- return grid color
  get_color: =>
    @color.a = (1 - (TIME_NOW - @time_init) / @LASTING) * 0.6
    @color

  done: =>
    return TIME_NOW - @time_init >= @LASTING


TERRAIN = {
  EMPTY: 1
  WALL: 0
}

interp_linear = (m) -> m
interp_bow3 = (m) -> m ^ 3
interp_step = (m) ->
  if m > 0 then 1
  else 0
interp_1 = -> 1
interp_cut1 = (m) -> math.max 0, m*2-1

class GameMap
  MEMORY_TIME: 27
  memory2alpha: interp_bow3
  visibility2memory: interp_cut1

  new: (@width, @height) =>
    @terrain = Array2d width, height, TERRAIN.EMPTY
    @visit = Array2d width, height
    @memory = Array2d width, height
    @memory\fill 0
    @fov = FOV ((_, x, y) ->
      @terrain\get_wrap(x, y) == TERRAIN.EMPTY
      ), {topology:8}

  player_move: (player, dt) =>
    player\move dt, @width, @height
    @visit\set(player.cellx, player.celly, Visit(player))

  set_terrain: (x, y, terrain_type) =>
    @terrain\set x, y, terrain_type

  draw: (px, py) =>
    for x=0,@width-1
      for y=0,@height-1
        visit_obj = @visit\get x, y
        if visit_obj
          util.draw_tile 'blank', x, y, visit_obj\get_color!    -- for x=0,@width-1
        m = @memory\get x, y
        if m > 0
          switch @terrain\get x, y
            when TERRAIN.EMPTY
              color = Color.DARKGRAY\clone!
              color.a = @.memory2alpha m
              util.draw_tile 'empty', x, y, color
            when TERRAIN.WALL
              color = Color.BLUEISH\clone!
              init_a = @.memory2alpha m
              color.a = init_a
              util.draw_tile_depth 'wall', x, y, px, py, -0.3, color
              color.a = init_a * 0.6
              util.draw_tile_depth 'wall', x, y, px, py, -0.2, color
              color.a = init_a * 0.4
              util.draw_tile_depth 'wall', x, y, px, py, -0.1, color
              color.a = init_a * 0.2
              util.draw_tile 'wall', x, y, color

  update: (dt, cx, cy) =>
    @fov\compute cx, cy, 20, (x,y,r,visibility) ->
      m = @memory\get_wrap x, y
      visibility = @.visibility2memory visibility
      if visibility > m
        @memory\set_wrap x, y, visibility
    for x=0,@width-1
      for y=0,@height-1
        m = @memory\get x, y
        if m > 0
          m -= dt / @MEMORY_TIME
          if m <= 0
            @memory\set x, y, 0
          else
            @memory\set x, y, m
        visit_obj = @visit\get x, y
        if visit_obj and visit_obj\done!
          @visit\set x, y, nil

GameMap
