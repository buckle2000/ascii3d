util = require "util"
Color = require "Color"

class Player
  size: .5

  new: (@pworld, @x, @y, @color=Color.RGB(1,1,1), @ctrl) =>
    @speed = 8
    pworld\add @, x, y, @size, @size
    @cellx = math.floor x + @size/2
    @celly = math.floor y + @size/2
    @vx = 0
    @vy = 0

  update: (dt) =>
    @ctrl.x\update!
    @ctrl.y\update!
    @vx = @ctrl.x\getValue!
    @vy = @ctrl.y\getValue!

  move: (dt, field_width, field_height) =>
    util.move @pworld, @,
      @vx * @speed * dt,
      @vy * @speed * dt
    px, py = @pworld\getRect @
    cellx = math.floor px + @size/2
    celly = math.floor py + @size/2
    if cellx < 0
      px += field_width
    elseif cellx >= field_width
      px -= field_width
    if celly < 0
      py += field_height
    elseif celly >= field_height
      py -= field_height
    @pworld\update @, px, py
    @x = px
    @y = py
    @cellx = math.floor px + @size/2
    @celly = math.floor py + @size/2

  draw: =>
    util.draw_tile 'player', @x, @y, @color
      