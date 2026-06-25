-- plugins/xcodebuild.lua — macOS only, lazy-loaded via ft = swift/objc
local ok, xcodebuild = pcall(require, "xcodebuild")
if not ok then return end

xcodebuild.setup({
  restore_on_start = true,
  auto_save        = true,
  code_coverage    = { enabled = false },
  test_search      = { file_matching = "filename_lsp" },
  logs = {
    auto_open_on_failed_build = true,
    auto_open_on_failed_tests = true,
    auto_focus                = false,
    show_warnings             = true,
  },
  quickfix = { show_errors_on_quickfixlist = true, show_warnings_on_quickfixlist = true },
})
