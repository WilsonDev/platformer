require "MenuState"
require "GameState"

State = {}

local states = {
	"menu",
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
	if name == nil or (not(self.name == name) and name == "menu") then
		self.currentState = MenuState:new()
		self.currentState:init()
	elseif not(self.name == name) and name == "game" then 
		self.currentState = GameState:new()
		self.currentState:init()
	end
	self.name = name
end

function State:init()
	self.currentState:init()
end

function State:update(dt)
	self.currentState:update(dt)


	if love.keyboard.isDown("return", "enter") then --start
		self:set(states[2])
	end
	if love.keyboard.isDown("escape") then --wyjście
		love.event.quit()
	end
	if love.keyboard.isDown("g") then --garbage collector
		collectgarbage()
	end
	if love.keyboard.isDown("p") then --pause
		self:set(states[1])
	end
end

function State:draw()
	self.currentState:draw()
end

function State:keyreleased(key)
	self.currentState:keyreleased(key)
end