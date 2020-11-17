function Run()

	if not AliasExists("Destination") then
		StopMeasure()
	end
	if not SimGetWorkingPlace("","Workbuilding") then
		if IsPartyMember("") then
			local NextBuilding = ai_GetNearestDynastyBuilding("",GL_BUILDING_CLASS_WORKSHOP,GL_BUILDING_TYPE_ROBBER)
			if not NextBuilding then
				StopMeasure()
			end
			CopyAlias(NextBuilding,"Workbuilding")
		else
			StopMeasure()
		end
	end
	if not GetOutdoorMovePosition("", "Destination", "DoorPos") then
		StopMeasure()
	end
	
	if BuildingGetOwner("Destination","VictimOwner") then
		local DefValue = GetDynastyID("VictimOwner")
		AddImpact("","NotFriends",DefValue,4)
	end
	
	f_MoveTo("", "DoorPos", GL_MOVESPEED_RUN,1500)
	MeasureSetNotRestartable()
	SetState("", STATE_HIDDEN, false)
	
	CommitAction("burgleahouse","","", "Destination","Destination")	--Start Crime
	
	if DynastyIsAI("") then
		local 	Att
		local		Def
		local		Ok = false
		
		for trys=0,4 do
	
			Att, Def = ai_CheckForces("", "Destination", 1500)
			if Att*1.25 < Def then
				Ok = true
				break
			end
			Sleep(Rand(10)+10)
		end
		
		if not Ok then
			StopMeasure()
			return
		end
	end
	
	PlaySound3DVariation("","Locations/alarm_horn_single",1)
	PlayAnimation("","attack_them")
	CommitAction("burgleahouse","","", "Destination","Destination")
	DynastySetDiplomacyState("Destination","",DIP_FOE)
	if BuildingGetType("Destination") == GL_BUILDING_TYPE_FARM or BuildingGetType("Destination") == GL_BUILDING_TYPE_RANGERHUT or BuildingGetType("Destination") == GL_BUILDING_TYPE_MINE or BuildingGetType("Destination") == GL_BUILDING_TYPE_ROBBER then
		if not f_MoveTo("","DoorPos",GL_MOVESPEED_RUN) then
			StopMeasure()
		end
	else
		SetProperty("Destination", "CanEnter_"..GetID(""),1)
		if not f_MoveTo("","Destination",GL_MOVESPEED_RUN) then
			StopMeasure()
		end
	end
	if GetImpactValue("Destination","buildingburgledtoday")==0 then
		local TimeLeft = 12
		if GetImpactValue("Destination","BoobyTrap")~=0 then
			GetPosition("","ParticleSpawnPos")
			PlaySound3D("","fire/Explosion_01.wav", 1.0)
			StartSingleShotParticle("particles/Explosion.nif", "ParticleSpawnPos", 1,5)
			ModifyHP("",-(0.5*GetMaxHP("")),true,1)
			if GetImpactValue("Destination","buildingburgledtoday")~=0 then
				TimeLeft = ImpactGetMaxTimeleft("Destination","BoobyTrap")
			end
			CommitAction("explosion", "", "", "Destination", "Destination")
			StopMeasure()
		end
		if GetLocatorByName("Destination","bomb1","ParticleSpawnPos") then
			StartSingleShotParticle("particles/plunder.nif","ParticleSpawnPos",8,5)
		end
		if GetLocatorByName("Destination","bomb2","ParticleSpawnPos2") then
			StartSingleShotParticle("particles/plunder.nif","ParticleSpawnPos2",7,5)
		end
		AddImpact("Destination","buildingburgledtoday",1,TimeLeft)
		
		local Money = Plunder("","Destination",22)
		if (Money > 0) then
			PlaySound3DVariation("Destination","measures/plunderbuilding",1)
			feedback_MessageMilitary("Destination","@L_BATTLE_061_PLUNDERBUILDING_MSG_VICTIM_START_HEAD_+0",
				"@L_BATTLE_061_PLUNDERBUILDING_MSG_VICTIM_START_BODY_+0",GetID(""),GetID("Destination"))
			ModifyHP("Destination",-(0.02*GetMaxHP("Destination")),false)
			Time = MoveSetActivity("","carry")
			Sleep(2)
			CarryObject("","Handheld_Device/ANIM_Bag.nif",false)
			PlaySound3DVariation("","measures/plunderbuilding",1)
			Sleep(Time-2)
			MsgQuick("","@L_BATTLE_061_PLUNDERBUILDING_MSG_ACTOR_END_BODY_+0",GetID("Destination"))
			chr_GainXP("",GetData("BaseXP"))		
			--for the mission
			mission_ScoreCrime("",Money)
		else
			MsgQuick("","@L_BATTLE_061_PLUNDERBUILDING_FAILURES_+1")
		end
	else
		MsgQuick("","@L_BATTLE_061_PLUNDERBUILDING_FAILURES_+1")
	end
	f_ExitCurrentBuilding("")
	GetFleePosition("", "Destination", 1500, "Away")
	f_MoveTo("", "Away", GL_MOVESPEED_RUN)
	StopAction("burgleahouse","")
	f_MoveTo("","Workbuilding",GL_MOVESPEED_RUN)
	local	ItemId
	local	Found
	local RemainingSpace
	local Removed
	
	local Count = InventoryGetSlotCount("", INVENTORY_STD)
	for i=0,Count-1 do
		ItemId, Found = InventoryGetSlotInfo("", i, INVENTORY_STD)
		if ItemId and ItemId>0 and Found>0 then
			RemainingSpace	= GetRemainingInventorySpace("Workbuilding",ItemId)
			Removed		= RemoveItems("", ItemId, RemainingSpace)
			if Removed>0 then
				AddItems("Workbuilding", ItemId, Removed)
			end
			
		end
	end

end
-- -----------------------
-- CleanUp
-- -----------------------
function CleanUp()
	if AliasExists("Destination") then
		if HasProperty("Destination", "CanEnter_"..GetID("")) then
			RemoveProperty("Destination", "CanEnter_"..GetID(""))
		end
	end
	if GetInsideBuilding("","CurrentBuilding") then
		if (GetID("CurrentBuilding") == GetID("Destination")) then
			if GetOutdoorMovePosition("", "Destination", "DoorPos") then
				SimBeamMeUp("", "DoorPos", false) -- false added
			end
		end
	end
		
	StopAction("burgleahouse","")
	MoveSetActivity("","")
	CarryObject("","",false)
end




