local const = require "const"

local test_range = {-3, -2, -1, 0, 1, 2, 3}

for _, v in ipairs(test_range) do
    assert(type(v) == "number", "invalid test setup!")
end

describe(
    "constructor",
    function()
        it(
            "should create a table with a `value` key",
            function()
                for _, v in ipairs(test_range) do
                    assert.are.equal(v, const(v).value)
                end
            end
        )
        it(
            "should copy a constant passed as argument",
            function()
                for _, v in ipairs(test_range) do
                    local c_base = const(v)
                    local copy = const(c_base)
                    assert.are.equal(c_base.value, copy.value)
                    assert.is_not(rawequal(c_base, copy))
                end
            end
        )
        it(
            "should validate its argument",
            function()
                assert.has.errors(
                    function()
                        const("not a number!")
                    end
                )
                assert.has.errors(
                    function()
                        const(nil)
                    end
                )
                assert.has.errors(
                    function()
                        const({})
                    end
                )
            end
        )
    end
)
describe(
    "comparison",
    function()
        it(
            "should work for equality",
            function()
                local c1 = const(1)
                assert.are.equal(c1, const(1))
                assert.are_not.equal(c1, const(2))
                assert.are_not.equal(c1, 1)
            end
        )
        -- TODO tests for other comparisons
    end
)
describe(
    "coercion",
    function()
        it(
            "should work on constants",
            function()
                for _, v in ipairs(test_range) do
                    local c = const(v)
                    assert.are.equal(v, c:asnum())
                end
            end
        )
        it(
            "should work on numbers",
            function()
                for _, v in ipairs(test_range) do
                    assert.are.equal(v, const.asnum(v))
                end
            end
        )
    end
)
describe(
    "arithmetic",
    function()
        it(
            "should support unary minus",
            function()
                for _, v in ipairs(test_range) do
                    local x = const(v)
                    local expected = const(-v)
                    assert.are.equal(expected, -x)
                end
            end
        )
        it(
            "should support addition",
            function()
                local expected = const(0)
                for _, v in ipairs(test_range) do
                    local x = const(v)
                    local y = const(expected.value - x.value)

                    assert.are.equal(expected, x + y)
                    assert.are.equal(expected, y + x)
                    assert.are.equal(expected, x.value + y)
                    assert.are.equal(expected, x + y.value)
                end
            end
        )
        it(
            "should support subtraction",
            function()
                local expected = const(0)
                for _, v in ipairs(test_range) do
                    local x = const(v)
                    local y = const(expected.value + x.value)

                    assert.are.equal(expected, y - x)
                    assert.are.equal(expected, y.value - x)
                    assert.are.equal(expected, y - x.value)

                    assert.are.equal(-expected, x - y)
                    assert.are.equal(-expected, x.value - y)
                    assert.are.equal(-expected, x - y.value)
                end
            end
        )
    end
)
