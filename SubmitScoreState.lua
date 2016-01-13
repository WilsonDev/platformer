SubmitScoreState = {}

function SubmitScoreState:new()
	object = {

	}
	setmetatable(object, { __index = SubmitScoreState })
	return object
end

function SubmitScoreState:init()
	return
end

function SubmitScoreState:update(dt)
	return
end

function SubmitScoreState:draw()
	love.graphics.setColor(31, 31, 31)
	love.graphics.rectangle("fill", 0, 0, 960, 480)
	love.graphics.setColor(255, 255, 255)

	love.graphics.print("Nothing to fear", 10, 5)
  love.graphics.print("(C) 2016 Wilson", 10, 285)

	love.graphics.print("Enter initials", 350, 100)
end

function SubmitScoreState:keyreleased(key)
	return
end

function SubmitScoreState:keypressed(key)
	return
end
