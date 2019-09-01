local skynet = require "skynet"

local dirtyagent = {}
local cmd = {}

function cmd.savedirty(msg)
	skynet.error("deal savedirty msg", msg)
end

function dirtyagent.command_handler(command, ...)
	local f = assert(cmd[command], command)
	return f(...)
end

return dirtyagent
