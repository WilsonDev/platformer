-- Zmienne globalne

local Global = {
	title = "GENERIC PLATFORMER",
	copyright = "(C) 2017 WILSON",

	debug = true,
	audioMute = false,

	windowHeight = 0,
	windowWidth = 0,
	vsync = true,

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
