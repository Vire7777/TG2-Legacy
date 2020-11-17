function Weight()
	local	Quote = GetHPRelative("SIM")
	if Quote>0.95 then
		return 0
	end
	
	if not GetSettlement("SIM", "City") then
		if not AliasExists("City") then
			return 0
		end
	end
	
	if not CityGetNearestBuilding("City", "SIM", -1, GL_BUILDING_TYPE_LINGERPLACE, -1, -1, FILTER_IGNORE, "LingerPlace") then
		return 0
	end
		
	if Quote<0.75 then
		return -20
	end
	
	return 1
end


function Execute()
	MeasureRun("SIM", "LingerPlace", "Linger")
end

function CleanUp()
end
