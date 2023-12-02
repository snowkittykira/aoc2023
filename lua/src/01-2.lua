local function starts_with (str, prefix)
  return str:match ('^' .. prefix)
end

local numbers = {'1', '2', '3', '4', '5', '6', '7', '8', '9', '0',
                 'one', 'two', 'three', 'four', 'five', 'six', 'seven', 'eight', 'nine'}
local input = io.open('../data/01.txt'):read('*a')

local total = 0

for line in input:gmatch ('[^\n]+') do
  local first, last
  for i = 1, #line do
    local str = line:sub(i)

    for j, n in ipairs (numbers) do
      if starts_with (str, n) then
        first = first or j % 10
        last = j % 10
      end
    end

  end
  local line_num = tonumber (first .. last)
  total = total + line_num
end

print (total)

