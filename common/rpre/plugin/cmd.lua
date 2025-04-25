local function terminal()
    -- prepend "+" to prevent editing a file named "terminal"
    vim.keymap.set("c", ":T", "split +terminal")

    local gid = vim.api.nvim_create_augroup(
        "TerminalMode", { clear = true }
    )
    vim.api.nvim_create_autocmd(
        { "TermOpen" },
        { pattern = { "*" }, group = gid, command = "startinsert" }
    )

    vim.keymap.set("t", "<C-C>", "<C-\\><C-n>") -- exit terminal-mode
end

local function commandline()
    vim.opt.wildmenu = true          -- enable completion
    vim.optwildmode = "list:longest" -- complete as much as possible

    vim.keymap.set("c", ":W", "wa!<Enter>")
    vim.keymap.set("c", "JJ", "<C-U><BS>")
end

local function search()
    vim.opt.hlsearch = true
    vim.opt.incsearch = true

    vim.opt.ignorecase = true
    vim.opt.smartcase = true
end

local function split_to_tmux()
    local function quote(str, use_double)
        local q
        if use_double then
            q = '"'
        else
            q = "'"
        end
        return q .. str .. q
    end

    local function f()
        local n_splits_active = vim.fn.tabpagewinnr(vim.fn.tabpagenr(), "$")
        if n_splits_active > 1 then
            local pos = vim.api.nvim_win_get_cursor(0)
            local cmd_nvim = quote(
                "nvim -c " ..
                -- (re)set cursor position
                quote("call cursor(" .. pos[1] .. ", " .. pos[2] .. ")", false) ..
                " -- " ..
                quote(vim.api.nvim_buf_get_name(0), false),
                true
            )

            vim.api.nvim_buf_delete(0, {}) -- will otherwise complain about swap
            os.execute(table.concat(
                { "tmux", "split-window", cmd_nvim }, " "
            ))
        end
    end

    vim.keymap.set("c", ":Q", f)
end

local function main()
    terminal()
    commandline()
    search()
    split_to_tmux()
end
main()
