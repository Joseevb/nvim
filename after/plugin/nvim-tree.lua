local nvim_tree_api = require("nvim-tree.api")

local function my_on_attach(bufnr)
    local function opts(desc)
        return {
            desc = "nvim-tree: " .. desc,
            buffer = bufnr,
            noremap = true,
            silent = true,
            nowait = true,
        }
    end

    nvim_tree_api.config.mappings.default_on_attach(bufnr)

end


require("nvim-tree").setup {
    on_attach = my_on_attach,
    renderer = {
        group_empty = true,
    },
}

