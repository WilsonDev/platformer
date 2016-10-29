require "Checkpoint"

local Quad = love.graphics.newQuad
local init

Platform = {}

function Platform:new(platformX, platformY, platformPath, platformSize)
	object = {
		x = platformX,
		y = platformY,
		width = 8,
		height = 8,
		size = tonumber(platformSize), --rozmiar platformy
		speed = 0,
		stringPath = platformPath,
		currentCheckpoint = 1,
		path = {}, --metoda init
		Quad = {} --metoda init
	}
	init(object)
	setmetatable(object, { __index = Platform })
	return object
end

--tablica, rozmiar platformy
function init(object)
	table.insert(object.Quad, Quad(32, 104, 8, 8, 160, 144))
	if object.size > 0 then
		for i = 1, object.size do
			table.insert(object.Quad, Quad(40, 104, 8, 8, 160, 144))
		end
	end
	table.insert(object.Quad, Quad(48, 104, 8, 8, 160, 144))

	local checkpoints = StringUtils.split(object.stringPath, ";")
	local lastX = object.x
	local lastY = object.y
	table.insert(object.path, Checkpoint:new(lastX, lastY))
	for i = 1, #checkpoints do
		local checkpoint = StringUtils.split(checkpoints[i], ",")
		local checkpointX = checkpoint[1] + lastX
		local checkpointY = checkpoint[2] + lastY
		lastX = checkpointX
		lastY = checkpointY
		table.insert(object.path, Checkpoint:new(checkpointX, checkpointY))
	end
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

	--TODO
	local checkpoint = self.path[self.currentCheckpoint]

	local nextX = self.x + (self.speed * dt)
	local nextY = self.y + (self.speed * dt)
	if self.speed > 0 then
		if not (self:mapColliding(Global.map, nextX + halfX + ((self.size + 1) * self.width) + 2, self.y - halfY))
		and not (self:mapColliding(Global.map, nextX + halfX + ((self.size + 1) * self.width) + 2, self.y + halfY - 1)) then
			self.x = nextX
		else
			self.speed = -self.speed
		end
	elseif self.speed < 0 then
		if not (self:mapColliding(Global.map, nextX - halfX - 2, self.y - halfY))
		and not (self:mapColliding(Global.map, nextX - halfX - 2, self.y + halfY - 1)) then
			self.x = nextX
		else
			self.speed = -self.speed
		end
	end

	if self:touchesObject(Global.p) then
		if Global.p.ySpeed > 0 then
			Global.p.y = Global.p.y - ((Global.p.y + (self.height / 2)) % self.height)
			Global.p:collide("floor")
			if not Global.p.isMoving then
				Global.p.xSpeed = self.speed
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
