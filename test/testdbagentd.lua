local skynet = require "skynet"
local dbagentd_addr = ...
skynet.start(function()
	skynet.send(dbagentd_addr, "lua", "saveall")
	skynet.send(dbagentd_addr, "lua", "savedirty")
	skynet.send(dbagentd_addr, "lua", "savedirty", 1)
	skynet.call(dbagentd_addr, "lua", "savedirty", 2)
	skynet.send(dbagentd_addr, "lua", "savedirty", 3)
end)
