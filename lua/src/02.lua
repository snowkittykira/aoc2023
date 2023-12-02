local input = io.open('../data/02.txt'):read('*a')

local limits = { red = 12, green = 13, blue = 14 }

local total = 0

for line in input:gmatch ('[^\n]+') do
  local num = tonumber (line:match 'Game (%d+)')
  local possible = true
  for count, color in line:gmatch '(%d+) (%w+)' do
    if tonumber(count) > limits [color] then
      possible = false
    end
  end
  if possible then
    total = total + num
  end
end

print (total)
