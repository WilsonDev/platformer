require "MenuState"
require "GameState"
require "HighScoreState"

State = {}

local states = {
	"menu",
	"scores",
	"game"
}

function State:new()
	object = {
		name = "",
		currentState = {}
	}
	setmetatable(object, { __index = State })
	return object
end

function State:set(name)
	if not name == nil then 
		print(not(self.name == name) .. " " .. self.name .. " " .. name)
	end

	if name == nil or (not(self.name == name) and name == "menu") then
		self.currentState = MenuState:new()
		self.currentState:init()
	elseif not(self.name == name) and name == "scores" then 
		self.currentState = HighScoreState:new()
		self.currentState:init()
	elseif not(self.name == name) and name == "game" then 
		self.currentState = GameState:new()
		self.currentState:init()
	elseif not(self.name == name) and name == "exit" then
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
		Global.scores:add("ABC", Global.score)
		self:set(states[2])
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
		    self:set(states[1])
		end
	end
	if key == "g" then --garbage collector
		collectgarbage()
	end
	if key == "p" then --pause
		--self:set(states[1])
	end
end