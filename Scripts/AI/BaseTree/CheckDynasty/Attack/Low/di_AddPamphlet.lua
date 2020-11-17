function Weight()
	
	if GetMeasureRepeat("SIM", "AddPamphlet")>0 then
		return 0
	end
	
	if SimGetAge("SIM") < GL_AGE_FOR_GROWNUP then
		return 0
	end
	
	local Difficulty = ScenarioGetDifficulty()
	local Round = GetRound()

	local result = math.min(10+ (Round * Difficulty), 40)  

	return result
	-- return 50
end

function Execute()
	MeasureRun("SIM","VICTIM","AddPamphlet")
end

function CleanUp()
end
