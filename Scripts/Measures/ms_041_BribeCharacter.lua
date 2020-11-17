-------------------------------------------------------------------------------
----
----	OVERVIEW "ms_041_BribeCharacter"
----
----	with this measure the player can bribe an other character to increase
----	the favour of his victim
----
-------------------------------------------------------------------------------


function Init()
	
	GetDynasty("Destination", "dynasty")
	DynastyGetMember("dynasty",0,"boss")
	local Difficulty = ScenarioGetDifficulty()
	local MyMoney = 0
	if HasProperty("","BugFix") and not DynastyIsPlayer("") then
		GetDynasty("", "Madynasty")
		DynastyGetFamilyMember("Madynasty",0,"DaBoss")
		MyMoney = GetMoney("DaBoss")
	else
		MyMoney = GetMoney("")
	end
	local money = SimGetWealth("Destination") 
	local Money = {}
		Money[1] = math.floor(money * 0.01)
		Money[2] = math.floor(money * 0.025)
		Money[3] = math.floor(money * 0.05)
	
	local X = SimGetOfficeLevel("Destination")
	local Title = GetNobilityTitle("Destination")
	local TitleCost = Title * 100
	local Level = {}
		Level[-1] = 0
		Level[1] = 500
		Level[2] = 1000
		Level[3] = 1500
		Level[4] = 2000
		Level[5] = 2500
		Level[6] = 3000
		Level[7] = 5000
		
	local OfficeCost = Level[X]
	local PowerCost = TitleCost + OfficeCost		
	local Choice = {}
		Choice[1] = Money[1] + PowerCost
		Choice[2] = Money[2] + PowerCost
		Choice[3] = Money[3] + PowerCost
	
	local Favor = {}
		Favor[1] = 5
		Favor[2] = 10
		Favor[3] = 20
	
	if Difficulty < 2 then
		Choice[1] = 500
		Choice[2] = 750
	    Choice[3] = 1000
		Favor[1] = Favor[1] * 5
	    Favor[2] = Favor[2] * 5
	    Favor[3] = Favor[3] * 5
	elseif Difficulty == 2 then
		Choice[1] =	Choice[1] * 0.5
	    Choice[2] = Choice[2] * 0.5
	    Choice[3] = Choice[3] * 0.5
		Favor[1] = Favor[1] * 2
	    Favor[2] = Favor[2] * 2
	    Favor[3] = Favor[3] * 2
	end
	
	if not DynastyIsPlayer("") and Choice[1] > 10000 then
		Choice[1] = 10000
	end
	if not DynastyIsPlayer("") and Choice[2] > 10000 then
		Choice[2] = 10000
	end
	if not DynastyIsPlayer("") and Choice[3] > 10000 then
		Choice[3] = 10000
	end
	
	if MyMoney < Choice[1] then
		MsgQuick("","@L_INTRIGUE_041_BRIBECHARACTER_FAILURES_+0")
		StopMeasure()
	end
	
	local panel
	if MyMoney >= Choice[3] then
        panel = ("@P"..
        "@B[1,@L_INTRIGUE_041_BRIBECHARACTER_SCREENPLAY_ACTOR_CHOICE_+0,@L_INTRIGUE_041_BRIBECHARACTER_SCREENPLAY_ACTOR_CHOICE_+0,Hud/Buttons/btn_Money_Small.tga]"..
		"@B[2,@L_INTRIGUE_041_BRIBECHARACTER_SCREENPLAY_ACTOR_CHOICE_+1,@L_INTRIGUE_041_BRIBECHARACTER_SCREENPLAY_ACTOR_CHOICE_+1,Hud/Buttons/btn_Money_Medium.tga]"..
		"@B[3,@L_INTRIGUE_041_BRIBECHARACTER_SCREENPLAY_ACTOR_CHOICE_+2,@L_INTRIGUE_041_BRIBECHARACTER_SCREENPLAY_ACTOR_CHOICE_+2,Hud/Buttons/btn_Money_Large.tga]")
	elseif MyMoney >= Choice[2] then
        panel = ("@P"..
        "@B[1,@L_INTRIGUE_041_BRIBECHARACTER_SCREENPLAY_ACTOR_CHOICE_+0,@L_INTRIGUE_041_BRIBECHARACTER_SCREENPLAY_ACTOR_CHOICE_+0,Hud/Buttons/btn_Money_Small.tga]"..
		"@B[2,@L_INTRIGUE_041_BRIBECHARACTER_SCREENPLAY_ACTOR_CHOICE_+1,@L_INTRIGUE_041_BRIBECHARACTER_SCREENPLAY_ACTOR_CHOICE_+1,Hud/Buttons/btn_Money_Medium.tga]")
	else
		panel = ("@P"..
        "@B[1,@L_INTRIGUE_041_BRIBECHARACTER_SCREENPLAY_ACTOR_CHOICE_+0,@L_INTRIGUE_041_BRIBECHARACTER_SCREENPLAY_ACTOR_CHOICE_+0,Hud/Buttons/btn_Money_Small.tga]")
	end
	
	MsgMeasure("","")
	local Result = InitData(panel,
	ms_041_BribeCharacter_AIInitBribe,
	"@L_INTRIGUE_041_BRIBECHARACTER_SCREENPLAY_ACTOR_HEAD_+0",
	"@L_INTRIGUE_041_BRIBECHARACTER_SCREENPLAY_ACTOR_BODY_+0",
	GetID("Destination"),Choice[1],Choice[2],Choice[3])

	if Result == 1 then
		SetData("Bribe", Choice[1])
		SetData("Favor", Favor[1])
	elseif Result == 2 then
		SetData("Bribe", Choice[2])
		SetData("Favor", Favor[2])
	elseif Result == 3 then
		SetData("Bribe", Choice[3])
		SetData("Favor", Favor[3])
	else
		StopMeasure()
	end
end

function AIInitBribe()
	--AI decides how much money to spend
	local OwnerMoney = GetMoney("Owner")
	local DestMoney = GetMoney("Destination")
	local Favor = GetFavorToSim("Destination","Owner")
	local SpendFactor = 0
	if OwnerMoney < DestMoney then
		SpendFactor = SpendFactor + 1
	end
	if Favor < 50 then
		SpendFactor = SpendFactor + 1
	end
	if SpendFactor == 2 then
		return 3	
	elseif SpendFactor == 1 then
		return 2
	else
		return 1
	end
end

function AIDecision()
	--AI accept or decline money
	local Money = 0 + GetData("Bribe")
	local DestMoney = GetMoney("Destination") / 10
	local Favor = GetFavorToSim("Destination","Owner")
	local RhetoricSkill = GetSkillValue("",RHETORIC)
	local FavorFactor = ((Money / DestMoney) * 100) + Favor + RhetoricSkill
	
	if FavorFactor < 50 then
		return 2
	else
		return 1
	end

end

function Run()
	if GetState("", STATE_CUTSCENE) then
		SetData("FromCutscene",1)
		ms_041_bribecharacter_Cutscene()
	else
		SetData("FromCutscene",0)
		ms_041_bribecharacter_Normal()
	end
end
  
function Normal()

	if not HasData("Bribe") then
		if IsStateDriven() then
			ms_041_bribecharacter_Init();
		end
		if not HasData("Bribe") then
			StopMeasure()
		end
	end

	--how far the Destination can be to start this action
	local MaxDistance = 1000
	--how far from the destination, the owner should stand while reading the letter from rome
	local ActionDistance = 80
	--how long message for destination will be displayed
	local MsgTimeOut = 0.25 --15 sekunden
	
	local MeasureID = GetCurrentMeasureID("")
	local TimeOut = mdata_GetTimeOut(MeasureID)

	--run to destination and start action at MaxDistance
	if not ai_StartInteraction("", "Destination", MaxDistance, ActionDistance, nil) then
		StopMeasure()
	end
	
	--get money 
	local Money = 0 + GetData("Bribe")
	local ModifyFavor = 0 + GetData("Favor")
	
	if not DynastyIsPlayer("Destination") then
		CreateCutscene("default","cutscene")
		CutsceneAddSim("cutscene","")
		CutsceneAddSim("cutscene","Destination")
		CutsceneCameraCreate("cutscene","")		
		camera_CutsceneBothLock("cutscene", "")
	end
	
	--do visual stuff
	CommitAction("bribe","Owner","Owner","Destination")
	--PlayAnimationNoWait("Destination","cogitate")
	PlayAnimation("", "watch_for_guard")
	
	local time1
	local time2
	time1 = PlayAnimationNoWait("Owner", "use_object_standing")
	time2 = PlayAnimationNoWait("Destination","cogitate")
	Sleep(1)
	PlaySound3D("","Locations/wear_clothes/wear_clothes+1.wav", 1.0)
	CarryObject("","Handheld_Device/ANIM_Smallsack.nif",false)
	
	Sleep(1)
	CarryObject("","",false)
	CarryObject("Destination","Handheld_Device/ANIM_Smallsack.nif",false)
	time2 = PlayAnimationNoWait("Destination","fetch_store_obj_R")
	Sleep(1)
	StopAnimation("")
	PlaySound3D("Destination","Locations/wear_clothes/wear_clothes+1.wav", 1.0)
	CarryObject("Destination","",false)	
	
	--set measure repat time
	SetRepeatTimer("", GetMeasureRepeatName2("BribeCharacter"), TimeOut)
	
	
	
	--display decision message for destination
	local Result = MsgNews("Destination","",
				"@B[1,@L_INTRIGUE_041_BRIBECHARACTER_SCREENPLAY_VICTIM_BUTTON_+0]"..
				"@B[2,@L_INTRIGUE_041_BRIBECHARACTER_SCREENPLAY_VICTIM_BUTTON_+1]",
				ms_041_bribecharacter_AIDecision,  --AIFunc
				"intrigue", --MessageClass
				MsgTimeOut, --TimeOut
				"@L_INTRIGUE_041_BRIBECHARACTER_SCREENPLAY_VICTIM_HEAD_+0",
				"@L_INTRIGUE_041_BRIBECHARACTER_SCREENPLAY_VICTIM_BODY_+0",
				GetID(""),Money)
	local Index
	local ReplacementLabel
	if not DynastyIsPlayer("Destination") then
		camera_CutsceneBothLock("cutscene", "Destination")
	end
	if Result == 1 then --accept money
		Index = MsgSay("Destination","@L_INTRIGUE_041_BRIBECHARACTER_SPEAK_SUCCESS")
		ReplacementLabel = "_INTRIGUE_041_BRIBECHARACTER_SPEAK_SUCCESS_+"..Index
		--do the financial stuff
		if HasProperty("","BugFix") and not DynastyIsPlayer("") then
			DynastyGetFamilyMember("",0,"SugarDaddy")
			SpendMoney("SugarDaddy",Money,"CostBribes")
		else
			SpendMoney("",Money,"CostBribes")
		end
		
		Sleep(1)
		if HasProperty("Destination","BugFix") and not DynastyIsPlayer("Destination") then
			DynastyGetFamilyMember("Destination",0,"PayDaddy")
			chr_RecieveMoney("PayDaddy", Money, "IncomeBribes")
		else
			chr_RecieveMoney("Destination", Money, "IncomeBribes")
		end
		
		--for the mission
		mission_ScoreCrime("Destination",Money)
		
		PlaySound3D("","Effects/coins_to_moneybag+0.wav", 1.0)
		Sleep(1)
		--do the favor stuff
		chr_ModifyFavor("Destination","",ModifyFavor)
		--show message
		chr_GainXP("",GetData("BaseXP"))
		MsgNewsNoWait("","Destination","","intrigue",-1,
			"@L_INTRIGUE_041_BRIBECHARACTER_MSG_SUCCESS_HEAD_+0",
			"@L_INTRIGUE_041_BRIBECHARACTER_MSG_SUCCESS_BODY_+0",ReplacementLabel,GetID("Destination"))
		
	else	--decline money
		Index = MsgSay("Destination","@L_INTRIGUE_041_BRIBECHARACTER_SPEAK_FAILED")
		ReplacementLabel = "_INTRIGUE_041_BRIBECHARACTER_SPEAK_FAILED_+"..Index
		--do the favor stuff
		chr_ModifyFavor("Destination","",-(5+(MaxModifyFavor-ModifyFavor)))
		--show message
		MsgNewsNoWait("","Destination","","intrigue",-1,
			"@L_INTRIGUE_041_BRIBECHARACTER_MSG_FAILED_HEAD_+0",
			"@L_INTRIGUE_041_BRIBECHARACTER_MSG_FAILED_BODY_+0",ReplacementLabel,GetID("Destination"))
	end
	DestroyCutscene("cutscene")
	StopMeasure()
end

function Cutscene()

	if not HasData("Bribe") then
		if IsStateDriven() then
			ms_041_bribecharacter_Init();
		end
		if not HasData("Bribe") then
			StopMeasure()
		end
	end

	if SimGetCutscene("","cutscene") then
		CutsceneSetMeasureLockTime("cutscene", 2.0)
	end

	--how far the Destination can be to start this action
	local MaxDistance = 1000
	--how far from the destination, the owner should stand while reading the letter from rome
	local ActionDistance = 80
	--how much favor from destination to owner is modified. max value
	local MaxModifyFavor = 20
	--how long message for destination will be displayed
	local MsgTimeOut = 0.25 --15 sekunden
	--time before measure can be used again on this destination, in hours
	local MeasureID = GetCurrentMeasureID("")
	local TimeOut = mdata_GetTimeOut(MeasureID)

	--run to destination and start action at MaxDistance
--	if not ai_StartInteraction("", "Destination", MaxDistance, ActionDistance, nil) then
--		StopMeasure()
--	end
	
	--get money 
	local Money = 0 + GetData("Bribe")
	local ModifyFavor
	--calc the favor
	local DestMoney = GetMoney("Destination") / 10
	local FavorFactor = (Money / DestMoney) * 100
	
	if FavorFactor < 35 then
		ModifyFavor = 0.3 * MaxModifyFavor
	elseif FavorFactor < 65 then
		ModifyFavor = 0.6 * MaxModifyFavor
	else
		ModifyFavor = MaxModifyFavor
	end
	
	--do visual stuff
	CommitAction("bribe","Owner","Owner","Destination")
	
	--set measure repat time
	SetRepeatTimer("", GetMeasureRepeatName2("BribeCharacter"), TimeOut)
	
	--SLeep because of the "Ok i do it Soeech of your char"
	Sleep(1)
	
	--display decision message for destination
	local Result = MsgNews("Destination","","@P"..
				"@B[1,@L_INTRIGUE_041_BRIBECHARACTER_SCREENPLAY_VICTIM_BUTTON_+0]"..
				"@B[2,@L_INTRIGUE_041_BRIBECHARACTER_SCREENPLAY_VICTIM_BUTTON_+1]",
				ms_041_bribecharacter_AIDecision,  --AIFunc
				"intrigue", --MessageClass
				MsgTimeOut, --TimeOut
				"@L_INTRIGUE_041_BRIBECHARACTER_SCREENPLAY_VICTIM_HEAD_+0",
				"@L_INTRIGUE_041_BRIBECHARACTER_SCREENPLAY_VICTIM_BODY_+0",
				GetID(""),Money)
	local ReplacementLabel
	if Result == 1 then --accept money
		
--		SetProperty to Check after the Voting if the Destination had voted for the one he had the Money from
		SetProperty("Destination","BribedBy",GetID(""))
		
		--do the financial stuff
		if HasProperty("","BugFix") and not DynastyIsPlayer("") then
			DynastyGetFamilyMember("",0,"SugarDaddy")
			SpendMoney("SugarDaddy",Money,"CostBribes")
		else
			SpendMoney("",Money,"CostBribes")
		end
		if HasProperty("Destination","BugFix") and not DynastyIsPlayer("Destination") then
			DynastyGetFamilyMember("Destination",0,"PayDaddy")
			chr_RecieveMoney("PayDaddy", Money, "IncomeBribes")
		else
			chr_RecieveMoney("Destination", Money, "IncomeBribes")
		end
		--for the mission
		mission_ScoreCrime("Destination",Money)
		--do the favor stuff
		Sleep(1)
		chr_ModifyFavor("Destination","",ModifyFavor)
				
		Index = MsgSay("Destination","@L_INTRIGUE_041_BRIBECHARACTER_SPEAK_SUCCESS")
		ReplacementLabel = "_INTRIGUE_041_BRIBECHARACTER_SPEAK_SUCCESS_+"..Index
		
		Sleep(1)
				
		--show message
		MsgNewsNoWait("","Destination","","intrigue",-1,
			"@L_INTRIGUE_041_BRIBECHARACTER_MSG_SUCCESS_HEAD_+0",
			"@L_INTRIGUE_041_BRIBECHARACTER_MSG_SUCCESS_BODY_+0",ReplacementLabel,GetID("Destination"))
		
	else	--decline money
		--do the favor stuff
		chr_ModifyFavor("Destination","",-(5+(MaxModifyFavor-ModifyFavor)))		
		Index = MsgSay("Destination","@L_INTRIGUE_041_BRIBECHARACTER_SPEAK_FAILED")
		ReplacementLabel = "_INTRIGUE_041_BRIBECHARACTER_SPEAK_FAILED_+"..Index
		--show message
		MsgNewsNoWait("","Destination","","intrigue",-1,
			"@L_INTRIGUE_041_BRIBECHARACTER_MSG_FAILED_HEAD_+0",
			"@L_INTRIGUE_041_BRIBECHARACTER_MSG_FAILED_BODY_+0",ReplacementLabel,GetID("Destination"))
	end
	
	if SimGetCutscene("","cutscene") then
		CutsceneCallUnscheduled("cutscene", "UpdatePanel")
		Sleep(0.1)
	end		
	
	StopMeasure()
end

function CleanUp()
	if GetData("FromCutscene") == 0 then
		DestroyCutscene("cutscene")
		if GetState("", STATE_CUTSCENE) == false then
			StopAnimation("")
			if AliasExists("Destination") then
				StopAnimation("Destination")
			end
		end
	end
	
	StopAction("bribe", "Owner")
end

function GetOSHData(MeasureID)
	--can be used again in:
	OSHSetMeasureRepeat("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+2",Gametime2Total(mdata_GetTimeOut(MeasureID)))
end
