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
	local prefix
	for i, score, name in Global.scores() do
		if i == 1 then
			prefix = "1st"
		elseif i == 2 then
			prefix = "2nd"
		elseif i == 3 then
			prefix = "3rd"
		else
			prefix = i .. "th"
		end
		table.insert(self.menuItems, menuItem:new(prefix .. " " .. name .. " " .. score, 10 + 30 * (i - 1)))
	end
end

function HighScoreState:update(dt)
	for _, v in ipairs(self.menuItems) do
		v:update(dt)
	end
end

function HighScoreState:draw()
	love.graphics.print("Nothing to fear", 10, 5)
  	love.graphics.print("(C) 2016 Wilson", 10, 285)

	for _, v in ipairs(self.menuItems) do
		v:draw()
	end
end

function HighScoreState:keyreleased(key)
	return
end

function HighScoreState:keypressed(key)
	return
end
