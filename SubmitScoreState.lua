SubmitScoreState = {}

local alphabet = {'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i',
            'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r',
            's', 't', 'u', 'v', 'w', 'x', 'y', 'z', '0',
            '1', '2', '3', '4', '5', '6', '7', '8', '9'};

function SubmitScoreState:new()
	object = {
		charSelected = 1,
		itemSelected = 1,
		submitName = {}
	}
	setmetatable(object, { __index = SubmitScoreState })
	return object
end

function SubmitScoreState:init()
	return
end

function SubmitScoreState:update(dt)
	self.submitName[self.itemSelected] = alphabet[self.charSelected]
end

function SubmitScoreState:draw()
	love.graphics.print("Nothing to fear", 10, 5)
  	love.graphics.print("(C) 2016 Wilson", 10, 285)

	love.graphics.print("Enter initials", 350, 100)

	for i, char in ipairs(self.submitName) do
		love.graphics.print(char, 440 + 30 * i, 160)
		love.graphics.rectangle("fill", 438 + 30 * i, 190, 16, 3)
	end
end

function SubmitScoreState:keyreleased(key)
	return
end

function SubmitScoreState:keypressed(key)
	if key == "up" then
    if self.charSelected == #alphabet then
		  self.charSelected = 1
    else
      self.charSelected = self.charSelected + 1
    end
	end
	if key == "down" then
    if self.charSelected == 1 then
		  self.charSelected = #alphabet
    else
      self.charSelected = self.charSelected - 1
    end
	end
	if key == "right" then
		self.charSelected = 1
		self.itemSelected = self.itemSelected + 1
	end
  if key == "return" or key == "enter" then

  end
end
