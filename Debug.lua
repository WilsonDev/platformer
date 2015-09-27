debug = {}

function debug:info(x, y, score)
	local g = love.graphics
	--love.graphics.setColor(196, 207, 161)
	g.print("fps: " .. tostring(love.timer.getFPS()) .. " dt: " .. string.format("%.3f", love.timer.getDelta()), 10, 10)
	g.print("x: " .. tostring(x) .. " y: " .. tostring(y), 10, 30)
	g.print("mem: " .. tostring(math.floor(collectgarbage("count"))) .. " kb", 10, 50)
	
	g.print("Z - jump", 10, 90)
	g.print("X - shoot", 10, 110)
	g.print("R - reload", 10, 130)

	--g.print(tostring(love.timer.getTime()), 463, 10)
	g.print("score: " .. tostring(score), 430, 10)
	--g.print("hitpoints: " .. tostring(p.hitpoints), 820, 30)
	--love.graphics.setColor(255, 255, 255)
end