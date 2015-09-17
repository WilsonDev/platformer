local Quad = love.graphics.newQuad

ammo = {}

function ammo:new(ammoX, ammoY, ammoClass, ammoRange)
	local object = {
	x = ammoX, y = ammoY,
	width = 8, height = 8,
	xSpeed = 150,
	xScale = 1,
	xOffset = 0,
	range = ammoRange,
	distance = 0,
	class = ammoClass,
	damage = 1,
	Quads = {
		bullet = {
			Quad(16, 32, 8, 8, 160, 144),
		},
		shotgun = {
			Quad(24, 32, 8, 8, 160, 144),
		}
	}
	}
	setmetatable(object, { __index = ammo })
	return object
end

function ammo:update(dt)
	self.distance = self.distance + (self.xScale * self.xSpeed * dt)
	self.x = self.x + (self.xScale * self.xSpeed * dt)
end

function ammo:mapColliding(map, x, y)
	local layer = map.layers["ground"]
	local tileX = math.floor(x / map.tileWidth)
	local tileY = math.floor(y / map.tileHeight)
	local tile = layer(tileX, tileY)
	
	return (not(tile == nil) and tile.properties.solid)
end

function ammo:touchesObject(object)
	local ax1, ax2 = self.x - self.width / 2, self.x + self.width / 2 - 1
	local ay1, ay2 = self.y - self.height / 2, self.y + self.height / 2 - 1
	local bx1, bx2 = object.x - object.width / 2, object.x + object.width / 2 - 1
	local by1, by2 = object.y - object.height / 2, object.y + object.height / 2 - 1

	return ((ax2 >= bx1) and (ax1 <= bx2) and (ay2 >= by1) and (ay1 <= by2))
end