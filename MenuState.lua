require "MenuItem"

MenuState = {}

function MenuState:new()
	local object = {
		menuItems = {},
		itemSelected = 1
	}
	setmetatable(object, { __index = MenuState })
	return object
end

function MenuState:init()
	table.insert(self.menuItems, menuItem:new("New", 100))
	table.insert(self.menuItems, menuItem:new("Scores", 130))
	table.insert(self.menuItems, menuItem:new("Controls", 160))
	table.insert(self.menuItems, menuItem:new("Exit", 190))
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

	love.graphics.print("Nothing to fear", 16, 16);
    love.graphics.print("(C) Wilson", 16, 285);

	for _, v in ipairs(self.menuItems) do
		v:draw()
	end	
end

function MenuState:keyreleased(key)
	if key == "up" and self.itemSelected > 1 then
		self.menuItems[self.itemSelected]:select(false)
		self.itemSelected = self.itemSelected - 1
	end
	if key == "down" and self.itemSelected < #self.menuItems then
		self.menuItems[self.itemSelected]:select(false)
		self.itemSelected = self.itemSelected + 1
	end	
end