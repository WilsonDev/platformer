require "utils.Animation"

local Quad = love.graphics.newQuad

Behemoth = {}
--Dziedziczenie po klasie Slime
setmetatable(Behemoth, { __index = Slime })

function Behemoth:new(objectName, behemothX, behemothY)
	local object = {
		name = objectName,
		x = behemothX, y = behemothY,
		width = 8, height = 8,
		xSpeed = 0, ySpeed = 0,
		state = "move",
		hitpoints = 2,
		runSpeed = 40,
		onGround = false,
		xScale = 1,
		xOffset = 0,
		animations = {
			move = {
				operator = Animation:new(0.14, 4,
				{
					Quad( 0, 0, 8, 8, 160, 144),
					Quad(24, 0, 8, 8, 160, 144),
					Quad(32, 0, 8, 8, 160, 144),
					Quad(40, 0, 8, 8, 160, 144)
				})
			}
		}
	}

	setmetatable(object, { __index = Behemoth })
	return object
end
