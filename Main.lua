require "Camera"
require "World"
require "Debug"

local love_timer_sleep = love.timer.sleep
local gamestate = "menu"

local DEBUG = true
local SCALE = 0.25
local AUDIO_MUTE = false
local MIN_DT = 1/60

function love.load()
	next_time = love.timer.getTime()

	windowHeight = love.graphics.getHeight()
	windowWidth = love.graphics.getWidth()
	
	loadReasources()

	--Mapa
	world:load("map5.tmx")

	--Kamera
	camera.scaleX = SCALE
	camera.scaleY = SCALE
	camera:setBounds(0, 0, (map.width * map.tileWidth) - (windowWidth * camera.scaleX),
		(map.height * map.tileHeight) - (windowHeight * camera.scaleX))
end

function love.update(dt)
	dt = math.min(dt, 0.07)
	next_time = next_time + MIN_DT

	if gamestate == "menu" then
		--na razie nie ma nic
	else
		world:update(dt)
		
		camera:setPosition(math.floor(p.x - windowWidth / map.tileWidth),
			math.floor(p.y - windowHeight / map.tileHeight))
	end

	if love.keyboard.isDown("return", "enter") then --start
		gamestate = "play"
	end
	if love.keyboard.isDown("escape") then --wyjście
		love.event.quit()
	end
	if love.keyboard.isDown("g") then --garbage collector
		collectgarbage()
	end
	if love.keyboard.isDown("p") then --pause
		gamestate = "menu"
	end
end

function love.draw()
	if gamestate == "menu" then
		love.graphics.setColor(31, 31, 31)
		love.graphics.rectangle("fill", 0, 0, 960, 480)
		love.graphics.setColor(255, 255, 255)
		love.graphics.print("Press Enter to start.", 355, 150)
	else
		camera:set()

		world:draw()

		camera:unset()

		--Informacje
		if DEBUG then
			debug:info(math.floor(p.x + 0.5), math.floor(p.y + 0.5), score)
		end
		
		if p.invul then
			love.graphics.translate(8 * (math.random() - 0.5), 8 * (math.random() - 0.5))
		end
		love.graphics.draw(hud, 792, 10, 0, 4, 4)
		for i = 1,p.hitpoints do
			love.graphics.draw(sprite, heart, 940 - (i * 28), 22, 0, 4, 4)
		end
		for i = 1,(5 - p.firedShots) do
			love.graphics.draw(sprite, clip, 940 - (i * 28), 46, 0, 4, 4)
		end
	end

	local cur_time = love.timer.getTime()
	if next_time <= cur_time then
		next_time = cur_time
		return
	end
	love_timer_sleep(next_time - cur_time)
end

function love.keyreleased(key)
	p:keyreleased(key)
end

function loadReasources()
	--Grafiki, Czcionka, Dźwięki
	love.graphics.setBackgroundColor(31, 31, 31)
	--love.graphics.setBackgroundColor(196, 207, 161)
	love.graphics.setDefaultFilter("nearest", "nearest")
	sprite = love.graphics.newImage("images/PixelArtTest.png")
	hud = love.graphics.newImage("images/hud.png")
	font = love.graphics.newFont("images/visitor1.ttf", 20)
	love.graphics.setFont(font)

	heart = love.graphics.newQuad(32, 40, 8, 8, 160, 144)
	clip = love.graphics.newQuad(16, 32, 8, 8, 160, 144)

	auHit = love.audio.newSource("sounds/hit.wav","static")
	auSelect = love.audio.newSource("sounds/select.wav","static")
	auShot = love.audio.newSource("sounds/shot.wav","static")
	auClickOn = love.audio.newSource("sounds/clickon.wav","static")
	auClickOff = love.audio.newSource("sounds/clickoff.wav","static")
	auPunch = love.audio.newSource("sounds/punch.wav","static")
	auJump = love.audio.newSource("sounds/jump.wav","static")
	
	mainTheme = love.audio.newSource("sounds/Underclocked.mp3")
	mainTheme:setLooping(true)
	mainTheme:setVolume(0.4)
	if not AUDIO_MUTE then
		love.audio.setVolume(1.0)
	else
		love.audio.setVolume(0.0)
	end
	mainTheme:play()
end