-- Must add this to .bashrc or .zshrc: 
-- export JDTLS_JVM_ARGS="-javaagent:$HOME/.local/share/nvim/mason/share/jdtls/lombok.jar"

return {
    "mfussenegger/nvim-jdtls",
    config = function()
        local jdtls = require("jdtls")

        -- Helper function to get the jdtls configuration
        local function get_config()
            local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
            local workspace_dir = "/home/jose/.cache/jdtls/workspace/jdt.ls-java-project/" .. project_name

            -- Path to google-java-format jar
            local home = os.getenv('HOME')
            local google_java_format_jar = home .. '/workspace/bin/google-java-format-1.23.0-all-deps.jar'

            return {
                cmd = {
                    "jdtls",
                    "--jvm-arg=" .. string.format("-javaagent:%s", vim.fn.expand "$MASON/share/jdtls/lombok.jar"),
                },
                root_dir = require("jdtls.setup").find_root({ ".git", "mvnw", "gradlew" }),
                settings = {
                    java = {
                        project = {
                            Lombok = {
                                enabled = true,
                            }
                        },
                        format = {
                            enabled = true,
                            settings = {
                                url = google_java_format_jar,
                            },
                        },
                    },
                },
                handlers = {
                    ["language/status"] = function(_, result) end,
                    ["$/progress"] = function(_, result, ctx) end,
                },
                on_attach = function(client, bufnr)
                    -- Enable formatting on save only for Java files
                    vim.api.nvim_create_autocmd("BufWritePre", {
                        buffer = bufnr,
                        callback = function()
                            -- Only format if the file type is Java
                            if vim.bo.filetype == 'java' and vim.api.nvim_buf_is_loaded(bufnr) then
                                vim.lsp.buf.format({ timeout_ms = 1000 })  -- Use `format` instead of `formatting_sync`
                            end
                        end,
                    })
                    -- Go to definition
                    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', { noremap = true, silent = true })

                    -- Trigger code action
                    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', { noremap = true, silent = true })

                    -- Automatically add imports on paste
                    vim.api.nvim_create_autocmd("TextYankPost", {
                        buffer = bufnr,
                        callback = function()
                            -- Trigger code action to add missing imports after pasting
                            vim.lsp.buf.code_action({
                                context = { only = { "source.addImports" } },  -- Limit the code action to adding imports
                                apply = true,
                            })
                        end,
                    })
                end

            }
        end

        -- Create an autocommand for Java files
        vim.api.nvim_create_autocmd("FileType", {
            pattern = "java",
            callback = function()
                jdtls.start_or_attach(get_config())
            end,
        })
    end,
}
