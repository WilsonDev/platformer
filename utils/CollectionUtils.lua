local CollectionUtils = {}

function CollectionUtils.addToTable(table, k1, k2, value)
	if table[k1] == nil then
		rawset(table, k1, {})
	end
	rawset(table[k1], k2, value)
end

return CollectionUtils