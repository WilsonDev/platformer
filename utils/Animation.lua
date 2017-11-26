Animation = {}

function Animation:new(animationDelay, animationFrames, animationQuads)
    object = {
        frames = animationFrames,
        delay = animationDelay,
        iterator = 1,
        timer = 0,
        quads = animationQuads
    }

    setmetatable(object, { __index = Animation })
    return object
end

function Animation:update(dt)
    self.timer = self.timer + dt
	if self.timer > self.delay then
		self.timer = 0
		self.iterator = self.iterator + 1
		if self.iterator > self.frames then
			self.iterator = 1
		end
	end
end

function Animation:setIteration(iteration)
    self.iterator = iteration
end

function Animation:getCurrentIteration()
    return self.iterator
end

function Animation:getCurrentQuad()
    return self.quads[self.iterator]
end