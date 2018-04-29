require "utils.MenuItem"

local Global = require "Global"

SettingsState = {}

function SettingsState:new()
	local object = {
		parentMenu = "menu",
		menuItems = {},
		itemSelected = 1
	}
	setmetatable(object, { __index = SettingsState })
	return object
end

function SettingsState:init()
	for i, name, value in Global.properties() do
		table.insert(self.menuItems, MenuItem:new(name .. ' ' .. tostring(value), 90 + 30 * (i - 1)))
	end

	self.menuItems[self.itemSelected]:select(true)
end

function SettingsState:update(dt)
	self.menuItems[self.itemSelected]:select(true)

	for _, v in ipairs(self.menuItems) do
		v:update(dt)
	end
end

function SettingsState:draw()
	love.graphics.print(Global.title, 10, 5)
	love.graphics.print(Global.copyright, 10, 285)

	for _, v in ipairs(self.menuItems) do
		v:draw()
	end
end

function SettingsState:keyreleased(key)
	return
end

function SettingsState:keypressed(key)
	if key == "up" then
		self.menuItems[self.itemSelected]:select(false)
		if self.itemSelected > 1 then
			self.itemSelected = self.itemSelected - 1
		else
			self.itemSelected = #self.menuItems
		end

		soundEvents:play("select")
	end
	if key == "down" then
		self.menuItems[self.itemSelected]:select(false)
		if self.itemSelected < #self.menuItems then
			self.itemSelected = self.itemSelected + 1
		else
			self.itemSelected = 1
		end

		soundEvents:play("select")
	end
	if key == "left" or key == "right" then
		local name, value = unpack(Global.properties.properties[self.itemSelected])
		local booleanValue = (tostring(value) == "true")
		Global.properties:add(name, not booleanValue)
		self.menuItems[self.itemSelected]:setLabel(name .. ' ' .. tostring(not booleanValue))

		propertiesEvents:invoke(name)
	end
end