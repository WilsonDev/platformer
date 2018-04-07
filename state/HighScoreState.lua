require "utils.MenuItem"

local Global = require "Global"

HighScoreState = {}

function HighScoreState:new()
	local object = {
		parentMenu = "menu"
	}
	setmetatable(object, { __index = HighScoreState })
	return object
end

function HighScoreState:init()
	return
end

function HighScoreState:update(dt)
	return
end

function HighScoreState:draw()
	love.graphics.print(Global.title, 10, 5)
	love.graphics.print(Global.copyright, 10, 285)

	local prefix = ""
	for i, score, name in Global.scores() do
		if i == 1 then
			prefix = "1ST"
		elseif i == 2 then
			prefix = "2ND"
		elseif i == 3 then
			prefix = "3RD"
		else
			prefix = i .. "TH"
		end
		love.graphics.print(prefix, 355, 10 + 30 * (i - 1))
		love.graphics.print(name, 455, 10 + 30 * (i - 1))
		love.graphics.print(score, 555, 10 + 30 * (i - 1))
	end
end

function HighScoreState:keyreleased(key)
	return
end

function HighScoreState:keypressed(key)
	return
end