local Quad = love.graphics.newQuad

--###############--
--#    SLIME    #--
--###############-- 

slime = {}

function slime:new(slimeX, slimeY)
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
		Quad(16, 8, 8, 8, 160, 144)}
	}
	setmetatable(object, { __index = slime })
	return object
end

function slime:move()
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

function slime:animation(dt, delay, frames)
	self.timer = self.timer + dt
	if self.timer > delay then
		self.timer = 0
		self.iterator = self.iterator + 1
		if self.iterator > frames then
			self.iterator = 1
		end
	end
end

function slime:collide(event)
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

function slime:mapColliding(map, x, y)
	local layer = map.layers["ground"]
	local tileX = math.floor(x / map.tileWidth)
	local tileY = math.floor(y / map.tileHeight)
	local tile = layer(tileX, tileY)

	return (not(tile == nil) and tile.properties.solid)
end

function slime:update(dt, gravity, map)
	local halfX = math.floor(self.width / 2)
	local halfY = math.floor(self.height / 2)

	self.ySpeed = self.ySpeed + (gravity * dt)

	--Kolizje z mapą w pionie
	local nextY = math.floor(self.y + (self.ySpeed * dt))
	if self.ySpeed < 0 then
		if not (self:mapColliding(map, self.x - halfX, nextY - halfY))
		and not (self:mapColliding(map, self.x + halfX - 1, nextY - halfY)) then
			self.y = nextY
			self.onGround = false
		else
			self.y = nextY + map.tileHeight - ((nextY - halfY) % map.tileHeight)
			self:collide("ceiling")
		end
	elseif self.ySpeed > 0 then
		if not (self:mapColliding(map, self.x - halfX, nextY + halfY))
		and not (self:mapColliding(map, self.x + halfX - 1, nextY + halfY)) then
			self.y = nextY
			self.onGround = false
		else
			self.y = nextY - ((nextY + halfY) % map.tileHeight)
			self:collide("floor")
		end
	end

	--Kolizje z mapą w poziomie
	local nextX = math.floor(self.x + (self.xSpeed * dt) + 0.5) --funkcja math.floor niepoprawnie zaokrągla (dodano 0.5 dla poprawy wyniku)
	if self.xSpeed > 0 then --prawy bok
		if not (self:mapColliding(map, nextX + halfX, self.y - halfY))
		and not (self:mapColliding(map, nextX + halfX, self.y + halfY - 1)) then
			self.x = nextX
		else
			self.x = nextX - ((nextX + halfX) % map.tileWidth)
			self:collide("wall")
		end
	elseif self.xSpeed < 0 then --lewy bok
		if not (self:mapColliding(map, nextX - halfX, self.y - halfY))
		and not (self:mapColliding(map, nextX - halfX, self.y + halfY - 1)) then
			self.x = nextX
		else
			self.x = nextX + map.tileWidth - ((nextX - halfX) % map.tileWidth)
			self:collide("wall")
		end
	end

	--Sprawdzaj czy natrafi na przepaść
	if ((self:mapColliding(map, self.x - halfX, nextY + halfY))
	and not (self:mapColliding(map, self.x + halfX, nextY + halfY)))
	or ((self:mapColliding(map, self.x + halfX, nextY + halfY))
	and not (self:mapColliding(map, self.x - halfX - 1, nextY + halfY))) then
		self.runSpeed = -1 * self.runSpeed
	end

	--Animacja
	self:animation(dt, 0.50, 2)

	--Ruch
	self:move()
end

--Kolizje z obiektami
function slime:touchesObject(object)
	local ax1, ax2 = self.x - self.width / 2, self.x + self.width / 2 - 1
	local ay1, ay2 = self.y - self.height / 2, self.y + self.height / 2 - 1
	local bx1, bx2 = object.x - object.width / 2, object.x + object.width / 2 - 1
	local by1, by2 = object.y - object.height / 2, object.y + object.height / 2 - 1

	return ((ax2 >= bx1) and (ax1 <= bx2) and (ay2 >= by1) and (ay1 <= by2))
end

--###############--
--#  BEHEMTOTH  #--
--###############-- 

behemoth = {}
--Dziedziczenie po klasie Slime
setmetatable(behemoth, { __index = slime })

function behemoth:new(behemothX, behemothY)
	local object = {
	x = behemothX, y = behemothY,
	width = 8, height = 8,
	xSpeed = 0, ySpeed = 0,
	hitpoints = 2,
	runSpeed = 50,
	onGround = false,
	xScale = 1,
	xOffset = 0,
	iterator = 1,
	timer = 0,
	Quads = {
		Quad( 0, 0, 8, 8, 160, 144),
		Quad(24, 0, 8, 8, 160, 144),
		Quad(32, 0, 8, 8, 160, 144),
		Quad(40, 0, 8, 8, 160, 144)}
	}
	setmetatable(object, { __index = behemoth })
	return object
end

--override behemoth:update()
function behemoth:update(dt, gravity, map)
	local halfX = math.floor(self.width / 2)
	local halfY = math.floor(self.height / 2)

	self.ySpeed = self.ySpeed + (gravity * dt)

	--Kolizje z mapą w pionie
	local nextY = math.floor(self.y + (self.ySpeed * dt))
	if self.ySpeed < 0 then
		if not (self:mapColliding(map, self.x - halfX, nextY - halfY))
		and not (self:mapColliding(map, self.x + halfX - 1, nextY - halfY)) then
			self.y = nextY
			self.onGround = false
		else
			self.y = nextY + map.tileHeight - ((nextY - halfY) % map.tileHeight)
			self:collide("ceiling")
		end
	elseif self.ySpeed > 0 then
		if not (self:mapColliding(map, self.x - halfX, nextY + halfY))
		and not (self:mapColliding(map, self.x + halfX - 1, nextY + halfY)) then
			self.y = nextY
			self.onGround = false
		else
			self.y = nextY - ((nextY + halfY) % map.tileHeight)
			self:collide("floor")
		end
	end

	--Kolizje z mapą w poziomie
	local nextX = math.floor(self.x + (self.xSpeed * dt) + 0.5) --funkcja math.floor niepoprawnie zaokrągla (dodano 0.5 dla poprawy wyniku)
	if self.xSpeed > 0 then --prawy bok
		if not (self:mapColliding(map, nextX + halfX, self.y - halfY))
		and not (self:mapColliding(map, nextX + halfX, self.y + halfY - 1)) then
			self.x = nextX
		else
			self.x = nextX - ((nextX + halfX) % map.tileWidth)
			self:collide("wall")
		end
	elseif self.xSpeed < 0 then --lewy bok
		if not (self:mapColliding(map, nextX - halfX, self.y - halfY))
		and not (self:mapColliding(map, nextX - halfX, self.y + halfY - 1)) then
			self.x = nextX
		else
			self.x = nextX + map.tileWidth - ((nextX - halfX) % map.tileWidth)
			self:collide("wall")
		end
	end

	--Sprawdzaj czy natrafi na przepaść
	if ((self:mapColliding(map, self.x - halfX, nextY + halfY))
	and not (self:mapColliding(map, self.x + halfX, nextY + halfY)))
	or ((self:mapColliding(map, self.x + halfX, nextY + halfY))
	and not (self:mapColliding(map, self.x - halfX - 1, nextY + halfY))) then
		self.runSpeed = -1 * self.runSpeed
	end

	--Animacja
	self:animation(dt, 0.14, 4)

	--Ruch
	self:move()
end