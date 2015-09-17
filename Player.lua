require "Ammo"

local Quad = love.graphics.newQuad

player = {}

function player:new(playerX, playerY)
	local object = {
	x = playerX, y = playerY,
	width = 8, height = 8,
	xSpeed = 0, ySpeed = 0,
	state = "stand",
	hitpoints = 3,
	jumpSpeed = -150,
	runSpeed = 50,
	xScale = 1,
	xOffset = 0,
	iterator = 1,
	timer = 0,
	onGround = false, hasJumped = false,
	shots = {}, firedShots = 0,
	invul = false, invultime = 2, isPoked = false,
	Quads = { --Klatki animacji
		move = {
			Quad( 0, 16, 8, 8, 160, 144),
			Quad(24, 16, 8, 8, 160, 144),
			Quad(32, 16, 8, 8, 160, 144),
			Quad(40, 16, 8, 8, 160, 144)
		},
		stand = {
			Quad( 8, 16, 8, 8, 160, 144),
			Quad(16, 16, 8, 8, 160, 144),
			Quad( 8, 16, 8, 8, 160, 144)
		}
	}
	}
	setmetatable(object, { __index = player })
	return object
end

function player:jump()
	if self.onGround or self.isPoked then
		self.ySpeed = self.jumpSpeed
		self.onGround = false
	end
end

function player:moveRight()
	self.xSpeed = self.runSpeed
	self.xScale = 1
	self.xOffset = 0
end

function player:moveLeft()
	self.xSpeed = -1 * self.runSpeed
	self.xScale = -1
	self.xOffset = 8
end

function player:stop()
	self.xSpeed = 0
	self.iterator = 1
end

function player:draw()
	--Bohater
	love.graphics.draw(sprite, self.Quads[self.state][self.iterator], self.x - (self.width / 2),
		self.y - (self.height / 2), 0, self.xScale, 1, self.xOffset)
	--Strzały
	for i,v in ipairs(self.shots) do
		love.graphics.draw(sprite, v.Quads[v.class][1], v.x - (v.width / 2),
			v.y - (v.height / 2), 0, v.xScale, 1, v.xOffset)
	end
end

function player:animation(dt, delay, frames)
	self.timer = self.timer + dt
	if self.timer > delay then
		self.timer = 0
		self.iterator = self.iterator + 1
		if self.iterator > frames then
			self.iterator = 1
		end
	end
end

function player:collide(event)
	if event == "floor" then
		self.ySpeed = 0
		self.onGround = true
	end
	if event == "ceiling" then
		self.ySpeed = 0
	end
end

function player:mapColliding(map, x, y)
	local layer = map.layers["ground"]
	local tileX = math.floor(x / map.tileWidth)
	local tileY = math.floor(y / map.tileHeight)
	local tile = layer(tileX, tileY)

	return (not(tile == nil) and tile.properties.solid)
end

function player:enemyColliding()
	--Kolizja z przeciwnikiem
	for i,v in ipairs(enemies) do
		if v:touchesObject(self) and not self.invul then
			self.isPoked = true
			auPunch:stop() auPunch:play()
			if self.invul == false then
				self.invul = true
				self.invultime = 2
				self.hitpoints = self.hitpoints - 1
			end
			self.runSpeed = 100
			self:jump()
			if love.keyboard.isDown("right")
			or (v.xScale == -1 and not love.keyboard.isDown("left")) then
				self:moveLeft()
			elseif love.keyboard.isDown("left") or v.xScale == 1 then
				self:moveRight()
			end
		end
	end

	if self.onGround and self.isPoked then
		self.isPoked = false
		self.runSpeed = 50
		self:stop()
	end
end

function player:update(dt, gravity, map)
	local halfX = math.floor(self.width / 2)
	local halfY = math.floor(self.height / 2)

	self.ySpeed = self.ySpeed + (gravity * dt)

	--Kolizje w pionie
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

	--Kolizje w poziomie
	local nextX = math.floor(self.x + (self.xSpeed * dt) + 0.5)
	--funkcja math.floor niepoprawnie zaokrągla (dodano 0.5 dla poprawy wyniku)
	if self.xSpeed > 0 then
		if not (self:mapColliding(map, nextX + halfX, self.y - halfY))
		and not (self:mapColliding(map, nextX + halfX, self.y + halfY - 1)) then
			self.x = nextX
		else
			self.x = nextX - ((nextX + halfX) % map.tileWidth)
		end
	elseif self.xSpeed < 0 then
		if not (self:mapColliding(map, nextX - halfX, self.y - halfY))
		and not (self:mapColliding(map, nextX - halfX, self.y + halfY - 1)) then
			self.x = nextX
		else
			self.x = nextX + map.tileWidth - ((nextX - halfX) % map.tileWidth)
		end
	end

	--Ograniczenie mapy
	if self.x + self.width / 2 > map.tileWidth * map.width then
		self.x = map.tileWidth * map.width - self.width / 2
	end

	--Aktualizacja strzałów
	for i,v in ipairs(self.shots) do
		v:update(dt)
		if (v.distance > v.range or v.distance < - v.range)
		or v:mapColliding(map, v.x + v.xScale * 2, v.y) then
			table.remove(self.shots, i)
		end
		for j in ipairs(enemies) do
			if v:touchesObject(enemies[j]) then
				enemies[j].hitpoints = enemies[j].hitpoints - v.damage
				if enemies[j].hitpoints <= 0 then
					table.remove(enemies, j)
				end
				table.remove(self.shots, i)
				score = score + 50
				auHit:stop() auHit:play()
			end
		end
	end

	--Kolizcja z przeciwnikami
	self:enemyColliding()

	--Ograniczenie prędkości spadania
	if self.ySpeed > 224 then
		self.ySpeed = 224
	end

	--Nietykalność
	if self.invultime > 0 then
		self.invultime = self.invultime - dt
		if self.invultime <= 0 then
			self.invul = false
		end
	end

	--Punkty życia
	if self.hitpoints <= 0 or self.y > map.height * map.tileHeight then
		love.event.quit()
	end

	--Zmiana animacji
	if self.state == "move" then
		self:animation(dt, 0.14, 4)
	elseif self.state == "stand" then
		self:animation(dt, 0.35, 3)
	end

	--Ruch
	self:keypressed()

	self.state = self:getState()
end

function player:getState()
	local myState = ""
	if self.xSpeed ~= 0 then
		myState = "move"
	else
		myState = "stand"
	end
	return myState
end

function player:keypressed() --player:update()
	local key = love.keyboard
	if not self.isPoked then
		if love.keyboard.isDown("right") then --prawo
			self:moveRight()
		end
		if love.keyboard.isDown("left") then --lewo
			self:moveLeft()
		end
		if love.keyboard.isDown("z", "up") and not self.hasJumped then --skok
			self:jump()
			self.hasJumped = true
		end
	end
end

function player:keyreleased(key) --love.keyreleased()
	if (key == "right" or key == "left") and not self.isPoked then
		self:stop()
	end
	if key == "z" or key == "up" then
		self.hasJumped = false
	end
	if key == "r" then
		self.firedShots = 0
	end
	if (key == "x") and (self.firedShots < 5) then
		self.firedShots = self.firedShots + 1
		bullet = ammo:new(self.x, self.y, "bullet", 120)
		bullet.xScale = self.xScale
		bullet.xOffset = self.xOffset
		if self.xScale == 1 then
			bullet.x = bullet.x + bullet.width / 2
		else
			bullet.x = bullet.x - bullet.width / 2
		end
		table.insert(self.shots, bullet)
		auShot:stop() auShot:play()
	end
end