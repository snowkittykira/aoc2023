local input = io.open('../../data/05.txt'):read('*a')
local lume = require 'lume'
local pprint = require 'pprint'

local array, map, split = lume.array, lume.map, lume.split

local function part_1 ()
  local sections = array (input:gmatch ':(.-)\n\n')
  local seeds = map (split (sections[1]), tonumber)
  local maps = map ({table.unpack (sections, 2)}, function (s)
    local ranges = map (array (s:gmatch ('[^\n]+')), function (line)
      local nums = map (array (line:gmatch ('%d+')), tonumber)
      return {dst = nums[1], src = nums[2], length = nums[3]}
      --return line
    end)
    return ranges
  end)

  local from = seeds
  for _, map_item in ipairs (maps) do
    local to = {}
    for _, f in ipairs (from) do
      local t
      for _, range in ipairs(map_item) do
        if range.src <= f and f < range.src + range.length then
          t = range.dst + f - range.src
          break
        end
      end
      if not t then
        t = f
      end
      table.insert (to, t)
    end
    from = to
  end
  --pprint(seeds)
  --pprint(maps)
  --pprint(from)

  return math.min (table.unpack (from))
end

local function map_range (range, mapping)
  --if not range then
  --  return false
  --end
  -- no overlap
  if range.first + range.length <= mapping.src or
     mapping.src + mapping.length <= range.first then
     return false
  end
  local overlap = {
    first = math.max (range.first, mapping.src),
    ending = math.min (range.first + range.length, mapping.src + mapping.length)
  }
  overlap.length = overlap.ending - overlap.first
  --pprint (range, mapping, overlap)
  assert (overlap.length > 0)

  -- map overlap
  local dst_range = {first = overlap.first + mapping.dst - mapping.src, length = overlap.length}
  local src_remainders = {}

  if overlap.first > range.first then
    local r = {
      first = range.first,
      length = overlap.first - range.first,
    }
    assert (r.length > 0)
    table.insert (src_remainders, r)
  end

  if range.first + range.length > mapping.src + mapping.length then
    local r = {
      first = overlap.ending,
      length = range.first + range.length - overlap.ending
    }
    assert (r.length > 0)
    table.insert (src_remainders, r)
  end

  return dst_range, src_remainders
end

local function part_2 ()
  -- doesn't work yet

  local sections = array (input:gmatch ':(.-)\n\n')
  local range_input = map (split (sections[1]), tonumber)
  local seed_ranges = {}
  for i = 1, #range_input, 2 do
    table.insert (seed_ranges, {first = range_input[i], length = range_input[i+1]})
  end
  --print (#seed_ranges)
  local maps = map ({table.unpack (sections, 2)}, function (s)
    local ranges = map (array (s:gmatch ('[^\n]+')), function (line)
      local nums = map (array (line:gmatch ('%d+')), tonumber)
      return {dst = nums[1], src = nums[2], length = nums[3]}
      --return line
    end)
    return ranges
  end)

  local from = seed_ranges
  for _, map_item in ipairs (maps) do
    local to = {}
    for _, f in ipairs (from) do
      -- here we need to take f and convert it into a series of ranges
      local src_ranges = {f}
      --local dst_ranges = {}
      local i = 1
      while i <= #src_ranges do
        local overlap_found = false
        for _, mapping in ipairs (map_item) do
          -- check intersection of src_ranges[i] and range
          local dst_range, remainder_ranges = map_range (src_ranges[i], mapping)
          -- if overlap,
          if dst_range and remainder_ranges then
            --   remove range from src_ranges and skip incrementing i
            --   add overlap to `to`
            table.insert (to, dst_range)
            --  remove original range and add non-overlapping components to src_ranges
            table.remove (src_ranges, i)
            for _, remainder in ipairs (remainder_ranges) do
              table.insert (src_ranges, remainder)
            end
            -- restart current iteration
            overlap_found = true
            break
          end
          --  
        end
        if not overlap_found then
          i = i + 1
        end
      end
      -- add remainders
      for _, x in ipairs (src_ranges) do
        table.insert (to, x)
      end

    end
    from = to
  end
  --pprint(seed_ranges)
  --pprint(maps)
  --pprint(from)

  return math.min (table.unpack (map (from, function (r) return r.first end)))
end

print ('part 1: ' .. part_1())
print ('part 2: ' .. part_2())


