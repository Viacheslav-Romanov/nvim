-- plugins/neogen.lua
-- neogen: generate idiomatic doc comment skeletons with a single keymap.
-- Rust → ///, JavaScript/TypeScript → JSDoc /** */, C/C++ → Doxygen /** */
-- Puts the cursor inside the comment so you can fill in the description.

local ok, neogen = pcall(require, "neogen")
if not ok then return end

neogen.setup({
  enabled             = true,
  input_after_comment = true,  -- place cursor inside the generated comment
  languages = {
    rust       = { template = { annotation_convention = "rustdoc" } },
    javascript = { template = { annotation_convention = "jsdoc"   } },
    typescript = { template = { annotation_convention = "tsdoc"   } },
    lua        = { template = { annotation_convention = "emmylua"  } },
    c          = { template = { annotation_convention = "doxygen"  } },
    cpp        = { template = { annotation_convention = "doxygen"  } },
    kotlin     = { template = { annotation_convention = "kdoc"     } },
  },
})

local km = vim.keymap.set
km("n", "<leader>ng", neogen.generate,
  { desc = "Neogen: Generate doc comment" })
km("n", "<leader>nf", function() neogen.generate({ type = "func"  }) end,
  { desc = "Neogen: Doc for function"     })
km("n", "<leader>nc", function() neogen.generate({ type = "class" }) end,
  { desc = "Neogen: Doc for class/type"   })
km("n", "<leader>nt", function() neogen.generate({ type = "type"  }) end,
  { desc = "Neogen: Doc for type alias"   })
