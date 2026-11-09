local function pick(name, opts)
    return function() require("fzf-lua")[name](opts) end
end

return {
    "ibhagwan/fzf-lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    cmd = "FzfLua",
    keys = {
        { "<leader>pw", pick("grep", { input_prompt = "Grep For > " }) },
        { "<leader>ff", pick("files") },
        { "<leader>fs", pick("grep_cword") },
        { "<leader>pb", pick("buffers") },
        { "<leader>vh", pick("helptags") },
        { "gr", pick("lsp_references") },
        { "gd", pick("lsp_definitions") },
        { "<leader>sd", pick("diagnostics_document") },
        { "<leader>gi", pick("lsp_implementations") },
    },
    opts = {
        fzf_opts = { ["--wrap"] = true },
    },
}
