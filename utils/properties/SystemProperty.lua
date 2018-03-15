SystemProperty = {}

function SystemProperty:new(propertyName, propertyValue)
	local object = {
		name = propertyName,
		value = propertyValue
	}
	setmetatable(object, { __index = SystemProperty })
	return object
end