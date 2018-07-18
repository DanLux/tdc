
-- Functions to check if strings are palindromes

-- should ignore white spaces and punctuation
local IGNORE_PUNCTUATION = true


-- import
local sub, gsub, lower, reverse = string.sub, string.gsub, string.lower, string.reverse
local floor, ceil = math.floor, math.ceil


local function palindrome(word)
  local first_half = sub(word, 1, floor(#word/2))
  local second_half = sub(word, ceil(#word/2) + 1, -1)
  return lower(first_half) == lower(reverse(second_half))
end

local function check_sentence(sentence)
  local chunk = IGNORE_PUNCTUATION and gsub(sentence, "%W", "") or sentence
  return palindrome(chunk)
end


-- ex: local palindrome = require('examples.palindrome').init(false)
local palindrome = {}

palindrome.init = function(ignore_punctuation)
    IGNORE_PUNCTUATION = ignore_punctuation
    return palindrome
end

palindrome.check = check_sentence

return palindrome
