require "entity.platform.PlatformCheckpoint"

local StringUtils = require "utils.StringUtils"
local Quad = love.graphics.newQuad

local init

Platform = {}

function Platform:new(objectName, platformX, platformY, platformProperties)
  object = {
    name = objectName,
    x = platformX,
    y = platformY,
    width = 8,
    height = 8,
    size = tonumber(platformProperties.size), --rozmiar platformy
    xSpeed = 20, ySpeed = 20,
    stringPath = platformProperties.path,
    currentCheckpoint = 1,
    lastCheckpoint = 0,
    isMoving = true,
    path = {}, --metoda init
    quads = {} --metoda init
  }
  
  init(object)
  setmetatable(object, { __index = Platform })
  return object
end

--tablica, rozmiar platformy
function init(object)
  table.insert(object.quads, Quad(32, 104, 8, 8, 160, 144))
  if object.size > 0 then
    for i = 1, object.size do
      table.insert(object.quads, Quad(40, 104, 8, 8, 160, 144))
    end
  end
  table.insert(object.quads, Quad(48, 104, 8, 8, 160, 144))

  local checkpoints = StringUtils.split(object.stringPath, ";")
  local lastX = object.x
  local lastY = object.y
  table.insert(object.path, PlatformCheckpoint:new(1, lastX, lastY))
  for i = 1, #checkpoints do
    local checkpoint = StringUtils.split(checkpoints[i], ",")
    lastX = checkpoint[1] + lastX
    lastY = checkpoint[2] + lastY
    table.insert(object.path, PlatformCheckpoint:new(i + 1, lastX, lastY))
  end
end

function Platform:mapColliding(map, x, y)
  local layer = map.layers["ground"]
  local tileX = math.floor(x / map.tilewidth) + 1
  local tileY = math.floor(y / map.tileheight) + 1
  local tile = layer.data[tileY][tileX]

  return tile and (tile.properties or {}).solid
end

function Platform:move(dt)
  if not self.isMoving then
    return
  end

  local checkpointFrom, checkpointTo
  if self.currentCheckpoint == #self.path or self.lastCheckpoint > self.currentCheckpoint 
  and self.currentCheckpoint - 1 ~= 0 then
    checkpointFrom = self.path[self.currentCheckpoint]
    checkpointTo = self.path[self.currentCheckpoint - 1]
  else
    checkpointFrom = self.path[self.currentCheckpoint]
    checkpointTo = self.path[self.currentCheckpoint + 1]
  end

  if checkpointTo ~= nil then
    local xModifier = 1
    local yModifier = 1
    local dxFrom = math.abs(checkpointFrom.x - checkpointTo.x)
    local dyFrom = math.abs(checkpointFrom.y - checkpointTo.y)

    local dx = self.x - checkpointTo.x
    local dy = self.y - checkpointTo.y
    local d = dx * dx + dy * dy

    if dxFrom > dyFrom then
      yModifier = dyFrom / dxFrom
    else
      xModifier = dxFrom / dyFrom
    end

    if math.abs(dx) > math.abs(self.xSpeed * dt) then
      self.xSpeed = 20
      if dx < 0 then
        self.xSpeed = math.abs(self.xSpeed) * xModifier
      else
        self.xSpeed = -math.abs(self.xSpeed) * xModifier
      end
      -- nextX
      self.x = self.x + (self.xSpeed * dt)
    else
      self.xSpeed = 0
    end

    if math.abs(dy) > math.abs(self.ySpeed * dt) then
      self.ySpeed = 20
      if dy < 0 then
        self.ySpeed = math.abs(self.ySpeed) * yModifier
      else
        self.ySpeed = -math.abs(self.ySpeed) * yModifier
      end
      -- nextY
      self.y = self.y + (self.ySpeed * dt)
    else
      self.ySpeed = 0
    end

    if d < math.max(math.abs(self.xSpeed), math.abs(self.ySpeed)) * dt then
      self.lastCheckpoint = self.currentCheckpoint
      if checkpointFrom.id < checkpointTo.id then
        self.currentCheckpoint = self.currentCheckpoint + 1
      else
        self.currentCheckpoint = self.currentCheckpoint - 1
      end
    end
  else
    self.xSpeed = 0
    self.ySpeed = 0
  end
end

function Platform:update(dt, world)
  self:move(dt)

  if self:touchesObject(world.player) then
    if world.player.ySpeed > 0 then
      self.isMoving = true
      world.player.y = (self.y - self.height / 2) - (world.player.height / 2)
      world.player:collide("platform")
      if self.ySpeed >= 0 then
        world.player.ySpeed = self.ySpeed
      else
        world.player.ySpeed = 0
      end
      if not world.player.isMoving then
        world.player.xSpeed = self.xSpeed
      end
    end
  end
end

function Platform:draw()
  for i, v in ipairs(self.quads) do
    love.graphics.draw(sprite, v, (self.x - (self.width / 2)) + 8 * (i - 1), self.y - (self.height / 2))
  end
end

function Platform:touchesObject(object)
  local ax1, ax2 = self.x - self.width / 2, self.x + self.width / 2 + ((self.size + 1) * self.width) - 1
  local ay1, ay2 = self.y - self.height / 2 - 1, self.y - self.height / 2 - 1
  local bx1, bx2 = object.x - object.width / 2, object.x + object.width / 2 - 1
  local by1, by2 = object.y - object.height / 2, object.y + object.height / 2 - 1

  return ((ax2 >= bx1) and (ax1 <= bx2) and (ay2 > by1) and (ay1 <= by2))
end
