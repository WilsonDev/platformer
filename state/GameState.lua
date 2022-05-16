require "World"

GameState = {}

function GameState:new()
  local object = {
    world = {},
    isEnd = false
  }
  setmetatable(object, { __index = GameState })
  return object
end

function GameState:init()
  self.world.currentMap = self.world.firstMap
  self.world = World:new()
  self.world:init()

  mainTheme:play()

  self.isEnd = false
end

function GameState:update(dt)
  self.world:update(dt)

  if not self.world.player:isAlive(self.world.map) then
    mainTheme:stop()
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

function GameState:getScore()
  return self.world.score
end
