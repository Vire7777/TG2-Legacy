-------------------------------------------------------------------------------
----
----	OVERVIEW "ms_114_BanCharacter"
----
----	with this privilege the office bearer can ban a person from the town, 
----	where he is office holder.
----
-------------------------------------------------------------------------------

function Run()

	--how far the Destination can be to start this action
	local MaxDistance = 1000
	--how far from the destination, the owner should stand while reading the letter from rome
	local ActionDistance = 40
	--time before privilege can be used again
	local MeasureID = GetCurrentMeasureID("")
	local TimeOut = mdata_GetTimeOut(MeasureID)
	
	local OwnerRhetoric = (GetSkillValue("",RHETORIC))
	local DestinationRhetoric = (GetSkillValue("Destination",RHETORIC))
	local OwnerGender = (SimGetGender(""))
	local DestinationGender = (SimGetGender("Destination"))
		
	SimGetCityOfOffice("","CityAlias")
	
	--check if destination is too far from city
	GetPosition("CityAlias","CityPos")
	if GetInsideBuilding("Destination","CurrentBuilding") then
		GetPosition("CurrentBuilding","BuildingPos")
		if GetDistance("BuildingPos","CityPos") > 10000 then
			MsgQuick("","@L_GENERAL_MEASURES_FAILURES_+23")
			StopMeasure("")
		end
	else
		GetPosition("Destination","DestPos")
		if GetDistance("CityPos","DestPos") > 10000 then
			MsgQuick("","@L_GENERAL_MEASURES_FAILURES_+23")
			StopMeasure("")
		end
	end
	
	find_Captain("","Captain")
	if not AliasExists("Captain") then
		MsgQuick("","@L_BANCHARACTER_FAILURE_+0")
		StopMeasure("")
	end
	--how long the ban will be 
	local MyMoney = 0
	if HasProperty("","BugFix") and not DynastyIsPlayer("") then
		GetDynasty("", "Madynasty")
		DynastyGetFamilyMember("Madynasty",0,"DaBoss")
		MyMoney = GetMoney("DaBoss")
	else
		MyMoney = GetMoney("")
	end
	local hismoney = GetMoney("Captain")
	local HisMoney = {}
		HisMoney[1] = hismoney * 0.01
		HisMoney[2] = hismoney * 0.05
		HisMoney[3] = hismoney * 0.10
	local OfficeType = SimGetOfficeLevel("")
	local duration
	if OfficeType == 3 then
		--if office holder is dorfschulze
		duration = 16
	elseif OfficeType == 4 then
		--if officeholder is buergemeister
		duration = 20
	else
		--then office holer must be landesherr
		duration = 24
	end
	local Cost = 0
	
	local Title = GetNobilityTitle("Captain")
	local TitleCost = Title * 500
	local X = SimGetOfficeLevel("Captain")
	local Level = {}
		Level[2] = 500
		Level[3] = 750
		Level[4] = 1000
		Level[5] = 1500
		Level[6] = 2000
	local PowerCost = Level[X] + TitleCost	
	local Duration = {}
		Duration[0] = duration
		Duration[1] = duration + 12
		Duration[2] = duration + 24
		Duration[3] = duration + 36
	local Choice = {}
		Choice[0] = 0
		Choice[1] = PowerCost + HisMoney[1]
	    Choice[2] = PowerCost + HisMoney[2]
	    Choice[3] = PowerCost + HisMoney[3]
	
	--run to destination and start action at MaxDistance
	if not ai_StartInteraction("", "Destination", MaxDistance, ActionDistance, nil) then
		StopMeasure()
	end
	
	--look at each other
	feedback_OverheadActionName("Destination")
	CreateCutscene("default","cutscene")
	CutsceneAddSim("cutscene","")
	CutsceneAddSim("cutscene","Destination")
	CutsceneCameraCreate("cutscene","")		
	camera_CutsceneBothLock("cutscene", "")
	
	AlignTo("", "Destination")
	AlignTo("Destination", "")
	Sleep(0.5)
	MeasureSetStopMode(STOP_CANCEL)
	SetMeasureRepeat(TimeOut)
	
	local panel
	if MyMoney >= Choice[3] then
        panel = ("@P"..
        "@B[0,@L_BANCHARACTER_BUTTONS_+0]"..
        "@B[1,@L_BANCHARACTER_BUTTONS_+1]"..
		"@B[2,@L_BANCHARACTER_BUTTONS_+2]"..
		"@B[3,@L_BANCHARACTER_BUTTONS_+3]"..
        "@B[N,@L_REPLACEMENTS_BUTTONS_NEIN_+0]")
	elseif MyMoney >= Choice[2] and MyMoney < Choice[3] then
        panel = ("@P"..
        "@B[0,@L_BANCHARACTER_BUTTONS_+0]"..
        "@B[1,@L_BANCHARACTER_BUTTONS_+1]"..
		"@B[2,@L_BANCHARACTER_BUTTONS_+2]"..
        "@B[N,@L_REPLACEMENTS_BUTTONS_NEIN_+0]")
	elseif MyMoney >= Choice[1] and MyMoney < Choice[2] then
		panel = ("@P"..
        "@B[0,@L_BANCHARACTER_BUTTONS_+0]"..
        "@B[1,@L_BANCHARACTER_BUTTONS_+1]"..
		"@B[N,@L_REPLACEMENTS_BUTTONS_NEIN_+0]")
	elseif MyMoney < Choice[1] then
		panel = ("@P"..
		"@B[0,@L_BANCHARACTER_BUTTONS_+0]"..
		"@B[N,@L_REPLACEMENTS_BUTTONS_NEIN_+0]")
	end
	
	local Result = MsgNews("","",panel,
	ms_BanCharacter_AIDecision,  --AIFunc 
	"intrigue", --Message Class
	2, --TimeOut
	"@L_INTRIGUE_BANCHARACTER_SCREENPLAY_ACTOR_HEAD_+0",
	"@L_INTRIGUE_BANCHARACTER_SCREENPLAY_ACTOR_BODY_+0",
	GetID(""),Duration[0],Choice[0],Duration[1],Choice[1],Duration[2],Choice[2],Duration[3],Choice[3])
	local Time = Duration[0]
	
	if DynastyIsAI("") or DynastyIsShadow("") then
		local Random = Rand(3)
		if Random == 1 then
			Result = 1
		elseif Random == 2 then
			Result = 2
		elseif Random == 3 then
			Result = 3
		end
	end
	
	if Result == 1 then
		Time = Duration[1]
		if DynastyIsPlayer("") then
			SpendMoney("",Choice[1],"CostBribes")
		elseif HasProperty("","BugFix") and not DynastyIsPlayer("") then
			DynastyGetFamilyMember("",0,"SugarDaddy")
			SpendMoney("SugarDaddy",Choice[1],"CostBribes")
		end
		if AliasExists("Captain") then
			if HasProperty("","BugFix") and not DynastyIsPlayer("") then
				DynastyGetFamilyMember("",0,"PayDaddy")
				chr_RecieveMoney("PayDaddy", Choice[1], "IncomeBribes")
			else
				chr_RecieveMoney("Captain", Choice[1], "IncomeBribes")
			end
		end
	elseif Result == 2 then
		Time = Duration[2]
		if DynastyIsPlayer("") then
			SpendMoney("",Choice[2],"CostBribes")
		elseif HasProperty("","BugFix") and not DynastyIsPlayer("") then
			DynastyGetFamilyMember("",0,"SugarDaddy")
			SpendMoney("SugarDaddy",Choice[2],"CostBribes")
		end
		if AliasExists("Captain") then
			if HasProperty("","BugFix") and not DynastyIsPlayer("") then
				DynastyGetFamilyMember("",0,"PayDaddy")
				chr_RecieveMoney("PayDaddy", Choice[2], "IncomeBribes")
			else
				chr_RecieveMoney("Captain", Choice[2], "IncomeBribes")
			end
		end			
	elseif Result == 3 then
		Time = Duration[3]
		if DynastyIsPlayer("") then
			SpendMoney("",Choice[3],"CostBribes")
		elseif HasProperty("","BugFix") and not DynastyIsPlayer("") then
			DynastyGetFamilyMember("",0,"SugarDaddy")
			SpendMoney("SugarDaddy",Choice[3],"CostBribes")
		end
		if AliasExists("Captain") then
			if HasProperty("","BugFix") and not DynastyIsPlayer("") then
				DynastyGetFamilyMember("",0,"PayDaddy")
				chr_RecieveMoney("PayDaddy", Choice[3], "IncomeBribes")
			else
				chr_RecieveMoney("Captain", Choice[3], "IncomeBribes")
			end
		end	
	elseif Result == "N" then
		StopMeasure("")
	end
	
	--send message to destination, that he will be banned
	MsgNewsNoWait("Destination","","","intrigue",-1,
		"@L_PRIVILEGES_114_BANCHARACTER_MSG_VICTIM_BEGIN_HEADLINE_+0",
		"@L_PRIVILEGES_114_BANCHARACTER_MSG_VICTIM_BEGIN_BODY_+0",GetID(""),GetID("Destination"),GetID("CityAlias"),Time)
	
	--combine textlabel by checking the destinations gender
	local GenderType
	if DestinationGender == 0 then
		GenderType = "_TOFEMALE"
	else
		GenderType = "_TOMALE"
	end
	
	PlayAnimationNoWait("","threat")
	local Elapse = 60*(GetGametime() + Time)
	MsgSay("","@L_PRIVILEGES_114_BANCHARACTER_BANISHMENT"..GenderType,GetID("CityAlias"),Elapse,GetID("Destination"))
	
	--remove the victim from his office
	if not (SimGetOfficeLevel("Destination") == -1) then
		CityRemoveFromOffice("CityAlias","Destination")
	end
	
	-- remove the victim from office applicants
	CityRemoveApplicant("CityAlias","Destination")
	
	-- set pre banned impact
	AddImpact("Destination","prebanned",1,4)
	
	--modify the favor
	local favormodify = GetFavorToSim("Destination","") - 5
	ModifyFavorToSim("Destination","",-favormodify)
	feedback_OverheadComment("Destination", "@L$S[2006] %1n", false, false, favormodify)

	
	CreateScriptcall("BanCharacter_Ban_Start",4,"Measures/ms_114_BanCharacter.lua","JailTime","","Destination",Time)
	CreateScriptcall("BanCharacter_Ban_End",Time,"Measures/ms_114_BanCharacter.lua","BanIsOver","","Destination",0)
	chr_GainXP("",GetData("BaseXP"))
	StopMeasure()
end

function JailTime(Time)
	SimGetCityOfOffice("","CityAlias")
	local impacttime = Time-4
	AddImpact("Destination","banned",1,impacttime)
	CityAddPenalty("CityAlias","Destination",PENALTY_PRISON,Time)
end

function BanIsOver()
	GetSettlement("","CityAlias")
	if CityGetPenalty("CityAlias","Destination",PENALTY_PRISON,true,"Penalty") then
		PenaltyFinish("Penalty")
	end
	--send message to destination, that ban is over
	feedback_MessageCharacter("Destination",
		"@L_PRIVILEGES_114_BANCHARACTER_MSG_VICTIM_END_HEADLINE",
		"@L_PRIVILEGES_114_BANCHARACTER_MSG_VICTIM_END_BODY",GetID("Destination"),GetID("CityAlias"))
	--send message to owner, that ban is over
	feedback_MessageCharacter("",
		"@L_PRIVILEGES_114_BANCHARACTER_MSG_ACTOR_END_HEADLINE",
		"@L_PRIVILEGES_114_BANCHARACTER_MSG_ACTOR_END_BODY",GetID("Destination"),GetID("CityAlias"))
end

function AIDecision()
	return 0
end

function CleanUp()
	DestroyCutscene("cutscene")
end

function GetOSHData(MeasureID)
	--can be used again in:
	OSHSetMeasureRepeat("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+2",Gametime2Total(mdata_GetTimeOut(MeasureID)))
	--active time:
	OSHSetMeasureRuntime("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+4",Gametime2Total(mdata_GetDuration(MeasureID)))
end

