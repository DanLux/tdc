
-- Module to represent temperatures in K, °C, °F


-- constructors
local function new_temperature(degrees, scale)
    return setmetatable({ degrees = degrees }, scale)
end

local kelvin_metatable = {}
local function new_kelvin(degrees)
    return new_temperature(degrees, kelvin_metatable)
end

local celsius_metatable = {}
local function new_celsius(degrees)
    return new_temperature(degrees, celsius_metatable)
end

local fahrenheit_metatable = {}
local function new_fahrenheit(degrees)
    return new_temperature(degrees, fahrenheit_metatable)
end


-- scale formulas
local function celsius_to_kelvin(temperature)
    return new_kelvin(temperature.degrees + 273.15)
end

local function kelvin_to_celsius(temperature)
    return new_celsius(temperature.degrees - 273.15)
end

local function kelvin_to_fahrenheit(temperature)
    return new_fahrenheit(temperature.degrees * 9/5 - 459.67)
end

local function fahrenheit_to_kelvin(temperature)
    return new_kelvin((temperature.degrees + 459.67) * 5/9)
end


-- to_scale
local function to_kelvin(temperature)
    if getmetatable(temperature) == kelvin_metatable then
        return temperature
    elseif getmetatable(temperature) == celsius_metatable then
        return celsius_to_kelvin(temperature)
    elseif getmetatable(temperature) == fahrenheit_metatable then
        return fahrenheit_to_kelvin(temperature)
    else
        error("argument provided does not represent a temperature", 2)
    end
end

local function to_celsius(temperature)
    return kelvin_to_celsius(to_kelvin(temperature))
end

local function to_fahrenheit(temperature)
    return kelvin_to_fahrenheit(to_kelvin(temperature))
end


-- real temperatures
local absolute_zero = new_kelvin(0)
local absolute_hot = new_kelvin(1.4168 * 10^32)

local function degrees_between_limits(degrees, to_scale)
    degrees = math.max(degrees, to_scale(absolute_zero).degrees)
    degrees = math.min(degrees, to_scale(absolute_hot).degrees)
    return degrees
end

local function kelvin(degrees)
    return new_kelvin(degrees_between_limits(degrees, to_kelvin))
end

local function celsius(degrees)
    return new_celsius(degrees_between_limits(degrees, to_celsius))
end

local function fahrenheit(degrees)
    return new_fahrenheit(degrees_between_limits(degrees, to_fahrenheit))
end


-- Metatables

-- + operator
function kelvin_metatable.__add(temperature, another_temperature)
    return kelvin(to_kelvin(temperature).degrees + to_kelvin(another_temperature).degrees)
end

function celsius_metatable.__add(temperature, another_temperature)
    return celsius(to_celsius(temperature).degrees + to_celsius(another_temperature).degrees)
end

function fahrenheit_metatable.__add(temperature, another_temperature)
    return fahrenheit(to_fahrenheit(temperature).degrees + to_fahrenheit(another_temperature).degrees)
end

-- - operator
function kelvin_metatable.__sub(temperature, another_temperature)
    return kelvin(to_kelvin(temperature).degrees - to_kelvin(another_temperature).degrees)
end

function celsius_metatable.__sub(temperature, another_temperature)
    return celsius(to_celsius(temperature).degrees - to_celsius(another_temperature).degrees)
end

function fahrenheit_metatable.__sub(temperature, another_temperature)
    return fahrenheit(to_fahrenheit(temperature).degrees - to_fahrenheit(another_temperature).degrees)
end

-- tostring method
function kelvin_metatable.__tostring(temperature)
    return to_kelvin(temperature).degrees .. "K"
end

function celsius_metatable.__tostring(temperature)
    return to_celsius(temperature).degrees .. "°C"
end

function fahrenheit_metatable.__tostring(temperature)
    return to_fahrenheit(temperature).degrees .. "°F"
end


return {
    absolute_zero = absolute_zero,
    absolute_hot = absolute_hot,

    kelvin = kelvin,
    celsius = celsius,
    fahrenheit = fahrenheit,

    to_kelvin = to_kelvin,
    to_celsius = to_celsius,
    to_fahrenheit = to_fahrenheit,
}
