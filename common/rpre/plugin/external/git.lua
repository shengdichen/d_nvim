local function augroup()
    vim.api.nvim_create_augroup(
        require("git")["augroup"], { clear = true }
    )
end

local function gitsigns()
    require('gitsigns').setup(
        {
            sign_priority       = 1, -- lowest possible priority (always leftmost)
            signs               = {
                add          = { text = "+" },
                delete       = { text = "-" },
                topdelete    = { text = "-" },
                change       = { text = "|" },
                changedelete = { text = "|" },
            },
            signs_staged        = {
                add          = { text = "+" },
                delete       = { text = "-" },
                topdelete    = { text = "-" },
                change       = { text = "|" },
                changedelete = { text = "|" },
            },
            attach_to_untracked = false, -- do NOT activate if file untracked

            preview_config      = {
                border = "single",
                style = "minimal",
                relative = "cursor",
                row = 1,
                col = 1
            },

            -- REF:
            --  https://github.com/lewis6991/gitsigns.nvim#keymaps
            on_attach           = function(bufnr)
                local gs = package.loaded.gitsigns

                local function map(mode, l, r, opts)
                    opts = opts or {}
                    opts.buffer = bufnr
                    vim.keymap.set(mode, l, r, opts)
                end

                -- do not detach/attach, just toggle (gutter-)sign
                map("n", "<leader>gq", gs.toggle_signs)

                local function jump(key, positive_dir)
                    map(
                        "n",
                        key,
                        function()
                            local auto_preview = { preview = true }
                            if vim.wo.diff then return key end
                            vim.schedule(
                                function()
                                    if positive_dir then
                                        gs.next_hunk(auto_preview)
                                    else
                                        gs.prev_hunk(auto_preview)
                                    end
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
