local DBInterface = require "Database.Interface"
local mysql = require "skynet.db.mysql"
local MysqlInterface = require "MysqlInterface"
local DBBuilds = {}

local m_DBInterface
function DBBuilds.StaticInit(dbInterface)
	m_DBInterface = dbInterface
end

function DBBuilds.Load(iCharGuid, iDBVersion)
	local res = m_DBInterface:query(MysqlInterface.LoadCharBuild, 
	iCharGuid,
	iDBVersion
	)
	return res
end

function DBBuilds.Save(iCharGuid, tCharFullData)
	local buildData = tCharFullData.m_Build
	if buildData then
		if buildData.m_BuildItems then
			for _, buildItem in ipairs (buildData.m_BuildItems) do
				m_DBInterface:query(MysqlInterface.SaveCharBuild, 
				iCharGuid,
				buildData.UniqueID,
				buildData.BuildID,
				buildData.Produce,
				buildData.QueueID,
				buildData.CreateTime,
				buildData.EndTime,
				buildData.ProduceTime,
				buildData.Status,
				buildData.IsHelp
				)
			end
		end
	end
end

return DBBuilds
