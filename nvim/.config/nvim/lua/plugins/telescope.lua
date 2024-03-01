local fnamemodify = vim.fn.fnamemodify

---@type LazySpec[]
return {
    {
        "nvim-telescope/telescope.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons",
            "nvim-telescope/telescope-ui-select.nvim",
        },
        event = "VeryLazy",
        cmd = "Telescope",
        config = function()
            local entry_display = require("telescope.pickers.entry_display")
            local pickers = require("telescope.pickers")
            local finders = require("telescope.finders")
            local actions = require("telescope.actions")
            local action_state = require("telescope.actions.state")
            local conf = require("telescope.config").values

            local devicons = require("nvim-web-devicons")
            local lazy = require("lazy")

            local plugin_displayer = entry_display.create({
                separator = " ",
                items = {
                    { remaining = true },
                    { remaining = true },
                },
            })

            local function plugin_entry_maker(plugin)
                local result = vim.fn.split(plugin[1], "/")
                local author = result[1]
                local name = result[2]

                return {
                    value = { author = author, name = name },
                    ordinal = name,
                    display = function()
                        return plugin_displayer({
                            name,
                            { author, "Comment" },
                        })
                    end,
                }
            end

            local function reload_plugin(opts)
                opts = opts or {}

                local plugins = lazy.plugins()

                pickers
                    .new(opts, {
                        finder = finders.new_table({
                            results = plugins,
                            entry_maker = function(plugin)
                                return plugin_entry_maker(plugin)
                            end,
                        }),
                        results_title = "Plugins",
                        prompt_title = false,
                        attach_mappings = function(buffer)
                            actions.select_default:replace(function()
                                actions.close(buffer)
                                local selection = action_state.get_selected_entry()
                                vim.cmd("Lazy reload " .. selection.value.name)
                            end)
                            return true
                        end,
                        sorter = conf.generic_sorter(opts),
                    })
                    :find()
            end
            vim.api.nvim_create_user_command("LazyReloadPlugin", reload_plugin, {})

            local function image_entry_maker(image)
                return {
                    value = image,
                    ordinal = image.Repository .. image.Tag,
                    display = image.Repository,
                }
            end
            local function docker_images(opts)
                opts = opts or {}

                pickers
                    .new(opts, {
                        finder = finders.new_async_job({
                            command_generator = function()
                                return { "docker", "images", "--format", "json" }
                            end,
                            entry_maker = function(image_raw)
                                local image = vim.json.decode(image_raw)
                                if image == nil then
                                    return nil
                                end

                                return image_entry_maker(image)
                            end,
                        }),
                        results_title = "Images",
                        prompt_title = false,
                        sorter = conf.generic_sorter(opts),
                        attach_mappings = function(buffer)
                            actions.select_default:replace(function()
                                actions.close(buffer)
                                local selection = action_state.get_selected_entry()
                                vim.cmd("e term://docker run --rm -it " .. selection.value.Repository)
                            end)

                            return true
                        end,
                    })
                    :find()
            end
            vim.api.nvim_create_user_command("DockerImages", docker_images, {})

            local file_displayer = entry_display.create({
                separator = " ",
                items = {
                    { width = 2 },
                    { remaining = true },
                    { remaining = true },
                },
            })

            local function file_entry_maker(path)
                local file_name = fnamemodify(path, ":t")
                local file_root = path:find("/") == nil and "" or (fnamemodify(path, ":h") .. "/")
                local file_ext = fnamemodify(path, ":e")

                local icons, highlight = devicons.get_icon(path, file_ext, { default = true })

                return {
                    value = path,
                    ordinal = path,
                    display = function()
                        return file_displayer({
                            { icons, highlight },
                            file_name,
                            { file_root, "Comment" },
                        })
                    end,
                }
            end
            local file_theme = {
                theme = "dropdown",
                layout_config = {
                    height = 12,
                    width = 0.5,
                    anchor = "N",
                },
                previewer = false,
            }
            require("telescope").setup({
                pickers = {
                    buffers = file_theme,
                    find_files = vim.tbl_extend("force", file_theme, { entry_maker = file_entry_maker }),
                    oldfiles = vim.tbl_extend("force", file_theme, { entry_maker = file_entry_maker }),
                    git_files = vim.tbl_extend("force", file_theme, { entry_maker = file_entry_maker }),
                },
                extensions = {
                    ["ui-select"] = {
                        require("telescope.themes").get_cursor({}),
                    },
                },
            })

            require("telescope").load_extension("ui-select")
        end,
    },
}

-- vim: foldmethod=marker
