menuItem = {}

function menuItem:new(menuItemName, menuItemY)
	local object = {
		name = menuItemName,
		x = 0, 
		y = menuItemY,
		selected = false,
		timer = 0,
		charWidth = 14
	}

	(function ()
		if not(string.find(menuItemName, "i") == nil) then
			object.x = (960 - string.len(menuItemName) * object.charWidth + 10) / 2
		else
			object.x = (960 - string.len(menuItemName) * object.charWidth) / 2
		end
	end)()

	setmetatable(object, { __index = menuItem })
	return object
end

function menuItem:update(dt)
	if self.selected then
		self.timer = self.timer + dt
	else
		self.timer = 0
	end
end

function menuItem:draw()
	if self.selected then
		love.graphics.push()
		love.graphics.translate(0, math.sin(self.timer * 12) * 2.5)
		love.graphics.print(self.name, self.x, self.y)
		love.graphics.pop()	
	else
		love.graphics.print(self.name, self.x, self.y)
	end
end

function menuItem:select(selected)
	if not self.selected and selected then
		-- Odtwarzany dźwięk
	end
	self.selected = selected
end