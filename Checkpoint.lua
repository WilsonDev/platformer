Checkpoint = {}

function Checkpoint:new(checkpointId, checkpointX, checkpointY)
    local object = {
        id = checkpointId,
        x = checkpointX,
        y = checkpointY
    }
    setmetatable(object, { __index = Checkpoint })
    return object
end