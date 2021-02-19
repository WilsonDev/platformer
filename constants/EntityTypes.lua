local ENTITY_NAMES = require "constants.EntityNames"

local ENTITY_TYPES = {
  [ENTITY_NAMES.PLAYER] = Player,
  [ENTITY_NAMES.BUTTON] = Button,
  [ENTITY_NAMES.SPRING] = Spring,
  [ENTITY_NAMES.SPIKE] = Spike,
  [ENTITY_NAMES.WARP] = Warp,
  [ENTITY_NAMES.SLIME] = Slime,
  [ENTITY_NAMES.BEHEMOTH] = Behemoth,
  [ENTITY_NAMES.MEGA_BEHEMOTH] = MegaBehemoth,
  [ENTITY_NAMES.PLATFORM] = Platform,
  [ENTITY_NAMES.ACID] = Acid,
  [ENTITY_NAMES.PICKUP] = Pickup
}

return ENTITY_TYPES
