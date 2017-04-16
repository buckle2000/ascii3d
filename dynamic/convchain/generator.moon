import random, exp, pow from require "math"

Array2D = require "Array2D"
Pattern = require "convchain.Pattern"

DEFAULT_WEIGHT = 0.9  -- <1

class Generator
  new: (sample, @N, @temperature, @width, @height) =>
    @field = Array2D width, height
    @changeSample sample
    @randomizeField!

  correctProbability: (i, j) =>
    value = 1.0
    for y = j - @N + 1, j + @N - 1
      for x = i - @N + 1, i + @N - 1
        weight = @weights[Pattern.hashPartial(@field, x, y, @N)]
        if weight == nil
          weight = DEFAULT_WEIGHT
        value *= weight
    value

  chooseBest: (i, j) =>
    p = @correctProbability i, j  -- no change
    @field\set i, j, 1 - @field\get(i, j)
    q = @correctProbability i, j  -- change
    if @temperature == 0
      if p >= q
        @field\set i, j, 1 - @field\get(i, j)
    else
      if pow(q/p, 1/@temperature) < random!
        @field\set i, j, 1 - @field\get(i, j)
    return

  randomizeField: =>
    for i=0,@field.size-1
      @field.data[i] = random(0,1)
    return

  changeSample: (sample) =>
    if sample == nil
      @weights = nil
      return
    weights = {}
    p = {}
    for y=0,sample.height-1
      for x=0,sample.width-1
        p[0] = Pattern.fromArray2D sample, x, y, @N
        p[1] = p[0]\rotated!
        p[2] = p[1]\rotated!
        p[3] = p[2]\rotated!
        p[4] = p[0]\reflected!
        p[5] = p[1]\reflected!
        p[6] = p[2]\reflected!
        p[7] = p[3]\reflected!
        for k=0,7
          index = p[k]\hash!
          if weights[index] == nil
            weights[index] = 0
          weights[index] += 1
    @weights = {}
    for k,v in pairs(weights)
      if v > DEFAULT_WEIGHT
        @weights[k] = weights[k]
    return

  iterate: =>

    for i=1,@width*@height
      @iterateRandom!
    return

  iterateRandom: =>
    @chooseBest random(0,@width-1), random(0,@height-1)
    return
