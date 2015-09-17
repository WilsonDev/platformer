require "Player"
require "Pickup"
require "Enemy"
require "Button"
require "Spring"
require "Spike"
require "Warp"
ATL = require "lib/AdvTiledLoader/Loader"
STI = require "lib/SimpleTiledImpl"

local g = love.graphics
score = 0

world = {}

function world:load(level)
	gravity = 800

	--Mapa
	ATL.path = "maps/"
	map = ATL.load(level)
	map:setDrawRange(0, 0, map.width * map.tileWidth, map.height * map.tileHeight)
	map.layers["objects"].visible = false --warstwa obiektów

	self:init()
end

function world:init()
	p = {} --Bohater
	buttons = {} --Button
	enemies = {} --Przeciwnicy
	pickups = {} --Znajdźki
	springs = {}
	spikes = {}
	warps = {}

	for x, y, tile in map("objects"):iterate() do
		if tile.properties.spawn and not(tile == nil) then
			p = player:new(map.tileWidth * (x + 0.5), map.tileHeight * (y + 0.5))
		end
		if tile.properties.button and not(tile == nil) then
			table.insert(buttons, button:new(map.tileWidth * (x + 0.5), map.tileHeight * (y + 0.5)))
		end
		if tile.properties.spring and not(tile == nil) then
			table.insert(springs, spring:new(map.tileWidth * (x + 0.5), map.tileHeight * (y + 0.5)))
		end
		if tile.properties.spike and not(tile == nil) then
			table.insert(spikes, spike:new(map.tileWidth * (x + 0.5), map.tileHeight * (y + 0.5)))
		end
		if tile.properties.warp and not(tile == nil) then
			table.insert(warps, warp:new(map.tileWidth * (x + 0.5), map.tileHeight * (y + 0.5)))
		end
		if tile.properties.slime and not(tile == nil) then
			table.insert(enemies, slime:new(map.tileWidth * (x + 0.5), map.tileHeight * (y + 0.5)))
		end
		if tile.properties.behemoth and not(tile == nil) then
			table.insert(enemies, behemoth:new(map.tileWidth * (x + 0.5), map.tileHeight * (y + 0.5)))
		end
		if tile.properties.pickup and not(tile == nil) then
			local id = 1
			table.insert(pickups, pickup:new(id, map.tileWidth * (x + 0.5), map.tileHeight * (y + 0.5)))
			id = id + 1
		end
	end
end

function world:update(dt)
	--Aktualizacja bohatera
	p:update(dt, gravity, map)
	--Aktualizacja przeciwników
	for i in ipairs(enemies) do
		enemies[i]:update(dt, gravity, map)
	end
	for j,w in ipairs({pickups, buttons, springs, warps, spikes}) do
		for i,v in ipairs(w) do
			v:update(dt)
		end
	end
end

function world:draw()
	map.useSpriteBatch = true
	map:draw()
	
	--Znajdźki
	for i in ipairs(pickups) do
		g.draw(sprite, pickups[i].Quads, pickups[i].x - (pickups[i].width / 2),
			pickups[i].y - (pickups[i].width / 2))
	end
	--Przeciwnicy
	for i in ipairs(enemies) do
		g.draw(sprite, enemies[i].Quads[enemies[i].iterator], enemies[i].x - (enemies[i].width / 2),
			enemies[i].y - (enemies[i].height / 2), 0, enemies[i].xScale, 1, enemies[i].xOffset)
	end
	--Buttony
	for i in ipairs(buttons) do
		g.draw(sprite, buttons[i].Quads[buttons[i].iterator], buttons[i].x - (buttons[i].width / 2),
			buttons[i].y - (buttons[i].height / 2))
	end
	for i in ipairs(springs) do
		g.draw(sprite, springs[i].Quads[springs[i].iterator], springs[i].x - (springs[i].width / 2),
			springs[i].y - (springs[i].height / 2))
	end
	for i in ipairs(spikes) do
		g.draw(sprite, spikes[i].Quads[spikes[i].iterator], spikes[i].x - (spikes[i].width / 2),
			spikes[i].y - (spikes[i].height / 2))
	end
	p:draw()
end

--Czyszczenie mapy z obiektów
function world:clean()
	for j,w in ipairs({pickups, enemies, buttons, springs, warps, spikes}) do
		for i,v in ipairs(w) do
			table.remove(w, i)
		end
	end
end

function world:change(level)
	self:clean()
	self:load(level)
	camera:setBounds(0, 0, (map.width * map.tileWidth) - (windowWidth * camera.scaleX),
		(map.height * map.tileHeight) - (windowHeight * camera.scaleX))
end