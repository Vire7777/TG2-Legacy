function Run()

	local MaxDistance = 1000
	local ActionDistance = 100
	if not AliasExists("Destination") then
		StopMeasure()
	end
	
	if GetState("Destination",STATE_DEAD) then
		StopMeasure()
	end
	
	--run to destination and start action at MaxDistance
	if not ai_StartInteraction("", "Destination", MaxDistance, ActionDistance, nil, true) then
		StopMeasure()
	end
	
	if not GetSettlement("Destination","settlement") then
		StopMeasure()
	end
	
	feedback_OverheadActionName("Destination")
	GetPosition("Destination", "ParticleSpawnPos")
	BattleWeaponPresent("")
	Sleep(2)
	
	
	local Bounty = 0

	
	PlayAnimationNoWait("","finishing_move_01")
	Sleep(0.6)	
	StartSingleShotParticle("particles/bloodsplash.nif", "ParticleSpawnPos", 1,4)
	PlaySound3DVariation("Destination","Effects/combat_strike_mace",1)
	Sleep(2)
	BattleWeaponStore("")

	StopAction("murder", "")

	MeasureSetNotRestartable()
	feedback_MessageCharacter("","@L_BATTLE_FIGHTKILL_MSG_SUCCESS_OWNER_HEAD_+0",
						"@L_BATTLE_FIGHTKILL_MSG_SUCCESS_OWNER_BODY_+0",GetID("Destination"))
	if not HasProperty("Destination","MessageRecieved") then
		SetProperty("Destination","MessageRecieved",1)
		MsgNewsNoWait("Destination","","","intrigue",-1,
						"@L_BATTLE_FIGHTKILL_MSG_SUCCESS_VICTIM_HEAD_+0",
						"@L_BATTLE_FIGHTKILL_MSG_SUCCESS_VICTIM_BODY_+0",GetID("Destination"),GetID(""))
	end
	local VictimLevel = SimGetLevel("Destination")
	local baseXP = GetData("BaseXP")
	baseXP = baseXP * VictimLevel
	chr_GainXP("",baseXP)
	Sleep(1)
	if GetDynastyID("")>0 then
		-- keien office angestellten
		GetOfficeTypeHolder("settlement",3,"Judge")
		if GetImpactValue("Destination","HasCharged")==1 or (GetID("Destination") == GetID("Judge") and HasProperty("settlement","TrialBooked")) then
		    SimGetWorkingPlace("","WorkBuilding")
			BuildingGetOwner("WorkBuilding","BuildingOwner")
			if GetImpactValue("","IsCharged")==1 then
		        CommitAction("murder","","Destination","Destination")
			    CityAddPenalty("settlement","",PENALTY_FUGITIVE,96)
				CommitAction("revolt","","")
				RemoveImpact("","IsCharged")
				AddImpact("","REVOLT",1,96)
				feedback_MessageCharacter("",
			        "@L_DEATH_HEAD_+0",
			        "@L_DEATH_BODY_+0", GetID("Destination"))
			elseif GetImpactValue("BuildingOwner","IsCharged")==1 and not (GetID("") == GetID("BuildingOwner")) then
		        CommitAction("murder","","Destination","Destination")
			    CityAddPenalty("settlement","BuildingOwner",PENALTY_FUGITIVE,96)
				CommitAction("revolt","BuildingOwner","BuildingOwner")
				CityAddPenalty("settlement","",PENALTY_FUGITIVE,96)
			    RemoveImpact("BuildingOwner","IsCharged")
				AddImpact("BuildingOwner","REVOLT",1,96)
				feedback_MessageCharacter("BuildingOwner",
			        "@L_DEATH_HEAD_+1",
			        "@L_DEATH_BODY_+1", GetID("Destination"))
			else
			    CommitAction("murder","BuildingOwner","Destination","Destination")
				CommitAction("murder","","Destination","Destination")
			    CityAddPenalty("settlement","",PENALTY_PRISON,96)
				CityAddPenalty("settlement","BuildingOwner",PENALTY_PRISON,96)
			    feedback_MessageCharacter("",
			        "@L_DEATH_HEAD_+2",
			        "@L_DEATH_BODY_+2", GetID("Destination"))
				feedback_MessageCharacter("BuildingOwner",
			        "@L_DEATH_HEAD_+2",
			        "@L_DEATH_BODY_+2", GetID("Destination"))
			end		
		elseif GetImpactValue("Destination","REVOLT")==1 then
			Bounty = SimGetLevel("Destination")*500
		else
			CommitAction("murder","","Destination","Destination")
		end
	end
	SetProperty("Destination","UnconsciousKill",1)
	Kill("Destination")	-- must be the last command in this measure, because the kill of a measure object restarts the measure
end

function CleanUp()
end
