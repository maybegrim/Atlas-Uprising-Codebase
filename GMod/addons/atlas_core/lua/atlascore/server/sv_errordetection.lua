sql.m_strError = nil

setmetatable(sql, { __newindex = function( table, k, v )
	if k == "m_strError" and v then
		if v == "" then return end
		print("[ATLASCORE] [SQLite Error] " .. v )
	end
end } )