function Weight()
	
	if not SimGetWorkingPlace("SIM", "Divehouse") then
		return 0
	end

	if HasProperty("SIM", "DanceSim") then
		return 0			
	end
	
	if HasProperty("SIM", "CocotteProvidesLove") then
		return 0			
	end
	
	if HasProperty("SIM", "PoisonEnemies") then
		return 0			
	end
	
	return 100
end

function Execute()
	MeasureCreate("Measure")
	MeasureAddData("Measure", "TimeOut", 2 + Rand(3))
	MeasureStart("Measure", "SIM", "Divehouse", "AssignToServiceDivehouse")
end

function CleanUp()
end
