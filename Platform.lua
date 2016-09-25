local Quad = love.graphics.newQuad

Platform = {}

function Platform:new(PlatformX, PlatformY)
	object = {
		x = PlatformX,
		y = PlatformY,
		width = 8,
		height = 8,
		size = 1, --rozmiar platformy
		xSpeed = 20,
		Quad = { } --metoda init
	}
	init(object)
	setmetatable(object, { __index = Platform })
	return object
end

--tablica, rozmiar platformy
function init(object)
	table.insert(object.Quad, Quad(32, 104, 8, 8, 160, 144))
	for i = 1, object.size do
		table.insert(object.Quad, Quad(40, 104, 8, 8, 160, 144))
	end
	table.insert(object.Quad, Quad(48, 104, 8, 8, 160, 144))
end

function Platform:mapColliding(map, x, y)
	local layer = Global.map.layers["ground"]
	local tileX = math.floor(x / Global.map.tilewidth) + 1
	local tileY = math.floor(y / Global.map.tileheight) + 1
	local tile = layer.data[tileY][tileX]

	return tile and (tile.properties or {}).solid
end

function Platform:update(dt)
	local halfX = math.floor(self.width / 2)
	local halfY = math.floor(self.height / 2)

	--Kolizje w poziomie
	local nextX = self.x + (self.xSpeed * dt)
	if self.xSpeed > 0 then
		if not (self:mapColliding(Global.map, nextX + halfX + ((self.size + 1) * self.width) + 2, self.y - halfY))
		and not (self:mapColliding(Global.map, nextX + halfX + ((self.size + 1) * self.width) + 2, self.y + halfY - 1)) then
			self.x = nextX
		else
			self.xSpeed = -self.xSpeed
		end
	elseif self.xSpeed < 0 then
		if not (self:mapColliding(Global.map, nextX - halfX - 2, self.y - halfY))
		and not (self:mapColliding(Global.map, nextX - halfX - 2, self.y + halfY - 1)) then
			self.x = nextX
		else
			self.xSpeed = -self.xSpeed
		end
	end

	if self:touchesObject(Global.p) then
		if Global.p.ySpeed > 0 then
			Global.p.y = Global.p.y - ((Global.p.y + (self.height / 2)) % self.height)
			Global.p:collide("floor")
			if not Global.p.isMoving then
				Global.p.xSpeed = self.xSpeed
			end
		end
	end
end

function Platform:draw()
	for i, v in ipairs(self.Quad) do
		love.graphics.draw(sprite, v, (self.x - (self.width / 2)) + 8 * (i - 1), self.y - (self.height / 2))
	end
end

function Platform:touchesObject(object)
	local ax1, ax2 = self.x - self.width / 2, self.x + self.width / 2 + ((self.size + 1) * self.width) - 1
	local ay1, ay2 = self.y - self.height / 2 - 1, self.y - self.height / 2 - 1
	local bx1, bx2 = object.x - object.width / 2, object.x + object.width / 2 - 1
	local by1, by2 = object.y - object.height / 2, object.y + object.height / 2 - 1

	--print("object1: " .. ax1 .. " " .. ax2 .. " " .. ay1 .. " " .. ay2)
	--print("object2: " .. bx1 .. " " .. bx2 .. " " .. by1 .. " " .. by2)

	return ((ax2 >= bx1) and (ax1 <= bx2) and (ay2 > by1) and (ay1 <= by2))
end
