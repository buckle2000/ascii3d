poc_loader_atlas = require "poc.loader.atlas"

atlas = poc_loader_atlas('tiles.png', 16, 16)

{
  atlas: atlas
  img: atlas.img
  wall: atlas[1]
  circle: atlas[2]
  player: atlas[3]
  altar: atlas[4]
  empty: atlas[5]
  blank: atlas[6]
}