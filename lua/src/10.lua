local cpml = require 'cpml'
local vec2 = cpml.vec2
local List = require 'pl.List'
local pretty = require 'pl.pretty'
require 'pl.stringx'.import()

local pipe_connections = {
  ['|'] = {          'n', 's'},
  ['-'] = {'w', 'e',         },
  ['L'] = {     'e', 'n',    },
  ['J'] = {'w',      'n',    },
  ['7'] = {'w',           's'},
  ['F'] = {     'e',      's'},
  ['.'] = {                  },
  ['S'] = {'w', 'e', 'n', 's'},
}

local directions = {'w', 'e', 'n', 's'}
local direction_offsets = {
  w = vec2 (-1, 0),
  e = vec2 ( 1, 0),
  n = vec2 (0, -1),
  s = vec2 (0,  1),
}
local opposites = {w='e', e='w', n='s', s='n'}

local input = io.open('../../data/10.txt'):read('*a')
local lines = input:splitlines ()
local width = #lines[1]
local height = #lines
print(width, height)
print(input)

local function pos_to_key (pos)
  return pos.y * (width+1) + pos.x + 1
end
local function key_to_pos (key)
  return vec2 ((key-1) % (width+1), math.floor((key-1)/(width+1)))
end
assert (1 == pos_to_key (key_to_pos (1)))
assert (12 == pos_to_key (key_to_pos (12)))

local function get_char (pos)
  local i = pos_to_key(pos)
  return input:sub (i, i)
end

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

-- connect nodes
for key, node in pairs (node_map) do
  local pos = key_to_pos (key)
  for _, dir in ipairs (pipe_connections [get_char(pos)]) do
    node [dir] = node_map [pos_to_key (pos + direction_offsets[dir])]
  end
end

-- disconnect nodes
for key, node in pairs (node_map) do
  local pos = key_to_pos (key)
  for _, dir in ipairs (pipe_connections [get_char(pos)]) do
    local other_node = node_map [pos_to_key (pos + direction_offsets[dir])]
    if not other_node or not other_node [opposites [dir]] then
      node[dir] = false
    end
  end
end

local start_node = node_map [input:match ('()S')]


do -- part 1
  -- breadth first search
  local queue = {start_node}
  local next_queue

  local distance = 0
  local max_distance = 0
  while #queue > 0 do
    next_queue = {}
    for _, node in ipairs (queue) do
      if not node.distance then
        node.distance = distance
        max_distance = distance
        --print ('visit ' .. tostring(node.pos) .. ' ' .. distance)
        for _, dir in ipairs (directions) do
          if node[dir] then
            table.insert (next_queue, node[dir])
          end
        end
      end
    end
    queue = next_queue
    distance = distance + 1
  end
  print (max_distance)
end


do
  -- trace around the loop in one direction
  local trace = {}
  local function do_trace (node, from)
    if node == start_node and from then
      return
    end
    --print ('do_trace', node.pos, from)
    -- pick a direction from the node that's not from
    for _, dir in ipairs (directions) do
      if node[dir] and dir ~= from then
        local key = pos_to_key (node.pos)
        -- prioritize up/down movement because
        -- those ones will tell us which side to use
        if from == 'n' then
          trace [key] = 's'
        elseif from == 's' then
          trace [key] = 'n'
        else
          trace[key] = dir
        end

        return do_trace (node[dir], opposites[dir])
      end
    end
  end
  do_trace (start_node, false)
  --pretty(trace)

  -- divide area into left/right
  local area_up = 0
  local area_down = 0
  for j = 0, height-1 do
    local last_dir = false
    for i = 0, width-1 do
      local key = pos_to_key (vec2 (i, j))
      local t = trace [key]
      if t then
        last_dir = t
      else
        -- count area
        if last_dir == 'n' then
          trace [key] = 'O'
          area_up = area_up + 1
        elseif last_dir == 's' then
          trace [key] = 'I'
          area_down = area_down + 1
        else
          trace [key] = '?'
        end
      end
    end
  end

  for j = 0, height-1 do
    for i = 0, width-1 do
      io.write (trace [pos_to_key (vec2 (i, j))])
    end
    io.write ('\n')
  end

  -- the answer should be one of these
  print ('part 2 is one of', area_up, area_down)
end
