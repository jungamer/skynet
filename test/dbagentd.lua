local dbserver = require "dbservice.dbserver"
local offlineagent = require "dbservice.offlineagent"
local dirtyagent = require "dbservice.dirtyagent"

--@ db_master:表示启动总的消息处理服务, 会根据消息类型分发给db_slave_offline、 db_slave_dirty 处理
--@ db_slave_offline:表示启动离线从服务
--@ db_slave_dirty:表示启动脏数据从服务
local name = ...
if not name then
	name = "db_master"
end
local server = {
	name = name,
	instance = 8,
}

server.offlineagent = offlineagent
server.dirtyagent = dirtyagent

dbserver(server)

