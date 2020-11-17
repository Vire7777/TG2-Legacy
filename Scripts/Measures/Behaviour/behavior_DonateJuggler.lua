function Run()
	if GetImpactValue("","HaveBeenPickpocketed")>0 then
		return
	end

	if IsPartyMember("") then
		return
	end
	
	if DynastyGetDiplomacyState("Actor", "") > DIP_NEUTRAL then
		return
	end	
	
	local Difficulty = ScenarioGetDifficulty()
	local VictimSkill
	if IsDynastySim("") then 
		VictimSkill = GetSkillValue("","EMPATHY")
	else
		VictimSkill = Rand(4) + 1
	end
	
	if CheckSkill("Actor",8,VictimSkill) then
		ai_GetWorkBuilding("Actor", 102, "Juggler")
		local BegerLevel = SimGetLevel("Actor")
		local begbonus = math.floor(GetImpactValue("Juggler",394))
		local spender = SimGetRank("")
		local spend

		if spender == 0 then
			return
		elseif spender == 1 then
			spend = Rand(4)
		elseif spender == 2 then
			spend = Rand(5)+5
		elseif spender == 3 then
			spend = Rand(10)+7
		elseif spender == 4 then
			spend = Rand(25)+11
		elseif spender == 5 then
			spend = Rand(40)+16
		end

		if Rand(100 ) > (95-(BegerLevel*1)) then
			spend = spend * 10
		end
		local getbeg = math.floor((BegerLevel*5) + spend + ((spend / 100) * begbonus))
		if Difficulty < 2 then
			getbeg = getbeg * 2
			spend = spend * 0.5
		elseif Difficulty == 2 then
			getbeg = getbeg * 1.5
			spend = spend * 0.75
		end	
		CreditMoney("Actor",getbeg,"Offering")
		ShowOverheadSymbol("Actor",false,true,0,"%1t",getbeg)
		if IsDynastySim("Owner") then
			SpendMoney("Owner",spend,"CostFee")
		end
		IncrementXPQuiet("",5)
		IncrementXPQuiet("Actor",3)
		AddImpact("", "HaveBeenPickpocketed", 1, 4)
	end

	Sleep(5)
end

function CleanUp()
	MoveSetActivity("", "")
end