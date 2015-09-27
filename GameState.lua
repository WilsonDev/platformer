require "World"

GameState = {}

function GameState:new()
	object = {
		world = {}
	}
	setmetatable(object, { __index = GameState })
	return object
end

function GameState:init()
	self.world = World:new()
	self.world:init()
end

function GameState:update(dt)
	self.world:update(dt)
end

function GameState:draw()
	self.world:draw()
end

function GameState:keyreleased(key)
	self.world:keyreleased(key)	
end