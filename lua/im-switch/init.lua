local defualt_config = require("im-switch.conf")
local core = require("im-switch.core")

local M = {}

function M.setup(opts)
	local conf = vim.tbl_deep_extend("force", defualt_config, opts or {})
	--for i, v in pairs(conf) do
		--print(i, v)
		--if type(v) == "table" then
			--for i2, v2 in pairs(v) do
				--print("\t", i2, v2)
			--end
		--end
	--end
	core.Switch(conf)
end

return M
