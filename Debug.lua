Debug = {}

function Debug:info(x, y, score)
	local lg = love.graphics
	--love.graphics.setColor(196, 207, 161)
	lg.print("fps: " .. tostring(love.timer.getFPS()) .. " dt: " .. string.format("%.3f", love.timer.getDelta()), 10, 5)
	lg.print("x: " .. tostring(x) .. " y: " .. tostring(y), 10, 25)
	lg.print("mem: " .. tostring(math.floor(collectgarbage("count"))) .. " kb", 10, 45)

	--g.print("Z - jump", 10, 90)
	--g.print("X - shoot", 10, 110)
	--g.print("R - reload", 10, 130)

	--g.print(tostring(love.timer.getTime()), 463, 10)
	lg.print("score: " .. tostring(score), (love.graphics.getWidth() - 100) / 2, 5)
	--g.print("hitpoints: " .. tostring(p.hitpoints), 820, 30)
	--love.graphics.setColor(255, 255, 255)

	local major, minor, revision = love.getVersion()
    local str = string.format("VER: %d.%d.%d", major, minor, revision)
    lg.print(str, 10, 65)
end
