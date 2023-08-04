local M = {}

function M.Switch(opts)
	M.check = opts[opts.is].check
	M.en = opts[opts.is].en
	M.zh = opts[opts.is].zh
	M.text = opts.ft_text
	M.code = opts.ft_code

	vim.api.nvim_create_autocmd("InsertLeave", { pattern = "*", command = "lua En()" })
	vim.api.nvim_create_autocmd("InsertEnter", { pattern = M.text, command = "lua Zh()" })
	vim.api.nvim_create_autocmd("InsertEnter", { pattern = M.code, command = "lua change_cursor_in_comment()" })

	vim.cmd("autocmd InsertCharPre *.lua if v:char == '-' && getline('.')[col('.')-2]=='-' | call EnterComment() | endif")
	vim.cmd(
		"autocmd InsertCharPre *.c,*.cpp,*.java,*.js,*.go if v:char == '/' && getline('.')[col('.')-2]=='/' | call EnterComment() | endif")
	vim.cmd("autocmd InsertCharPre *.py,*.sh,*.zsh if line('.') != 1 && v:char == '#' | call EnterComment() | endif")
end

local input_toggle = 1

function En()
	local input_status = tonumber(io.popen(M.check):read("*all"))
	if (input_status == 2) then
		input_toggle = 1
		os.execute(M.en)
	end
end

function Zh()
	local input_status = tonumber(io.popen(M.check):read("*all"))
	if (input_status ~= 2 and input_toggle == 1) then
		os.execute(M.zh)
		input_toggle = 0
	end
end

local function is_cursor_in_comment()
	local ts_utils = require('nvim-treesitter.ts_utils')

	local current_node = ts_utils.get_node_at_cursor()
	local current_pos = vim.fn.getcurpos()
	current_pos[3] = current_pos[3] - 1
	vim.fn.setpos('.', current_pos)
	local previous_node = ts_utils.get_node_at_cursor()

	return (current_node and current_node:type() == 'comment') or (previous_node and previous_node:type() == 'comment')
end

function change_cursor_in_comment()
	local cursor_in_comment = is_cursor_in_comment()
	if cursor_in_comment then
		Zh()
	end
end

vim.cmd([[
	function! EnterComment()
		lua Zh()
	endfunction
]])

return M
