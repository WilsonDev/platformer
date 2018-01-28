require "Debug"
require "state.State"
require "Scores"
require "event.SoundEvents"

local MathUtils = require "utils.MathUtils"
local StringUtils = require "utils.StringUtils"
local Global = require "Global"

local initScores
local state = {}

function love.load()
	Global.windowHeight = love.graphics.getHeight()
	Global.windowWidth = love.graphics.getWidth()

	loadReasources()

	Global.scores = Scores:new("scores", 10)
	Global.scores:load()

	initScores()

	state = State:new()
	state:set()
end

function initScores() 
	if #Global.scores == 0 then
		for i = 1,10 do
			Global.scores:add("AAA", 0)
		end
		Global.scores:save()
	end
end

function love.update(dt)
	dt = MathUtils.clamp(dt, 0, 0.05) --math.min(dt, 0.016)
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
	soundEvents = SoundEvents:new(false)
	-- soundEvents:add("hit")
	-- soundEvents:hook("hit", hookTest)
	-- soundEvents:invoke("hit")

	love.graphics.setBackgroundColor(31, 31, 31)
	love.graphics.setDefaultFilter("nearest", "nearest")
	sprite = love.graphics.newImage("resources/images/PixelArtTest.png")
	hud = love.graphics.newImage("resources/images/hud.png")
	font = love.graphics.newFont("resources/images/visitor2.ttf", 38)
	love.graphics.setFont(font)

	heart = love.graphics.newQuad(32, 40, 8, 8, 160, 144)
	clip = love.graphics.newQuad(16, 32, 8, 8, 160, 144)

	soundEvents:addSound("hit", love.audio.newSource("resources/sounds/hit.wav", "static"))
	soundEvents:addSound("select", love.audio.newSource("resources/sounds/select.wav", "static"))
	soundEvents:addSound("shot", love.audio.newSource("resources/sounds/shot.wav", "static"))
	soundEvents:addSound("click_on", love.audio.newSource("resources/sounds/clickon.wav", "static"))
	soundEvents:addSound("click_off", love.audio.newSource("resources/sounds/clickoff.wav", "static"))
	soundEvents:addSound("punch", love.audio.newSource("resources/sounds/punch.wav", "static"))
	soundEvents:addSound("jump", love.audio.newSource("resources/sounds/jump.wav", "static"))
	soundEvents:addSound("warp", love.audio.newSource("resources/sounds/warp.wav", "static"))

	mainTheme = love.audio.newSource("resources/sounds/Underclocked.mp3")
	mainTheme:setLooping(true)
	mainTheme:setVolume(0.5)

	if Global.audio.value then
		love.audio.setVolume(1.0)
	else
		love.audio.setVolume(0.0)
	end
end
