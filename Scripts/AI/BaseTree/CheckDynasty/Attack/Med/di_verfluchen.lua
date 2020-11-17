function Weight() 
	
	if not IsDynastySim("SIM") then
		return 0
	end
	
	if not DynastyGetRandomBuilding("SIM", 2, 98, "VerfluchHouse") then
		return 0
	end

	if not BuildingHasUpgrade("VerfluchHouse","steinkreis") then
	   return 0
	end
	
	return 100
end

function Execute()
	if DynastyGetRandomVictim("SIM", 55, "victimfluch") then
		if not DynastyGetDiplomacyState("SIM", "victimfluch") > DIP_NEUTRAL then
			if DynastyGetRandomBuilding("victimfluch", 2, -1, "VictimHouse") then
				AddItems("SIM",966,6,INVENTORY_STD)
				MeasureRun("SIM","VictimHouse","VerFluchen")
				return
			end
		end
	end
end

function CleanUp()
end
