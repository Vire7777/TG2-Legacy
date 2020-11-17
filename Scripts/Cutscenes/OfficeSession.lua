-------------------------------------------------------------------------------------------------------------------------
-- PreSession Part ------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
function Start()
 	-- if no settlement, no office session
 	if GetID("settlement")==-1 then
		MsgDebugMeasure("applicant","error: This townhall does not belong to any settlement.")
		EndCutscene("")
		StopMeasure()
	end
	
	GetScenario("World")
	local fos = GetProperty("World","fos")
	local nextOS = 17
	if not HasProperty("World","static") and (GetRound() > 0 or math.mod(GetGametime(),24) > 17) then
		nextOS = nextOS + ((fos * 24) - 24)
	end

 	-- set a Date: event_alias, settlement, cutscene, function
	if IsMultiplayerGame() then
		CityScheduleCutsceneEvent("settlement","council_date","","BeginCouncilMeeting",17,6,"@L_SESSION_6_TIMEPLANNERENTRY_CITY_+0")  -- hour of day=17h, MinTimeInFuture = 8
	else
		CityScheduleCutsceneEvent("settlement","council_date","","BeginCouncilMeeting",nextOS,6,"@L_SESSION_6_TIMEPLANNERENTRY_CITY_+0")  -- hour of day=17h, MinTimeInFuture = 8
	end
	local EventTime = SettlementEventGetTime("council_date")
	
	-- needed for the tutorial
	SetData("EventTime",EventTime)
	local GameTime = GetGametime()*60	-- in hours
	local WaitTime = (EventTime - (21*60)) - GameTime

	if (WaitTime<0) then
		officesession_SetBuildingInfo()
	else
		CutsceneAddEvent("","SetBuildingInfo",WaitTime)
	end

	if HasProperty("councilbuilding","CutsceneAhead") then
		local CutscenesAhead = GetProperty("councilbuilding","CutsceneAhead") + 1
		SetProperty("councilbuilding","CutsceneAhead",CutscenesAhead)
	else
		SetProperty("councilbuilding","CutsceneAhead",1)
	end

	SetData("FirstRun",1)

	-- add the invited voters list
	ListNew("InvitedSims")
	SetData("AppList_Count", 0)
end

function SetBuildingInfo()
	SetProperty("councilbuilding","sessioncutszene",GetID(""))
end

function AddApplicant()
	if not AliasExists("InvitedSims") then
		ListNew("InvitedSims")
	end
	--Add the Applicant "applicant" to the Applicant list for the office "office"
	if not CitySetOfficeApplicant("settlement", "applicant", "office") then
		return false
	end

	--Invite the Applicant
	local OfficeNameLabel = OfficeGetTextLabel("office")
	local OfficeName = "@L"..string.sub(OfficeNameLabel, 0, -2)..2
	officesession_InviteApplicant("applicant","", OfficeName)

	-- invite the deposition defender if exists and not already invited
	if(OfficeGetHolder("office","Holder") and not ListContains("InvitedSims","Holder")) then
		officesession_InviteDepositionDefender("Holder","", "defender" , OfficeName, "applicant")
		ListAdd("InvitedSims","Holder")
	end

	-- invite the voters
	officesession_InviteVoters()

	SetProperty("applicant","cutscene_destination_ID",GetID(""))
	SetProperty("applicant","HaveCutscene",1)
end

function InviteVoters()
	if not AliasExists("InvitedSims") then
		ListNew("InvitedSims")
	end
	-- get all voters
	-- last parameter: 0 - All (voters and applicants), 1 - only office voters, 2 - only applicants 
	local VoterCnt = OfficePrepareSessionMembers("office","VoterList",1)
	
	-- PATCH TODO
	-- Prevents cutscene from freezing
	if VoterCnt == nil then
		VoterCnt = OfficePrepareSessionMembers("office", "VoterList", 1)
	end
	local Voter = VoterCnt - 1
	-- PATCH TODO
	
	
	--Filter out already invited voters
	local InvitedCnt = ListSize("InvitedSims")
	for i=0,Voter do
		ListGetElement("VoterList",i,"Voter")
		if(ListContains("InvitedSims","Voter")) then
			ListRemove("VoterList","Voter")
		end
	end

	-- invite all voters
	local VoterCnt = ListSize("VoterList")
	local Voter = VoterCnt - 1
	for i = 0, Voter do
			ListGetElement("VoterList",i,"Voter")
			ListAdd("InvitedSims","Voter")
			officesession_InviteVoter("Voter","@L_SESSION_5_MESSAGES_ERROR_+0")
	end
	RemoveAlias("Voter")
	RemoveAlias("VoterList")
end

function InviteApplicant(SimAlias, MessageText, Office)
	--invite Applicants
	SimAddDate(SimAlias,"councilbuilding","Council Meeting", SettlementEventGetTime("council_date")-60,"AttendOfficeMeeting")
	feedback_MessagePolitics(SimAlias, "@L_SESSION_6_TIMEPLANNERENTRY_APPLICANT_+0", "@L_SESSION_6_TIMEPLANNERENTRY_APPLICANT_+1", GetID(SimAlias), GetID("settlement"))
	SimAddDatebookEntry(SimAlias,SettlementEventGetTime("council_date"),"councilbuilding","@L_SESSION_6_TIMEPLANNERENTRY_APPLICANT_+0", "@L_SESSION_6_TIMEPLANNERENTRY_APPLICANT_+1", GetID(SimAlias), GetID("settlement"))
end

function InviteVoter(SimAlias, MessageText)
	--Invite Voters
	SimAddDate(SimAlias,"councilbuilding","Council Meeting", SettlementEventGetTime("council_date")-60,"AttendOfficeMeeting")
	feedback_MessagePolitics(SimAlias, "@L_SESSION_6_TIMEPLANNERENTRY_ELECTOR_+0", "@L_SESSION_6_TIMEPLANNERENTRY_ELECTOR_+1", GetID(SimAlias), GetID("settlement"))
	SimAddDatebookEntry(SimAlias,SettlementEventGetTime("council_date"),"councilbuilding","@L_SESSION_6_TIMEPLANNERENTRY_ELECTOR_+0", "@L_SESSION_6_TIMEPLANNERENTRY_ELECTOR_+1", GetID(SimAlias), GetID("settlement"))
end

function InviteDepositionDefender(SimAlias, MessageText, ApplicantAlias, Office, RunForOfficeSim)
      -- TODO Insert right textlabels
	--invite Depositions
	SimAddDate(SimAlias,"councilbuilding","Council Meeting", SettlementEventGetTime("council_date")-60,"AttendOfficeMeeting")
	feedback_MessagePolitics(SimAlias, "@L_SESSION_ADDON_MESSAGE_HEAD_+0", "@L_SESSION_ADDON_MESSAGE_BODY", GetID(RunForOfficeSim),GetID("settlement"))
	SimAddDatebookEntry(SimAlias,SettlementEventGetTime("council_date"),"councilbuilding","@L_SESSION_ADDON_MESSAGE_HEAD_+0","@L_SESSION_ADDON_MESSAGE_BODY_+1", GetID(RunForOfficeSim), GetID("settlement"))
end

------------------------------------------------------------------------------------------------------------------------
-- Session Parts    ----------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
-- prepare the townhall for the meeting. Let the meeting sims go to the right places, kick out not meeting sims
function BeginCouncilMeeting()
	
	RoomGetInsideSimList("Room","SimList")

	local TriggerEventCnt = 0
	-- kick all sims which are not allowed at the office meeting
	local SimCnt = ListSize("SimList")

	for i=0,SimCnt - 1 do
		ListGetElement("SimList",i,"Sim")
		if(not ListContains("SimOfficeList","Sim") and HasProperty("Sim","BUILDING_NPC") == false) then
			SimStopMeasure("Sim")
			officesession_SimLeaveBuilding("Sim")
			TriggerEventCnt = TriggerEventCnt + 1
		end
	end
	
	
	-- DataInit
	SetData("PanelShow",0)
	SetData("PanelInit",1)
	SetData("PanelCandidates",0)
	SetData("VoteCacheIdx",0)
	-- get whole office session member list
	CityGetOfficeSessionMemberList("settlement","SimOfficeList",0)
	
	local SimCnt = ListSize("SimOfficeList")
	RemoveAlias("InvitedSims")
	-- go over all office members and stop those who are to late. Remove them from the SimOfficeList
	local SimCnt = ListSize("SimOfficeList")
	-- PATCH TODO
		--prevents game from freezing
		if (SimCnt == nil) then
			SimCnt = ListSize("SimOfficeList")
		end
		local Sims = SimCnt - 1
		-- PATCH TODO
	for i=0,Sims do
		ListGetElement("SimOfficeList",i,"Sim")
		BuildingGetRoom("councilbuilding","Judge","Room")
		GetInsideRoom("Sim","InsideRoom")
		SimSetBehavior("Sim","")
		if (officesession_IsSimValid("Sim",true)==false) or not GetInsideBuilding("Sim", "simbuilding") or (GetID("simbuilding")~=GetID("councilbuilding")) or (GetID("Room") ~= GetID("InsideRoom")) then
			if DynastyIsPlayer("Sim") then
				MsgNewsNoWait("Sim",0,"MB_OK","default",1,"@L_SESSION_5_MESSAGES_NOTATPLACE_+0","@L_SESSION_5_MESSAGES_NOTATPLACE_+1",GetID("settlement"))
			end

			if DynastyIsAI("Sim") then
				AllowAllMeasures("Sim")
				SimStopMeasure("Sim")
				SimSetBehavior("Sim","idle")
				if (HasProperty("Sim","cutscene_destination_ID") == true) then
					RemoveProperty("Sim","cutscene_destination_ID")
				end
			end
			
			if (HasProperty("Sim","HaveCutscene") == true) then
				RemoveProperty("Sim","HaveCutscene")
			end
			ListRemove("SimOfficeList","Sim")
		end
	end
	
	Sleep(2)
	
	BuildingGetRoom("councilbuilding","Judge","Room")
	RoomLockForCutscene("Room","")
	if IsMultiplayerGame() then 
		if CameraIndoorGetBuilding("IndoorBuilding") ~= nil then
			if GetID("IndoorBuilding") == GetID("councilbuilding") then
				ExitBuildingWithCamera()  
			end
		end
		MsgBoxNoWait("All", nil, "@L_OOS_PREVENTION_HEAD_+0", "@L_OOS_PREVENTION_BODY_+0")
	end
  
  

--	Check if any Office is Valid, if not then the Usher throw the lot
	local ValidTasks = 0

	local NumOfVotes = CityPrepareOfficesToVote("settlement","OfficeList",false)
	-- PATCH TODO
	-- prevents cutscene from freezing
	if (NumOfVotes == nil) then
		NumOfVotes = CityPrepareOfficesToVote("settlement","OfficeList",false)
	end
	local Nums = NumOfVotes - 1
	-- PATCH TODO
	for i=0,Nums do
		ListGetElement("OfficeList",i,"OfficeToCheck")

	    local VoterCnt = officesession_GetVoters("OfficeToCheck","Voter")
		--local VoterCnt
		-- PATCH TODO
		-- prevents cutscene from freezing
		if VoterCnt == nil then
			VoterCnt = officesession_GetVoters("OfficeToCheck", "Voter")
		end
		local Voter = VoterCnt - 1
		--PATCH TODO
	    if(VoterCnt > 0) then
	    	for j=0,Voter do
	    		local VoterAlias = "Voter"..j
	    		if officesession_IsSimValid(VoterAlias,true) then
	    			ValidTasks = ValidTasks + 1
	    			break
	    		end
	    	end
	    end
	end

	Sleep(2)
	
	if (ValidTasks == 0) or (ValidTasks == nil) then
		officesession_UsherSession()
	end	
	
	local TablePlace = 1;
	local BenchPlace = 1;
	SetData("KingTask",0)

	-- Get the Chairman, if no one of the office tree is there, use the townclerk
	local ChairmanExists = officesession_GetChairman("Chairman")
	if(not ChairmanExists)then
		-- ERROR --
		EndCutscene("")
	end

	-- remove chairman from SimOfficeList
	-- move special offices to their seats
	local CapitalCityLevel = 6
	if(CityGetLevel("settlement") == CapitalCityLevel) then
		local SimCnt = ListSize("SimOfficeList")
		-- PATCH TODO
		--prevents game from freezing
		if (SimCnt == nil) then
			SimCnt = ListSize("SimOfficeList")
		end
		local Sims = SimCnt - 1
		-- PATCH TODO
		for i=0,Sims do
			ListGetElement("SimOfficeList",i,"Sim")
			local simOfficeLevel = SimGetOfficeLevel("Sim")
			local simOfficeIndex = SimGetOfficeIndex("Sim")
			if ( simOfficeLevel == 6 ) then
				if ( simOfficeIndex == 0 ) then
					SetData("KingTask",1)
					SetData("CardinalID",GetID("Sim"))
					CutsceneCallThread("", "SpecialSimAttend", "Sim", "LeftAssessorChairPos");
					ListRemove("SimOfficeList","Sim")
				else
					SetData("KingTask",1)
					SetData("FeldherrID",GetID("Sim"))
					CutsceneCallThread("", "SpecialSimAttend", "Sim", "RightAssessorChairPos");
					ListRemove("SimOfficeList","Sim")
				end
			elseif ( simOfficeLevel == 7 ) then
				SetData("KingID",GetID("Sim"))
				CutsceneCallThread("", "SpecialSimAttend", "Sim", "JudgeChairPos");
				SetData("KingTask",1)
				ListRemove("SimOfficeList","Sim")
			end
		end

--		if the king is there, then he is the
		TablePlace = 0;

		TriggerEventCnt = TriggerEventCnt + 1

		if( GetData("KingTask") == 0 ) then
			CutsceneCallThread("", "VoterAttend", "Chairman", 9);
		end
	else
		ListRemove("SimOfficeList","Chairman")
		TriggerEventCnt = TriggerEventCnt + 1
		CutsceneCallThread("", "VoterAttend", "Chairman", 9);
	end
	-- move remain officeholders and applicants to their seats

	local SimCnt = ListSize("SimOfficeList")
	-- PATCH TODO
	-- prevents cutscene from freezing
	if (SimCnt == nil) then
		SimCnt = ListSize("SimOfficeList")
	end
	local Sims = SimCnt - 1
	-- PATCH TODO

	for i=0,Sims do
		ListGetElement("SimOfficeList",i,"Sim")
--		SetProperty("Sim","officesession",1)
		if ( officesession_IsSimValid("Sim",true) ) then
			ForbidMeasure("Sim","StartDialog",EN_BOTH)
			if(SimGetOffice("Sim","Office")) then
				CutsceneCallThread("", "VoterAttend", "Sim", 9 - TablePlace);
				TriggerEventCnt = TriggerEventCnt + 1
				TablePlace = TablePlace + 1
			else
				CutsceneCallThread("", "ApplicantAttend", "Sim", BenchPlace);
				TriggerEventCnt = TriggerEventCnt + 1
				BenchPlace = BenchPlace + 1
			end
		end
	end

	CutsceneAddTriggerEvent("","RunCouncilMeeting", "Reached", TriggerEventCnt,60)
end

function RunCouncilMeeting()
	BuildingGetRoom("councilbuilding", "Judge", "Room")
	
	-- Cutscenes can only be attached to the _main_ room of a building or to a position (or a simobject) - NOT to a room!
	GetLocatorByName("councilbuilding", "TableChair0", "CameraCreatePos")
	CutsceneCameraCreate("","CameraCreatePos")
	officesession_OverviewCam()

	-- all sims are at their places, let the games begin
	MsgSay("Chairman","@L_SESSION_1_GREETING")
	if CutsceneLocalPlayerIsWatching("") then
		HudClearSelection()
		officesession_UpdatePanel()
	end

	-- Check ob überhaupt Applicants da sind. Ist niemand da, sollte die Sitzung gleich beendet werden.
	if(not (officesession_GetValidApplicantCount("settlement") > 0)) then
		officesession_SimCam("Chairman",0,0)
		PlayAnimationNoWait("Chairman", "sit_talk_short")
		MsgSay("Chairman","@L_SESSION_ADDON_NO_DECIDERS")
		EndCutscene("")
	end

	-- schleife über alle votes, vom höchsten Amt bis zu niedrigsten Amt
	local NumOfVotes = CityPrepareOfficesToVote("settlement","OfficeList",true)
	SetData("VoteCnt",NumOfVotes)

	local NumOfVotes = GetData("VoteCnt")
	if(NumOfVotes == nil) then
		NumOfVotes = 0
	end

	if(NumOfVotes == 0) then
		officesession_SimCam("Chairman",0,0)
		PlayAnimationNoWait("Chairman", "sit_talk_short")
		MsgSay("Chairman","@L_SESSION_ADDON_NO_DECIDERS") 
		EndCutscene("")
	end

	-- PATCH TODO
	-- prevents cutscene from freezing
	local Nums = NumOfVotes - 1
	-- PATCH TODO
	
	for i=0,Nums do
		ListGetElement("OfficeList",i,"Office")
		officesession_VoteForOffice("Office")
		officesession_OverviewCam()
		if CutsceneLocalPlayerIsWatching("") then
			HudClearSelection()
			officesession_UpdatePanel()
		end
	end


	-- Verabschiedung durch den Chairman
	PlayAnimationNoWait("Chairman", "sit_talk_short")	
	MsgSay("Chairman","@L_SESSION_4_GOODBYE_SUCCESS")

	-- Übertragen der Änderungen in den OfficeTree
	officesession_WriteVotes()

	 -- Alle Sims ausser die Stadtangestellten verlassen die TownHall
	local SimWalkOutCount = officesession_SimLeaveTownhall()
	
	CutsceneAddTriggerEvent("","QuitCutscene", "OutOfBuilding", SimWalkOutCount, 60)
end

function VoteForOffice(Office)
	SetData("CurrentOffice",Office)
	local Winner = -1 -- speichert den alias des gewinners. z.B. Applicant1
	local ApplicantCnt = officesession_OfficeGetApplicants(Office,"Applicant")
	local OfficeID = GetID("Office")

	SetData("ApplicantCnt",ApplicantCnt)
	-- if no applicant is there, no vote will be made.
	if (ApplicantCnt == 0) or (ApplicantCnt == nil) then
		officesession_SimCam("Chairman",0,0)
		PlayAnimationNoWait("Chairman", "sit_talk_short")		
		MsgSay("Chairman","@L_SESSION_ADDON_NO_DECIDERS")
		return
	end

	local OfficeNameLabel = OfficeGetTextLabel(Office)
	local OfficeName = "@L"..string.sub(OfficeNameLabel, 0, -2)..2

	officesession_SimCam("Chairman",0,0)
	PlayAnimationNoWait("Chairman", "sit_talk_short")
	MsgSay("Chairman","@L_SESSION_ADDON_INTRO")
		if CutsceneLocalPlayerIsWatching("") then
			HudClearSelection()
			officesession_UpdatePanel()
		end
	MsgSay("Chairman",OfficeName)
		if CutsceneLocalPlayerIsWatching("") then
			HudClearSelection()
			officesession_UpdatePanel()
		end
--	Check if the user had won an ellection before. if true, no negative reaction
	local wonEllection = false;
	
	local VoteCacheIdx = GetData("VoteCacheIdx")
	if (VoteCacheIdx == nil) then
		VoteCacheIdx = 0
	end
	-- prevents cutscene from freezing
	local VoteCache = VoteCacheIdx - 1
	
	for i=0,VoteCache do
--		GetAliasByID(GetData("VoteCacheWinnerID"..i),"Holder")
		-- setzen des neuen office holders, richtigstellen aller relevanten beziehungen, privilegien etc.
--		if(GetID("Holder") == GetID("OfficeHolder")) then
		if(OfficeGetHolder("Office","OfficeHolder") and GetData("VoteCacheWinnerID"..i) == GetID("OfficeHolder")) then
			wonEllection = true;
			break;
		end
	end	

	if( OfficeGetHolder("Office","OfficeHolder") and officesession_SimIsInTownhall("OfficeHolder") and wonEllection == false) then
	--	officesession_SimCam("OfficeHolder",0,0)
	--	PlayAnimationNoWait("OfficeHolder", "sit_talk_short")
	--	MsgSay("OfficeHolder","@L_SESSION_ADDON_REACTION")
		officesession_SimCam("Chairman",0,0)
	end

	SetData("HumanTask",0)
	-- Aufzählung der Bewerber
	SetData("PanelShow",1)
	
	PlayAnimationNoWait("Chairman", "sit_talk_short")
	if (ApplicantCnt > 1) then
		MsgSay("Chairman","@L_SESSION_ADDON_CANDIDATES_MORE")
	else
		MsgSay("Chairman","@L_SESSION_ADDON_CANDIDATES_ONE")
	end
		if CutsceneLocalPlayerIsWatching("") then
			HudClearSelection()
			officesession_UpdatePanel()
		end
		
		-- PATCH TODO
		--prevents cutscene from freezing
		if (ApplicantCnt == nil) then
			ApplicantCnt = officesession_OfficeGetApplicants(Office,"Applicant")
		end
		
		local Applicant = ApplicantCnt - 1
		-- PATCH TODO
	for i=0,Applicant do
--		local SimOfficeID = SimGetOfficeID("Applicant"..i)
		if( DynastyIsPlayer("Applicant"..i) ) then
			SetData("HumanTask",1)
		end
		
--		if( SimOfficeID ~= OfficeID ) then
			SetData("PanelCandidates",(i+1))
			officesession_UpdatePanel()
			if (officesession_SimIsInTownhall("Applicant"..i)) then
--				officesession_SimCam("Applicant"..i,0,0)
			end
--			MsgSay("Chairman","%1SN",GetID("Applicant"..i))
--		end
	end

	if(ApplicantCnt == 1) then
		Winner = 0
		officesession_OverviewCam()
		MsgSay("Chairman","@L_SESSION_ADDON_ONLY_ONE_CANDIDATE")
		if CutsceneLocalPlayerIsWatching("") then
			HudClearSelection()
			officesession_UpdatePanel()
		end
	else
    -- Aufzählung der Voters
    local VoterCnt = officesession_GetVoters("Office","Voter")
	--PATCH TODO
	-- prevents cutscene from freezing
	if VoterCnt == nil then
		VoterCnt = officesession_GetVoters("Office", "Voter")
	end
	
	--PATCH TODO
    if(VoterCnt == 0) then
    	officesession_OverviewCam()
    	MsgSay("Chairman","@L_SESSION_7_NOJURYEVENT_WELCOME","@L_SESSION_ADDON_ADD_NO_VOTERS")
		if CutsceneLocalPlayerIsWatching("") then
			HudClearSelection()
			officesession_UpdatePanel()
		end
    	local WinnerIdx = Rand(ApplicantCnt)
    	Winner = WinnerIdx
			MsgSay("Chairman","@L_SESSION_3_ELECT_RESULT2",GetID("Applicant"..Winner))
		if CutsceneLocalPlayerIsWatching("") then
			HudClearSelection()
			officesession_UpdatePanel()
		end
    else
			officesession_OverviewCam()
	  	MsgSay("Chairman","@L_SESSION_ADDON_VOTERS")
		if CutsceneLocalPlayerIsWatching("") then
			HudClearSelection()
			officesession_UpdatePanel()
		end

	  	SetData("PanelVoters",1)
			SetData("PanelInit",0)
			
		--PATCH TODO
		local VoterCnt = officesession_GetVoters("Office", "Voters")
		-- prevents cutscene from freezing
		if VoterCnt == nil then
			VoterCnt = officesession_GetVoters("Office", "Voters")
		end
		local Voter = VoterCnt - 1
		--PATCH TODO

	  	for i=0,Voter do
	  		if( officesession_SimIsInTownhall("Voter"..i)) then
					if( DynastyIsPlayer("Voter"..i) ) then
						SetData("HumanTask",0)
					end
					officesession_UpdatePanel()
--					officesession_SimCam("Voter"..i,0,0)
--					MsgSay("Chairman","%1SN",GetID("Voter"..i))
					SetData("PanelVoters",GetData("PanelVoters") +1 )
				end
	  	end
	
			--derjeniger der das amt hat und da ist darf der jury drohen
			if( OfficeGetHolder("Office","OfficeHolder") and officesession_SimIsInTownhall("OfficeHolder") and wonEllection == false ) then
				officesession_OverviewCam()
				MsgSay("Chairman","@L_SESSION_2_CANCEL_REASONTOSTAY_+0",GetID("OfficeHolder"))
				if CutsceneLocalPlayerIsWatching("") then
					HudClearSelection()
					officesession_UpdatePanel()
				end
				local Res = MsgSayInteraction("OfficeHolder","OfficeHolder",0,"@B[A, @L_REPLACEMENTS_BUTTONS_JA]@B[C, @L_REPLACEMENTS_BUTTONS_NEIN]@P",officesession_AIBedrohung,"@L_SESSION_2_CANCEL_REASONTOSTAY_+2")
				if(Res == "A") then
					officesession_SimCam("OfficeHolder",0,0)
					PlayAnimationNoWait("OfficeHolder", "sit_talk_short")
					MsgSay("OfficeHolder", "@L_SESSION_2_CANCEL_REASONTOSTAY_MENACE")
					if CutsceneLocalPlayerIsWatching("") then
						HudClearSelection()
						officesession_UpdatePanel()
					end
	
		--				bonus modifyer
					VoterCnt = officesession_GetVoters("Office","Voter")
					-- PATCH TODO
					-- prevents cutscene from freezing 
					
					if VoterCnt == nil then
						VoterCnt = officesession_GetVoters("Office", "Voter")
					end
					local Voter = VoterCnt - 1
					
					--PATCH TODO
					officesession_OverviewCam()
					for i=0,Voter do
						local VoterAlias = "Voter"..i
						if GetInsideBuilding(VoterAlias,"currentbuilding") then
							if GetID("OfficeHolder") ~= GetID(VoterAlias) then
								if (DynastyIsAI(VoterAlias) == true) then
									if GetID("currentbuilding") == GetID("councilbuilding") then
										if GetSkillValue("OfficeHolder",RHETORIC)>=GetSkillValue(VoterAlias,EMPATHY) then
											PlayAnimationNoWait(VoterAlias, "sit_yes")
											SetFavorToSim(VoterAlias,"OfficeHolder",GetFavorToSim(VoterAlias,"OfficeHolder")+10)
											officesession_UpdatePanel()
--											MsgSay(VoterAlias, "@L_SESSION_2_CANCEL_REASONTOSTAY_REACTION_PRO")
										else
											PlayAnimationNoWait(VoterAlias, "sit_no")
											SetFavorToSim(VoterAlias,"OfficeHolder",GetFavorToSim(VoterAlias,"OfficeHolder")-10)
											officesession_UpdatePanel()
--											MsgSay(VoterAlias, "@L_SESSION_2_CANCEL_REASONTOSTAY_REACTION_CONTRA")
										end
									end
								end
							end
						end
					end
				else
					officesession_SimCam("OfficeHolder",0,0)
					PlayAnimationNoWait("OfficeHolder", "sit_talk_short")
					MsgSay("OfficeHolder", "@L_SESSION_2_CANCEL_REASONTOSTAY_NEUTRAL")
					if CutsceneLocalPlayerIsWatching("") then
						HudClearSelection()
						officesession_UpdatePanel()
					end
					officesession_OverviewCam()
				end
			else			
				officesession_OverviewCam()
			end
	
			 MsgSay("Chairman","@L_SESSION_3_ELECT_THINKBREAK")
	
			 -- Bedenkzeit
			
			 if CutsceneLocalPlayerIsWatching("") then
				 HudClearSelection()
				 officesession_UpdatePanel()
			 end
			
			 local SleepTime = 20
			 local Actions = 5
			 local SleepAction = SleepTime/Actions
	
			 if (GetData("HumanTask") == 0) then
				 SleepAction = 1
			 else
				 officesession_MeasureBar(Office,true)
	
				 CutsceneSetTimeBar("",SleepTime)
			 end
	
			-- PATCH TODO 
			-- prevents cutscene from freezing
			if (ApplicantCnt == nil) then
				ApplicantCnt = officesession_OfficeGetApplicants(Office,"Applicant")
			end
			local Applicant = ApplicantCnt - 1
			-- PATCH TODO
			 for i=1,Actions do
				 for j = 0, Applicant do
					 officesession_RunAIPlan("Applicant"..j)
				 end
				
				
				 Sleep(SleepAction)
			 end
	
			 if CutsceneLocalPlayerIsWatching("") then
				 HudCancelUserSelection()
				 officesession_UpdatePanel()
			 end
	
			 officesession_MeasureBar(Office,false)
	
			-- Stimmenabgabe
			
			officesession_OverviewCam()
	
			MsgSay("Chairman","@L_SESSION_2_CANCEL_2NDINTRO")
					if CutsceneLocalPlayerIsWatching("") then
						HudClearSelection()
						officesession_UpdatePanel()
					end
	
			local ApplicantCnt = GetData("ApplicantCnt")
			if (ApplicantCnt == nil) then
				ApplicantCnt = 0
			end

			local votes = {}
			-- PATCH TODO
			local Applicant = ApplicantCnt -1
			-- PATCH TODO
			-- init the votes
			for i=0,Applicant do
				votes[i] = 0
			end
						
			VoterCnt = officesession_GetVoters("Office","Voter")
			-- PATCH TODO
			-- prevents cutscene from freezing
			if (VoterCnt == nil) then
				VoterCnt = officesession_GetVoters("Office", "Voter")
			end
			-- PATCH TODO
			local Voter = VoterCnt - 1
			
			for i=0,Voter do
				local Idx = -1
				if(officesession_SimIsInTownhall("Voter"..i)) then
					Idx = officesession_DoVote("Voter"..i,Office,"Applicant",ApplicantCnt)
				end
			
				if( Idx ~= -1 ) then
					local Value = votes[Idx]
					--PATCH TODO
					-- prevents cutscene from freezing
					if value == nil then
						Value = votes[Idx]
					end
					--PATCH TODO
					votes[Idx] = Value + 1
				end
		 	end
		 	
		 	officesession_OverviewCam()
	
	
			-- Auszählung der Stimmen
			local WinnerArray = {}
			local WinnerArrayCount = 0
			local MaxVote = 0
	
			-- PATCH TODO 
			-- prevents cutscene from freezing
			if (ApplicantCnt == nil) then
				ApplicantCnt = officesession_OfficeGetApplicants(Office,"Applicant")
			end
			local Applicant = ApplicantCnt - 1
			local Vote = 0
			-- PATCH TODO
	
			for i=0,Applicant do
				Vote = votes[i]
				if(Vote > MaxVote) then
					WinnerArray = {}
					WinnerArrayCount = 1
					WinnerArray[WinnerArrayCount] = i
					Winner = i
					MaxVote = Vote
				elseif(Vote == MaxVote and Vote ~= 0) then
					WinnerArrayCount = WinnerArrayCount + 1
					WinnerArray[WinnerArrayCount] = i
					Winner = -1
					MaxVote = Vote
				end
			end

			-- eindeutiger Gewinner
			if(Winner > -1) then
				local CurrentWinner = "Applicant"..Winner
				local GenderText
				if SimGetGender(CurrentWinner) == GL_GENDER_FEMALE then
					GenderText = "_+1"
				else
					GenderText = "_+0"
				end		
				
				local OfficeNameLabel = OfficeGetTextLabel("office",SimGetGender(CurrentWinner))
				local OfficeName = "@L"..string.sub(OfficeNameLabel, 0, -4)..GenderText
				-- alter Amtstraeger neuer Amtstraeger?
				if( OfficeGetHolder("Office","OfficeHolder") and GetID("OfficeHolder") == GetID(CurrentWinner) ) then
--					MsgSay("Chairman","@L_SESSION_2_CANCEL_ANOUNCEMENT_SPEECH_+1")
				elseif( OfficeGetHolder("Office","OfficeHolder") and wonEllection == false ) then
--					MsgSay("Chairman","@L_SESSION_2_CANCEL_ANOUNCEMENT_SPEECH_+0")
					MsgSay("Chairman","@L_SESSION_3_ELECT_RESULT1"..GenderText,GetID(CurrentWinner),GetID("settlement"),OfficeName)
				else
					MsgSay("Chairman","@L_SESSION_3_ELECT_RESULT1"..GenderText,GetID(CurrentWinner),GetID("settlement"),OfficeName)
				end
					if CutsceneLocalPlayerIsWatching("") then
						HudClearSelection()
						officesession_UpdatePanel()
					end
			else
				if (WinnerArrayCount == 0) then
					Winner = Rand(ApplicantCnt)
				else
					Winner = WinnerArray[Rand(WinnerArrayCount)+1]
				end
				-- Losentscheid über diejenigen mit den meisten Stimmen
				if( OfficeGetHolder("Office","OfficeHolder") and GetID("OfficeHolder") == GetID(CurrentWinner) ) then
--					MsgSay("Chairman","@L_SESSION_2_CANCEL_ANOUNCEMENT_SPEECH_+1")
				elseif( OfficeGetHolder("Office","OfficeHolder") and wonEllection == false ) then
					MsgSay("Chairman","@L_SESSION_3_ELECT_RESULT2",GetID("Applicant"..Winner))
--					MsgSay("Chairman","@L_SESSION_2_CANCEL_ANOUNCEMENT_SPEECH_+0")
				else
					MsgSay("Chairman","@L_SESSION_3_ELECT_RESULT2",GetID("Applicant"..Winner))
				end

					if CutsceneLocalPlayerIsWatching("") then
						HudClearSelection()
						officesession_UpdatePanel()
					end
			end
		end
	end

	SetData("PanelShow",0)
	SetData("PanelInit",1)

	officesession_UpdatePanel()

	-- Bekanntgabe des Gewinners
	officesession_SaveVoteResult(Office,"Applicant"..Winner)
	
	if( officesession_SimIsInTownhall("Applicant"..Winner)) then
		officesession_SimCam("Applicant"..Winner,0,0)
		PlayAnimationNoWait("Applicant"..Winner, "sit_talk_short")		
		-- alter Amtstraeger neuer Amtstraeger?
		if( OfficeGetHolder("Office","OfficeHolder") and GetID("OfficeHolder") == GetID("Applicant"..Winner) ) then
			MsgSay("Applicant"..Winner,"@L_SESSION_3_ELECT_REACTION_+3")
		elseif( OfficeGetHolder("Office","OfficeHolder") and officesession_SimIsInTownhall("OfficeHolder") and wonEllection == false) then
			MsgSay("Applicant"..Winner,"@L_SESSION_3_ELECT_REACTION")
			officesession_SimCam("OfficeHolder",0,0)
			MsgSay("OfficeHolder", "@L_SESSION_2_CANCEL_COMMENTS")
		else
			MsgSay("Applicant"..Winner,"@L_SESSION_3_ELECT_REACTION") 
		end
			if CutsceneLocalPlayerIsWatching("") then
				HudClearSelection()
				officesession_UpdatePanel()
			end
	end

end

-- returns the idx of the voted applicant
function DoVote(VoterAlias,OfficeAlias,ApplicantAlias, ApplicantCnt)

	local ApplicantIDArray = {0,0,0,0}
	local ApplicantIDCnt = 0	
	local CommandIdx = 3
	local ButtonLabel = "@B[0,@L%"..CommandIdx.."SN]"
	ApplicantIDArray[ApplicantIDCnt] = GetID(ApplicantAlias..0)
	ApplicantIDCnt = ApplicantIDCnt + 1	
	CommandIdx = CommandIdx + 1
	
	-- PATCH TODO 
			-- prevents cutscene from freezing
			if (ApplicantCnt == nil) then
				ApplicantCnt = officesession_OfficeGetApplicants(Office,"Applicant")
			end
			local Applicant = ApplicantCnt - 1
			-- PATCH TODO
--	Check if the Voter is maybe an applicant of the current office run, security task
	for CheckApp = 0, Applicant do
		if (GetID(VoterAlias) == GetID(ApplicantAlias..CheckApp)) then
			return -1
		end
	end

	for App = 1, Applicant, 1 do
		local SimExists = GetAliasByID(GetID(ApplicantAlias..App),"ExisitingSim")

		if (GetID(VoterAlias) == GetID("ExisitingSim")) then
			return -1
		end

		if(SimExists == true) then
			if (GetHP("ExisitingSim") > 0 and GetState(ApplicantAlias..App, STATE_DEAD) == false) then
				ButtonLabel = ButtonLabel.."@B["..App..",@L"..GetName(ApplicantAlias..App).."]"
				ApplicantIDArray[ApplicantIDCnt] = GetID(ApplicantAlias..App)
				ApplicantIDCnt = ApplicantIDCnt + 1	
				CommandIdx = CommandIdx + 1				
			end
		end
	end

	ButtonLabel = ButtonLabel.."@B[-1,@L_SESSION_+0]"

	ButtonLabel = ButtonLabel.."@P"

	local Res = -1

	Res = MsgSayInteraction(VoterAlias,VoterAlias,0,ButtonLabel,officesession_AIAbstimmung,"@L_SESSION_3_ELECT_PLAYER", VoterAlias, GetID(VoterAlias),ApplicantIDArray[0],ApplicantIDArray[1],ApplicantIDArray[2],ApplicantIDArray[3])
	if Res == "C" then
		Res = -1
	end
	officesession_SimCam(VoterAlias,0,0)	
	if Res ~= -1 then
--		SetData("votes"..Res, GetData("votes"..Res) + 1)
		PlayAnimationNoWait(VoterAlias, "sit_yes")
		MsgSay(VoterAlias, "@L_SESSION_3_ELECT_CHOISE_+0", GetID(ApplicantAlias..Res))
--		SetData("VotedFor_"..GetDynastyID(VoterAlias),GetID("Applicant_"..CurrentOffice.."_"..Res))
	else
		PlayAnimationNoWait(VoterAlias, "sit_no")
		PlayAnimationNoWait(VoterAlias, "sit_talk_short")
		MsgSay(VoterAlias, "@L_SESSION_3_ELECT_CHOISE_+1")
	end
	
	if HasProperty(VoterAlias,"BribedBy") then
		GetAliasByID(GetProperty(VoterAlias,"BribedBy"),"BribedBySim")
		if (Res ~= -1) then
			if (GetID(ApplicantAlias..Res) ~= GetProperty(VoterAlias,"BribedBy")) then
				SetFavorToSim(VoterAlias,"BribedBySim",GetFavorToSim(VoterAlias,"BribedBySim")-25)
			end
		else
			SetFavorToSim(VoterAlias,"BribedBySim",GetFavorToSim(VoterAlias,"BribedBySim")-10)
		end
		RemoveProperty(VoterAlias,"BribedBy")
	end
	
	Sleep(0.2)
	return Res
end

function UsherSession()
	BuildingFindSimByProperty("councilbuilding","BUILDING_NPC", 1,"Usher")
	
	CityGetOfficeSessionMemberList("settlement","SimOfficeList",0)
	
	-- go over all office members and Stop the Behavior
	local SimCnt = ListSize("SimOfficeList")
	-- PATCH TODO
	-- prevents cutscene from freezing
	
	if (SimCnt == nil) then
		SimCnt = ListSize("SimOfficeList")
	end
	
	local Sims = SimCnt -1 
	
	-- PATCH TODO
	for i=0,Sims do
		ListGetElement("SimOfficeList",i,"Sim")
		if ( officesession_IsSimValid("Sim",true) == true) then

			local Dynasty = GetDynastyID("Sim")

			if (DynastyIsAI("Sim")) then
				SimStopMeasure("Sim")
				-- No idle in office!
				SimSetBehavior("Sim","")
				AlignTo("Sim","Usher")
				if (HasProperty("Sim","cutscene_destination_ID") == true) then
					RemoveProperty("Sim","cutscene_destination_ID")
				end
			end
			
			if (HasProperty("Sim","HaveCutscene") == true) then
				RemoveProperty("Sim","HaveCutscene")
			end			
	    	
	    end
	end

	
	local Talker = "Usher"
	officesession_SimCam("Usher",0,0)
	PlayAnimationNoWait("Usher", "sit_talk_short")
	MsgSay(Talker, "@L_SESSION_7_NOJURYEVENT_WELCOME","@L_BUILDING_Quarry_REQUIREMENTS")

	local NumOfVotes = CityPrepareOfficesToVote("settlement","OfficeList",false)
	local HadValidVotes = false
	
	-- PATCH TODO
	-- prevents cutscene from freezing
	
	if (NumOfVotes == nil) then
		NumOfVotes = CityPrepareOfficesToVote("settlement","OfficeList",false)
	end
	local Nums = NumOfVotes - 1
	
	-- PATCH TODO
	
	
	for i=0,Nums do
		ListGetElement("OfficeList",i,"OfficeToCheck")

		if (officesession_CheckForValidOfficeRun("OfficeToCheck") == true) then
			local ApplicantCnt = officesession_OfficeGetApplicants("OfficeToCheck","Applicant")

			local Winner = Rand(ApplicantCnt)

			officesession_SaveVoteResult("OfficeToCheck","Applicant"..Winner)
			
			local OfficeNameLabel = OfficeGetTextLabel("OfficeToCheck",SimGetGender("Applicant"..Winner))

			officesession_SimCam(Talker,0,0)
			PlayAnimationNoWait(Talker, "sit_talk_short")
			MsgSay(Talker, "@L_SESSION_7_NOJURYEVENT_APPLICATION",GetID("Applicant"..Winner),OfficeNameLabel)

			HadValidVotes = true

			if officesession_SimIsInTownhall("Applicant"..Winner) then
				CutsceneCameraBlend("",0,0)
				CutsceneCameraSetRelativePosition("","Mid_HCenterYLeft","Applicant"..Winner)
				PlayAnimationNoWait("Applicant"..Winner, "talk")
				MsgSay("Applicant"..Winner, "@L_SESSION_3_ELECT_REACTION")
				StopAnimation("Applicant"..Winner)
			end
		end

	end

	if( HadValidVotes ) then
		officesession_WriteVotes()

		MsgSay(Talker,"@L_SESSION_4_GOODBYE_SUCCESS")
	else
		MsgSay(Talker,"@L_SESSION_4_GOODBYE_FAILED")
	end

	officesession_QuitCutscene()
end

function CheckForValidOfficeRun(Office)
	--Check if the current rask have living applicants
	local Valid = false

	local ApplicantCnt = officesession_OfficeGetApplicants(Office,"Applicant")

	local DeadApplicants = 0
	
	-- PATCH TODO 
			-- prevents cutscene from freezing
			if (ApplicantCnt == nil) then
				ApplicantCnt = officesession_OfficeGetApplicants(Office,"Applicant")
			end
			local Applicant = ApplicantCnt - 1
			-- PATCH TODO

	for i = 0, Applicant, 1 do
		local CurrentApplicant = "Applicant"..i
		if (officesession_IsSimValid(CurrentApplicant,false) == false) then
			DeadApplicants = DeadApplicants + 1
		end
	end

	if ( (DeadApplicants > 0) or (ApplicantCnt == 0) or (ApplicantCnt == nil) ) then
		if (DeadApplicants == ApplicantCnt) then
			Valid = false
		else
			Valid = true
		end
	else
		Valid = true
	end

	return Valid
end

------------------------------------------------------------------------------------------------------------------------
-- Functions for place Voters and Applicants ---------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
function VoterAttend(Id)
--	if (DynastyIsAI("")) then
		-- No idle in Office!	
		-- SimSetBehavior("","idle")
--	else
--		SimSetBehavior("","")
--	end
	SimStopMeasure("")
	-- ClearMeasureCache("")
	Sleep(0.2)
	
	if GetID("councilbuilding")==GetInsideBuildingID("") then
		if LocatorStatus("councilbuilding","TableChair"..Id,true)==1 then
			SetData("Office_Sims_"..GetID("").."Seat","TableChair"..Id)
			if(GetLocatorByName("councilbuilding", "TableChair"..Id, "TableChair")) then
				if not f_BeginUseLocator("","TableChair", GL_STANCE_SIT, true) then
			--	SimBeamMeUp("", "TableChair")
				f_Stroll("",5.0,1.0)
				f_BeginUseLocator("","TableChair", GL_STANCE_SIT, true)
					if f_BeginUseLocator("","TableChair", GL_STANCE_SIT, true) then
						CutsceneSendEventTrigger("owner", "Reached")
					end
				else
					CutsceneSendEventTrigger("owner", "Reached")
				end
			CutsceneSendEventTrigger("owner", "Reached")
			end
		end		
	end
end

function ApplicantAttend(Id)
	--	if (DynastyIsAI("")) then
	--		SimSetBehavior("","idle")
	--	else
	--		SimSetBehavior("","")
	--	end
	--	SimStopMeasure("")
	-- ClearMeasureCache("")
	Sleep(0.2)

	if GetID("councilbuilding")==GetInsideBuildingID("") then
		if LocatorStatus("councilbuilding","BenchChair"..Id,true)==1 then
			SetData("Office_Sims_"..GetID("").."Seat","BenchChair"..Id)
			if(GetLocatorByName("councilbuilding", "BenchChair"..Id, "BenchChair")) then
				if not f_BeginUseLocator("","BenchChair", GL_STANCE_SITBENCH, true) then
				--	SimBeamMeUp("", "BenchChair")
				f_Stroll("",5.0,1.0)
				f_BeginUseLocator("","BenchChair", GL_STANCE_SITBENCH, true)
					if f_BeginUseLocator("","BenchChair", GL_STANCE_SITBENCH, true) then
						CutsceneSendEventTrigger("owner", "Reached")
					end
				else
					CutsceneSendEventTrigger("owner", "Reached")
				end
			CutsceneSendEventTrigger("owner", "Reached")	
			end
		end		
	end
end

function SpecialSimAttend(Locator)
	SimSetBehavior("","")
	SimStopMeasure("")
	SetData("Office_Sims_"..GetID("").."Seat",Locator)
	if(GetLocatorByName("councilbuilding", Locator, "Locator")) then
		f_BeginUseLocator("","Locator", GL_STANCE_SIT, true)
	end
	CutsceneSendEventTrigger("owner", "Reached")
	SimStopMeasure("")
--	if (DynastyIsAI("")) then
	--	SimSetBehavior("","idle")
--	end
end


------------------------------------------------------------------------------------------------------------------------
-- Functions for Voters and Applicants to leave bulding ----------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------

function SimLeave()
	f_EndUseLocator("",GetData("Office_Sims_"..GetID("").."Seat"))
	CutsceneSendEventTrigger("owner", "OutOfBuilding")
	if AliasExists("") then
		if (DynastyIsAI("")) then
			--f_ExitCurrentBuilding("")
			--f_Stroll("",250.0,1.0)
			SimSetBehavior("","idle")
			AllowAllMeasures("Sim")
		end
	end
	--SimStopMeasure("")
end

function SimLeaveTownhall()
	BuildingGetRoom("councilbuilding","Judge","Room")
	RoomGetInsideSimList("Room","SimList")

	local SimCnt = ListSize("SimList")
	local totalCount = 0
	
	-- PATCH TODO
	-- prevents cutscene from freezing
	
	if (SimCnt == nil) then
		SimCnt = ListSize("SimList")
	end
	
	local Sims = SimCnt -1 
	
	-- PATCH TODO

	for i=0,Sims do
		ListGetElement("SimList",i,"Sim")
		if(HasProperty("Sim","BUILDING_NPC") == false) then
			AllowMeasure("Sim","StartDialog",EN_BOTH)
			totalCount = totalCount + 1
			CutsceneCallThread("","SimLeave","Sim")
		end
	end
	
	return totalCount
end

------------------------------------------------------------------------------------------------------------------------
-- Clean Up         ----------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------

function UnlockAll()
	officesession_DoBlend(0.1,0)
	OfficeSetBlock("office", false)
end

function QuitCutscene()
	officesession_UnlockAll()
	EndCutscene("")
end

function CleanUp()
	RemoveProperty("councilbuilding","CutsceneAhead")
	BuildingGetRoom("councilbuilding","Judge","Room")	
	RoomLockForCutscene("Room",0)
	-- entfernen aller Bewerber
	CityEndOfficeElection("Settlement","",nil)
	RemoveProperty("councilbuilding","sessioncutszene")
	mccoy_AIOfficeCheck()
	DestroyCutscene("")
end

------------------------------------------------------------------------------------------------------------------------
-- Camera Functions ----------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------

function OverviewCam()
	if (GetData("KingTask") == 0) or (GetData("KingTask") == nil) then
		officesession_TotalCam(1,0,0)
	else
		officesession_TotalKingCam(1,0,0)
	end
end

function TotalCam(totalnum,blend,duration)
	if blend == 1 then
		officesession_DoBlend(duration,1)
	end
	officesession_Cam("Total"..totalnum.."_start")
	if blend == 1 then
		Sleep(duration + 0.1)
	end
	officesession_DoBlend(15,1)
	officesession_Cam("Total"..totalnum.."_end")
end

function TotalKingCam(totalnum,blend,duration)
	if blend == 1 then
		officesession_DoBlend(duration,1)
	end
	officesession_Cam("ConCamT3")
end

function BlendCamTo(locator,blend,duration)
	if blend > 0 then
		officesession_DoBlend(duration,blend)
	end
	officesession_Cam(locator)
end

function SetTableCam()
	officesession_Cam("ConCamT"..(Rand(4) + 1))
end

function SetBenchCam(Voter)
	officesession_Cam("ConCamClose"..(Rand(2) + 2))
end

function DoBlend(a,b)
	CutsceneCameraBlend("",a,b)
end

function Cam(LocatorName)
	GetLocatorByName("councilbuilding",LocatorName,"DestPos")
	if AliasExists("DestPos") then
		CutsceneCameraSetAbsolutePosition("","DestPos")
	end
end

function SimCam(character, blending, duration)
	if blending then
		if duration then
			CutsceneCameraBlend("",duration,blending)
		else
			CutsceneCameraBlend("",1.0,blending)
		end
	else
		CutsceneCameraBlend("",1.0,2)
	end
	CutsceneCameraSetRelativePosition("","CloseUpSit",character)
end

function OnCameraEnable()
	BuildingGetRoom("councilbuilding","Judge","Room")
	CutsceneHUDShow("","LetterBoxPanel")
	officesession_UpdatePanel()
	HudClearSelection()

	local sim
	local SimCount = ScenarioGetObjects("cl_Sim", 99999, "SimList")
	for sim=0,SimCount-1 do
		local SimAlias = "SimList"..sim
		if DynastyIsPlayer(SimAlias) then
			if GetInsideBuildingID(SimAlias) == GetID("councilbuilding") then
				HudAddToSelection(SimAlias)
				return true
			end
		end
	end
end

function OnCameraDisable()
	CutsceneHUDShow("","LetterBoxPanel",false)
	CutsceneHUDShow("","OfficeApplicationPanel",false)

	HudCancelUserSelection()
	HudClearSelection()
	HudAddToSelection("councilbuilding")
end

------------------------------------------------------------------------------------------------------------------------
-- AI DECISSION Functions ----------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------

function AIBedrohung()
	if(Rand(2) == 0) then
		return "A"
	else
		return "Z"
	end
end

--ai voting for application
function AIAbstimmung(Params)
	local VoterAlias = Params[1]
	local App
	local Best = -1
	local MaxFav = -999
	local ApplicantCnt = officesession_OfficeGetApplicants(GetData("CurrentOffice"),"Applicant")
	local NobilityBonus = 0
	local CurrentOfficeBonus = 0
	local CustomAmount = GetSettingNumber("CHEAT","MyFavorBonus",0)
	local MyBonus = 0
	
	-- PATCH TODO
	-- prevents the cutscene from freezing
	if (ApplicantCnt == nil) then
		ApplicantCnt = officesession_OfficeGetApplicants(GetData("CurrentOffice"),"Applicant")
	end
	local Applicant = ApplicantCnt - 1
	-- PATCH TODO
	for App=0, Applicant, 1 do
		local CurrentApplicant = "Applicant"..App
		if( (GetHP(CurrentApplicant) > 0) and (GetState(CurrentApplicant, STATE_DEAD) == false )) then
			local Fav = GetFavorToSim(VoterAlias, CurrentApplicant)
			GetDynasty(CurrentApplicant,"SimDynasty")
			if SimGetOffice(CurrentApplicant,"ExistingSimOffice") then
				if (GetID("ExistingSimOffice") == GetID(GetData("CurrentOffice"))) then
					CurrentOfficeBonus = 10
				end
			end			
			local TmpFavor = GetFavorToSim(VoterAlias,CurrentApplicant)
			local GTfavor = math.floor(math.pow(TmpFavor + 1, 0.94) / 2)
			--A:7 D:8
			local VAtt = math.floor(GetSkillValue(CurrentApplicant, RHETORIC) * 3)
			local MDef =	math.floor(GetSkillValue(VoterAlias, EMPATHY) * 3)
			local ResultVs = VAtt - MDef
			local TitleBonus = GetNobilityTitle(CurrentApplicant) * 5
			if GetImpactValue(CurrentApplicant,"BeFromNobleBlood") > 0 then
				NobilityBonus = 30
			end
			if DynastyIsPlayer(CurrentApplicant) then
				MyBonus = 0 + CustomAmount
			end
			local Fav = GTfavor + ResultVs + GetImpactValue(CurrentApplicant,"CutsceneFavor") + (GetImpactValue("SimDynasty","PoliticalAttention") * 15) + CurrentOfficeBonus + TitleBonus + NobilityBonus + MyBonus
			LogMessage("MyBonus: "..MyBonus.."   Fav: "..Fav)
			if Fav > MaxFav then
				Best = App
				MaxFav = Fav
			elseif Fav == MaxFavor then
				Best = -1
			end
		end
	end
	return Best
end

function RunAIPlan(SimAlias)
	local SimExists = GetAliasByID(GetID(SimAlias),"ExisitingSim")
	if(SimExists == true) then
		if DynastyIsAI(SimAlias) then
			if GetInsideBuilding(SimAlias,"currentbuilding") then
				if GetID("currentbuilding")==GetID("councilbuilding") then
					AIExecutePlan(SimAlias, "OfficeSession", "SIM",SimAlias)
					Sleep(0.01)
				end
			end
		end
	end
end

------------------------------------------------------------------------------------------------------------------------
-- Panel Functions ----------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------



function UpdatePanel()
	local Office = GetData("CurrentOffice")
	if GetData("PanelShow") == 1 then
		CutsceneHUDShow("","OfficeApplicationPanel")
	else
		CutsceneHUDShow("","OfficeApplicationPanel",false)
		return
	end
	local ApplicantCnt = officesession_OfficeGetApplicants(Office,"Applicant")
	local AppsArray = {}

	for i=1,4 do
		local SimExists = GetAliasByID(GetID("Applicant"..i-1),"ExisitingSim")
		if( (SimExists == true) and (GetHP("ExisitingSim") > 0 ) and (i <= GetData("PanelCandidates",0)) and (GetState("Applicant"..i-1, STATE_DEAD) == false) )then
			AppsArray[i] = GetID("Applicant"..i-1)
		else
			AppsArray[i] = -1
		end
	end

	OfficeApplicationHUDSetCandidates("",GetID(Office),AppsArray[1],AppsArray[2],AppsArray[3],AppsArray[4])

	local VotersToShow = GetData("PanelVoters")

	if (GetData("PanelInit") == 0) then
		local VoterCnt = officesession_GetVoters("Office","Voter")
		
		-- PATCH TODO
		-- prevents cutscene from freezing
		if VoterCnt == nil then
			VoterCnt = officesession_GetVoters("Office", "Voter")
		end
		local Voter = VoterCnt - 1
		--PATCH TODO

	  	for i=0,Voter do
			local IsApp = 0
			local VoterAlias = "Voter"..i
			if officesession_SimIsInTownhall(VoterAlias) == true then

				local VotersLevel = SimGetOfficeLevel(VoterAlias)

				if (VotersLevel == nil) then
					return
				end

				for Count=1,4 do
					if AppsArray[Count] == GetID(VoterAlias) then
						IsApp = 1
					end
				end
				if (IsApp == 0) and (HasProperty(VoterAlias,"inpanel") == false) and (VotersToShow > 0) then
--					if (DynastyIsAI(VoterAlias) or GetData("HumanTask") == 1) then
						VotersToShow = VotersToShow - 1
						local FavApp = officesession_GetFavoriteApplicantToVoter(Office,GetID(VoterAlias))
						if DynastyIsPlayer(VoterAlias) then
							FavApp = -1
						end
						OfficeApplicationHUDAddVoter("",GetID(VoterAlias),FavApp)
						SetProperty(VoterAlias,"inpanel",1)
--					end
				end
			end
		end
		
		-- PATCH TODO
		-- prevents cutscene from freezing
		
		if VoterCnt == nil then
			VoterCnt = officesession_GetVoters("Office", "Voters")
		end
		local Voter = VoterCnt - 1
		
		--PATCH TODO
		for i=0,Voter do
			local VoterAlias = "Voter"..i
			RemoveProperty(VoterAlias,"inpanel")
		end
	end
end


function GetFavoriteApplicantToVoter(Office,VoterID)
	local ApplicantCnt = officesession_OfficeGetApplicants(Office,"Applicant")
	local AppsArray = {}
	local MaxFavor = -99
	local FavoriteApplicant= -1
	local NobilityBonus = 0
	local CurrentOfficeBonus = 0	
	local CustomAmount = GetSettingNumber("CHEAT","MyFavorBonus",0)
	local MyBonus = 0
	--PATCH TODO
	-- prevents cutscene from freezing
	if (ApplicantCnt == nil) then
		ApplicantCnt = officesession_OfficeGetApplicants(Office,"Applicant")
	end
	local Applicant = ApplicantCnt - 1
	-- PATCH TODO
	for i=0,Applicant do
		local SimExists = GetAliasByID(GetID("Applicant"..i),"ExisitingSim")
		if( (SimExists == true) and (GetHP("ExisitingSim") > 0) and (GetState("ExisitingSim", STATE_DEAD) == false) ) then
			GetAliasByID(VoterID,"VoterAlias")
			GetDynasty("ExisitingSim","SimDynasty")
			if SimGetOffice("ExisitingSim","ExistingSimOffice") then
				if (GetID("ExistingSimOffice") == GetID(Office)) then
					CurrentOfficeBonus = 10
				end
			end
			local TmpFavor = GetFavorToSim("VoterAlias","ExisitingSim")
			local GTfavor = math.floor(math.pow(TmpFavor + 1, 0.94) / 2)
			--A:7 D:8
			local VAtt = math.floor(GetSkillValue("ExisitingSim", RHETORIC) * 3)
			local MDef =	math.floor(GetSkillValue("VoterAlias", EMPATHY) * 3)
			local ResultVs = VAtt - MDef
			local TitleBonus = GetNobilityTitle("ExisitingSim") * 5
			if GetImpactValue("ExisitingSim","BeFromNobleBlood") > 0 then
				NobilityBonus = 30
			end
			if DynastyIsPlayer("ExisitingSim") then
				MyBonus = 0 + CustomAmount
			end
			
			local Fav = GTfavor + ResultVs + GetImpactValue("ExisitingSim","CutsceneFavor") + (GetImpactValue("SimDynasty","PoliticalAttention") * 15) + CurrentOfficeBonus + TitleBonus + NobilityBonus + MyBonus
			LogMessage("MyBonus: "..MyBonus.."   Fav: "..Fav.."   LastName: "..SimGetLastname("ExisitingSim"))
			if Fav > MaxFavor then
				MaxFavor = Fav
				FavoriteApplicant = GetID("Applicant"..i)
			elseif Fav == MaxFavor then
				FavoriteApplicant = -1
			end
		end
	end
	return FavoriteApplicant
end

------------------------------------------------------------------------------------------------------------------------
-- Measure Bar Functions -----------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------


function MeasureBar(Office,state)
	CutsceneShowCharacterPanel("",state)
	--All Voters

	local VoterCnt = officesession_GetVoters(Office,"Voter")
	
	-- PATCH TODO
	-- prevents cutscene from freezing
	if VoterCnt == nil then
		VoterCnt = officesesion_GetVoters(Office, "Voters")
	end
	-- PATCH TODO
	local Voter = VoterCnt - 1

	for i = 0, Voter, 1 do
		local VoterAlias = "Voter"..i
		if (officesession_IsSimValid(VoterAlias,true) == true) then
			if (state == true) then
				SetProperty(VoterAlias,"AIMode",1)
				officesession_ActivateSessionMeasures(VoterAlias)
			elseif (state == false) then
				RemoveProperty(VoterAlias,"AIMode")
				officesession_RemoveAllSessionMeasures(VoterAlias)
			end
		end
	end

	--All Applicants

	local ApplicantCnt = officesession_OfficeGetApplicants(Office,"Applicant")
	
	--PATCH TODO
	-- prevents cutscene from freezing
	if (ApplicantCnt == nil) then
		ApplicantCnt = officesession_OfficeGetApplicants(Office,"Applicant")
	end
	local Applicant = ApplicantCnt - 1
	-- PATCH TODO
	
	for i = 0, Applicant, 1 do
		local CurrentApplicant = "Applicant"..i
		if (officesession_IsSimValid(CurrentApplicant,true) == true) then
			if (state == true) then
				SetProperty(CurrentApplicant,"AIMode",1)
				officesession_ActivateSessionMeasures(CurrentApplicant)
			elseif (state == false) then
				RemoveProperty(CurrentApplicant,"AIMode")
				officesession_RemoveAllSessionMeasures(CurrentApplicant)
			end
		end
	end
end

function ActivateSessionMeasures(Sim)
	local i
	local SimCount = ScenarioGetObjects("cl_Sim", 99999, "SimList")
	for i=0,SimCount-1 do
		local SimAlias = "SimList"..i
		if DynastyIsPlayer(SimAlias) then
			if GetID(Sim) == GetID(SimAlias) then	
				HudClearSelection()
				HudAddToSelection(Sim)
			end
		end
	end
	SetProperty(Sim,"CutsceneBribeCharacter",1)
	SetProperty(Sim,"CutsceneLetterFromRome",1)
--	SetProperty(Sim,"CutsceneAboutTalents1",1)
--	SetProperty(Sim,"CutsceneAboutTalents2",1)
	SetProperty(Sim,"CutsceneFlowerOfDiscord",1)
	SetProperty(Sim,"CutscenePerfume",1)
	SetProperty(Sim,"CutscenePoem",1)
	SetProperty(Sim,"CutsceneThesisPaper",1)
	SetProperty(Sim,"CutsceneCurryFavor",1)
	SetProperty(Sim,"CutsceneDeliverTheFalseGauntlet",1)
	SetProperty(Sim,"CutsceneHaveAStabbingGaze",1)
	SetProperty(Sim,"CutsceneMakeACompliment",1)
	SetProperty(Sim,"CutsceneFlirt",1)
	SetProperty(Sim,"CutsceneThreatCharacter",1)
end


function RemoveAllSessionMeasures(Sim)
	RemoveProperty(Sim,"CutsceneBribeCharacter")
	RemoveProperty(Sim,"CutsceneLetterFromRome")
--	RemoveProperty(Sim,"CutsceneAboutTalents1")
--	RemoveProperty(Sim,"CutsceneAboutTalents2")
	RemoveProperty(Sim,"CutsceneFlowerOfDiscord")
	RemoveProperty(Sim,"CutscenePerfume")
	RemoveProperty(Sim,"CutscenePoem")
	RemoveProperty(Sim,"CutsceneThesisPaper")
	RemoveProperty(Sim,"CutsceneCurryFavor")
	RemoveProperty(Sim,"CutsceneDeliverTheFalseGauntlet")
	RemoveProperty(Sim,"CutsceneHaveAStabbingGaze")
	RemoveProperty(Sim,"CutsceneMakeACompliment")
	RemoveProperty(Sim,"CutsceneFlirt")
	RemoveProperty(Sim,"CutsceneThreatCharacter")
end

------------------------------------------------------------------------------------------------------------------------
-- Helper Functions ----------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------


function SimLeaveBuilding(SimAlias)
	if officesession_SimIsInTownhall(SimAlias)== true  then
		feedback_MessagePolitics(SimAlias,"@L_TOWNHALL_CLOSED_HEADER_+0","@L_TOWNHALL_CLOSED_TEXT_+0",GetID(SimAlias))
		CutsceneCallThread("", "SimExitBuilding", SimAlias)
		return 1
	end
	return 0
end

function SimExitBuilding()
	f_ExitCurrentBuilding("")
	CutsceneRemoveSim("owner","")
	CutsceneSendEventTrigger("owner", "Reached")
	--f_Stroll("",250.0,1.0)
	if DynastyIsAI("") then
		SimSetBehavior("","idle")
		AllowAllMeasures("Sim")
	end
end

--check if sim is in the offices session townhall
function SimIsInTownhall(SimAlias)
	if GetID(SimAlias)>0 then
		if GetInsideBuilding(SimAlias,"currentbuilding") then
			if GetID("currentbuilding")==GetID("councilbuilding") then
				GetInsideRoom(SimAlias,"InsideRoom")
				BuildingGetRoom("councilbuilding","Judge","Room")
				if (GetID("Room") ~= GetID("InsideRoom")) then
				--	SimBeamMeUp(SimAlias, "Room", false) -- bad to wait for every single person.
					return false
				else
					-- sim is already there
					return true
				end
			else
				-- sim is not in the building
				return false
			end
		else
			return false
		end
	end
	return false
end

-- prepares the valid (available for the office meeting) applicants for the given office, returns the number of valid applicants
function OfficeGetApplicants(Office,ApplicantAlias)
	local APPLICANTS = 2
	OfficePrepareSessionMembers(Office,"ApplicantList",APPLICANTS)
	return officesession_BuildValidSimList("ApplicantList",ApplicantAlias)
end

-- prepares the valid (available for the office meeting) voters for the given office, returns the number of valid voters
function GetVoters(Office,VoterAlias)
 	local VOTERS = 1
	OfficePrepareSessionMembers(Office,"VoterList",VOTERS)
	return officesession_BuildValidSimList("VoterList",VoterAlias)
end

-- prepares the current office trees chairman with the given alias. Returns if a chairman exists or not
function GetChairman(ChairmanAlias)
	CityGetChairmanList("settlement","ChairmanList")
	local Size = ListSize("ChairmanList")
	-- PATCH TODO
	-- prevents cutscene from freezing
	if (Size == nil) then
		Size = ListSize("ChairmanList")
	end
	local Sizes = Size - 1
	-- PATCH TODO
	for i=0,Sizes do
		ListGetElement("ChairmanList",i,ChairmanAlias)
		if(officesession_IsSimValid(ChairmanAlias,true)) then
			-- remove the list
			RemoveAlias("ChairmanList")
			return true
		end
	end
	
	return false
	-- no valid chairman found, use the townclerk.
	--return officesession_XGetTownClerk(ChairmanAlias)
end

-- returns the count of valid applicants for the whole office session
function GetValidApplicantCount()
	local APPLICANTS = 2
 	CityGetOfficeSessionMemberList("settlement","ApplicantList",APPLICANTS)
 	officesession_PrepareValidSimList("ApplicantList")
 	local ApplicantCnt = ListSize("ApplicantList")
 	-- remove the list
 	RemoveAlias("ApplicantList")
 	return ApplicantCnt
end

-- prepares the alias of all valid sims in the given list
function BuildValidSimList(ListAlias,Alias)

	local Size = officesession_PrepareValidSimList(ListAlias)
	
	-- PATCH TODO
	-- prevents cutscene from freezing
	if (Size == nil) then
		Size = officesession_PrepareValidSimList(ListAlias)
	end
	local Sizes = Size - 1
	-- PATCH TODO
	for i=0,Sizes do
		ListGetElement(ListAlias,i,Alias..i)
	end

	-- remove the list
	RemoveAlias("ApplicantList")

	return Size
end

-- removes all invalid sims from the given list
function PrepareValidSimList(ListAlias)
	-- remove all invalid objects
	local Size = ListSize(ListAlias)
	-- PATCH TODO
	-- prevents cutscene from freezing
	if (Size == nil) then
		Size = ListSize(ListAlias)
	end
	local Sizes = Size - 1
	-- PATCH TODO
	for i=Sizes,0,-1 do
		ListGetElement(ListAlias, i,"ListSim")
		if(not officesession_IsSimValid("ListSim",false)) then
			ListRemove(ListAlias,"ListSim")
		end
	end
	-- Remove the list sim alias
	RemoveAlias("ListSim")
	local Size = ListSize(ListAlias)
	return Size
end

-- checks if a sim is valid for the office
function IsSimValid(SimAlias,insidecheck)
	if(AliasExists(SimAlias)) then
		if(GetState(SimAlias, STATE_DEAD) == false) then
			if(GetState(SimAlias, STATE_CAPTURED) == false) then
				if(GetState(SimAlias, STATE_UNCONSCIOUS) == false) then
					if(officesession_SimIsInTownhall(SimAlias) or insidecheck == false) then
						return true
					end
				end
			end
		end
	end
	return false
end


-- saves the result of the given vote
function SaveVoteResult(OfficeAlias,WinnerAlias)
 -- sollte der Gewinner ebenfalls in der Amtswahl um sein altes Amt vertreten sein, wird er aus der Wahlliste für dieses Amt gelöscht
	if(SimGetOffice(WinnerAlias,"CurrentOffice") == true) then
		OfficeRemoveApplicant("CurrentOffice",WinnerAlias)
	end

	-- Speichern des Voteergebnisses
	local VoteCacheIdx = GetData("VoteCacheIdx")
	SetData("VoteCacheOfficeID"..VoteCacheIdx,OfficeGetIdx(OfficeAlias))
	SetData("VoteCacheOfficeLevel"..VoteCacheIdx,OfficeGetLevel(OfficeAlias))
	SetData("VoteCacheWinnerID"..VoteCacheIdx,GetID(WinnerAlias))
	VoteCacheIdx = VoteCacheIdx + 1
	SetData("VoteCacheIdx",VoteCacheIdx)

end

-- executes all saved vote results
function WriteVotes()
	local VoteCacheIdx = GetData("VoteCacheIdx")
	-- PATCH TODO 
	-- prevents cutscene from freezing
	if (VoteCacheIdx == nil) then
			VoteCacheIdx = GetData("VoteCacheIdx")
	end
	local VoteCache = VoteCacheIdx - 1
	
	-- PATCH TODO
	for i=0,VoteCache do
		CityGetOffice("Settlement",GetData("VoteCacheOfficeLevel"..i),GetData("VoteCacheOfficeID"..i),"Office")
		GetAliasByID(GetData("VoteCacheWinnerID"..i),"Holder")
		-- setzen des neuen office holders, richtigstellen aller relevanten beziehungen, privilegien etc.
		CityEndOfficeElection("Settlement","Office","Holder")
		xp_RunForAnOffice("Holder", OfficeGetLevel("Office"))	
	end
end

