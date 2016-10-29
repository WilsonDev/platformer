Checkpoint = {}

function Checkpoint:new(checkpointX, checkpointY, checkpointYDiffX, checkpointDiffY)
    local object = {
        x = CheckpointX,
        y = CheckpointY,
        diffX = checkpointYDiffX,
        diffY = checkpointDiffY
    }
    setmetatable(object, { __index = Checkpoint })
    return object
end