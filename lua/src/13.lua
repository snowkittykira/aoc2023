local List = require 'pl.List'
local pretty = require 'pl.pretty'
local tablex = require 'pl.tablex'
local seq = require 'pl.seq'
require 'pl.stringx'.import()

local input = io.open('../../data/13.txt'):read('*a')
-- images is a list of lists of strings
local images = input:split ('\n\n'):map (function (s) return List(s:lines ()) end)

local function find_line_reflection (image)
  for i = 1, #image - 1 do
    local match = true
    for j = 1, math.min (i, #image - i) do
      if image[i-j+1] ~= image[i+j] then
        match = false
        break
      end
    end
    if match then
      return i
    end
  end
end

local function transpose (image)
  return List(tablex.zip (table.unpack (image:map (List)))):map(table.concat)
end

local function find_reflection_score (image)
  return find_line_reflection (transpose(image)) or
         (100*find_line_reflection (image))
end

print ('part 1: ', (seq.sum (images, find_reflection_score)))
