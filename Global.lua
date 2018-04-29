-- Zmienne globalne

local Global = {
	title = "GENERIC PLATFORMER",
	copyright = "(C) 2018 WILSON",

	debug = true,

	windowHeight = love.graphics.getHeight(),
	windowWidth = love.graphics.getWidth(),

	properties = {},

	score = 0,
	scores = {},
	gravity = 760, --800

	scale = 0.25,

	map = {},
	camera = {},
	p = {},
	objects = {},

	firstMap = 5,
	currentMap = 5, --indeks
}

return Global
