-- AstroCommunity: import any community modules here
-- We import this file in `lazy_setup.lua` before the `plugins/` folder.
-- This guarantees that the specs are processed before any user plugins.

---@type LazySpec
return {
  "AstroNvim/astrocommunity",
  { import = "astrocommunity.pack.lua" },
  -- import/override with your plugins folder
  { import = "astrocommunity.motion.nvim-surround" },
  { import = "astrocommunity.scrolling.mini-animate" },
  { import = "astrocommunity.git.diffview-nvim" },
  { import = "astrocommunity.completion.codeium-vim" },
}
