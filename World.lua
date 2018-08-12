require "Camera"
require "entity.Player"
require "entity.Pickup"
require "entity.Slime"
require "entity.Behemoth"
require "entity.MegaBehemoth"
require "entity.Button"
require "entity.Spring"
require "entity.Spike"
require "entity.Warp"
require "entity.Acid"
require "entity.platform.Platform"
require "entity.Cloud"

local Global = require "Global"
local STI = require "lib/SimpleTiledImpl/sti"
local addToTable

World = {}

function World:new()
	local object = {}
	setmetatable(object, { __index = World })
	return object
end

function World:init(level)
	self:clean()

	if level == nil then
		level = "map" .. Global.currentMap
	end
	-- Mapa
	Global.map = STI("resources/maps/" .. level .. ".lua")

	-- Chowamy warstwę obiektów
	Global.map.layers["objects"].visible = false
	local objectLayer = Global.map.layers["objects"]

	for k, object in pairs(objectLayer.objects) do
		if object.properties then
			local objectName = object.properties.name
			if object.properties.type == 'player' then
				Global.player = Player:new(objectName, object.x + object.width / 2, object.y - object.height / 2)
			end
			if object.properties.type == 'button' then
				local button = Button:new(objectName, object.x + object.width / 2, object.y - object.height / 2)
				button.interact = object.properties.interact
				addToTable(Global.objects, object.properties.type, objectName, button)
			end
			if object.properties.type == 'spring' then
				local spring = Spring:new(objectName, object.x + object.width / 2, object.y - object.height / 2)
				if object.properties.power then
					spring.power = object.properties.power
				end
				addToTable(Global.objects, object.properties.type, objectName, spring)
			end
			if object.properties.type == 'spike' then
				local spike = Spike:new(objectName, object.x + object.width / 2, object.y - object.height / 2)
				addToTable(Global.objects, object.properties.type, objectName, spike)
			end
			if object.properties.type == 'warp' then
				local warp = Warp:new(objectName, object.x + object.width / 2, object.y - object.height / 2)
				addToTable(Global.objects, object.properties.type, objectName, warp)
			end
			if object.properties.type == 'slime' then
				local slime = Slime:new(objectName, object.x + object.width / 2, object.y - object.height / 2)
				addToTable(Global.objects, object.properties.type, objectName, slime)
			end
			if object.properties.type == 'behemoth' then
				local behemoth = Behemoth:new(objectName, object.x + object.width / 2, object.y - object.height / 2)
				addToTable(Global.objects, object.properties.type, objectName, behemoth)
			end
			if object.properties.type == 'mega_behemoth' then
				local behemoth = MegaBehemoth:new(objectName, object.x + object.width / 2, object.y - object.height / 2)
				addToTable(Global.objects, object.properties.type, objectName, behemoth)
			end
			if object.properties.type == 'platform' then
				local platform = Platform:new(objectName, object.x + object.width / 2, object.y - object.height / 2, object.properties.path, object.properties.size)
				addToTable(Global.objects, object.properties.type, objectName, platform)
			end
			if object.properties.type == 'acid' then
				local acid = Acid:new(objectName, object.x + object.width / 2, object.y - object.height / 2)
				addToTable(Global.objects, object.properties.type, objectName, acid)
			end
			if object.properties.type == 'pickup' then
				local pickup = Pickup:new(objectName, object.x + object.width / 2, object.y - object.height / 2, object.properties.value)
				addToTable(Global.objects, object.properties.type, objectName, pickup)
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

function addToTable(table, k1, k2, value)
	if table[k1] == nil then
		rawset(table, k1, {})
	end
	rawset(table[k1], k2, value)
end

function World:update(dt)
	Global.player:update(dt)
	Global.map:update(dt)

	for _, v in pairs(Global.objects) do
		for _, w in pairs(v) do
			w:update(dt)
		end
	end

	if Global.camera.activated then
		Global.camera:flowX(dt, Global.player.x - Global.windowWidth / Global.map.tilewidth,
			Global.player.y - Global.windowHeight / Global.map.tileheight, 80)
	else
		Global.camera:setPosition(Global.player.x - Global.windowWidth / Global.map.tilewidth,
			Global.player.y - Global.windowHeight / Global.map.tileheight)
	end
end

function World:draw()
	Global.camera:set()

	--removed in STI v0.18.1.0
	--Global.map:setDrawRange(0, 0, Global.map.width * Global.map.tilewidth, Global.map.height * Global.map.tileheight)
	Global.map:draw()

	for _, v in pairs(Global.objects) do
		for _, w in pairs(v) do
			w:draw()
		end
	end

	Global.player:draw()

	Global.camera:unset()

	if Global.player.immune then
		love.graphics.translate(8 * (math.random() - 0.5), 8 * (math.random() - 0.5))
	end
	if Global.debug then
		Debug:info(math.floor(Global.player.x + 0.5), math.floor(Global.player.y + 0.5), Global.score)
	end
	love.graphics.draw(hud, love.graphics.getWidth() - 168, 10, 0, 4, 4)
	for i = 1, Global.player.hitpoints do
		love.graphics.draw(sprite, heart, love.graphics.getWidth() - 20 - (i * 28), 22, 0, 4, 4)
	end
	for i = 1, (5 - Global.player.firedShots) do
		love.graphics.draw(sprite, clip, love.graphics.getWidth() - 20 - (i * 28), 46, 0, 4, 4)
	end
end

--Czyszczenie mapy z obiektów
function World:clean()
	for k, v in pairs(Global.objects) do
		for l, w in pairs(v) do
			Global.objects[k][l] = nil
		end
		Global.objects[k] = nil
	end
end

function World:change(level)
	self:init(level)
	Global.camera:setBounds(0, 0, (Global.map.width * Global.map.tilewidth) - (Global.windowWidth * Global.camera.scaleX),
		(Global.map.height * Global.map.tileheight) - (Global.windowHeight * Global.camera.scaleX))
end

function World:keyreleased(key)
	Global.player:keyreleased(key)
end

function World:keypressed(key)
	Global.player:keypressed(key)

	if key == "l" then
		if Global.camera.stop == false then
			Global.camera.stop = true
		else
			Global.camera.stop = false
			Global.camera.activated = true
		end
	end
end
