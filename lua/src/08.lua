local List = require 'pl.List'
local pretty = require 'pl.pretty'
require 'pl.stringx'.import()

local function line_to_node (line)
  local name, L, R = line:match ('^(%w+) = %((%w+), (%w+)%)')
  return {name = name, L = L, R = R}
end


local input = io.open('../../data/08.txt'):read('*a')

local directions = List (input:match ('^[LR]+'))
--local nodes = List (input:gmatch '^[^\n]+ = [^\n]+')
local nodes = List (input:gmatch '[^\n]+ = [^\n]+'):map (line_to_node)
local node_map = {}
for _, node in pairs (nodes) do
  node_map [node.name] = node
end
--pretty (directions, node_map)

do -- part 1
  local cur = node_map.AAA
  local count = 0
  while true do
    for _, dir in ipairs (directions) do
      --pretty (cur, dir, cur [dir])
      cur = node_map [cur[dir]]
      count = count + 1
      if cur.name == 'ZZZ' then
        break
      end
    end
    if cur.name == 'ZZZ' then
      break
    end
  end
  print ('part 1: ' .. count)
end

do -- part 2
  local reached = {}
  local done = false
  local cur = nodes:filter (function (n) return n.name:endswith'A' end)
  local count = 0
  while not done do
    for _, dir in ipairs (directions) do
      cur = cur:map (function (c) return node_map [c[dir]] end)
      count = count + 1
      local cur_ends = cur:filter (function (c) return c.name:endswith'Z' end)
      local stamp = cur:map (function (c) return c.name end):join()
      --print (stamp)
      assert (not reached[stamp], 'loop detected')
      reached[stamp] = true
      if #cur_ends == #cur then
        done = true
        break
      end
    end
    --print (count)
  end
  print ('part 2: ' .. count)
end
