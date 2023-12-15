local List = require 'pl.List'
local pretty = require 'pl.pretty'
local tablex = require 'pl.tablex'
require 'pl.stringx'.import()

---- read input -------------------------------------------

local lines = io.open('../../data/11.txt'):read('*a'):splitlines ():map (List)
--pretty (lines)

local function show_grid (list)
  list:map (function (line) print (line:concat()) end)
end

---- expand -----------------------------------------------
local function duplicate_empty (list)
  for i = #list, 1, -1 do
    if list[i]:concat():match('^%.*$') then
      list:insert (i, list[i])
    end
  end
end

local function transpose (list)
  -- there should be a better way...
  return List(tablex.zip(table.unpack (list))):transform(List)
end

duplicate_empty (lines)
lines = transpose (lines)
duplicate_empty (lines)
lines = transpose (lines)

show_grid(lines)
--pretty (lines)

---- convert back to string -------------------------------

local combined = lines:map (table.concat):concat('\n')
print (combined)

---- find galaxies ----------------------------------------

local line_len = #combined:match ('[^\n]+\n')

local function index_to_coords (index)
  return {
    x = (index-1) % line_len,
    y = math.floor ((index-1) / line_len)
  }
end

local function find_all_with_locations (input, pat)
  pat = '()' .. pat
  local results = List()
  for from in input:gmatch(pat) do
    results:append(index_to_coords (from))
  end
  return results
end

local galaxies = find_all_with_locations (combined, "#")
pretty (galaxies)

local function dist (a, b)
  return math.abs(a.x - b.x) +
         math.abs(a.y - b.y)
end

local total = 0
for i = 1, #galaxies do
  for j = i+1, #galaxies do
    total = total + dist (galaxies[i], galaxies[j])
  end
end
print (total)
