local const = {}
local const_meta = {__index = const}

function const.new(value)
    local v = tonumber(value)
    assert(type(v) == "number", "Value must be a number")

    local c = {value = v}
    setmetatable(c, const_meta)
    return c
end

function const.asconst(arg)
    if type(arg) == "number" then
        return const.new(arg)
    elseif type(arg) == "table" or type(arg) == "userdata" then
        return const.new(arg.value)
    else
        error("Can only coerce from numbers or tables/userdata with `value` key")
    end
end

function const.asnum(arg)
    if type(arg) == "number" then
        return arg
    elseif type(arg) == "table" or type(arg) == "userdata" then
        assert(arg.value ~= nil, "Object has no `value` key")

        local v = tonumber(arg.value)
        assert(v ~= nil, "Object has a non-number value stored in the `value` key")
        return v
    else
        error("Can only coerce from numbers or tables/userdata with `value` key")
    end
end

function const.isint(arg)
    return const.asnum(arg) % 1 == 0
end

function const:unm()
    return const.new(-self.value)
end
const_meta.__unm = const.unm

function const:add(other)
    return const.new(self.value + const.asnum(other))
end
const_meta.__add = const.add

function const:sub(other)
    return const.new(self.value - const.asnum(other))
end
const_meta.__sub = const.sub

function const:mul(other)
    return const.new(self.value * const.asnum(other))
end
const_meta.__mul = const.mul

function const:div(other)
    return const.new(self.value / const.asnum(other))
end
const_meta.__div = const.div

function const:mod(other)
    return const.new(self.value % const.asnum(other))
end
const_meta.__mod = const.mod

function const:pow(other)
    return const.new(self.value ^ const.asnum(other))
end
const_meta.__pow = const.pow

const.float_fmt = "const<%.2f>"
const.int_fmt = "const<%d>"
function const_meta:__tostring()
    if self:isint() then
        return self.int_fmt:format(self.value)
    else
        return self.float_fmt:format(self.value)
    end
end

-- Make const a callable table as a constructor
setmetatable(
    const,
    {
        __call = function(_, v)
            return const.new(v)
        end
    }
)
return const
