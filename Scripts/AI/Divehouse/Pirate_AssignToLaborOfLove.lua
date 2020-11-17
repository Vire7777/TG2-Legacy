function Weight()
	
	if not GetSettlement("SIM", "City") then
		return 0
	end

	if not SimGetWorkingPlace("SIM", "Divehouse") then
		return 0
	end

	if CityFindCrowdedPlace("City", "SIM", "pick_pos")<3 then
		return 0
	end

	if HasProperty("SIM", "ServiceSim") then
		return 0			
	end	

	if HasProperty("SIM", "DanceSim") then
		return 0			
	end
	
	if HasProperty("SIM", "PoisonEnemies") then
		return 0			
	end
	
	return 100
end

function Execute()
	MeasureCreate("Measure")
	MeasureAddData("Measure", "TimeOut", 2 + Rand(6))
	MeasureStart("Measure", "SIM", "pick_pos", "AssignToLaborOfLove")
end

function CleanUp()
end
