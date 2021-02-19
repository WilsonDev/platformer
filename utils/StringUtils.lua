local StringUtils = {}

function StringUtils.split(text, inSplitPattern)
  local outResults = {}
  local theStart = 1
  local theSplitStart, theSplitEnd = string.find(text, inSplitPattern, theStart)
  while theSplitStart do
    table.insert(outResults, string.sub(text, theStart, theSplitStart - 1))
    theStart = theSplitEnd + 1
    theSplitStart, theSplitEnd = string.find(text, inSplitPattern, theStart)
  end
  table.insert(outResults, string.sub(text, theStart))
  return outResults
end

return StringUtils
