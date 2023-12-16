local cpml = require 'cpml'
local vec2 = cpml.vec2
require 'pl.stringx'.import()

local direction_offsets = {
  w = vec2 (-1, 0),
  e = vec2 ( 1, 0),
  n = vec2 (0, -1),
  s = vec2 (0,  1),
}

local reflections = {
  ['/']  = {w = {'s'}, e = {'n'}, n = {'e'}, s = {'w'}},
  ['\\'] = {w = {'n'}, e = {'s'}, n = {'w'}, s = {'e'}},
  ['|']  = {w = {'n', 's'}, e = {'n', 's'}, n = {'n'}, s = {'s'}},
  ['-']  = {w = {'w'}, e = {'e'}, n = {'w', 'e'}, s = {'w', 'e'}},
  ['.']  = {w = {'w'}, e = {'e'}, n = {'n'}, s = {'s'}},
}

local chars = io.open('../../data/16.txt'):read('*a')
local lines = chars:splitlines ()
local width = #lines[1]
local height = #lines

local function pos_to_key (pos)
  return pos.y * (width+1) + pos.x + 1
end
local function key_to_pos (key)
  return vec2 ((key-1) % (width+1), math.floor((key-1)/(width+1)))
end
assert (1 == pos_to_key (key_to_pos (1)))
assert (123 == pos_to_key (key_to_pos (123)))


local function get_char (pos)
  local i = pos_to_key(pos)
  return chars:sub (i, i)
end

local function count_energized (initial_pos, initial_dir)
  -- populate nodes
  local node_map = {}
  for j = 0, height-1 do
    for i = 0, width-1 do
      local pos = vec2 (i, j)
      local key = pos_to_key (pos)
      node_map [key] = {
        pos = pos,
        char = get_char (pos)
      }
    end
  end

  local function get_node (pos)
    local key = pos_to_key (pos)
    return node_map [key]
  end

  local function traverse (pos, direction)
    local node = get_node (pos)
    if node and not node[direction] then
      node[direction] = true
      node.energized = true
      local outputs = reflections [node.char][direction]
      for _, out_dir in ipairs (outputs) do
        traverse (pos + direction_offsets [out_dir], out_dir)
      end
    end
  end

  traverse (initial_pos, initial_dir)

  local total = 0
  for _, node in pairs (node_map) do
    if node.energized then
      total = total + 1
    end
  end
  return total
end

print ('part 1: ' .. count_energized (vec2 (0, 0), 'e'))

local max_energized = 0
for i = 1, width-1 do
  max_energized = math.max (max_energized,
    count_energized (vec2 (i, 0), 's'))
  max_energized = math.max (max_energized,
    count_energized (vec2 (i, height-1), 'n'))
end
for j = 1, height-1 do
  max_energized = math.max (max_energized,
    count_energized (vec2 (0, j), 'e'))
  max_energized = math.max (max_energized,
    count_energized (vec2 (width-1, j), 'w'))
end

print ('part 2: ' .. max_energized)
