function Weight()
	
	if not GetSettlement("SIM", "City") then
		return 0
	end
	
	if CityFindCrowdedPlace("City", "SIM", "jugglerPlay")==0 then
		return 0
	end
	
	if SimGetWorkingPlace("SIM","MyWork") then
	    if BuildingGetLevel("MyWork") < 2 then
		    return 0
		end
	else
	    return 0
	end
	
	return 100
end

function Execute()
	MeasureCreate("Measure")
	MeasureAddData("Measure", "TimeOut", 3 + Rand(3))
	MeasureStart("Measure", "SIM", "jugglerPlay", "LayTarot")
end

function CleanUp()
end
