local cpml = require 'cpml'
local vec2 = cpml.vec2
local List = require 'pl.List'
require 'pl.stringx'.import()

local directions = { 'w', 'e', 'n', 's' }
local direction_offsets = {
  w = vec2 (-1, 0),
  e = vec2 ( 1, 0),
  n = vec2 (0, -1),
  s = vec2 (0,  1),
}
local sides = {
  w = {'n', 's'},
  e = {'n', 's'},
  n = {'w', 'e'},
  s = {'w', 'e'},
}

local chars = io.open('../../data/17.txt'):read('*a')
local lines = chars:splitlines ():map(List)
local width = #lines[1]
local height = #lines

local function state_to_key (pos, dir, n)
  return pos.x .. '_' .. pos.y .. '_' .. dir .. '_' .. n
end

local function solve ()
  -- make node map
  local node_map = {}
  for j = 1, height do
    for i = 1, width do
      local pos = vec2 (i, j)
      for _, dir in ipairs (directions) do
        for n = 1, 10 do
          local key = state_to_key (pos, dir, n)
          node_map [key] = {
            pos = pos,
            dir = dir,
            n = n,
            cost = tonumber (lines[pos.y][pos.x]),
            total_cost = 1/0
          }
        end
      end
    end
  end

  local function get_node (pos, dir, n)
    return node_map [state_to_key(pos, dir, n)]
  end

  for _, node in pairs (node_map) do
    local neighbors = List ()
    local function add_neighbor (dir, n)
      local neighbor = get_node (node.pos + direction_offsets[dir], dir, n)
      if node then
        neighbors:append (neighbor)
      end
    end
    add_neighbor (node.dir, node.n + 1)
    if node.n >= 4 then
      add_neighbor (sides[node.dir][1], 1)
      add_neighbor (sides[node.dir][2], 1)
    end
    node.neighbors = neighbors
  end

  local unvisited = List ()

  local function traverse ()
    while next (unvisited) do
      local node = false
      for n in pairs (unvisited) do
        if not node or node.total_cost > n.total_cost then
          node = n
        end
      end
      unvisited [node] = nil
      print (node.pos, node.total_cost)
      if node.pos == vec2 (width, height) then
        return node.total_cost
      end
      for _, next in ipairs (node.neighbors) do
          if next.total_cost > node.total_cost + next.cost then
          next.total_cost = node.total_cost + next.cost
          unvisited [next] = true
        end
      end
    end
  end

  unvisited [get_node(vec2 (2, 1), 'e', 1)] = true
  unvisited [get_node(vec2 (1, 2), 's', 1)] = true
  for node in pairs (unvisited) do
    node.total_cost = node.cost
  end
  return traverse ()
end
print ('part 1: ' .. solve())
