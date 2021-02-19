local MathUtils = require "utils.MathUtils"

Camera = {}

function Camera:new()
  local object = {
    _x = 0,
    _y = 0,
    scaleX = 1,
    scaleY = 1,
    rotation = 0,
    stop = false,
    activated = false,
    lastX = 0
  }
  setmetatable(object, { __index = Camera })
  return object
end

function Camera:set()
  love.graphics.push()
  love.graphics.rotate(-self.rotation)
  love.graphics.scale(1 / self.scaleX, 1 / self.scaleY)
  love.graphics.translate(-self._x, -self._y)
end

function Camera:unset()
  love.graphics.pop()
end

function Camera:move(dx, dy)
  self._x = self._x + (dx or 0)
  self._y = self._y + (dy or 0)
end

function Camera:rotate(dr)
  self.rotation = self.rotation + dr
end

function Camera:scale(sx, sy)
  sx = sx or 1
  self.scaleX = self.scaleX * sx
  self.scaleY = self.scaleY * (sy or sx)
end

function Camera:setX(value)
  if self._bounds then
    self._x = MathUtils.clamp(value, self._bounds.x1, self._bounds.x2)
  else
    self._x = value
  end
end

function Camera:setY(value)
  if self._bounds then
    self._y = MathUtils.clamp(value, self._bounds.y1, self._bounds.y2)
  else
    self._y = value
  end
end

function Camera:flowX(dt, x, y, speed)
  if self.lastX < x - 2 then
    self.lastX = self.lastX + dt * speed
    self:setX(self.lastX)
  elseif self.lastX > x + 2 then
    self.lastX = self.lastX - dt * speed
    self:setX(self.lastX)
  else
    self.activated = false
  end
  if y then self:setY(y) end
end

function Camera:setPosition(x, y)
  if self.stop == false then
    if x < self.lastX then
      self.lastX = x
    end
    if x then self:setX(x) end
  else
    self.lastX = self._x
  end
  if y then self:setY(y) end
end

function Camera:setScale(sx, sy)
  self.scaleX = sx or self.scaleX
  self.scaleY = sy or self.scaleY
end

function Camera:getBounds()
  return unpack(self._bounds)
end

function Camera:setBounds(x1, y1, x2, y2)
  self._bounds = { x1 = x1, y1 = y1, x2 = x2, y2 = y2 }
end
