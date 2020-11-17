function Run()

	MeasureSetNotRestartable()
	
	-- ms_092_SingForPeacefulness.lua active
	if (GetImpactValue("", "Peaceful") ~= 0) then
		StopMeasure("") 
		return
	end
	
	-- sight distance   
	local DistanceToJoinBattle = gameplayformulas_CalcSightRange("Destination")
	local DefValue = GetDynastyID("Destination")
	local AttValue = GetDynastyID("")
	AddImpact("","NotFriends",DefValue,4)
	AddImpact("Destination","NotFriends",AttValue,4)
	-- i am a building no need to move
	
	if IsType("", "Building") then
		BattleJoin("","Destination", false)
		Sleep(1)
		return
	end

	--dont follow buildings and force outdoor position
	if IsType("Destination", "Building") then
		BuildingGetOwner("Destination", "BOwner")
		if GetState("Destination", STATE_REPAIRING) then 
			SetState("Destination", STATE_REPAIRING, false)
		end
		GetFleePosition("","Destination",1000,"AttackPos")
		if not f_MoveTo("","AttackPos",GL_MOVESPEED_RUN) then
			StopMeasure("")
			return
		end
		AlignTo("","Destination")
		
		if AliasExists("BOwner") then
			DefValue = GetDynastyID("BOwner")
			AddImpact("BOwner","NotFriends",DefValue,4)
		end
		if not HasProperty("","AttBld") then
			SetProperty("","AttBld",1)
		end
	elseif IsType("Destination", "Ship") then
		local radius = 3200
		if not ai_StartInteraction("", "Destination", radius, radius, NIL, true) then
			StopMeasure("")
			return
		end
	elseif IsType("Destination", "Cart") then
		local radius = GetRadius("Destination")*2
		if not ai_StartInteraction("", "Destination", radius, radius, NIL, true) then
			StopMeasure("")
			return
		end
	elseif not ai_StartInteraction("", "Destination", DistanceToJoinBattle, DistanceToJoinBattle, NIL, true) then
		StopMeasure("")
		return
	elseif IsType("Destination", "Sim") then
		GetHomeBuilding("Destination","HomeOfTarget")
		BuildingGetCity("HomeOfTarget","TrialCity")--For some reason GetSettlement kept returning nil and stopping the measure when ("Destination") was out of town...hopefully this ensures that does not happen
		GetOfficeTypeHolder("TrialCity",3,"Judge")
		if (GetImpactValue("Destination","HasCharged")==1) or (GetID("Destination") == GetID("Judge") and HasProperty("TrialCity","TrialBooked")) then
			CommitAction("attackvip","","Destination","Destination") --Your Victim has an important trial to attend and is being watched. very closely....pretty much ensures you will be punished
			if GetImpactValue("Destination","Timer")==0 then
				feedback_MessageCharacter("",
					"@L_ATTACK_HEAD_+0",
					"@L_ATTACK_BODY_+0", GetID("Destination"))
				AddImpact("Destination","Timer",1,1)
			end
		end
	end
	gameplayformulas_SimAttackWithRangeWeapon("", "Destination")
	local iBattleID = BattleJoin("","Destination", false)
	Sleep(1)
end
	
function CleanUp()
end
	