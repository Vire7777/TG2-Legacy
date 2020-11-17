function Weight()
	if not DynastyGetRandomVictim("SIM", 45, "VictimDynasty") then
		return 0
	end

	local Count = DynastyGetMemberCount("VictimDynasty")
	local VictimNo = Rand(Count)
	local Difficulty = ScenarioGetDifficulty()
	local AValue = 20 - (Difficulty * 3)
	local IsPDyn = false
	if DynastyIsPlayer("VictimDynasty") then
		local IsPDyn = true
--		local ACanFight = true
		if Count < 1 then

		elseif  Count < 2 then
			AValue = AValue - 2
		elseif  Count < 3 then
			AValue = AValue - 4
		elseif  Count < 4 then
			AValue = AValue - 6
		else
			AValue = AValue - 8
	--		ACanFight = false
		end

		if AValue < 1 then
			AValue = 0
		else
			AValue = Rand(AValue+1)
		end
	end

	if (DynastyGetMember("VictimDynasty", VictimNo, "Victim")) then
		if ai_AICheckAction()==true then
			if IsPDyn and AValue < 5 then
				return 100
			else
				return 50
			end
		end
	end		
	return 0
end

function Execute()
end

function CleanUp()
end
