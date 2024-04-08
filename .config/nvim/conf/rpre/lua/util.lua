local MODULE = {}

---@param tab table|any[]
---@param val any
---@return boolean
MODULE.has_value = function(tab, val)
    for _, v in ipairs(tab) do
        if v == val then
            return true
        end
    end
    return false
end

---@param this table
---@param that table
---@return table
MODULE.update = function(this, that)
    for k, v in pairs(that) do
        this[k] = v
    end
    return this
end

---@param this table
---@return table
MODULE.copy_shallow = function(this)
    if type(this) ~= "table" then
        return this
    end
    local new = {}
    for k, v in pairs(this) do
        new[k] = v
    end
    return new
end

---@param tbls table[]
---@return table
MODULE.combine = function(tbls)
    local new = {}
    for _, tbl in ipairs(tbls) do
        for k, v in pairs(tbl) do
            new[k] = v
        end
    end
    return new
end

return MODULE
