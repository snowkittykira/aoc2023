local input = io.open('../data/02.txt'):read('*a')

local total = 0

for line in input:gmatch ('[^\n]+') do
  local maxes = { red = 0, green = 0, blue = 0 }
  for count, color in line:gmatch '(%d+) (%w+)' do
    count = tonumber(count)
    maxes [color] = math.max (maxes[color], count)
  end
  total = total + maxes.red * maxes.green * maxes.blue
end

print (total)
