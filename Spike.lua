local Quad = love.graphics.newQuad

spike = {}

function spike:new(spikeX, spikeY)
	local object = {
	x = spikeX,
	y = spikeY,
	width = 8,
	height = 8,
	iterator = 1,
	Quads = {
		Quad(88, 104, 8, 8, 160, 144)}
	}
	setmetatable(object, { __index = spike })
	return object
end

function spike:update(dt)
	local player = p
	if self:touchesObject(player) then
		if player.invul == false then
			player.invul = true
			player.invultime = 2
			player.hitpoints = player.hitpoints - 1
			auPunch:stop() auPunch:play()
		end
		--player:jump()
	end
end

function spike:touchesObject(object)
	local ax1, ax2 = self.x - self.width / 2, self.x + self.width / 2 - 1
	local ay1, ay2 = self.y - self.height / 2, self.y + self.height / 2 - 1
	local bx1, bx2 = object.x - object.width / 2, object.x + object.width / 2 - 1
	local by1, by2 = object.y - object.height / 2, object.y + object.height / 2 - 1

	return ((ax2 >= bx1) and (ax1 <= bx2) and (ay2 >= by1) and (ay1 <= by2))
end