local input = io.open('../data/01.txt'):read('*a')

local total = 0

for line in input:gmatch ('[^\n]+') do
  local first, last
  for num in line:gmatch ('[0-9]') do
    first = first or num
    last = num
  end
  local line_num = tonumber (first .. last)
  total = total + line_num
end

print (total)

