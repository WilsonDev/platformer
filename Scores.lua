Scores = {}

function Scores:new(scoresFilename, scoresPlaces)
	local object = {
		filename = scoresFilename,
		places = scoresPlaces,
		scores = {}
	}
	setmetatable(object, {
		__index = Scores,
		__call = function(self)
			local i = 0
			return function()
				i = i + 1
				if i <= self.places and self.scores[i] then
					return i, unpack(self.scores[i])
				end
			end
		end
	})
	return object
end

function Scores:size()
	return #self.scores
end

function Scores:load()
	local file = love.filesystem.newFile(self.filename)

	if not love.filesystem.exists(self.filename) or not file:open("r") then
		return
	end

	for line in file:lines() do
		local i = line:find('\t', 1, true)
		self.scores[#self.scores + 1] = { tonumber(line:sub(1, i - 1)), line:sub(i + 1) }
	end
	
	return file:close()
end

local function sortScore(a, b)
	return a[1] > b[1]
end

function Scores:add(name, score)
	--print(#self.scores)
	self.scores[#self.scores + 1] = { score, name }
	table.sort(self.scores, sortScore)
end

function Scores:save()
	local file = love.filesystem.newFile(self.filename)

	if not file:open("w") then
		return
	end

	for i = 1, #self.scores do
		item = self.scores[i]
		file:write(item[1] .. "\t" .. item[2] .. "\n")
	end
	return file:close()
end
