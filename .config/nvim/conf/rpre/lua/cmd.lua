local function run_in_terminal(cmd)
    vim.cmd("terminal $SHELL -c " .. '"' .. cmd .. '"')
end

local function main()
    local d = {}
    d["run_in_terminal"] = run_in_terminal

    return d
end
return main()
