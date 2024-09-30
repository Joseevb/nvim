return {
    "mfussenegger/nvim-jdtls",
    config = function()
        local jdtls = require("jdtls")

        local function get_config()
            local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
            local workspace_dir = "/home/jose/.cache/jdtls/workspace/jdt.ls-java-project/" .. project_name

            return {
                cmd = {
                    "java",
                    "-javaagent:/home/jose/.local/share/nvim/mason/share/jdtls/lombok.jar",
                    "-Declipse.application=org.eclipse.jdt.ls.core.id1",
                    "-Dosgi.bundles.defaultStartLevel=4",
                    "-Declipse.product=org.eclipse.jdt.ls.core.product",
                    "-Dlog.protocol=true",
                    "-Dlog.level=ALL",
                    "-Xms1g",
                    "--add-modules=ALL-SYSTEM",
                    "--add-opens", "java.base/java.util=ALL-UNNAMED",
                    "--add-opens", "java.base/java.lang=ALL-UNNAMED",
                    "-jar", "/home/jose/.local/share/nvim/mason/share/jdtls/plugins/org.eclipse.equinox.launcher_1.6.900.v20240613-2009.jar",
                    "-configuration", "/home/jose/.local/share/nvim/mason/share/jdtls/config",
                    "-data", workspace_dir,
                },
                root_dir = require("jdtls.setup").find_root({ ".git", "mvnw", "gradlew" }),
                settings = {
                    java = {
                        project = {
                            Lombok = {
                                enabled = true,
                            }
                        }
                    },
                },
                handlers = {
                    ["language/status"] = function(_, result) end,
                    ["$/progress"] = function(_, result, ctx) end,
                },
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

