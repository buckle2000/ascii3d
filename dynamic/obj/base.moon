TILE_SIZE = 16

class Object
  -- @param pos tile position
  -- @param cpos camera position
  -- @param depth something like 0.9
  draw: (batch, pos, cpos, depth) =>
    for tile in *tiles
      dx,dy,dz,quad,color = unpack tile
      dpos = vec2 dx, dy
      real_pos =  (dpos + pos + (cpos - dpos)*depth) * TILE_SIZE
      batch\setColor color\love_unpack!
      batch\add quad, real_pos\unpack!
  tiles: {}