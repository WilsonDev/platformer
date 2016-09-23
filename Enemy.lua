local Quad = love.graphics.newQuad

Slime = {}

function Slime:new(slimeX, slimeY)
	local object = {
		x = slimeX, y = slimeY,
		width = 8, height = 8,
		xSpeed = 0, ySpeed = 0,
		hitpoints = 1,
		runSpeed = 30,
		onGround = false,
		xScale = 1,
		xOffset = 0,
		iterator = 1,
		timer = 0,
		Quads = { --Klatki animacji
			Quad( 8, 8, 8, 8, 160, 144),
			Quad(16, 8, 8, 8, 160, 144)},
		animationSpeed = 0.50
	}
	setmetatable(object, { __index = Slime })
	return object
end

function Slime:move()
	self.xSpeed = self.runSpeed
	--Orientacja tekstur
	if self.runSpeed > 0 then
		self.xScale = 1
		self.xOffset = 0
	else
		self.xScale = -1
		self.xOffset = 8
	end
end

function Slime:animation(dt, delay, frames)
	self.timer = self.timer + dt
	if self.timer > delay then
		self.timer = 0
		self.iterator = self.iterator + 1
		if self.iterator > frames then
			self.iterator = 1
		end
	end
end

function Slime:draw()
	love.graphics.draw(sprite, self.Quads[self.iterator], self.x - (self.width / 2),
			self.y - (self.height / 2), 0, self.xScale, 1, self.xOffset)
end

function Slime:collide(event)
	if event == "floor" then
		self.ySpeed = 0
		self.onGround = true
	end
	if event == "ceiling" then
		self.ySpeed = 0
	end
	if event == "wall" then
		self.runSpeed = -1 * self.runSpeed
	end
end

function Slime:mapColliding(map, x, y)
	local layer = Global.map.layers["ground"]
	local tileX = math.floor(x / Global.map.tilewidth) + 1
	local tileY = math.floor(y / Global.map.tileheight) + 1
	local tile = layer.data[tileY][tileX]

	return tile and (tile.properties or {}).solid
end

function Slime:update(dt, gravity, map)
	local halfX = math.floor(self.width / 2)
	local halfY = math.floor(self.height / 2)

	self.ySpeed = self.ySpeed + (Global.gravity * dt)

	--Kolizje z mapą w pionie
	local nextY = math.floor(self.y + (self.ySpeed * dt))
	if self.ySpeed < 0 then
		if not (self:mapColliding(Global.map, self.x - halfX, nextY - halfY))
		and not (self:mapColliding(Global.map, self.x + halfX - 1, nextY - halfY)) then
			self.y = nextY
			self.onGround = false
		else
			self.y = nextY + Global.map.tileheight - ((nextY - halfY) % Global.map.tileheight)
			self:collide("ceiling")
		end
	elseif self.ySpeed > 0 then
		if not (self:mapColliding(Global.map, self.x - halfX, nextY + halfY))
		and not (self:mapColliding(Global.map, self.x + halfX - 1, nextY + halfY)) then
			self.y = nextY
			self.onGround = false
		else
			self.y = nextY - ((nextY + halfY) % Global.map.tileheight)
			self:collide("floor")
		end
	end

	--Kolizje z mapą w poziomie
	local nextX = self.x + (self.xSpeed * dt)
	if self.xSpeed > 0 then --prawy bok
		if not (self:mapColliding(Global.map, nextX + halfX, self.y - halfY))
		and not (self:mapColliding(Global.map, nextX + halfX, self.y + halfY - 1)) then
			self.x = nextX
		else
			self.x = nextX - ((nextX + halfX) % Global.map.tilewidth)
			self:collide("wall")
		end
	elseif self.xSpeed < 0 then --lewy bok
		if not (self:mapColliding(Global.map, nextX - halfX, self.y - halfY))
		and not (self:mapColliding(Global.map, nextX - halfX, self.y + halfY - 1)) then
			self.x = nextX
		else
			self.x = nextX + Global.map.tilewidth - ((nextX - halfX) % Global.map.tilewidth)
			self:collide("wall")
		end
	end

	--Sprawdzaj czy natrafi na przepaść
	if ((self:mapColliding(Global.map, self.x - halfX, nextY + halfY))
		and not (self:mapColliding(Global.map, self.x + halfX, nextY + halfY)))
	or ((self:mapColliding(Global.map, self.x + halfX, nextY + halfY))
		and not (self:mapColliding(Global.map, self.x - halfX - 1, nextY + halfY))) then
		self.runSpeed = -1 * self.runSpeed
	end

	--Animacja
	self:animation(dt, self.animationSpeed, #self.Quads)

	--Ruch
	self:move()
end

--Kolizje z obiektami
function Slime:touchesObject(object)
	local ax1, ax2 = self.x - self.width / 2, self.x + self.width / 2 - 1
	local ay1, ay2 = self.y - self.height / 2, self.y + self.height / 2 - 1
	local bx1, bx2 = object.x - object.width / 2, object.x + object.width / 2 - 1
	local by1, by2 = object.y - object.height / 2, object.y + object.height / 2 - 1

	return ((ax2 >= bx1) and (ax1 <= bx2) and (ay2 >= by1) and (ay1 <= by2))
end
