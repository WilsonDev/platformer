require "state.MenuState"
require "state.GameState"
require "state.ControlsMenuState"
require "state.HighScoreState"
require "state.SubmitScoreState"
require "state.SettingsState"

local Global = require "Global"
local STATES = require "state.constants.States"
local STATE_NAMES = require "state.constants.StateNames"

State = {}

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
function State:set(name, additionalConfig)
  local StateToSet = STATES[STATE_NAMES.MENU]

  if name == STATE_NAMES.EXIT then
    Global.scores:save()
    Global.properties:save()
    love.event.quit()
    return
  end

  if name and not(self.name == name) then
    StateToSet = STATES[name]
  end

  local config = {
    lastSelectedItem = self.lastSelectedItem
  }

  if (additionalConfig) then
    for k, v in pairs(additionalConfig) do
      config[k] = v
    end
  end

  self.currentState = StateToSet:new(config)
  self.currentState:init()

  self.name = name
end

function State:init()
  self.currentState:init()
end

function State:update(dt)
  self.currentState:update(dt)

  if self.currentState.isEnd then
    local config = {
      score = self.currentState:getScore()
    }
    self:set(STATE_NAMES.SUBMIT_SCORE, config)
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
