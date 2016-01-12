require "MenuItem"

ControlsMenuState = {}

function ControlsMenuState:new()
	object = {
		menuItems = {},
		parentMenu = "menu"
	}
	setmetatable(object, { __index = ControlsMenuState })
	return object
end

function ControlsMenuState:init()
	table.insert(self.menuItems, menuItem:new("Z - Jump", 95))
	table.insert(self.menuItems, menuItem:new("X - Shot", 125))
	table.insert(self.menuItems, menuItem:new("R - Reload", 155))
	table.insert(self.menuItems, menuItem:new("M - Mute/Unmute", 185))
end

function ControlsMenuState:update(dt)
	return
end

function ControlsMenuState:draw()
	love.graphics.setColor(31, 31, 31)
	love.graphics.rectangle("fill", 0, 0, 960, 480)
	love.graphics.setColor(255, 255, 255)

	love.graphics.print("Nothing to fear", 10, 5);
    love.graphics.print("(C) 2016 Wilson", 10, 285);

	for _, v in ipairs(self.menuItems) do
		v:draw()
	end	
end

function ControlsMenuState:keyreleased(key)
	return
end

function ControlsMenuState:keypressed(key)
	return
end