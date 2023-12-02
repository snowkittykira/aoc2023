local input = io.open('../data/02.txt'):read('*a')

local total = 0

for line in input:gmatch ('[^\n]+') do
  local num, batches = line:match 'Game (%d+): (.*)'
  num = tonumber(num)
  local maxes = { red = 0, green = 0, blue = 0 }
  for batch in batches:gmatch '[^;]+' do
    for item in batch:gmatch '[^,]+' do
      local count, color = item:match '(%d+) (%w+)'
      count = tonumber(count)
      if count > maxes [color] then
        maxes[color] = count
      end
    end
  end
  total = total + maxes.red * maxes.green * maxes.blue
end

print (total)
