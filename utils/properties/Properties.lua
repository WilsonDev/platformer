Properties = {}

function Properties:new(propertiesFilename)
  local object = {
    filename = propertiesFilename,
    properties = {}
  }
  setmetatable(object, {
    __index = Properties,
    __call = function(self)
      local i = 0
      return function()
        i = i + 1
        if self.properties[i] then
          return i, unpack(self.properties[i])
        end
      end
    end
  })
  return object
end

function Properties:get(propertyName)
  for i = 1, self:size() do
    local name, value = unpack(self.properties[i])
    if name == propertyName then
      return value
    end
  end
  return
end

function Properties:size()
  return #self.properties
end

function Properties:add(propertyName, propertyValue)
  local score = { propertyName, propertyValue }
  for i = 1, self:size() do
    local name, _ = unpack(self.properties[i])
    if name == propertyName then
      self.properties[i] = score
      return
    end
  end
  self.properties[#self.properties + 1] = score
end

function Properties:load()
  local file = love.filesystem.newFile(self.filename)
  local info = love.filesystem.getInfo(self.filename)

  if not info == nil or not file:open("r") then
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
    local name, value = unpack(self.properties[i])
    file:write(name .. "\t" .. tostring(value) .. "\n")
  end
  return file:close()
end
