require "MenuItem"

MenuState = {}

local subStates = {
	"game",
	"scores",
	"controls",
	"exit"
}

function MenuState:new()
	local object = {
		menuItems = {},
		itemSelected = 1,
		subState = "game"
	}
	setmetatable(object, { __index = MenuState })
	return object
end

function MenuState:init()
	table.insert(self.menuItems, menuItem:new("New", 95))
	table.insert(self.menuItems, menuItem:new("Scores", 125))
	table.insert(self.menuItems, menuItem:new("Controls", 155))
	table.insert(self.menuItems, menuItem:new("Exit", 185))

	self.menuItems[1]:select(true)
end

function MenuState:update(dt)
	self.menuItems[self.itemSelected]:select(true)

	for _, v in ipairs(self.menuItems) do
		v:update(dt)
	end
end

function MenuState:draw()
	love.graphics.setColor(31, 31, 31)
	love.graphics.rectangle("fill", 0, 0, 960, 480)
	love.graphics.setColor(255, 255, 255)

	love.graphics.print("Nothing to fear", 10, 5)
  love.graphics.print("(C) 2016 Wilson", 10, 285)

	for _, v in ipairs(self.menuItems) do
		v:draw()
	end
end

function MenuState:keyreleased(key)
	return
end

function MenuState:keypressed(key)
	if key == "up" and self.itemSelected > 1 then
		self.menuItems[self.itemSelected]:select(false)
		self.itemSelected = self.itemSelected - 1
		self.subState = subStates[self.itemSelected]
	end
	if key == "down" and self.itemSelected < #self.menuItems then
		self.menuItems[self.itemSelected]:select(false)
		self.itemSelected = self.itemSelected + 1
		self.subState = subStates[self.itemSelected]
	end
end
