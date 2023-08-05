local defualt_config = require("im-switch.conf")
local core = require("im-switch.core")

local M = {}

function M.setup(opts)
	local conf = vim.tbl_deep_extend("force", defualt_config, opts or {})
	core.Switch(conf)
end

return M
