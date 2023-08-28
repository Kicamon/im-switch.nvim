local M = {}

local input_toggle = 1

local function En()
  local input_status = tonumber(io.popen(M.check):read("*all"))
  if (input_status == 2) then
    input_toggle = 1
    os.execute(M.en)
  end
end

local function Zh()
  local input_status = tonumber(io.popen(M.check):read("*all"))
  if (input_status ~= 2 and input_toggle == 1) then
    os.execute(M.zh)
    input_toggle = 0
  end
end

local ts_utils = require('nvim-treesitter.ts_utils')

local md = {
  "language",
  "fenced_code_block_delimiter",
  "link_destination",
  "code_fence_content",
  "fenced_code_block",
  "latex_block",
}

local md_code = {
  "chunk",            --lua
  "translation_unit", --c/cpp
  "module",           --python
}

local function is_not_in_code_block() --markdown
  local node_cursor = ts_utils.get_node_at_cursor()
  for _, node_type in ipairs(md) do
    if node_cursor and node_cursor:type() == node_type then
      return false
    end
  end
  while node_cursor do
    for _, node_type in ipairs(md_code) do
      if node_cursor and node_cursor:type() == node_type then
        return false
      end
    end
    --local current_pos = vim.fn.getcurpos()
    --current_pos[3] = current_pos[3] - 1
    --vim.fn.setpos('.', current_pos)
    --local previous_node = ts_utils.get_node_at_cursor()
    --return previous_node and previous_node:type() == 'comment'
    node_cursor = node_cursor:parent()
  end
  return true
end

local function filetype_checke()
  if vim.bo.filetype == 'markdown' then
    return is_not_in_code_block()
  else
    return true
  end
end

function M.Switch(opts)
  M.check = opts[opts.im].check
  M.en = opts[opts.im].en
  M.zh = opts[opts.im].zh
  M.text = opts.ft_text
  M.code = opts.ft_code

  vim.api.nvim_create_autocmd("InsertLeave", {
    pattern = "*",
    callback = function()
      En()
    end
  })
  vim.api.nvim_create_autocmd("InsertEnter", {
    pattern = M.text,
    callback = function()
      if filetype_checke() then
        Zh()
      end
    end
  })
  vim.api.nvim_create_autocmd("InsertEnter", {
    pattern = M.code,
    callback = function()
      local current_pos = vim.fn.getcurpos()
      current_pos[3] = current_pos[3] - 1
      vim.fn.setpos('.', current_pos)
      local previous_node = ts_utils.get_node_at_cursor()

      if previous_node and (previous_node:type() == 'comment' or previous_node:type() == 'comment_content') then
        Zh()
      end
    end
  })

  vim.api.nvim_create_autocmd("TextChangedI", {
    pattern = M.code,
    callback = function()
      if (vim.bo.filetype == 'python' or vim.bo.filetype == 'sh') and vim.fn.line('.') == 1 then
        return
      end
      local current_pos = vim.fn.getcurpos()
      current_pos[3] = current_pos[3] - 1
      vim.fn.setpos('.', current_pos)
      local previous_node = ts_utils.get_node_at_cursor()
      if previous_node and (previous_node:type() == 'comment' or previous_node:type() == 'comment_content') then
        Zh()
      end
      current_pos[3] = current_pos[3] + 1
      vim.fn.setpos('.', current_pos)
    end
  })
end

return M
