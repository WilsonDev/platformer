PlatformCheckpoint = {}

function PlatformCheckpoint:new(checkpointId, checkpointX, checkpointY)
  local object = {
    id = checkpointId,
    x = checkpointX,
    y = checkpointY
  }
  setmetatable(object, { __index = PlatformCheckpoint })
  return object
end
