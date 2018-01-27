local Global = require "Global"

SettingsState = {}

function SettingsState:new()
	local object = {
		parentMenu = "turbo"
	}
	setmetatable(object, { _index = SettingsState })
	return object
end

function SettingsState:init()
	return
end

function SettingsState:update(dt)
	return
end

function SettingsState:draw()
	love.graphics.print(Global.title, 10, 5)
	love.graphics.print(Global.copyright, 10, 285)
end

function SettingsState:keyreleased(key)
	return
end

function SettingsState:keypressed(key)
	return
end
