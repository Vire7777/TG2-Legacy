function Weight()

	GetDynasty("SIM","DefDyn")
	if GetDynastyID("DefDyn") == nil or GetDynastyID("DefDyn") < 1 then
		return 0
	end 
	
	if not DynastyGetRandomBuilding("SIM", -1, 12, "Mine") then
		return 0
	end
	
	if GetMeasureRepeat("SIM", "MineGuards")>0 then
		return 0
	end
	
	local Difficulty = ScenarioGetDifficulty()
	if Difficulty < 2 then
		return 0
	elseif Difficulty == 2 then
		return 5
	else
		return 10
	end
	
	return 0
end

function Execute()
	MeasureRun("SIM", nil, "MineGuards")
end

function CleanUp()
end
