require "MenuState"
require "GameState"
require "ControlsMenuState"
require "HighScoreState"
require "SubmitScoreState"

State = {}

local states = {
	"menu",
	"scores",
	"controls",
	"submit",
	"game"
}

function State:new()
	object = {
		name = "",
		currentState = {},
		lastSelectedItem = 1
	}
	setmetatable(object, { __index = State })
	return object
end

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
	elseif not(self.name == name) and name == "game" then
		self.currentState = GameState:new()
		self.currentState:init()
	elseif not(self.name == name) and name == "exit" then
		Global.scores:save()
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
		if self.currentState.parentMenu then
			self:set(self.currentState.parentMenu)
		else
			self:set("menu")
		end
	end
	if key == "g" then --garbage collector
		collectgarbage()
	end
	if key == "p" then --pause
		--self:set(states[1])
	end
end
