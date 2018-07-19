
-- Module for counting

local func = require("functional")
local foreach, bind = func.foreach, func.bind

local function new_counter()
  local counter = 0
  return function(delta)
    delta = delta or 0
    counter = counter + delta
    return counter
  end
end


local function new_register(size)
  local entries = {}
  for k = 1, size do
    entries[k] = {
      label = k,
      counter = new_counter(),
    }
  end

  local register = { entries = entries }
  function register.get(label)
    return entries[label].counter()
  end

  function register.increase(label)
    return entries[label].counter(1)
  end

  register.update = bind(foreach, function(_, value)
    register.increase(value)
  end)

  return register
end

return {
  new_register = new_register
}
