function Weight() 
	
	if not BuildingHasUpgrade("VerfluchHouse","steinkreis") then
	    return 0
	end
	
	if not DynastyGetRandomVictim("dynasty", 55, "victimfluch") then
		if not GetSettlement("SIM","City") then
			return 0
		end
		if not CityGetRandomBuilding("City",2,-1,-1,-1,FILTER_IGNORE,"VerfluchHouse") then
			return 0
		end
	end 
	
	if DynastyGetDiplomacyState("dynasty", "victimfluch") > DIP_NEUTRAL then
		return 0
	end
	
	if not DynastyGetRandomBuilding("victimfluch", 2, -1, "VerfluchHouse") then
		return 0
	end
	
	return 100
end

function Execute()
	local DynID = GetDynastyID("dynasty")
	AddItems("SIM",966,6,INVENTORY_STD)
	MeasureRun("SIM","VerfluchHouse","VerFluchen")
	return
end

function CleanUp()
end
