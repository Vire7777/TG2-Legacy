function Weight()
	
	if not ReadyToRepeat("SIM", "AI_DepositOffice") then
		return 0
	end

	if not GetSettlement("SIM", "CITY_OF_OFFICE") then
		return 0
	end
	
	if DynastyIsShadow("SIM") then
		return 0
	end
	
	CityGetBuildings("CITY_OF_OFFICE",GL_BUILDING_CLASS_PUBLICBUILDING,GL_BUILDING_TYPE_TOWNHALL,-1,-1,FILTER_IGNORE,"CouncilBuilding")
	
	if HasProperty("CouncilBuilding0","MeetingTasks") then
		if (GetProperty("CouncilBuilding0","MeetingTasks") >= 3) then
			return 0
		end
	end	
	
	if not SimGetOffice("Victim", "VicOffice") then
		return 0
	end
	
	if OfficeGetAccessRights("VicOffice","SIM", 2) then
	
		local DepositionTopActorID = GetProperty("CITY_OF_OFFICE","Crimes_DepositionTopActorID")
		local Bias = 100 - GetFavorToSim("SIM","Victim")
		
		if DepositionTopActorID==GetID("Victim") then
			Bias = Bias + 50
		end
		if (Bias>100) then
			Bias = 100
		end
		
		return Bias
	end
	
	return 0
end

function Execute()
	SetRepeatTimer("SIM", "AI_DepositOffice", 4)
	MeasureRun("SIM", "Victim", "RunForAnOffice")
end

function CleanUp()
end
