local switch = {}

local input_toggle = 1
local ts_utils = require('nvim-treesitter.ts_utils')

local function En()
  local input_status = tonumber(io.popen(switch.check):read('*all'))
  if input_status == 2 then
    input_toggle = 1
    vim.fn.system(switch.en)
  end
end

local function Zh()
  local input_status = tonumber(io.popen(switch.check):read('*all'))
  if input_status ~= 2 and input_toggle == 1 then
    vim.fn.system(switch.zh)
    input_toggle = 0
  end
end

local function is_not_in_code_block() --markdown
  local node_cursor = vim.treesitter.get_captures_at_cursor(0)
  for _, v in pairs(node_cursor) do
    if string.find(v, 'markup.link') or string.find(v, 'markup.raw.block') then
      return false
    end
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

local function setup(opt)
  switch = vim.tbl_deep_extend('force', {
    text = {
      '*.md',
      '*.txt',
    },
    code = {
      '*',
    },
    en = 'fcitx5-remote -c',
    zh = 'fcitx5-remote -o',
    check = 'fcitx5-remote',
  }, opt or {})

  vim.api.nvim_create_autocmd('InsertLeave', {
    pattern = '*',
    callback = function()
      En()
    end,
  })
  vim.api.nvim_create_autocmd('InsertEnter', {
    pattern = switch.text,
    callback = function()
      if filetype_checke() then
        Zh()
      end
    end,
  })
  vim.api.nvim_create_autocmd('InsertEnter', {
    pattern = switch.code,
    callback = function()
      local current_pos = vim.fn.getcurpos()
      current_pos[3] = current_pos[3] - 1
      vim.fn.setpos('.', current_pos)
      local previous_node = ts_utils.get_node_at_cursor()

      if
        previous_node
        and (previous_node:type() == 'comment' or previous_node:type() == 'comment_content')
      then
        Zh()
      end
    end,
  })

  vim.api.nvim_create_autocmd('TextChangedI', {
    pattern = switch.code,
    callback = function()
      if (vim.bo.filetype == 'python' or vim.bo.filetype == 'sh') and vim.fn.line('.') == 1 then
        return
      end
      local current_pos = vim.fn.getcurpos()
      current_pos[3] = current_pos[3] - 1
      vim.fn.setpos('.', current_pos)
      local previous_node = ts_utils.get_node_at_cursor()
      if
        previous_node
        and (previous_node:type() == 'comment' or previous_node:type() == 'comment_content')
      then
        Zh()
      end
      current_pos[3] = current_pos[3] + 1
      vim.fn.setpos('.', current_pos)
    end,
  })
end

return {
  setup = setup,
}
