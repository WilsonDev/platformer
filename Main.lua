require "Debug"
require "State"
require "Scores"
require "Global"

local state = {}

function love.load()
	windowHeight = love.graphics.getHeight()
	windowWidth = love.graphics.getWidth()
	
	loadReasources()

	Global.scores = Scores:new("scores", 10)
	Global.scores:load()

	state = State:new()
	state:set()
end

function love.update(dt)
	dt = math.min(dt, 0.016)
	state:update(dt)
end

function love.draw()
	state:draw()
end

function love.keyreleased(key)
	state:keyreleased(key)
end

function love.keypressed(key, isrepeat)
	state:keypressed(key)
end

function loadReasources()
	love.graphics.setBackgroundColor(31, 31, 31)
	love.graphics.setDefaultFilter("nearest", "nearest")
	sprite = love.graphics.newImage("images/PixelArtTest.png")
	hud = love.graphics.newImage("images/hud.png")
	font = love.graphics.newFont("images/visitor2.ttf", 38)
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

	if not Global.audioMute then
		love.audio.setVolume(1.0)
	else
		love.audio.setVolume(0.0)
	end
	mainTheme:play()
end