require "MenuItem"

HighScoreState = {}

function HighScoreState:new()
	local object = {
		menuItems = {},
		parentMenu = "menu"
	}
	setmetatable(object, { __index = HighScoreState })
	return object
end

function HighScoreState:init()
	for i, score, name in Global.scores() do
		table.insert(self.menuItems, menuItem:new(name .. " " .. score, 10 + 30 * (i - 1)))
	end
end

function HighScoreState:update(dt)
	for _, v in ipairs(self.menuItems) do
		v:update(dt)
	end
end

function HighScoreState:draw()
	love.graphics.setColor(31, 31, 31)
	love.graphics.rectangle("fill", 0, 0, 960, 480)
	love.graphics.setColor(255, 255, 255)

	love.graphics.print("Nothing to fear", 10, 5);
    love.graphics.print("(C) 2016 Wilson", 10, 285);

	for _, v in ipairs(self.menuItems) do
		v:draw()
	end	
end

function HighScoreState:keyreleased(key)
	
end

function HighScoreState:keypressed(key)

end