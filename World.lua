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
local STI = require "lib/SimpleTiledImpl/sti"

World = {}

function World:new()
	object = {}
	setmetatable(object, { __index = World})
	return object
end

function World:init(level)
	self:clean()

	if level == nil then
		level = "map5"
	end
	-- Mapa
	Global.map = STI("maps/" .. level .. ".lua")
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
	Global.camera:setBounds(0, 0, (Global.map.width * Global.map.tilewidth) - (Global.windowWidth * Global.camera.scaleX),
		(Global.map.height * Global.map.tileheight) - (Global.windowHeight * Global.camera.scaleX))
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

	if Global.camera.activated then
		Global.camera:flowX(dt, Global.p.x - Global.windowWidth / Global.map.tilewidth,
			Global.p.y - Global.windowHeight / Global.map.tileheight, 80)
	else
		Global.camera:setPosition(Global.p.x - Global.windowWidth / Global.map.tilewidth,
			Global.p.y - Global.windowHeight / Global.map.tileheight)
	end
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

	if Global.p.invul then
		love.graphics.translate(8 * (math.random() - 0.5), 8 * (math.random() - 0.5))
	end
	if Global.debug then
		Debug:info(math.floor(Global.p.x + 0.5), math.floor(Global.p.y + 0.5), Global.score)
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

function World:keypressed(key)
	Global.p:keypressed(key)

	if key == "l" then
		if Global.camera.stop == false then
			Global.camera.stop = true
		else
			Global.camera.stop = false
			Global.camera.activated = true
		end
	end
end

--Czyszczenie mapy z obiektów
function World:clean()
	for i, v in ipairs({
		Global.pickups,
		Global.enemies,
		Global.buttons,
		Global.springs,
		Global.platforms,
		Global.warps,
		Global.acids,
		Global.spikes}) do

		for i = 0, #v do
			v[i] = nil
		end
	end
end

function World:change(level)
	self:init(level)
	Global.camera:setBounds(0, 0, (Global.map.width * Global.map.tilewidth) - (Global.windowWidth * Global.camera.scaleX),
		(Global.map.height * Global.map.tileheight) - (Global.windowHeight * Global.camera.scaleX))
end
