function Weight()
	
	if not GetSettlement("SIM", "City") then
		return 0
	end

	if SimGetWorkingPlace("SIM","MyWork") then
	    if BuildingGetLevel("MyWork") < 3 then
		    return 0
		end
	end
	
   if HasProperty("SIM", "ServiceSim") then
		return 0			
	end	

	if HasProperty("SIM", "DanceSim") then
		return 0			
	end
	
	if HasProperty("SIM", "CocotteProvidesLove") then
		return 0			
	end

   if not CityGetRandomBuilding("City",-1,30,-1,-1,FILTER_IGNORE,"Sabotage") then
	    return 0
	end

	local OpferSimFiletr = "__F( (Object.GetObjectsByRadius(Sim)==1000)AND(Object.HasDynasty())AND NOT(Object.BelongsToMe())AND NOT(Object.GetState(child))AND NOT(Object.GetState(fighting)))"
	local NumEnemySims = Find("SIM", OpferSimFiletr,"EnemySim", -1)
	if NumEnemySims < 1 then
		return 0
	end

	GetDynasty("EnemySim","DynEnem")
	GetDynasty("SIM","DynDo")
	if DynastyGetDiplomacyState("DynDo","DynEnem") >= DIP_NAP then
		return 0
	end

    if not GetOutdoorMovePosition("SIM","Sabotage","StartHier") then
	    return 0
	end
	
	return 100
end

function Execute()
	MeasureCreate("Measure")
	MeasureAddData("Measure", "TimeOut", 3 + Rand(2))
	MeasureStart("Measure", "SIM", "StartHier", "AssignToPoisonEnemy")
end

function CleanUp()
end
