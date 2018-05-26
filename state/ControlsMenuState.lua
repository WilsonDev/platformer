require "utils.MenuItem"

local Global = require "Global"

ControlsMenuState = {}

function ControlsMenuState:new()
	local object = {
		menuItems = {},
		parentMenu = "menu"
	}
	setmetatable(object, { __index = ControlsMenuState })
	return object
end

function ControlsMenuState:init()
	table.insert(self.menuItems, MenuItem:new("Z - JUMP", 90))
	table.insert(self.menuItems, MenuItem:new("X - SHOT", 120))
	table.insert(self.menuItems, MenuItem:new("R - RELOAD", 150))
end

function ControlsMenuState:update(dt)
	return
end

function ControlsMenuState:draw()
	love.graphics.print(Global.title, 10, 5)
	love.graphics.print(Global.copyright, 10, 285)
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
