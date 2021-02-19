require "utils.MenuItem"

local Global = require "Global"

SettingsState = {}

function SettingsState:new()
  local object = {
    parentMenu = "menu",
    menuItems = {},
    entrySelected = 1
  }
  setmetatable(object, { __index = SettingsState })
  return object
end

function SettingsState:init()
  for i, name, value in Global.properties() do
    table.insert(self.menuItems, MenuItem:new(name .. ' ' .. tostring(value), 90 + 30 * (i - 1)))
  end

  self.menuItems[self.entrySelected]:select(true)
end

function SettingsState:update(dt)
  self.menuItems[self.entrySelected]:select(true)

  for _, v in ipairs(self.menuItems) do
    v:update(dt)
  end
end

function SettingsState:draw()
  for _, v in ipairs(self.menuItems) do
    v:draw()
  end
end

function SettingsState:keyreleased(key)
  return
end

function SettingsState:keypressed(key)
  if key == "up" then
    self.menuItems[self.entrySelected]:select(false)
    if self.entrySelected > 1 then
      self.entrySelected = self.entrySelected - 1
    else
      self.entrySelected = #self.menuItems
    end

    soundEvents:play("select")
  end
  if key == "down" then
    self.menuItems[self.entrySelected]:select(false)
    if self.entrySelected < #self.menuItems then
      self.entrySelected = self.entrySelected + 1
    else
      self.entrySelected = 1
    end

    soundEvents:play("select")
  end
  if key == "left" or key == "right" then
    local name, value = unpack(Global.properties.properties[self.entrySelected])
    local booleanValue = (tostring(value) == "true")
    Global.properties:add(name, not booleanValue)
    self.menuItems[self.entrySelected]:setLabel(name .. ' ' .. tostring(not booleanValue))

    Global.propertiesEvents:invoke(name)
  end
end
