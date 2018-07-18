
-- Module for high-order functions

local function foreach(fn, tbl)
  for key, value in pairs(tbl) do
    fn(key, value)
  end
end


local function filter(predicate, tbl)
  local new_table = {}
  for key, value in pairs(tbl) do
    if predicate(value) then
      new_table[key] = value
    end
  end
  return new_table
end


local function map(fn, tbl)
  local new_table = {}
  for key, value in pairs(tbl) do
    new_table[key] = fn(value)
  end
  return new_table
end


local function unzip(tbl, index)
  local next_index, next_value = next(tbl, index)
  if next_value ~= nil then
    return next_value, unzip(tbl, next_index)
  end
end


local function reduce_rec(fn, value, other_value, ...)
  if not other_value then return value end
  return reduce_rec(fn, fn(value, other_value), ...)
end

local function reduce(fn, tbl, accumulator)
  return accumulator and reduce_rec(fn, accumulator, unzip(tbl))
                      or reduce_rec(fn, unzip(tbl))
end


local function bind(fn, ...)
  local args = { ... }
  return function(...)
    return fn(unzip(args), ...)
  end
end


return {
    foreach = foreach,
    filter = filter,
    map = map,
    reduce = reduce,
    bind = bind,
    unzip = unzip,
}
