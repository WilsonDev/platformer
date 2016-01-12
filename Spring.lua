local Quad = love.graphics.newQuad

Spring = {}

function Spring:new(springX, springY)
	local object = {
	x = springX,
	y = springY,
	width = 8,
	height = 8,
	iterator = 1,
	isPressed = false,
	Quads = { --Klatki animacji
		Quad(96, 104, 8, 8, 160, 144),
		Quad(96, 112, 8, 8, 160, 144)}
	}
	setmetatable(object, { __index = Spring })
	return object
end

function Spring:update(dt)
	local player = Global.p
	
	if self:touchesObject(player) then
		self.iterator = 2
		player:specialJump(120)
		auJump:stop() 
		auJump:play()
	elseif player.ySpeed > 0 then
		self.iterator = 1
	end
end

function Spring:draw()
	love.graphics.draw(sprite, self.Quads[self.iterator], self.x - (self.width / 2),
			self.y - (self.height / 2))
end

function Spring:touchesObject(object)
	local ax1, ax2 = self.x - self.width / 2, self.x + self.width / 2 - 1
	local ay1, ay2 = self.y - self.height / 2, self.y + self.height / 2 - 1
	local bx1, bx2 = object.x - object.width / 2, object.x + object.width / 2 - 1
	local by1, by2 = object.y - object.height / 2, object.y + object.height / 2 - 1

	return ((ax2 >= bx1) and (ax1 <= bx2) and (ay2 >= by1) and (ay1 <= by2))
end