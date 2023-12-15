local List = require 'pl.List'
local pretty = require 'pl.pretty'
local tablex = require 'pl.tablex'
local seq = require 'pl.seq'
require 'pl.stringx'.import()

local input = io.open('../../data/14.txt'):read('*a'):splitlines():map(List)
input = List(tablex.zip (table.unpack (input))):map(table.concat)
input = input:map (function (line)
  for i = 1, #line * 2 do
    line = line:gsub ('%.O', 'O.')
  end
  return line
end)

local total = 0
for _, line in ipairs (input) do
  for i = 1, #line do
    if line:sub (i, i) == 'O' then
      total = total + #line - i + 1
    end
  end
end
pretty (total)

