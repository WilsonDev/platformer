require "entity.MenuItem"

local Global = require "Global"

MenuState = {}

--Istotna jest kolejność podstanów
local subStates = {
	"game",
	"scores",
	"settings",
	"controls",
	"exit"
}

function MenuState:new(stateItemSelected)
	local object = {
		menuItems = {},
		itemSelected = stateItemSelected,
		subState = subStates[stateItemSelected],
		pause = false,
	}
	setmetatable(object, { __index = MenuState })
	return object
end

function MenuState:init()
	table.insert(self.menuItems, MenuItem:new("NEW", 90))
	table.insert(self.menuItems, MenuItem:new("SCORES", 120))
	table.insert(self.menuItems, MenuItem:new("SETTINGS", 150))
	table.insert(self.menuItems, MenuItem:new("CONTROLS", 180))
	table.insert(self.menuItems, MenuItem:new("EXIT", 210))

	self.menuItems[self.itemSelected]:select(true)
end

function MenuState:update(dt)
	self.menuItems[self.itemSelected]:select(true)

	for _, v in ipairs(self.menuItems) do
		v:update(dt)
	end
end

function MenuState:draw()
	love.graphics.print(Global.title, 10, 5)
  	love.graphics.print(Global.copyright, 10, 285)

	for _, v in ipairs(self.menuItems) do
		v:draw()
	end
end

function MenuState:keyreleased(key)
	return
end

function MenuState:keypressed(key)
	if key == "up" then
		self.menuItems[self.itemSelected]:select(false)
		if self.itemSelected > 1 then
			self.itemSelected = self.itemSelected - 1
		else
			self.itemSelected = #self.menuItems
		end

		self.subState = subStates[self.itemSelected]
		soundEvents:play("select")
	end
	if key == "down" then
		self.menuItems[self.itemSelected]:select(false)
		if self.itemSelected < #self.menuItems then
			self.itemSelected = self.itemSelected + 1
		else
			self.itemSelected = 1
		end

		self.subState = subStates[self.itemSelected]
		soundEvents:play("select")
	end
end
