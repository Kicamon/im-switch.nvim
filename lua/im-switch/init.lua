local au = vim.api.nvim_create_autocmd

local switch = {
  input_toggle = 1,
  text = {
    enable = true,
    files = {
      '*.md',
      '*.txt',
    },
  },
  code = {
    enable = true,
    files = { '*' },
  },
  en = 'fcitx5-remote -c',
  zh = 'fcitx5-remote -o',
  check = 'fcitx5-remote',
}

local function En()
  local input_status = tonumber(io.popen(switch.check):read('*all'))
  if input_status == 2 then
    switch.input_toggle = 1
    vim.fn.system(switch.en)
  end
end

local function Zh()
  local input_status = tonumber(io.popen(switch.check):read('*all'))
  if input_status ~= 2 and switch.input_toggle == 1 then
    vim.fn.system(switch.zh)
    switch.input_toggle = 0
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

local function check_comment()
  local node_cursor = vim.treesitter.get_captures_at_cursor(0)
  for _, v in pairs(node_cursor) do
    if string.find(v, 'comment') or string.find(v, 'documentation') then
      return true
    end
  end
  return false
end

local function setup(opt)
  switch = vim.tbl_deep_extend('force', switch, opt or {})

  au('InsertLeave', {
    pattern = '*',
    callback = function()
      En()
    end,
  })

  if switch.text.enable then
    au('InsertEnter', {
      pattern = switch.text.files,
      callback = function()
        if filetype_checke() then
          Zh()
        end
      end,
    })
  end

  if switch.code.enable then
    au('InsertEnter', {
      pattern = switch.code.files,
      callback = function()
        if (vim.bo.filetype == 'python' or vim.bo.filetype == 'sh') and vim.fn.line('.') == 1 then
          return
        end

        local current_pos = vim.fn.getcurpos()
        current_pos[3] = current_pos[3] - 1
        vim.fn.setpos('.', current_pos)

        if check_comment() then
          Zh()
        end
      end,
    })
    au('TextChangedI', {
      pattern = switch.code.files,
      callback = function()
        if (vim.bo.filetype == 'python' or vim.bo.filetype == 'sh') and vim.fn.line('.') == 1 then
          return
        end

        local current_pos = vim.fn.getcurpos()
        current_pos[3] = current_pos[3] - 1
        vim.fn.setpos('.', current_pos)

        if check_comment() then
          Zh()
        end

        current_pos[3] = current_pos[3] + 1
        vim.fn.setpos('.', current_pos)
      end,
    })
  end
end

return { setup = setup }
