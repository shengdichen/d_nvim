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

---@return boolean
MODULE.is_unix = function()
    -- REF:
    --  https://stackoverflow.com/questions/295052/how-can-i-determine-the-os-of-the-system-from-within-a-lua-script/326677#326677
    return package.config:sub(1, 1) == "/"
end

---@return string
MODULE.HOME = function()
    -- REF:
    --  https://stackoverflow.com/questions/70944869/why-does-a-simple-printos-getenvhome-get-nil/77882654#77882654
    return os.getenv("HOME") or os.getenv("USERPROFILE") or ""
end

---@return string
MODULE.dir_log = function()
    if MODULE.is_unix() then
        return os.getenv("HOME") .. "/.local/state/nvim"
    end
    return os.getenv("LOCALAPPDATA") .. "/nvim-data"
end

return MODULE
