local List = require 'pl.List'
local pretty = require 'pl.pretty'
require 'pl.stringx'.import()

local strength_order = List ('AKQJT98765432')

local function card_comparator (a, b)
  return strength_order:index (a) < strength_order:index (b)
end

local hand_types = {
  'five of a kind',
  'four of a kind',
  'full house',
  'three of a kind',
  'two pairs',
  'one pair',
  'high card'
}

local type_order = {
  -- five of a kind
  function (cards)
    return cards:count (cards[1]) == 5
  end,
  -- four of a kind
  function (cards)
    return cards:count (cards[1]) == 4 or
           cards:count (cards[2]) == 4
  end,
  -- full house
  function (cards)
    return cards:count (cards[1]) == 3 and
           cards:count (cards[5]) == 2
           or
           cards:count (cards[1]) == 2 and
           cards:count (cards[5]) == 3
  end,
  -- three of a kind
  function (cards)
    return cards:count (cards[1]) == 3 or
           cards:count (cards[2]) == 3 or
           cards:count (cards[3]) == 3
  end,
  -- two pairs
  function (cards)
    return cards:count (cards[2]) == 2 and
           cards:count (cards[4]) == 2
  end,
  -- one pair
  function (cards)
    return cards:count (cards[2]) == 2 or
           cards:count (cards[4]) == 2
  end,
  -- high card
  function (cards)
    return true
  end,

}

local function get_hand_type (cards)
  for i = 1, #type_order do
    if type_order[i](cards) then
      return i
    end
  end
  assert (false)
end

local function get_cards_score (cards)
  local score = 0
  for i = 1, #cards do
    score = score * #strength_order
    score = score + (strength_order:index (cards [i]))
  end
  return score
end

local function hand_comparator (a, b)
  -- put weaker hands first
  if a.type > b.type then
    return true
  elseif a.type < b.type then
    return false
  else
    return get_cards_score (a.cards_unsorted) > get_cards_score (b.cards_unsorted)
  end
end

local function hand_from_line (line)
  local cards_unsorted, bid = table.unpack (line:split ())
  cards_unsorted = List (cards_unsorted)
  local cards = cards_unsorted:sorted(card_comparator)
  bid = tonumber (bid)

  return {
    cards_unsorted = cards_unsorted,
    cards = cards,
    bid = bid,
    type = get_hand_type (cards),
  }
end

local function hand_tostring (hand)
  return hand.cards_unsorted:join() .. ' ' ..
         hand.cards:join () .. ' ' ..
         hand_types [hand.type]
end

assert (hand_from_line ("QQQQQ 1").type == 1)
assert (hand_from_line ("QQQQJ 1").type == 2)
assert (hand_from_line ("QQQKK 1").type == 3)
assert (hand_from_line ("QQQ22 1").type == 3)
assert (hand_from_line ("22QQQ 1").type == 3)
assert (hand_from_line ("2Q2QQ 1").type == 3)
assert (hand_from_line ("Q2Q2Q 1").type == 3)
assert (hand_from_line ("QQKKK 1").type == 3)
assert (hand_from_line ("QJKKK 1").type == 4)
assert (hand_from_line ("QKKKJ 1").type == 4)
assert (hand_from_line ("KKKQJ 1").type == 4)
assert (hand_from_line ("KKAQQ 1").type == 5)
assert (hand_from_line ("KKAJQ 1").type == 6)
assert (hand_from_line ("K5AJQ 1").type == 7)

local input = io.open('../../data/07.txt'):read('*a')

-- part 1 (doesn't work yet)

local hands = input:splitlines():map (hand_from_line)
hands:sort (hand_comparator)
pretty (hands:map (hand_tostring))
local total = 0
for i = 1, #hands do
  total = total + hands[i].bid * i
end
print(total)


