local input = io.open('../data/02.txt'):read('*a')

local limits = { red = 12, green = 13, blue = 14 }

local total = 0

for line in input:gmatch ('[^\n]+') do
  local num, batches = line:match 'Game (%d+): (.*)'
  num = tonumber(num)
  local possible = true
  for batch in batches:gmatch '[^;]+' do
    for item in batch:gmatch '[^,]+' do
      local count, color = item:match '(%d+) (%w+)'
      if tonumber(count) > limits [color] then
        possible = false
      end
    end
  end
  if possible then
    total = total + num
  end
end

print (total)
