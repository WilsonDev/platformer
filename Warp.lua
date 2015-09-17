local Quad = love.graphics.newQuad

warp = {}

function warp:new(warpX, warpY)
	local object = {
	x = warpX,
	y = warpY,
	width = 8,
	height = 8
	}
	setmetatable(object, { __index = warp })
	return object
end

function warp:update(dt)
	local player = p
	if self:touchesObject(player) then
		world:change("map4.tmx")
	end
end

function warp:touchesObject(object)
	local ax1, ax2 = self.x - self.width / 2, self.x + self.width / 2 - 1
	local ay1, ay2 = self.y - self.height / 2, self.y + self.height / 2 - 1
	local bx1, bx2 = object.x - object.width / 2, object.x + object.width / 2 - 1
	local by1, by2 = object.y - object.height / 2, object.y + object.height / 2 - 1

	return ((ax2 >= bx1) and (ax1 <= bx2) and (ay2 >= by1) and (ay1 <= by2))
end