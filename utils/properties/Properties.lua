require "utils.properties.SystemProperty"

Properties = {}

function Properties:new(propertiesFilename)
	local object = {
		filename = propertiesFilename,
		properties = {}
	}
	setmetatable(object, { __index = Properties,
		__call = function(self)
			return self.properties
		end
	})
	return object
end

function Properties:get(name)
	for i = 1, #self.properties do
		if self.properties[i].name == name then
			return self.properties[i].value
		end
	end
	return
end

function Properties:size()
	return #self.properties
end

function Properties:add(name, value)
	self.properties[#self.properties + 1] = SystemProperty:new(name, value)
end

function Properties:load()
	local file = love.filesystem.newFile(self.filename)

	if not love.filesystem.exists(self.filename) or not file:open("r") then
		return
	end

	for line in file:lines() do
		local i = line:find('\t', 1, true)
		self:add(line:sub(1, i - 1), line:sub(i + 1))
	end

	return file:close()
end

--TODO save on property change
function Properties:save()
	local file = love.filesystem.newFile(self.filename)

	if not file:open("w") then
		return
	end

	for i = 1, #self.properties do
		item = self.properties[i]
		file:write(item.name .. "\t" .. tostring(item.value) .. "\n")
	end
	return file:close()
end