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
  local function run_until_end (cur)
    local count = 0
    while true do
      for _, dir in ipairs (directions) do
        --pretty (cur, dir, cur [dir])
        cur = node_map [cur[dir]]
        count = count + 1
        if cur.name:endswith'Z' then
          break
        end
      end
      if cur.name:endswith'Z' then
        break
      end
    end
    return count
  end
  local starts = nodes:filter (function (n) return n.name:endswith'A' end)
  local lengths = starts:map (run_until_end)
  --print (lengths)

  local function gcd (a, b)
    for i = math.min (a, b) - 1, 1, -1 do
      if a%i == 0 and b%i == 0 then
        return i
      end
    end
  end
  local function lcm (a, b)
    return a * b / gcd (a, b)
  end
  -- dunno why but i need the floor to take off the .0 at the end
  print ('part 2: ' .. math.floor(lengths:reduce(lcm)))
end
