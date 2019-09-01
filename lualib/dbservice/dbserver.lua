local skynet = require "skynet"
require "skynet.manager"
local table = table
local assert = assert
local math_fmod = math.fmod

local function launch_slave(conf)
	local command_handler
	if conf.name == "db_slave_offline" then
		conf.dirtyagent = nil
		command_handler = conf.offlineagent.command_handler
	elseif conf.name == "db_slave_dirty" then
		conf.offlineagent = nil
		command_handler = conf.dirtyagent.command_handler
	else
		assert(false, "launch_slave conf.name error"..conf.name)
	end

	skynet.dispatch("lua", function(_,_, ...)
		command_handler(...)
	end)
end

local function launch_master(conf)
	local instance = conf.instance or 8
	assert(instance > 1)
	local slave = {}
	local offline_slave

	skynet.dispatch("lua", function(_,source,command, uid, ...)
		skynet.error(_,source,command, uid, ...)
		if command == "saveall" then
			skynet.send(offline_slave, "lua", command, uid, ...)
			skynet.ret(nil)
		else
			if not uid then
				uid = 0
			end
			slaveid=math_fmod(uid, instance-1) + 1
			skynet.send(slave[slaveid], "lua", command, uid, ...)
			skynet.ret(nil)
		end
	end)

	for i=1,instance-1 do
		table.insert(slave, skynet.newservice(SERVICE_NAME, "db_slave_dirty"))
	end
	table.insert(slave, skynet.newservice(SERVICE_NAME, "db_slave_offline"))
	offline_slave = slave[instance]
end

local function dbserver(conf)
	skynet.start(function()
		if conf.name == "db_master" then
			launch_slave = nil
			conf.dirtyagent = nil
			conf.offlineagent = nil
			launch_master(conf)
		else
			assert(conf.name=="db_slave_offline" or conf.name=="db_slave_dirty", "dbserver conf.name error"..conf.name)
			launch_slave(conf)
		end
	end)
end

return dbserver
