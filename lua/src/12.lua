local List = require 'pl.List'
local pretty = require 'pl.pretty'
local tablex = require 'pl.tablex'
require 'pl.stringx'.import()

local input = io.open('../../data/12.txt'):read('*a')
local lines = input:splitlines ()

--pretty (lines)

local function check_segment (line, first, len)
  --print ()
  --print (line)
  --print ((' '):rep (first-1) .. ('#'):rep (len))
  --print( line:sub (first-1, first + len)
  --           :match ('^[%.?][?#]+[%.?]$') and true or false)
  return line:sub (first-1, first + len)
             :match ('^[%.?][?#]+[%.?]$') and true or false
end

assert (check_segment ('.###.', 2, 3))
assert (not check_segment ('.#.#.', 2, 3))
assert (check_segment ('.???.', 2, 3))
assert (check_segment ('.???.', 2, 2))
assert (not check_segment ('.??#.', 2, 2))

local function try_all (line, counts, start)
  --print ('\ntry all', line, counts[1], start)
  if #counts == 0 then
    -- assert no more #
    if line:sub (start):match'#' then
      --print ('FAIL')
      return 0
    else
      --print ('SUCCESS')
      return 1
    end
  end
  local total = 0
  -- for all places you could put the first number
  for i = start, #line - counts[1] do
    -- check if you can place the number there
    if check_segment (line, i, counts[1]) then
      total = total + try_all (line, {table.unpack (counts, 2)}, i + counts[1] + 1)
    end
    if line:sub (i, i) == '#' then
      break
    end
  end
  return total
end

--print (try_all ('.???.###.', {1, 1, 3}, 2))

local function count_combinations (line)
  local grid, counts = table.unpack (line:split(' '))
  counts = counts:split (',')
  return try_all ('.' .. grid .. '.', counts, 2)
end

--print (count_combinations ('???#???.#??####? 5,1,5'))
--print (count_combinations ('#??????? 1'))

do -- part 1
  local total = 0
  for _, line in ipairs (lines) do
    local count = count_combinations (line)
    print (count, line)
    total = total + count
  end
  print ('part 1: ' .. total)
end

local function expand (line)
  local grid, counts = table.unpack (line:split(' '))
  local grid_list = List()
  local counts_list = List()
  for _ = 1, 5 do
    grid_list:append (grid)
    counts_list:append (counts)
  end
  return grid_list:concat ('?') .. ' ' .. counts_list:concat(',')
end

do -- part 2
  local total = 0
  for i, line in ipairs (lines) do
    line = expand (line)
    local count = count_combinations (line)
    print (i, count, line)
    total = total + count
  end
  print ('part 2: ' .. total)
end
