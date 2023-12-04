local input = io.open('../data/04.txt'):read('*a')

local function part_1 ()
  local total = 0

  for winning, actual in input:gmatch (': ([^|]*) | ([^\n]*)\n') do
    local nums = {}
    local score = 0.5
    for num in winning:gmatch ('%d+') do
      nums[num] = true
    end
    for num in actual:gmatch ('%d+') do
      if nums[num] then
        score = score * 2
      end
    end
    total = total + math.floor (score)
  end
  return total
end

local function part_2 ()
  local total = 0
  -- including original
  local copies = {}


  for game, winning, actual in input:gmatch ('Card +(%d+): ([^|]*) | ([^\n]*)\n') do
    game = tonumber (game)
    local count = copies [game] or 1
    local nums = {}
    local matches = 0
    for num in winning:gmatch ('%d+') do
      nums[num] = true
    end
    for num in actual:gmatch ('%d+') do
      if nums[num] then
        matches = matches + 1
      end
    end
    for i = game + 1, game + matches do
      copies [i] = (copies [i] or 1) + count
    end

    total = total + count
  end
  return total
end

print ('part 1: ' .. part_1())
print ('part 2: ' .. part_2())
