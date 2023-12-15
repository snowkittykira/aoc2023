local List = require 'pl.List'
local pretty = require 'pl.pretty'
require 'pl.stringx'.import()

local function all_zero(list)
  for i = 1, #list do
    if list[i] ~= 0 then
      return false
    end
  end
  return true
end

local function extrapolate (list)
  -- all zero? then answer is zero
  if all_zero(list) then
    return 0
  end
  -- find differences
  local diff = {}
  for i = 2, #list do
    table.insert (diff, list[i] - list[i-1])
  end
  -- extrapolate
  local new_diff = extrapolate (diff)
  return list[1] - new_diff
end

local input = io.open('../../data/09.txt'):read('*a')
local lines = input:splitlines()
local lists = lines:map (function (line) return line:split():map(tonumber) end)
local total = 0
for i = 1, #lists do
  total = total + extrapolate(lists[i])
end
print (total)
