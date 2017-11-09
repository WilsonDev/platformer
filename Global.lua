-- Zmienne globalne

local Global = {
	title = "GENERIC PLATFORMER",
	copyright = "(C) 2017 WILSON",

	debug = true,
	score = 0,
	scores = {},
	gravity = 760, --800

	map = {},
	camera = {},
	scale = 0.25,
	windowHeight = 0,
	windowWidth = 0,

	p = {},
	objects = {},
	-- buttons = {},
	-- enemies = {},
	-- pickups = {},
	-- springs = {},
	-- spikes = {},
	-- platforms = {},
	-- warps = {},
	-- acids = {},
	-- clouds = {},

	firstMap = 5,
	currentMap = 5, --indeks

	audioMute = false
}

return Global
