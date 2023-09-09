-- NOTE:
--  1. view current filetype:
--     :set filetype?
--  2. (re)detect filetype:
--     :filetype detect

local function ssh()
    vim.filetype.add({
        filename = { ["known_hosts"] = "ssh_known_hosts" },
    })
end

local function main()
    ssh()
end
main()
