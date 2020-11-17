function Run()
	if SimGetAge("") < GL_AGE_FOR_GROWNUP then
		StopMeasure()
	end
	
	if not ai_GoInsideBuilding("", "", -1, GL_BUILDING_TYPE_TOWNHALL) then
		StopMeasure()
	end
	
	if not GetHomeBuilding("","HomeBuilding") then
		MsgQuick("", "@L_PRIVILEGES_118_RUNFORANOFFICE_FAILURES_+4")
		StopMeasure()
	end
	
	if GetNobilityTitle("") < 5 and SimGetOfficeLevel("") > 0 then
		MsgQuick("", "@L_PRIVILEGES_118_RUNFORANOFFICE_FAILURES_+5")
		StopMeasure()
	end

	if not DynastyIsPlayer("") then
		if OfficeGetApplicantCount("destination") >= 3 then
			StopMeasure()
		end
	elseif OfficeGetApplicantCount("destination") >= 4 then
		MsgQuick("", "@L_REPLACEMENTS_FAILURE_MSG_OFFICE_ACTION_IMPOSSIBLE_CITYLEVELUP_+3")
		StopMeasure()
	end
	
	if SimGetOfficeID("") ~= -1 then
		if SimIsAppliedForOffice("") then
			if SimGetOffice("","CurrentOffice") then
				if GetOfficeByApplicant("","AppliedOffice") then
					if OfficeGetLevel("AppliedOffice") ~= OfficeGetLevel("CurrentOffice") and OfficeGetIdx("AppliedOffice") ~= OfficeGetIdx("CurrentOffice")  then
						MsgQuick("", "@L_GET_OFFICE_FAILURES_+0", GetID(""))
						StopMeasure()
					end
				end
			end
		end
	elseif SimIsAppliedForOffice("") then
		MsgQuick("", "@L_GET_OFFICE_FAILURES_+0", GetID(""))
		StopMeasure()
	end
	
	-- if not DynastyIsShadow("") then
		-- if BuildingGetType("HomeBuilding")~=GL_BUILDING_TYPE_RESIDENCE then
			-- MsgQuick("", "@L_PRIVILEGES_118_RUNFORANOFFICE_FAILURES_+4")
			-- StopMeasure()
		-- end
	-- end

	if not GetInsideBuilding("","councilbuilding") then
		StopMeasure()
	end

	if not GetSettlement("councilbuilding", "city") then
		StopMeasure()
	end

	if (GetSettlementID("councilbuilding") ~= GetSettlementID("HomeBuilding")) then
		MsgQuick("", "@L_PRIVILEGES_118_RUNFORANOFFICE_FAILURES_+1",GetID("city"))
		StopMeasure()
	end

	if not HasProperty("councilbuilding","CutsceneAhead") then
		if HasProperty("councilbuilding","CityLevelUpAhead") then
			MsgQuick("", "@L_REPLACEMENTS_FAILURE_MSG_OFFICE_ACTION_IMPOSSIBLE_CITYLEVELUP_+0")
			StopMeasure()
		end
	end
	if OfficeGetLevel("destination") == 7 then
		MsgQuick("","@L_PRIVILEGES_118_RUNFORANOFFICE_EMPEROR")	
		StopMeasure()
	end
	
	if OfficeGetLevel("destination") == 6 then
		CityGetOffice("city", 6, 0, "OFFICE")
		if GetID("OFFICE") == GetID("destination") then
			MsgQuick("","@L_PRIVILEGES_118_RUNFORANOFFICE_POPE")
			StopMeasure()
		end
	end		
	
	if OfficeGetLevel("destination") == 6 then
		CityGetOffice("city", 6, 1, "OFFICE")
		if GetID("OFFICE") == GetID("destination") then
			if not HasProperty("","Sovereign") then
				MsgQuick("","@L_PRIVILEGES_118_RUNFORANOFFICE_KING")
				StopMeasure()
			end
		end
	end	
	
	local ChargeCost  = OfficeGetChargeCost("destination")

		
	if DynastyIsPlayer("") then
		if (GetMoney("") < ChargeCost) then
			MsgQuick("", "@L_PRIVILEGES_118_RUNFORANOFFICE_FAILURES_+3")
			StopMeasure()
		end
		if not GetImpactValue("","RunForAnOffice") then
			if OfficeGetLevel("destination")>1 then
				MsgQuick("", "@L_PRIVILEGES_118_RUNFORANOFFICE_FAILURES_+5")
				StopMeasure()
			end
		end
	elseif HasProperty("","BugFix") and not DynastyIsPlayer("") then
		GetDynasty("", "Madynasty")
		DynastyGetFamilyMember("Madynasty",0,"DaBoss")
		if (GetMoney("DaBoss") < ChargeCost) then
			MsgQuick("DaBoss", "@L_PRIVILEGES_118_RUNFORANOFFICE_FAILURES_+3")
			StopMeasure()
		end
		if not GetImpactValue("DaBoss","RunForAnOffice") then
			if OfficeGetLevel("destination")>1 then
				MsgQuick("DaBoss", "@L_PRIVILEGES_118_RUNFORANOFFICE_FAILURES_+5")
				StopMeasure()
			end
		end
	end

	if not IsGUIDriven() and Rand(100)>10 then
		SimRunForAnOffice("","destination")
		StopMeasure()
	end

	if not GetLocatorByName("councilbuilding", "ApproachUsherPos", "destpos") then
		MsgQuick("", "@L_PRIVILEGES_118_RUNFORANOFFICE_FAILURES_+0", GetID("city"))
		StopMeasure()
	end
	
	while true do
		if f_BeginUseLocator("","destpos", GL_STANCE_STAND, true) then
			break
		end
		Sleep(2)
	end

	-- GetDynasty("","SimDynasty")
	-- if DynastyIsShadow("SimDynasty") then
		-- if OfficeGetShadowApplicantCount("destination") >= 2 then
			-- StopMeasure()
		-- end
	-- end	
	
	SetData("ReleaseLocator", 1)

	BuildingFindSimByProperty("councilbuilding","BUILDING_NPC", 1,"Usher")

--	--cutscene cam
	SetData("CutsceneCleared", 0)
	CreateCutscene("default","cutscene")
	CutsceneAddSim("cutscene","")
	CutsceneAddSim("cutscene","Usher")
	CutsceneCameraCreate("cutscene","")
	camera_CutsceneBothLock("cutscene", "")

	PlayAnimationNoWait("","talk")
	MsgSay("","@L_SESSION_ADDON_RunForAnOffice")
	-- MsgMeasure("","You charge somebody(debug)")

	--WalkTo Scribe locator

	-- der sim erzeugt ein settlementevent mit alias "trial"
	-- das event erhält automatisch einen termin, und eine guildworldID.

	camera_CutsceneBothLockCam("cutscene", "Usher", "Far_HUpYRight")
	if SimGetOfficeID("Sim") == -1 then
		if SimIsAppliedForOffice("Sim") then
			MsgQuick("", "@L_GET_OFFICE_FAILURES_+0", GetID(""))
			StopMeasure()
		end
	end
	
	if not HasProperty("councilbuilding","CutsceneAhead") then
		if HasProperty("councilbuilding","CityLevelUpAhead") then
			MsgQuick("", "@L_REPLACEMENTS_FAILURE_MSG_OFFICE_ACTION_IMPOSSIBLE_CITYLEVELUP_+0")
			StopMeasure()
		end
	end
	if SimRunForAnOffice("","destination") then
		if DynastyIsPlayer("") then
			SpendMoney("",ChargeCost,"CostAdministration")
		elseif HasProperty("","BugFix") and not DynastyIsPlayer("") then
			DynastyGetFamilyMember("",0,"SugarDaddy")
			SpendMoney("SugarDaddy",ChargeCost,"CostAdministration")
		end
		PlayAnimationNoWait("Usher",ms_118_runforanoffice_getRandomTalk())
		MsgSay("Usher","@L_PRIVILEGES_118_RUNFORANOFFICE_COMMENT_TOWN_CLERK")
		StopAnimation("Usher")
		-- erzeugt ein event (GuildObject mit ID mit dem alias "trial", Current Sim charges "Destination")
		-- event wird in
		StopAnimation("")
	else
		MsgQuick("", "@L_PRIVILEGES_118_RUNFORANOFFICE_FAILURES_+2", GetID("city"))
	end
	DestroyCutscene("cutscene")
	SetData("CutsceneCleared", 1)
	
	StopAnimation("")
	
	if(GetLocatorByName("councilbuilding", "LookAtBoardPos", "LookAtBoardPos")) then
		f_MoveTo("","LookAtBoardPos")
	end	
	f_StrollNoWait("",250,1)
end

function getRandomTalk()
	local TargetArray = {"sit_talk_short","sit_talk","sit_talk_02"}
	local TargetCount = 3
	return TargetArray[Rand(TargetCount)+1]
end

function CleanUp()
	if GetData("CutsceneCleared")==0 then
		DestroyCutscene("cutscene")
	end
	if GetData("ReleaseLocator")==1 then
		f_EndUseLocatorNoWait("","destpos", GL_STANCE_STAND)
	end
	if not DynastyIsPlayer("") then
		MeasureRun("", nil, "DynastyIdle",true)
	end
end

