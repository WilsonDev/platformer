local Quad = love.graphics.newQuad

Warp = {}

function Warp:new(objectName, warpX, warpY)
	local object = {
		name = objectName,
		x = warpX,
		y = warpY,
		width = 8,
		height = 8
	}
	setmetatable(object, { __index = Warp })
	return object
end

function Warp:update(dt)
	local player = Global.p
	if self:touchesObject(player) then
		Global.currentMap = Global.currentMap + 1
		World:change("map" .. Global.currentMap)

		auWarp:stop()
		auWarp:play()
	end
end

function Warp:draw()
	return
end

function Warp:touchesObject(object)
	local ax1, ax2 = self.x - self.width / 2, self.x + self.width / 2 - 1
	local ay1, ay2 = self.y - self.height / 2, self.y + self.height / 2 - 1
	local bx1, bx2 = object.x - object.width / 2, object.x + object.width / 2 - 1
	local by1, by2 = object.y - object.height / 2, object.y + object.height / 2 - 1

	return ((ax2 >= bx1) and (ax1 <= bx2) and (ay2 >= by1) and (ay1 <= by2))
end
