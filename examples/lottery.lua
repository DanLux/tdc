
-- Lottery analysis


-- import
package.path = package.path .. ";../?.lua"

local func = require("functional")
local foreach, map, bind = func.foreach, func.map, func.bind

local count = require("count")
local draws = require("lib.megasena")


-- count
ball_register = count.new_register(60)
for draw, golden_balls in ipairs(draws) do
  ball_register.update(golden_balls)
end
table.sort(ball_register.entries, function(entry1, entry2)
  return entry1.counter() > entry2.counter()
end)

result = map(function(entry) return entry.label .. ": " .. entry.counter() end, ball_register.entries)


-- weird draws
lottery = dofile("../lib/megasena.lua")
table.sort(lottery, function(draw1, draw2) return (draw1[6] - draw1[1]) < (draw2[6] - draw2[1]) end)
