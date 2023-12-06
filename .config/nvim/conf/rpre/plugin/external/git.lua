local function augroup()
    vim.api.nvim_create_augroup(
        require("git")["augroup"], { clear = true }
    )
end

local function gitsigns()
    require('gitsigns').setup(
        {
            signs               = {
                add          = { text = '+' },
                topdelete    = { text = '-' },
                delete       = { text = '-' },
                change       = { text = '/' },
                changedelete = { text = '|' },
            },
            attach_to_untracked = false, -- do NOT activate if file untracked

            on_attach           = function(bufnr)
                local gs = package.loaded.gitsigns

                local function map(mode, l, r, opts)
                    opts = opts or {}
                    opts.buffer = bufnr
                    vim.keymap.set(mode, l, r, opts)
                end

                local function jump(key, positive_dir)
                    map(
                        "n",
                        key,
                        function()
                            if vim.wo.diff then return key end
                            vim.schedule(
                                function()
                                    if positive_dir then gs.next_hunk() else gs.prev_hunk() end
                                end
                            )
                            return "<Ignore>"
                        end,
                        { expr = true }
                    )
                end
                jump("<Leader>gk", false)
                jump("<Leader>gj", true)

                -- add
                map("n", "<leader>ga", gs.stage_hunk)
                map("v", "<leader>ga", function() gs.stage_hunk { vim.fn.line('.'), vim.fn.line('v') } end)
                map("n", "<leader>gA", gs.stage_buffer)
                map("n", "<leader>gr", gs.undo_stage_hunk)

                -- restore
                map("n", "<leader>gu", gs.reset_hunk)
                map("v", "<leader>gu", function() gs.reset_hunk { vim.fn.line('.'), vim.fn.line('v') } end)

                -- inspect
                map("n", "<leader>gg", gs.preview_hunk)
                map("n", "<leader>gdf", gs.diffthis) -- view diff in split
                map("n", "<leader>gl", function() gs.blame_line { full = true } end)

                map({ "o", "x" }, "<Leader>g", ":<C-u>Gitsigns select_hunk<CR>")
            end
        }
    )
end

local function main()
    augroup()
    gitsigns()
end
main()
