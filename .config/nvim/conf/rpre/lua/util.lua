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

return MODULE
