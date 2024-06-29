local markview = {}
local renderer = require("markview/renderer")

--- Setup function for markview.nvim
---
---@param user_config markview_config?
markview.setup = function(user_config)
	---@type markview_config
	renderer.config = vim.tbl_deep_extend("keep", user_config or {}, renderer.config)
end

return markview
