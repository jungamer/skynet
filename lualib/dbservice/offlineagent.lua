local skynet = require "skynet"

local offlineagent = {}
local cmd = {}

function cmd.saveall(msg)
	skynet.error("deal saveall msg", msg)
end

function offlineagent.command_handler(command, ...)
	local f = assert(cmd[command], command)
	return f(...)
end

return offlineagent
