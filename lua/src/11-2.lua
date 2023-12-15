local List = require 'pl.List'
local pretty = require 'pl.pretty'
local tablex = require 'pl.tablex'
require 'pl.stringx'.import()

---- read input -------------------------------------------

local input = io.open('../../data/11.txt'):read('*a')
local lines = input:splitlines ():map (List)
--pretty (lines)

local function show_grid (list)
  list:map (function (line) print (line:concat()) end)
end

---- find empty rows / cols -------------------------------
local function find_empty (list, out)
  for i = 1, #list do
    if list[i]:concat():match('^%.*$') then
      out:append (i-1)
    end
  end
end

local function transpose (list)
  -- there should be a better way...
  return List(tablex.zip(table.unpack (list))):transform(List)
end

local empty_cols = List()
local empty_rows = List()
find_empty (lines, empty_rows)
find_empty (transpose(lines), empty_cols)

--show_grid(lines)
pretty (empty_cols, empty_rows)

---- find galaxies ----------------------------------------

local line_len = #input:match ('[^\n]+\n')

local function index_to_coords (index)
  return {
    x = (index-1) % line_len,
    y = math.floor ((index-1) / line_len)
  }
end

local function find_all_with_locations (pat)
  pat = '()' .. pat
  local results = List()
  for from in input:gmatch(pat) do
    results:append(index_to_coords (from))
  end
  return results
end

local galaxies = find_all_with_locations ("#")
--pretty (galaxies)

local function is_between (from, to, i)
  return from < i and i < to
end

local expansion = 999999
local function count_distance_1d (from, to, empty_list)
  if to < from then
    from, to = to, from
  end

  return to - from + expansion * #empty_list:filter (function (i)
    return is_between (from, to, i)
  end)
end

local function dist (a, b)
  return count_distance_1d (a.x, b.x, empty_cols)+
         count_distance_1d (a.y, b.y, empty_rows)
end

local total = 0
for i = 1, #galaxies-1 do
  for j = i+1, #galaxies do
    total = total + dist (galaxies[i], galaxies[j])
  end
end
print (total)
