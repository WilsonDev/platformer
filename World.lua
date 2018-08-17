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
require "utils.Camera"

local Global = require "Global"
local CollectionUtils = require "utils.CollectionUtils"
local STI = require "lib.SimpleTiledImpl.sti"

World = {}

function World:new()
	local object = {
		camera = {},
		map = {},
		firstMap = 5,
		currentMap = 5,
		player = {},
		entities = {},
		gravity = 760, --800
		score = 0
	}

	object.camera = Camera:new()
	object.camera.scaleX = Global.scale
	object.camera.scaleY = Global.scale

	setmetatable(object, { __index = World })
	return object
end

function World:init(level)
	self:clean()

	if level == nil then
		level = "map" .. self.currentMap
	end
	-- Mapa
	self.map = STI("resources/maps/" .. level .. ".lua")

	local objectLayer = self.map.layers["objects"]
	objectLayer.visible = false -- Hide object layer

	for k, object in pairs(objectLayer.objects) do
		if object.properties then
			local objectName = object.properties.name
			local objectType = object.properties.type
			local objectPosX = object.x + object.width / 2
			local objectPosY = object.y - object.height / 2

			local entity
			if objectType == 'player' then
				self.player = Player:new(objectName, objectPosX, objectPosY)
			elseif objectType == 'button' then
				entity = Button:new(objectName, objectPosX, objectPosY, object.properties)
			elseif objectType == 'spring' then
				entity = Spring:new(objectName, objectPosX, objectPosY, object.properties)
			elseif objectType == 'spike' then
				entity = Spike:new(objectName, objectPosX, objectPosY)
			elseif objectType == 'warp' then
				entity = Warp:new(objectName, objectPosX, objectPosY)
			elseif objectType == 'slime' then
				entity = Slime:new(objectName, objectPosX, objectPosY)
			elseif objectType == 'behemoth' then
				entity = Behemoth:new(objectName, objectPosX, objectPosY)
			elseif objectType == 'mega_behemoth' then
				entity = MegaBehemoth:new(objectName, objectPosX, objectPosY)
			elseif objectType == 'platform' then
				entity = Platform:new(objectName, objectPosX, objectPosY, object.properties)
			elseif objectType == 'acid' then
				entity = Acid:new(objectName, objectPosX, objectPosY)
			elseif objectType == 'pickup' then
				entity = Pickup:new(objectName, objectPosX, objectPosY, object.properties)
			end

			if entity then
				CollectionUtils.addToTable(self.entities, objectType, objectName, entity)
			end
		end
	end

	self.camera:setBounds(0, 0, (self.map.width * self.map.tilewidth) - (Global.windowWidth * self.camera.scaleX),
		(self.map.height * self.map.tileheight) - (Global.windowHeight * self.camera.scaleX))
end

function World:update(dt)
	self.player:update(dt, self)
	self.map:update(dt)

	for _, v in pairs(self.entities) do
		for _, w in pairs(v) do
			w:update(dt, self)
		end
	end

	if self.camera.activated then
		self.camera:flowX(dt, self.player.x - Global.windowWidth / self.map.tilewidth,
			self.player.y - Global.windowHeight / self.map.tileheight, 80)
	else
		self.camera:setPosition(self.player.x - Global.windowWidth / self.map.tilewidth,
			self.player.y - Global.windowHeight / self.map.tileheight)
	end
end

function World:draw()
	self.camera:set()

	self.map:draw()

	for _, v in pairs(self.entities) do
		for _, w in pairs(v) do
			w:draw()
		end
	end

	self.player:draw()

	self.camera:unset()

	if self.player.immune then
		love.graphics.translate(8 * (math.random() - 0.5), 8 * (math.random() - 0.5))
	end
	if Global.debug then
		Debug:info(math.floor(self.player.x + 0.5), math.floor(self.player.y + 0.5), self.score)
	end
	love.graphics.draw(hud, love.graphics.getWidth() - 168, 10, 0, 4, 4)
	for i = 1, self.player.hitpoints do
		love.graphics.draw(sprite, heart, love.graphics.getWidth() - 20 - (i * 28), 22, 0, 4, 4)
	end
	for i = 1, (5 - self.player.firedShots) do
		love.graphics.draw(sprite, clip, love.graphics.getWidth() - 20 - (i * 28), 46, 0, 4, 4)
	end
end

--Czyszczenie mapy z obiektów
function World:clean()
	for k, v in pairs(self.entities) do
		for l, w in pairs(v) do
			self.entities[k][l] = nil
		end
		self.entities[k] = nil
	end
end

function World:change(level)
	self:init(level)
	self.camera:setBounds(0, 0, (self.map.width * self.map.tilewidth) - (Global.windowWidth * self.camera.scaleX),
		(self.map.height * self.map.tileheight) - (Global.windowHeight * self.camera.scaleX))
end

function World:keyreleased(key)
	self.player:keyreleased(key)
end

function World:keypressed(key)
	self.player:keypressed(key)

	if key == "l" then
		if self.camera.stop == false then
			self.camera.stop = true
		else
			self.camera.stop = false
			self.camera.activated = true
		end
	end
end
