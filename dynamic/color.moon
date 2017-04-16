local *

-- All values inside [0.0, 1.0]


hsl2rgb = (h,s,l) ->
  local q, p, r, g, b
  if @l < 1/2
    q = l * (1 + s)
  else
    q = l + s - l * s
  p = 2 * l - q
  h %= 1.0
  r = h + 1/3
  g = h
  b = h - 1/3
  hsl2rgb_helper1 = (t) ->
    if (t < 0) then t += 1
    if (t > 1) then t -= 1
    if t < 1/6
      p + (q - p) * 6 * t
    elseif t < 1/2
      q
    elseif t < 2/3
      p + (q - p) * 6 * (2/3 - t)
    else 
      p
  r = hsl2rgb_helper1 r
  g = hsl2rgb_helper1 g
  b = hsl2rgb_helper1 b
  r,g,b


  
-- Converts HSV to RGB. (input and output range: 0.0 - 1.0)
hsv2rgb = (h, s, v) ->
  if s <= 0 then return v,v,v
  h = (h % 1.0) * 6
  c = v * s
  x = (1 - math.abs( h%2 - 1 )) * c
  m = v - c
  r,g,b = if h < 1 then c,x,0
  elseif h < 2 then x,c,0
  elseif h < 3 then 0,c,x
  elseif h < 4 then 0,x,c
  elseif h < 5 then x,0,c
  else              c,0,x
  (r+m),(g+m),(b+m)


class Color
  love_set: =>
    love.graphics.setColor @love_unpack!
    return
  love_with: =>
    rr,gg,bb,aa = love.graphics.getColor!
    @love_set!
    love.graphics.setColor rr,gg,bb,aa
    return

class ColorRGB extends Color
  new: (@r,@g,@b,@a=1.0) =>
  clone: =>
    ColorRGB @r,@g,@b,@a
  to_rgb: =>
    @clone!
  to_hsv: =>
    -- TODO
  to_hsl: =>
    -- TODO
  love_unpack: =>
    @r*256,@g*256,@b*256,@a*256
  love_table: =>
    {@r*256,@g*256,@b*256,@a*256}


class ColorHSV extends Color
  new: (@h,@s,@v,@a=1.0) =>
  clone: =>
    ColorHSV @h,@s,@v,@a
  to_rgb: =>
    r,g,b = hsv2rgb @h,@s,@v
    ColorRGB r,g,b,@a
  to_hsv: =>
    @clone!
  to_hsl: =>
    -- TODO
  love_unpack: =>
    r,g,b = hsv2rgb @h,@s,@v
    r*256,g*256,b*256,@a*256
  love_table: =>
    r,g,b = hsv2rgb @h,@s,@v
    {r*256,g*256,b*256,@a*256}


class ColorHSL extends Color
  new: (@h,@s,@l,@a=1.0) =>
  clone: =>
    ColorHSL @h,@s,@l,@a
  to_rgb: =>
    r,g,b = hsl2rgb @h,@s,@l
    ColorRGB r,g,b,@a
  to_hsv: =>
    -- TODO
  to_hsl: =>
    @clone!
  love_unpack: =>
    r,g,b = hsl2rgb @h,@s,@l
    r*256,g*256,b*256,@a*256
  love_table: =>
    r,g,b = hsl2rgb @h,@s,@l
    {r*256,g*256,b*256,@a*256}


Color_M =
  RGB: (r,g,b,a) ->
    ColorRGB r,g,b,a
  HSV: (h,s,v,a) ->
    ColorHSV h,s,v,a
  HSL: (h,s,l,a) ->
    ColorHSL h,s,l,a
  -- clone: => ColorSame
  -- to_rgb: => ColorRGB
  -- to_hsv: => ColorHSV
  -- to_hsl: => ColorHSL
  -- love_unpack: => r,g,b,a
  -- love_table: => {r,g,b,a}

  :hsv2rgb
  :hsl2rgb

  WHITE:     ColorRGB 1,1,1
  BLACK:     ColorRGB 0,0,0
  RED:       ColorRGB 1,0,0
  GREEN:     ColorRGB 0,1,0
  BLUE:      ColorRGB 0,0,1

  DARKGRAY:  ColorHSV 0,0,.11 
  LIGHTGRAY: ColorHSV 0,0,.80
  REDISH:    ColorHSV 0,0,.81
  BLUEISH:   ColorHSV 252/360,.48,.75
  P1:        ColorRGB 214/256,203/256,137/256
  P2:        ColorRGB 201/256,237/256,240/256
  -- P2:        ColorRGB 137/256,149/256,214/256

return Color_M
