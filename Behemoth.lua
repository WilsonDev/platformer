require "Enemy"

local Quad = love.graphics.newQuad

behemoth = {}

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
		Quad(40, 0, 8, 8, 160, 144) }
	}
	setmetatable(object, { __index = slime })
	return object
end

function behemoth:update(dt, gravity, map)
	local halfX = math.floor(self.width / 2)
	local halfY = math.floor(self.height / 2)

	self.ySpeed = self.ySpeed + (gravity * dt)
	print("behemoth")

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