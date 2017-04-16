Array = require "Array"

class Array2D
  -- not auto init
  new: (@width, @height) =>
    @size = width * height
    @data = Array @size

  fill: (value) =>
    for i=0,@size-1
      @data[i] = value

  index: (x, y) =>
    x + @width * y

  get: (x, y) =>
    @data[@index(x, y)]

  set: (x, y, value) =>
    @data[@index(x, y)] = value

  get_wrap: (x, y) =>
    x %= @width
    y %= @height
    @data[@index(x, y)]

  set_wrap: (x, y, value) =>
    x %= @width
    y %= @height
    @data[@index(x, y)] = value

  __tostring: =>
    tostring @data
