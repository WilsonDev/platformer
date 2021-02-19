local MathUtils = {}

function MathUtils.clamp(x, min, max)
  return x < min and min or (x > max and max or x)
end

function MathUtils.round(number)
  return math.floor(number + 0.5)
end

return MathUtils
