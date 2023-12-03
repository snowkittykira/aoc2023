---- common --------------------------------------

local pprint = require 'pprint'

local input = io.open('../data/03.txt'):read('*a')
local line_len = #input:match ('[^\n]+\n')

--print ('line length:' .. line_len)

local function index_to_coords (index)
  return {
    x = (index-1) % line_len,
    y = math.floor ((index-1) / line_len)
  }
end

local function find_all_with_location (pat)
  pat = '()(' .. pat .. ')()'
  local results = {}
  for from, body, to in input:gmatch(pat) do
    table.insert (results, {
      from = index_to_coords (from),
      body = body,
      -- convert `to` to one-past-the-end vertically
      to = index_to_coords (to + line_len)
    })
  end
  return results
end

local function are_adjacent (a, b)
  return a.from.x <= b.to.x and b.from.x <= a.to.x and
         a.from.y <= b.to.y and b.from.y <= a.to.y
end

local numbers = find_all_with_location "%d+"
--pprint (numbers)
local symbols = find_all_with_location "[^%.%d%s]"
--pprint (symbols)

---- part 1 --------------------------------------

do
  local total = 0

  for _, num in ipairs (numbers) do
    local is_counted = false
    for _, sym in ipairs (symbols) do
      if are_adjacent (num, sym) then
        is_counted = true
      end
    end
    if is_counted then
      total = total + tonumber (num.body)
    end
  end

  print ('part 1: ' .. total)
end

---- part 2 --------------------------------------

do
  local total = 0

  for _, sym in ipairs (symbols) do
    if sym.body == '*' then
      local num_count = 0
      local num_product = 1
      for _, num in ipairs (numbers) do
        if are_adjacent (num, sym) then
          num_count = num_count + 1
          num_product = num_product * tonumber (num.body)
        end
      end
      if num_count == 2 then
        total = total + num_product
      end
    end
  end

  print ('part 2: ' .. total)
end
