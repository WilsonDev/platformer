require "utils.MenuItem"

local Global = require "Global"

MenuState = {}

local subStates = {
	[1] = {
		label = "NEW",
		state = "game"
	},
	[2] = {
		label = "SCORES",
		state = "scores"
	},
	[3] = {
		label = "SETTINGS",
		state = "settings"
	},
	[4] = {
		label = "CONTROLS",
		state = "controls"
	},
	[5] = {
		label = "EXIT",
		state = "exit"
	}
}

function MenuState:new(stateItemSelected)
	local object = {
		menuItems = {},
		itemSelected = stateItemSelected or 1,
		subState = subStates[stateItemSelected or 1].state,
		pause = false,
	}
	setmetatable(object, { __index = MenuState })
	return object
end

function MenuState:init()
	for i, v in ipairs(subStates) do
		table.insert(self.menuItems, MenuItem:new(v.label, 90 + 30 * (i - 1)))
	end

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

		self.subState = subStates[self.itemSelected].state
		soundEvents:play("select")
	end
	if key == "down" then
		self.menuItems[self.itemSelected]:select(false)
		if self.itemSelected < #self.menuItems then
			self.itemSelected = self.itemSelected + 1
		else
			self.itemSelected = 1
		end

		self.subState = subStates[self.itemSelected].state
		soundEvents:play("select")
	end
end