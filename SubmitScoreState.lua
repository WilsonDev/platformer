SubmitScoreState = {}

function SubmitScoreState:new()
	object = {

	}
	setmetatable(object, { __index = SubmitScoreState })
	return object
end