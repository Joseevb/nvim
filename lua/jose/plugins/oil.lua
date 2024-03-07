return {
    'stevearc/oil.nvim',
    opts = {},
    -- Optional dependencies
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function() 
        require("oil").setup({
            columns = {
                "icon",
                "size",
            },

            delete_to_trash = true,
            view_options = {
                show_hidden = true,
            },

            sort = {
                { "size", "asc"},
            },
        })      
    end
}
