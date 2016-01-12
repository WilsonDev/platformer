require "World"

GameState = {}

function GameState:new()
	object = {
		world = {},
		isEnd = false
	}
	setmetatable(object, { __index = GameState })
	return object
end

function GameState:init()
	self.world = World:new()
	self.world:init()

	self.isEnd = false
end

function GameState:update(dt)
	self.world:update(dt)

	if not Global.p:isAlive() then
		self.isEnd = true
	end
end

function GameState:draw()
	self.world:draw()
end

function GameState:keyreleased(key)
	self.world:keyreleased(key)	
end

function GameState:keypressed(key)
	self.world:keypressed(key)	
end