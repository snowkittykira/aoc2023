local input = io.open('../../data/06.txt'):read('*a')
local lume = require 'lume'

local function do_race (time, distance)
  local total = 0
  for hold = 1, time-1 do
    local achieved = (time - hold) * hold
    if achieved > distance then
      total = total + 1
    end
  end
  return total
end

do -- part 1
  local times = lume.map (lume.split (input:match ('Time: ([^\n]*)\n')), tonumber)
  local distances = lume.map (lume.split (input:match ('Distance: ([^\n]*)\n')), tonumber)

  local product = 1
  for i, time in ipairs(times) do
    local distance = distances[i]
    -- process race
    product = product * do_race (time, distance)
  end
  print ('part 1: ' .. product)
end

do -- part 2
  local time = tonumber ((input:match ('Time: ([^\n]*)\n'):gsub(' ', '')))
  local distance = tonumber ((input:match ('Distance: ([^\n]*)\n'):gsub(' ', '')))

  print ('part 2: ' .. do_race (time, distance))
end

