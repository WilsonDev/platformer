EnumUtils = {}

local __enumID = 0

function EnumUtils.enum(names)
	local t = {}
	for _, k in ipairs(names) do
		t[k] = __enumID
		__enumID = __enumID + 1
	end
	return t
end

return EnumUtils