local Expectation = require(script.Parent.Expectation)

local function copy(t)
	local result = {}

	for key, value in pairs(t) do
		result[key] = value
	end

	return result
end

local ExpectationContext = {}
ExpectationContext.__index = ExpectationContext

function ExpectationContext.new(parent)
	local self = {
		_extensions = parent and copy(parent._extensions) or {},
	}

	return setmetatable(self, ExpectationContext)
end

function ExpectationContext:startExpectationChain(...)
	return Expectation.new(...):extend(self._extensions)
end

function ExpectationContext:extend(config)
	for key, value in pairs(config) do
		if self._extensions[key] then
			error(string.format("Cannot reassign %q in expect.extend", key))
		end

		self._extensions[key] = value
	end
end

return ExpectationContext