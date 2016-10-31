require "MenuItem"

MenuState = {}

--Istotna jest kolejność podstanów
local subStates = {
	"game",
	"scores",
	"controls",
	"exit"
}

function MenuState:new(stateItemSelected)
	local object = {
		menuItems = {},
		itemSelected = stateItemSelected,
		subState = subStates[stateItemSelected]
	}
	setmetatable(object, { __index = MenuState })
	return object
end

function MenuState:init()
	table.insert(self.menuItems, MenuItem:new("NEW", 95))
	table.insert(self.menuItems, MenuItem:new("SCORES", 125))
	table.insert(self.menuItems, MenuItem:new("CONTROLS", 155))
	table.insert(self.menuItems, MenuItem:new("EXIT", 185))

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
  	love.graphics.print("(C) 2016 WILSON", 10, 285)

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
		auSelect:stop()
		auSelect:play()
	end
	if key == "down" then
		self.menuItems[self.itemSelected]:select(false)
		if self.itemSelected < #self.menuItems then
			self.itemSelected = self.itemSelected + 1
		else
			self.itemSelected = 1
		end

		self.subState = subStates[self.itemSelected]
		auSelect:stop()
		auSelect:play()
	end
end
