local DBSkillList = require "DBServer.DBSkillList"

local DBCharFullData = {}

function DBCharFullData.Save(pCharFullData)
	local dbVersion = pCharFullData->m_Human.m_DBVersion
	DBSkillList.Save(pCharFullData)
end

return DBCharFullData
