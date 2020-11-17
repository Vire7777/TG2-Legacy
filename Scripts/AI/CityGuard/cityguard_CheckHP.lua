function Weight()
	
	
	if GetCurrentMeasureName("SIM")=="AttendDoctor" then
		return 0
	end
	
	if GetCurrentMeasurePriority("SIM") >= 40 then
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

	local	Quote = GetHPRelative("SIM")
	if GetImpactValue("","Sickness")>0 then
		return 100
	end
	
	if Quote<0.75 then
		return 100
	end
	
	return 0
end


function Execute()
	if GetImpactValue("","Sickness")>0 then
		MeasureRun("SIM", "", "AttendDoctor")
	else
		MeasureRun("SIM", "LingerPlace", "Linger")
	end
end

function CleanUp()
end
