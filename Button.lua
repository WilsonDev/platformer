local Quad = love.graphics.newQuad

Button = {}

function Button:new(buttonX, buttonY)
	local object = {
		x = buttonX,
		y = buttonY,
		width = 8,
		height = 8,
		iterator = 1,
		isPressed = false,
		Quads = { --Klatki animacji
			Quad(104, 104, 8, 8, 160, 144),
			Quad(104, 112, 8, 8, 160, 144)}
	}
	setmetatable(object, { __index = Button })
	return object
end

local clicked = false

function Button:update(dt)
	if self:touchesObject(Global.p) then
		--[[if player.ySpeed > 0 then
			player.y = self.y - self.height + 1
			player:collide("floor")
		end]]
		if self.isPressed == false then
			table.insert(Global.enemies, Behemoth:new(0, 28))
			self.isPressed = true
			auClickOn:stop() auClickOn:play()
		end
		self.iterator = 2
		clicked = true
	else
		if clicked == true then
			auClickOff:stop()
			auClickOff:play()
			clicked = false
		end
		self.isPressed = false
		self.iterator = 1
	end
end

function Button:draw()
	love.graphics.draw(sprite, self.Quads[self.iterator], self.x - (self.width / 2),
			self.y - (self.height / 2))
end

function Button:touchesObject(object)
	local ax1, ax2 = self.x - self.width / 2, self.x + self.width / 2 - 1
	local ay1, ay2 = self.y - self.height / 2, self.y + self.height / 2 - 1
	local bx1, bx2 = object.x - object.width / 2, object.x + object.width / 2 - 1
	local by1, by2 = object.y - object.height / 2, object.y + object.height / 2 - 1

	return ((ax2 >= bx1) and (ax1 <= bx2) and (ay2 >= by1) and (ay1 <= by2))
end