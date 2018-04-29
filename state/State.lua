require "state.MenuState"
require "state.GameState"
require "state.ControlsMenuState"
require "state.HighScoreState"
require "state.SubmitScoreState"
require "state.SettingsState"

local Global = require "Global"

State = {}

-- local states = {
-- 	[1] = {
-- 		state = MenuState:new()
-- 	},
-- 	[2] = {
-- 		state = HighScoreState:new()
-- 	},
-- 	[3] = {
-- 		state = ControlsMenuState:new()
-- 	},
-- 	[4] = {
-- 		state = SettingsState:new()
-- 	},
-- 	[5] = {
-- 		state = SubmitScoreState:new()
-- 	},
-- 	[6] = {
-- 		state = GameState:new()
-- 	}
-- }

function State:new()
	local object = {
		name = "",
		currentState = {},
		lastSelectedItem = 1
	}
	setmetatable(object, { __index = State })
	return object
end

-- TODO init all states
function State:set(name)
	if name == nil or (not(self.name == name) and name == "menu") then
		self.currentState = MenuState:new(self.lastSelectedItem)
		self.currentState:init()
	elseif not(self.name == name) and name == "scores" then
		self.currentState = HighScoreState:new()
		self.currentState:init()
	elseif not(self.name == name) and name == "submit" then
		self.currentState = SubmitScoreState:new()
		self.currentState:init()
	elseif not(self.name == name) and name == "controls" then
		self.currentState = ControlsMenuState:new()
		self.currentState:init()
	elseif not(self.name == name) and name == "settings" then
		self.currentState = SettingsState:new()
		self.currentState:init()
	elseif not(self.name == name) and name == "game" then
		self.currentState = GameState:new()
		self.currentState:init()
	elseif not(self.name == name) and name == "exit" then
		Global.scores:save()
		Global.properties:save()
		love.event.quit()
	end
	self.name = name
end

function State:init()
	self.currentState:init()
end

function State:update(dt)
	self.currentState:update(dt)

	if self.currentState.isEnd then
		self:set("submit")
	end
	
	if self.currentState.itemSelected then
		self.lastSelectedItem = self.currentState.itemSelected
	end
end

function State:draw()
	self.currentState:draw()
end

function State:keyreleased(key)
	self.currentState:keyreleased(key)
end

function State:keypressed(key)
	self.currentState:keypressed(key)

	if key == "return" or key == "enter" then
		if (self.currentState.subState) then
			self:set(self.currentState.subState)
		elseif self.currentState.parentMenu then
			self:set(self.currentState.parentMenu)
		end
	end
	if key == "escape" then
		mainTheme:stop()
		if self.currentState.parentMenu then
			self:set(self.currentState.parentMenu)
		else
			self:set("menu")
		end
	end
	if key == "g" then --garbage collector
		print('GARBAGE_COLLECTOR')
		collectgarbage()
	end
	if key == "p" then --pause
		-- self:set(states[1])
		print('PAUSE')
	end
end
