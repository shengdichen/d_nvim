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

return MODULE
