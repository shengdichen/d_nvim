local function augroup()
    vim.api.nvim_create_augroup(
        require("git")["augroup"], { clear = true }
    )
end

local function main()
    augroup()
end
main()
