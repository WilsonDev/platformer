require "Camera"
require "Player"
require "Pickup"
require "Enemy"
require "Behemoth"
require "Button"
require "Spring"
require "Spike"
require "Warp"
require "Acid"
require "Platform"
sti = require "lib/SimpleTiledImpl"

World = {}

function World:new()
	object = {}
	setmetatable(object, { __index = World})
	return object
end

function World:init(level)
	if level == nil then
		level = "map6"
	end
	-- Mapa
	Global.map = sti.new("maps/" .. level .. ".lua")
	-- Chowamy warstwę obiektów
	Global.map.layers["objects"].visible = false

	local layer = Global.map.layers["objects"]

	for y = 1, Global.map.height do
		for x = 1, Global.map.width do
			local tile = layer.data[y][x]

			if tile and tile.properties then
				if tile.properties.spawn and tile then
					Global.p = Player:new(Global.map.tilewidth * (x - 0.5), Global.map.tileheight * (y - 0.5))
				end
				if tile.properties.button and tile then
					table.insert(Global.buttons, 
						Button:new(Global.map.tilewidth * (x - 0.5), Global.map.tileheight * (y - 0.5)))
				end
				if tile.properties.spring and tile then
					table.insert(Global.springs, 
						Spring:new(Global.map.tilewidth * (x - 0.5), Global.map.tileheight * (y - 0.5)))
				end
				if tile.properties.spike and tile then
					table.insert(Global.spikes, 
						Spike:new(Global.map.tilewidth * (x - 0.5), Global.map.tileheight * (y - 0.5)))
				end
				if tile.properties.warp and tile then
					table.insert(Global.warps, 
						Warp:new(Global.map.tilewidth * (x - 0.5), Global.map.tileheight * (y - 0.5)))
				end
				if tile.properties.slime and tile then
					table.insert(Global.enemies, 
						Slime:new(Global.map.tilewidth * (x - 0.5), Global.map.tileheight * (y - 0.5)))
				end
				if tile.properties.behemoth and tile then
					table.insert(Global.enemies, 
						Behemoth:new(Global.map.tilewidth * (x - 0.5), Global.map.tileheight * (y - 0.5)))
				end
				if tile.properties.platform and tile then
					table.insert(Global.platforms, 
						Platform:new(Global.map.tilewidth * (x - 0.5), Global.map.tileheight * (y - 0.5)))
				end
				if tile.properties.acid and tile then
					table.insert(Global.acids, 
						Acid:new(Global.map.tilewidth * (x - 0.5), Global.map.tileheight * (y - 0.5)))
				end
				if tile.properties.pickup and tile then
					local id = 1
					table.insert(Global.pickups, 
						Pickup:new(id, Global.map.tilewidth * (x - 0.5), Global.map.tileheight * (y - 0.5)))
					id = id + 1
				end
			end
		end
	end

	-- Kamera
	Global.camera = Camera:new()
	Global.camera.scaleX = Global.scale
	Global.camera.scaleY = Global.scale
	Global.camera:setBounds(0, 0, (Global.map.width * Global.map.tilewidth) - (windowWidth * Global.camera.scaleX),
		(Global.map.height * Global.map.tileheight) - (windowHeight * Global.camera.scaleX))
end

function World:update(dt)
	Global.p:update(dt)

	for _, v in ipairs({
		Global.pickups, 
		Global.enemies,
		Global.buttons, 
		Global.springs,
		Global.platforms, 
		Global.warps,
		Global.acids,
		Global.spikes}) do

		for _, w in ipairs(v) do
			w:update(dt)
		end
	end

	Global.camera:setPosition(Global.p.x - windowWidth / Global.map.tilewidth,
		Global.p.y - windowHeight / Global.map.tileheight)
end

function World:draw()
	Global.camera:set()

	Global.map:setDrawRange(0, 0, Global.map.width * Global.map.tilewidth, Global.map.height * Global.map.tileheight)
	Global.map:draw()

	for _, v in ipairs({
		Global.pickups, 
		Global.enemies,
		Global.buttons, 
		Global.springs,
		Global.platforms,
		Global.warps,
		Global.acids, 
		Global.spikes}) do

		for _, w in ipairs(v) do
			w:draw()
		end
	end

	Global.p:draw()

	Global.camera:unset()

	if Global.debug then
		debug:info(math.floor(Global.p.x + 0.5), math.floor(Global.p.y + 0.5), Global.score)
	end
	
	if Global.p.invul then
		love.graphics.translate(8 * (math.random() - 0.5), 8 * (math.random() - 0.5))
	end
	love.graphics.draw(hud, 792, 10, 0, 4, 4)
	for i = 1, Global.p.hitpoints do
		love.graphics.draw(sprite, heart, 940 - (i * 28), 22, 0, 4, 4)
	end
	for i = 1,(5 - Global.p.firedShots) do
		love.graphics.draw(sprite, clip, 940 - (i * 28), 46, 0, 4, 4)
	end
end

function World:keyreleased(key)
	Global.p:keyreleased(key)
end

--Czyszczenie mapy z obiektów
function World:clean()
	for _, v in ipairs({
		Global.pickups, 
		Global.enemies,
		Global.buttons, 
		Global.springs,
		Global.platforms,
		Global.warps,
		Global.acids,
		Global.spikes}) do

		for j, w in ipairs(v) do
			table.remove(v, j)
		end
	end
end

function World:change(level)
	self:clean()
	self:init(level)
	Global.camera:setBounds(0, 0, (Global.map.width * Global.map.tilewidth) - (windowWidth * Global.camera.scaleX),
		(Global.map.height * Global.map.tileheight) - (windowHeight * Global.camera.scaleX))
end