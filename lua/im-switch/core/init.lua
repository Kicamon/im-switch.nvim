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

local function is_cursor_in_comment()
	local current_pos = vim.fn.getcurpos()
	current_pos[3] = current_pos[3] - 1
	vim.fn.setpos('.', current_pos)
	local previous_node = ts_utils.get_node_at_cursor()

	return (previous_node and previous_node:type() == 'comment')
end

--local function is_in_code_block() --markdown
--local ts_utils = require('nvim-treesitter.ts_utils')
--local current_node = ts_utils.get_node_at_cursor()
--while current_node do
--if current_node:type() == 'fenced_code_block' then
--return false
--end
--current_node = current_node:parent()
--end
--return true
--end

local function change_cursor_in_comment()
	if is_cursor_in_comment() then
		Zh()
	end
end

vim.cmd([[
	function! EnterComment()
		lua Zh()
	endfunction
]])

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
			--if (vim.bo.filetype == 'markdown') then
			--if is_in_code_block() then
			--Zh()
			--end
			--end
			Zh()
		end
	})
	vim.api.nvim_create_autocmd("InsertEnter", {
		pattern = M.code,
		callback = function()
			change_cursor_in_comment()
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
			vim.fn.setpos('.', current_pos)
			if previous_node and previous_node:type() == 'comment' then
				Zh()
			end
			current_pos[3] = current_pos[3] + 1
			previous_node = ts_utils.get_node_at_cursor()
			vim.fn.setpos('.', current_pos)
		end
	})
end

return M
