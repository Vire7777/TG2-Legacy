--scriptfunctions

--Settlement?

--/*!int CityGetOfficeSessionMemberList(cl_Settlement* pSettlement, String ListAlias, int Mode)
--		returns a list which contains all needed members of the current office session
--*/
--int CityGetOfficeSessionMembers(cl_Settlement* pSettlement, String ListAlias, int Mode)

--/*! bool ListContaines(cl_CoreNode* pCoreNode)
--		checks if the given object is member of the given list
--*/
--bool ListContaines(cl_String ListAlias, cl_CoreNode* pCoreNode)

--/*! bool CityGetChairman(cl_Settlement* pSettlement, String Alias)
--		prepares a ordered list of all possible chairmans of the current offices session. The chairman is the sim which owns the highest office in the tree and is at the session right in time.
--*/
--bool CityGetChairmanList(cl_Settlement* pSettlement, String ListAlias)

--/*! int CityPrepareOfficesToVote(cl_Settlement* pSettlement, String ListAlias)
--\brief : prepares all offices for vote:
--- blocks all offices
--and stores them in the list with the given alias
--\author : UweH
--\param  : cl_Settlement* pSettlement - settlemebnt
--\param  : String ListAlias - list alias
--\return : int  - the number of offices to vote
--*/
--int GuildGameObjects_CityPrepareOfficesToVote(lua_State * L)

--/*! int  OfficePrepareSessionMembers(String OfficeAlias, String ListAlias, int Mode)
--\brief : prepares a list of all applicants or voters or both for the current vote and saves them in the list with the given alias
--returns the number of applicants for the given office
--\author : UweH
--\param  : String OfficeAlias - Office
--\param  : String ListAlias - List
--\param  : int Mode - specifies which office members should be added to the list:
--0 - All (voters and applicants)
--1 - only office voters
--2 - only applicants 
--\return : int   - number of session members
--*/
--int GuildGameObjects_OfficePrepareSessionMembers(lua_State * L)

--/*! bool OfficeRemoveApplicant(cl_Office* pOffice, cl_Sim* pSim)
--		removes the given sim from the offices applicants
--		returns true if the sim was an applicant for that office
--*/
--bool OfficeRemoveApplicant(cl_Office* pOffice, cl_Sim* pSim)

-------------------------------------------------------------------------------------------------------------------------

function Start()
 
 	-- if no settlement, no office session
 	if GetID("settlement")==-1 then
		MsgDebugMeasure("applicant","error: This townhall does not belong to any settlement.")
		EndCutscene("")
	end
	
 	-- set a Date: event_alias, settlement, cutscene, function
	CityScheduleCutsceneEvent("settlement","council_date","","BeginCouncilMeeting",17,6,"@L_SESSION_6_TIMEPLANNERENTRY_CITY_+0")  -- hour of day=17h, MinTimeInFuture = 8
	
	local EventTime = SettlementEventGetTime("council_date")
	
	local GameTime = GetGametime()*60	-- in stunden
	local WaitTime = (EventTime -( 21*60)) - GameTime
	
	if (WaitTime<0) then
		officesession_SetBuildingInfo()
	else
		CutsceneAddEvent("","SetBuildingInfo",WaitTime)
	end
	
	local CutscenesAhead
	if HasProperty("councilbuilding","CutsceneAhead") then
		CutscenesAhead = GetProperty("councilbuilding","CutsceneAhead") + 1
		SetProperty("councilbuilding","CutsceneAhead",CutscenesAhead)
	else
		SetProperty("councilbuilding","CutsceneAhead",1)
	end

	SetData("FirstRun",1)
	
end

function SetBuildingInfo()
	SetProperty("councilbuilding","sessioncutszene",GetID(""))
end

function AddApplicant()
	--Add the Applicant "applicant" to the Applicant list for the office "office"
	if not CitySetOfficeApplicant("settlement", "applicant", "office") then
  	return false
	end
	
	--Invite the Applicant
		--Gets the Name of the to Applied Office
	local OfficeNameLabel = OfficeGetTextLabel("office")
	local OfficeName = "@L"..string.sub(OfficeNameLabel, 0, -2)..2
	
	officesession_InviteApplication("applicant","", OfficeName)
	officesessioninvite_SendApplicationInvites()
	
end

-- prepare the townhall for the meeting. Let the meeting sims go to the right places, kick out not meeting sims
function PrepareCouncilMeeting()
  -- DataInit
  SetData("VoteCacheIdx",0)
 
  -- get whole office session member list
	CityGetOfficeSessionMemberList("settlement","SimOfficeList",0)	
	BuildingGetInsideSimList("councilbuilding","SimList")
	
	local TriggerEventCnt = 0
	-- kick all sims which are not allowed at the office meeting
	SimCnt = ListSize("SimList")
	for i=0,SimCnt - 1 do
		ListGetElement("SimList",i,"Sim")
		if not ListContains("SimOfficeList","Sim") then
			officesession_XLeaveBuilding("Sim")
			TriggerEventCnt = 1
		end
	end
	
	-- go over all office members and stop those who are to late. Remove them from the SimOfficeList
	SimCnt = ListSize("SimOfficeList")
	for i=0,SimCnt - 1 do
		ListGetElement("SimOfficeList",i,"Sim")	  
		if(not officesession_XSimIsInTownhall("Sim")) then
		    officesession_XRemindOfMissedOffice("Sim")
		    StopMeasure("Sim")
		    ListRemove("SimOfficeList","Sim")
		end
	end	
	
	-- Get the Chairman, if no one of the office tree is there, use the townclerk
	local ChairmanExists = officetree_GetChairman("Chairman")
	if(not ChairmanExists)then
		-- ERROR --
		EndCutscene()
	end
	
	-- move chairman to his seat
	officetree_XHandleChairman("Chairman")
	TriggerEventCnt = 1
	
	-- remove chairman from SimOfficeList
	ListRemove("SimOfficeList","Chairman")
			
	-- move special offices to their seats
	local CapitalCityLevel = 6
	if XSettlementGetLevel("settlement") == CapitalCityLevel then
		officetree_XHandleKing("King")
		TriggerEventCnt = 1
		officetree_XHandleCardinal("Cardinal")
		TriggerEventCnt = 1
		officetree_XHandleFeldherr("Feldherr")
		TriggerEventCnt = 1
		-- remove special offices from list
		ListRemove("SimOfficeList","King")
		ListRemove("SimOfficeList","Cardinal")
		ListRemove("SimOfficeList","Feldherr")
	end
		
	-- move remain officeholders and applicants to their seats
	SimCnt = ListSize("SimOfficeList")
	for i=0,SimCnt - 1 do
		ListGetElement("SimOfficeList",i,"Sim")
		if SimGetOffice("Sim","Office") == XCheckIfOfficeBelongsToTheRightSettlement("settlement","Office") then
			officesession_XMoveOfficeHolderToSeat("Sim")
			TriggerEventCnt = 1
		else
			officesession_XMoveApplicantToSeat("Sim")
			TriggerEventCnt = 1
		end
	end
	
	CutsceneAddTriggerEvent("","RunCouncilMeeting", "Reached", TriggerEventCnt,60)
end

function RunCouncilMeeting()	
	
	-- all sims are at their places, let the games begin
	MsgSay("Chairman","Begrüssung")	 
	
	-- Check ob überhaupt Applicants da sind. Ist niemand da, sollte die Sitzung gleich beendet werden.
	if officesession_GetValidApplicantCount("Settlement") > 0 then
	  MsgSay("Chairman","Keine Bewerber da? Also brauchen wir auch keine Sitzung")
		EndCutscene()
	end
	
	-- schleife über alle votes, vom höchsten Amt bis zu niedrigsten Amt
	local NumOfVotes = CityPrepareOfficesToVote("Settlement","OfficeList")
	SetData("VoteCnt",NumOfVotes)
	local NumOfVotes = GetData("VoteCnt")
	if (NumOfVotes == 0) or (NumOfVotes == nil) then
		MsgSay("Chairman","Aus unerfindlichen Gründen finden keine Wahlen statt")
		EndCutscene()
	end
		
	for i=0,NumOfVotes - 1 do
	 ListGetElement("OfficeList",i,"Office")
	 officesession_VoteForOffice("Office")
	end
	
	-- Verabschiedung durch den Chairman
	MsgSay("Chairman","Ende der Verhandlung")
	
	-- Übertragen der Änderungen in den OfficeTree
	officesession_WriteVotes()	
	
end

function CleanUp()
 -- Alle Sims ausser die Stadtangestellten verlassen die TownHall
 
 -- entfernen aller Bewerber
	CityEndOfficeElection("Settlement","",nil)
	DestroyCutscene("")
end

function VoteForOffice(Office)
  local Winner; -- speichert den alias des gewinners. z.B. Applicant1
  local ApplicantCnt = officetree_OfficeGetApplicants(Office,"Applicant")
  
  -- if no applicant is there, no vote will be made.
  if (ApplicantCnt == 0) or (ApplicantCnt == nil) then
    MsgSay("Chairman","Keiner Da, es wird nicht gewählt");
  	return
  end
  
  -- Aufzählung der Bewerber	 
  MsgSay("Chairman","Bewerber:")
  for i=0,ApplicantCnt - 1 do
    MsgSay("Chairman","%1SN",GetID("Applicant"..i))
  end
  
  if(ApplicantCnt == 1) then
  	 Winner = "Applicant"..0
     MsgSay("Chairman","Da nur ein Bewerber da ist, gewinnt dieser")
  else
  
    -- Aufzählung der Voters
    VoterCnt = officetree_GetVoters("Office","Voter")
    if (VoterCnt == 0) or (VoterCnt == nil) then
    	MsgSay("Chairman","Keine Wähler da, es entscheidet das Los")
    	local WinnerIdx = PhysicsRand(ApplicantCnt)
    	Winner = "Applicant"..WinnerIdx
		MsgSay("Chairman","Der Gewinner ist: %SN",GetID(Winner))
		officesession_SaveVoteResult(Office,Winner)
		return
	end
       	
  	MsgSay("Chairman","Wahlberechtigte:")
  	 for i=0,VoterCnt - 1 do
  	 MsgSay("Chairman","%SN",GetID("Voter"..i))
  	end
  	   
		-- Bedenkzeit
		officesession_XDoThinkTime()
		
	  -- Stimmenabgabe
	  local vector = votes[ApplicantCnt]
		for i=0,VoterCnt-1 do
		 votes[officesession_DoVote("Voter"..i,Office,"Applicant",ApplicantCnt)] = 1
	 
		-- Auszählung der Stimmen
		local vector = winners[ApplicantCnt]
		local WinnerCnt = 0
		MaxVote = -1
		 for i=0,ApplicantCnt - 1 do
		  if(votes[i] > MaxVote) then
		    MaxVote = votes[i]
		    WinnerCnt = 0
				winners[WinnerCnt] = "Applicant" + i
			else if(votes[i] == MaxVote) then
			  winners[WinnerCnt] = "Applicant" + i
			end			
		end
		end		
		-- eindeutiger Gewinner
		if(WinnerCnt == 1) then
			Winner = winners[0]
		-- Wenn kein eindeutiger Gewinner dann 
		else
			-- Losentscheid über diejenigen mit den meisten Stimmen
			Winner = winners[random(WinnerCnt)]
		end 
	end
	end
	-- Bekanntgabe des Gewinners
	MsgSay("Chairman","Der Gewinner ist: %SN",GetID(Winner))
	officesession_SaveVoteResult(Office,Winner)
	return
end

-- returns the idx of the voted applicant
function DoVote(VoterAlias,OfficeAlias,ApplicantAlias, ApplicantCnt)
	-- Wenn spieler, dann Dialog
		 return descion
	-- Wenn Ai, dann descision berechnen
	 --  return decision
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
	local ListSize = ListSize("ChairmanList")
	for i=0,ListSize - 1 do
		ListGetElement("ChairmanList",i,ChairmanAlias)
		if(officesession_IsSimValid(ChairmanAlias)) then
			-- remove the list
			RemoveAlias("ChairmanList")
			return true
		end
	end
		
	-- no valid chairman found, use the townclerk.
	return officetree_XGetTownClerk(ChairmanAlias)
end

-- returns the count of valid applicants for the whole office session
function GetValidApplicantCount()
	local APPLICANTS = 2
 	CityGetOfficeSessionMembers("settlement","ApplicantList",APPLICANTS)
 	officesession_PrepareValidSimList("ApplicantList")
 	local ListSize = ListSize("ApplicantList")		
 	-- remove the list
 	RemoveAlias("ApplicantList")
 	return ListSize

end

-- prepares the alias of all valid sims in the given list
function BuildValidSimList(ListAlias,Alias)
	
	ListSize = PrepareValidSimList(ListAlias)
	for i=0,ListSize -1 do
		ListGetElement(ListAlias,i,"Applicant"..i)
	end
		
	-- remove the list
	RemoveAlias("ApplicantList")
	
	return ListSize
end

-- removes all invalid sims from the given list
function PrepareValidSimList(ListAlias)
	-- remove all invalid objects
	local ListSize = ListSize(ListAlias)
	for i=0,ListSize - 1 do
		ListGetElement(ListAlias, i,"ListSim")
		if not officesession_IsSimValid("ListSim") then
			ListRemove(ListAlias,"ListSim")
		end
	end
	-- Remove the list sim alias	
	RemoveAlias("ListSim")
	return ListSize(ListAlias)
end

-- checks if a sim is valid for the office
function IsSimValid(SimAlias)
	return true/false
end

-- saves the result of the given vote
function SaveVoteResult(OfficeAlias,WinnerAlias)
 -- sollte der Gewinner ebenfalls in der Amtswahl um sein altes Amt vertreten sein, wird er aus der Wahlliste für dieses Amt gelöscht
 if (SimGetOffice(WinnerAlias,"CurrentOffice") == 1) then
 	OfficeRemoveApplicant("CurrentOffice",WinnerAlias)
 end
 -- Speichern des Voteergebnisses 
 local VoteCacheIdx = GetData("VoteCacheIdx")
 SetData("VoteCacheOfficeID"..VoteCacheIdx,OfficeGetID(OfficeAlias))
 SetData("VoteCacheOfficeLevel"..VoteCacheIdx,OfficeGetLevel(OfficeAlias))
 SetData("VoteCacheWinnerID"..VoteCacheIdx,SimGetID(WinnerAlias))
 VoteCacheIdx = 1
 SetData("VoteCacheIdx",VoteCacheIdx)
  
end

-- executes all saved vote results
function WriteVotes()
 local VoteCacheIdx = GetData("VoteCacheIdx")
 for i=0,VoteCacheIdx - 1 do
  CityGetOffice("Settlement",GetData("VoteCacheOfficeID"..i),GetData("VoteCacheOfficeLevel"..i),"Office")
  GetAliasByID(GetData("VoteCacheWinnerID"..i),"Holder")
  -- setzen des neuen office holders, richtigstellen aller relevanten beziehungen, privilegien etc.
  CityEndOfficeElection("Settlement","Office","Holder")
 end  
end
