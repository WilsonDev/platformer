require "entity.PlatformCheckpoint"

local Global = require "Global"
local StringUtils = require "utils.StringUtils"
local Quad = love.graphics.newQuad

local init

Platform = {}

function Platform:new(objectName, platformX, platformY, platformPath, platformSize)
	object = {
		name = objectName,
		x = platformX,
		y = platformY,
		width = 8,
		height = 8,
		size = tonumber(platformSize), --rozmiar platformy
		xSpeed = 20, ySpeed = 20,
		stringPath = platformPath,
		currentCheckpoint = 1,
		lastCheckpoint = 0,
		isMoving = false,
		path = {}, --metoda init
		animationQuads = {} --metoda init
	}
	
	init(object)
	setmetatable(object, { __index = Platform })
	return object
end

--tablica, rozmiar platformy
function init(object)
	table.insert(object.animationQuads, Quad(32, 104, 8, 8, 160, 144))
	if object.size > 0 then
		for i = 1, object.size do
			table.insert(object.animationQuads, Quad(40, 104, 8, 8, 160, 144))
		end
	end
	table.insert(object.animationQuads, Quad(48, 104, 8, 8, 160, 144))

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

	-- for k, v in pairs(object.path) do
	-- 	print(k, v.x, v.y)
	-- end
end

function Platform:mapColliding(map, x, y)
	local layer = Global.map.layers["ground"]
	local tileX = math.floor(x / Global.map.tilewidth) + 1
	local tileY = math.floor(y / Global.map.tileheight) + 1
	local tile = layer.data[tileY][tileX]

	return tile and (tile.properties or {}).solid
end

function Platform:move(dt)
	local nextX = self.x + (self.xSpeed * dt)
	local nextY = self.y + (self.ySpeed * dt)	

	if self.isMoving then
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
				self.x = nextX
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
				self.y = nextY
			else
				self.ySpeed = 0
			end

			if d < math.max(math.abs(self.xSpeed), math.abs(self.ySpeed)) * dt then
				--powoduje minimalne przesuniecie gracza podczas zmiany punktu
				--self.x = checkpointTo.x
				--self.y = checkpointTo.y
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
end

function Platform:update(dt)
	-- local halfX = math.floor(self.width / 2)
	-- local halfY = math.floor(self.height / 2)

	-- if self.xSpeed > 0 then
	-- 	if not (self:mapColliding(Global.map, nextX + halfX + ((self.size + 1) * self.width) + 2, self.y - halfY))
	-- 	and not (self:mapColliding(Global.map, nextX + halfX + ((self.size + 1) * self.width) + 2, self.y + halfY - 1)) then
	-- 		self.x = nextX
	-- 	else
	-- 		self.xSpeed = -self.xSpeed
	-- 	end
	-- elseif self.xSpeed < 0 then
	-- 	if not (self:mapColliding(Global.map, nextX - halfX - 2, self.y - halfY))
	-- 	and not (self:mapColliding(Global.map, nextX - halfX - 2, self.y + halfY - 1)) then
	-- 		self.x = nextX
	-- 	else
	-- 		self.xSpeed = -self.xSpeed
	-- 	end
	-- end
	self:move(dt)

	if self:touchesObject(Global.p) then
		if Global.p.ySpeed > 0 then
			self.isMoving = true
			Global.p.y = (self.y - self.height / 2) - (Global.p.height / 2)
			Global.p:collide("platform")
			if self.ySpeed >= 0 then
				Global.p.ySpeed = self.ySpeed
			else
				Global.p.ySpeed = 0
			end
			if not Global.p.isMoving then
				Global.p.xSpeed = self.xSpeed
			end
		end
	end
end

function Platform:draw()
	for i, v in ipairs(self.animationQuads) do
		love.graphics.draw(sprite, v, (self.x - (self.width / 2)) + 8 * (i - 1), self.y - (self.height / 2))
		--love.graphics.setPointSize(8)
		--love.graphics.points(self.x, self.y)
	end

	-- love.graphics.setLineWidth(0.25)
	-- for i, v in ipairs(self.path) do
	-- 	if self.path[i + 1] ~= nil then
	-- 		love.graphics.line(self.path[i].x, self.path[i].y, self.path[i + 1].x, self.path[i + 1].y)
	-- 	end
	-- end
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
