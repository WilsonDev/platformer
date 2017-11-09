require "event.Events"

SoundEvents = {}

setmetatable(SoundEvents, { __index = Events })

function SoundEvents:new(must_exist)
    local object = {
        handlers = {},
        event_must_exist = (must_exist == nil) or must_exist
    }
    setmetatable(object, { __index = SoundEvents })
    return object
end

function SoundEvents:addSound(evt_type, sound)
    local function play()
        print(sound)
        sound:stop()
        sound:play()
    end 

    self:hook(evt_type, play)
end

function SoundEvents:play(evt_type)
    self:invoke(evt_type)
end