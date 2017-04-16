import lshift from require "bit"

Array2D = require "Array2D"

class Pattern
  new: (@size, init) =>
    @data = Array2D size, size
    for x=0,size-1
      for y=0,size-1
        @data\set x, y, init(x, y)

  @fromArray2D = (arr2d, x, y, N) ->
    @ N, (i, j) -> arr2d\get(
        (x + i) % arr2d.width
        (y + j) % arr2d.height)

  rotated: =>
    @@ @size, (x, y) ->
      @data\get (@size - 1 - y), x

  reflected: =>
    @@ @size, (x, y) ->
      @data\get (@size - 1 - x), y

  @hashPartial = (arr2d, start_x, start_y, size) ->
    result = 0
    power = 0
    for x=0,size-1
      for y=0,size-1
        xx, yy = (x + start_x) % arr2d.width, (y + start_y) % arr2d.height
        result += lshift arr2d\get(xx, yy), power
        power += 1
    result

  hash: =>
    if @_hash == nil
      @_hash = @@.hashPartial @data, 0, 0, @size
    @_hash
    