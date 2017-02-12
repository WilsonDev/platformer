MenuItem = {}

function MenuItem:new(menuItemName, menuItemY)
	local object = {
		name = menuItemName,
		x = 0,
		y = menuItemY,
		selected = false,
		redirectTo = nil,
		timer = 0,
		charWidth = 18
	}

	(function ()
		local _, occurence = string.gsub(menuItemName, "[1]", "")
		if occurence > 0 then
			object.x = (960 - string.len(menuItemName) * object.charWidth + (occurence * 18)) / 2
		else
			object.x = (960 - string.len(menuItemName) * object.charWidth) / 2
		end
	end)()

	setmetatable(object, { __index = MenuItem })
	return object
end

function MenuItem:update(dt)
	if self.selected then
		self.timer = self.timer + dt
	else
		self.timer = 0
	end
end

function MenuItem:draw()
	if self.selected then
		love.graphics.push()
		love.graphics.translate(0, math.sin(self.timer * 12) * 2.5)
		love.graphics.print(self.name, self.x, self.y)
		love.graphics.pop()
	else
		love.graphics.print(self.name, self.x, self.y)
	end
end

function MenuItem:select(selected)
	if not self.selected and selected then
		-- Odtwarzany dźwięk
	end
	self.selected = selected
end
