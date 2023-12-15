local List = require 'pl.List'
local pretty = require 'pl.pretty'
local tablex = require 'pl.tablex'
local seq = require 'pl.seq'
local operator = require 'pl.operator'
require 'pl.stringx'.import()

local input = io.open('../../data/15.txt'):read('*a'):strip():split(',')

pretty (input)

local function hash_of (str)
  local chars = List (str)
  local total = 0
  for c in chars:iter() do
    total = total + c:byte()
    total = total * 17 % 256
  end
  return total
end

print ("part 1: " ..
  input:map(hash_of):reduce (operator.add))

local boxes = {}
for i = 0, 255 do
  boxes[i] = List()
  boxes[i].box_index = i
end

local function find (list, label)
  for i = 1, #list do
    if list[i].label == label then
      return i
    end
  end
end

for instruction in input:iter() do
  local label, type = instruction:match '^(%w+)([-=])'
  local box = boxes [hash_of (label)]
  if type == '-' then
    --TODO remove lens with label from box
    local index = find (box, label)
    if index then
      box:remove (index)
    end
  else
    -- add lens
    local lens = {
      label = label,
      power = tonumber (instruction:match ('=(%d+)$'))
    }
    local index = find (box, label)
    if index then
      -- if lens already exists, replace
      box [index] = lens
    else
      box:append (lens)
    end
  end
end

--pretty (boxes)

local power = 0
for i = 0, 255 do
  local box = boxes [i]
  for j = 1, #box do
    power = power + (i+1) * j * (box[j].power)
  end
end
print ('part 2: ' .. power)
