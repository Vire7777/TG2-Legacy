-------------------------------------------------------------------------------
----
----	OVERVIEW "ms_043_CaptureBuilding"
----
----	with this measure the player can capture a building
----
-------------------------------------------------------------------------------

-- -----------------------
-- Run
-- -----------------------
function Run()	
	SimGetWorkingPlace("", "WorkingPlace")
	BuildingGetOwner("WorkingPlace", "SimOwner")
	Find("SimOwner","__F((Object.GetObjectsByRadius(Sim) == 1500) AND (Object.GetProfession() == 21) OR (Object.GetProfession() == 25))", "Protected", 1)
	if AliasExists("Protected") then
		MsgQuick("SimOwner","The guards are too close to this building to capture it.")
		StopMeasure()
	end
	if not AliasExists("Destination") then
		StopMeasure()
	end

	local MeasureID = GetCurrentMeasureID("")
	local TimeOut = mdata_GetTimeOut(MeasureID)
	
	if GetState("", STATE_FIGHTING) then
		return
	end
	
	if AliasExists("SimOwner") then
		local DefValue = GetDynastyID("SimOwner")
		AddImpact("","NotFriends",DefValue,7)
	end
	
	if not f_MoveTo("","Destination") then
		GetOutdoorMovePosition("","Destination","MovePos")
		if not f_MoveTo("","Destination") then
			StopMeasure()
		end
	end
	
	CopyAlias("Destination","InsideBuilding")
	
	SetData("Success", "0")
	--SetData("Target", "InsideBuilding")
	
	if not (SimGetWorkingPlace("","WorkBuilding")) then
		MsgQuick("", "@L_BATTLE_043_CAPTUREBUILDING_FAILURES_+0")
		return	
	end
	
	if not (BuildingGetOwner("WorkBuilding","AttackerOwner")) then
		MsgQuick("", "@L_BATTLE_043_CAPTUREBUILDING_FAILURES_+1")
		return	
	end
	
	if not (BuildingGetOwner("InsideBuilding","OldBuildingOwner")) then
		MsgQuick("", "@L_BATTLE_043_CAPTUREBUILDING_FAILURES_+1")
		return
	end
	
	if not SendCommandNoWait("", "ChangeFlags") then
		MsgQuick("", "@L_BATTLE_043_CAPTUREBUILDING_FAILURES_+2")
	end
	CarryObject("", "Handheld_Device/ANIM_Flag.nif",false)
	
	LoopAnimation("", "capture_building",31)
	CarryObject("","",false)
	
	Sleep (5)
	
	if not (BuildingBuy("InsideBuilding","AttackerOwner", BM_CAPTURE)) then
		MsgQuick("", "@L_BATTLE_043_CAPTUREBUILDING_FAILURES_+3")
		return
	end
	
	SetRepeatTimer("Dynasty", GetMeasureRepeatName2("CaptureBuilding"), TimeOut)
	
	if GetImpactValue("Destination","messagesent")==0 then
		SetData("Success", "1")
		AddImpact("Destination","recentlycapturedbuilding",1,36)
		MsgNewsNoWait("OldBuildingOwner","","","military",-1,
			"@L_BATTLE_043_CAPTUREBUILDING_MSG_VICTIM_HEAD_+0",
			"@L_BATTLE_043_CAPTUREBUILDING_MSG_VICTIM_BODY_+0", GetID(""), GetID("InsideBuilding"))
		
		MsgNewsNoWait("","","","military",-1,
			"@L_BATTLE_043_CAPTUREBUILDING_MSG_ACTOR_HEAD_+0",
			"@L_BATTLE_043_CAPTUREBUILDING_MSG_ACTOR_BODY_+0", GetID("InsideBuilding"))
		
		-- clear all eventual workers and ppl out of the building
		
		--for the mission
		local MissionMoney = chr_GetBootyCount("InsideBuilding",INVENTORY_STD) + chr_GetBootyCount("InsideBuilding",INVENTORY_SELL)
		MissionMoney = MissionMoney + BuildingGetValue("InsideBuilding")
		mission_ScoreCrime("",MissionMoney)
		
		-- Add xp
		xp_CaptureBuilding("SimOwner", GetData("BaseXP"), BuildingGetLevel("InsideBuilding"))
		Evacuate("InsideBuilding", true)
	end
	StopMeasure()
end

-- -----------------------
-- ChangeFlags
-- -----------------------
function ChangeFlags()
	if (BuildingGetFlag("InsideBuilding", "FlagObject", 1)) then
		local bFlag2 = BuildingGetFlag("InsideBuilding", "FlagObject2", 2)
		local bFlag3 = BuildingGetFlag("InsideBuilding", "FlagObject3", 3)
		if (GetDynasty("", "AttackerDynasty")) then 
			--down

			if AliasExists("FlagObject2") then
				GfxMoveToPositionNoWait("FlagObject2", 0, -65, 0, 15, false)
			end
			if AliasExists("FlagObject3") then
				GfxMoveToPositionNoWait("FlagObject3", 0, -65, 0, 15, false)
			end
			if AliasExists("FlagObject") then
				GfxMoveToPosition("FlagObject", 0, -65, 0, 15, false)
			end
			
			--change color
			if AliasExists("FlagObject2") then
				BuildingSetFlagColor("InsideBuilding", "AttackerDynasty", 2)
			end
			if AliasExists("FlagObject3") then
				BuildingSetFlagColor("InsideBuilding", "AttackerDynasty", 3)
			end
			if AliasExists("FlagObject") then
				BuildingSetFlagColor("InsideBuilding", "AttackerDynasty")
			end

			--up
			if AliasExists("FlagObject2") then
				GfxMoveToPositionNoWait("FlagObject2", 0, 65, 0, 15, false)
			end
			if AliasExists("FlagObject3") then
				GfxMoveToPositionNoWait("FlagObject3", 0, 65, 0, 15, false)
			end	
			if AliasExists("FlagObject") then
				GfxMoveToPosition("FlagObject", 0, 65, 0, 15, false)
			end
		end
	end
	
end

-- -----------------------
-- CleanUp
-- -----------------------
function CleanUp()
	local bSuccess	= GetData("Success")
	if not (bSuccess == 1) then
		if AliasExists("OldBuildingOwner") then
			if (GetDynasty("OldBuildingOwner", "OldDynasty")) then 
				BuildingSetFlagColor("InsideBuilding", "OldDynasty", 1)
				BuildingSetFlagColor("InsideBuilding", "OldDynasty", 2)
				BuildingSetFlagColor("InsideBuilding", "OldDynasty", 3)
				if AliasExists("FlagObject") then
					GfxSetPosition("FlagObject", 0, 0, 0, true)
				end
				if AliasExists("FlagObject2") then
					GfxSetPosition("FlagObject2", 0, 0, 0, true)
				end
				if AliasExists("FlagObject3") then
					GfxSetPosition("FlagObject3", 0, 0, 0, true)
				end
				CarryObject("","",false)
			end
		end
	end
end

function GetOSHData(MeasureID)
	--can be used again in:
	OSHSetMeasureRepeat("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+2",Gametime2Total(mdata_GetTimeOut(MeasureID)))
end

