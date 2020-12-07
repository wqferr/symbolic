local path = (...)
print(path)
local function relative_import(p)
    return require(table.concat({path, p}, "."))
end

return {
    const = relative_import "const"
}
