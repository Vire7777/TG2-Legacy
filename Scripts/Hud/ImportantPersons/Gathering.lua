

function ImportantPersonsAddDynMemberToSection(DynastyReference, Section)

	local iQuantity = DynastyGetMemberCount(DynastyReference)
	for iCount=0, iQuantity-1 do
		if DynastyGetMember(DynastyReference, iCount, "dynAlias") then
			SetImportantPersonToSection(GetID("dynAlias"), Section, GetDynastyID(""))
		end
	end
end


function ImportantPersonsDiplomacyFilter(DiplState, Section)

	GetDynasty("", "dynasty")
	local iCount = ScenarioGetObjects("Dynasty", 99, "Dynasties")

	if iCount==0 then
		return
	end

	for dyn=0, iCount-1 do
		Alias = "Dynasties"..dyn
		if not (GetID(Alias)==GetID("dynasty")) then
			if DynastyGetDiplomacyState("dynasty", Alias)==DiplState then
				gathering_ImportantPersonsAddDynMemberToSection(Alias, Section)
			end
		end
	end
end


function ImportantPersonsSetupSections()
	-- family
	CreateImportantPersonSection("Family", "@L_IMPORTANTPERSONS_TOPICS_+0")
	CreateImportantPersonSection("CourtLover", "@L_IMPORTANTPERSONS_TOPICS_+1")
	CreateImportantPersonSection("Liaison", "@L_IMPORTANTPERSONS_TOPICS_+2")

	-- Pope Hopefuls
	-- CreateImportantPersonSection("PopeHopefuls", "@L_IMPORTANTPERSONS_Pope_+0")
	
	-- unemployed
   CreateImportantPersonSection("UnemployedByAge", "@L_IMPORTANTPERSONS_Age_+0")
   CreateImportantPersonSection("UnemployedByLevel", "@L_IMPORTANTPERSONS_Level_+0")

	-- cutscenes
	CreateImportantPersonSection("DuellGegner", "@L_IMPORTANTPERSONS_TOPICS_+5")
	CreateImportantPersonSection("ProcessMember", "@L_IMPORTANTPERSONS_TOPICS_+6")
	CreateImportantPersonSection("OfficeSession", "@L_IMPORTANTPERSONS_TOPICS_+7")

	-- gunst
	CreateImportantPersonSection("TopCandidates", "@L_IMPORTANTPERSONS_TOPICS_+11")
	CreateImportantPersonSection("Alliance", "@L_IMPORTANTPERSONS_TOPICS_+3")
	CreateImportantPersonSection("Nap", "@L_IMPORTANTPERSONS_TOPICS_+9")
	CreateImportantPersonSection("Neutral", "@L_IMPORTANTPERSONS_TOPICS_+10")
	CreateImportantPersonSection("Enemies", "@L_IMPORTANTPERSONS_TOPICS_+4")


end

-- function ImportantPersonsGather_PopeHopefuls()
	
	-- local iPope = Find("", "__F((Object.GetObjectsOfWorld(Sim))AND(Object.MinAge(16))AND(Object.HasProperty(CardinalFavor)))","PopeCdt", -1)
	-- local idx
	-- local PopeAlias
	-- if iPope~=0 then
		-- for idx=0,iPope-1 do
			-- PopeAlias = "PopeCdt"..idx
			-- ListNew("PopeCan")
			-- ListAdd("PopeCan",PopeAlias)
			-- for i=0,ListSize("PopeCan") do
				-- ListGetElement("PopeCan",i,"Canidate")
				-- SetImportantPersonToSection(GetID("Canidate"), "PopeHopefuls", GetDynastyID(""))
			-- end
		-- end
	-- end
-- end	

function ImportantPersonsGather_Family()

	GetDynasty("", "dynasty")
	local iCount = DynastyGetFamilyMemberCount("dynasty")
	local iIndex
	local iCIndex

	local iChildCount

	local SimArray

	for iIndex = 0, iCount-1 do
		if DynastyGetFamilyMember("dynasty", iIndex, "member") then
			if IsPartyMember("member") then
				SetImportantPersonToSection(GetID("member"), "Family", GetDynastyID(""))
				iChildCount = SimGetChildCount("member")
				for iCIndex = 0, iChildCount-1 do
					if SimGetChild("member", iCIndex, "child") then
						SetImportantPersonToSection(GetID("child"), "Family", GetDynastyID(""))
					end
				end
			end
		end
	end
end


function ImportantPersonsGather_CourtLover()

	if SimGetCourtLover("", "courtlover") then
		SetImportantPersonToSection(GetID("courtlover"), "CourtLover"..GetID(""), GetDynastyID(""))
	end
end



function ImportantPersonsGather_TopTenCLs()

--	local iPartners = Find("", "__F((Object.GetObjectsOfWorld(Sim))AND(Object.CanBeCourted()))","Partner", -1)

--	if iPartners==0 then
--		return
--	end

--	local iIndex
--	local iSubIndex
--	local PartAlias
--	local ValueAlias

--	local ValueArray
--	local PartArray

--	for iIndex = 0, iPartners-1 do
--		PartAlias = "Partner"..iIndex
--		ValueArray[iIndex] = GetMoney(PartAlias) + SimGetMaxOfficeLevel(PartAlias)*1000

--		for iSubIndex = 0, iIndex do
--
--			if ValueArray[iIndex] <
--
--		end


--	end
end





function ImportantPersonsGather_Liaison()

	if SimGetLiaison("", "courtlover") then
		SetImportantPersonToSection(GetID("courtlover"), "Liaison"..GetDynastyID(""), GetDynastyID(""))
	end
end


function ImportantPersonsGather_OfficeSession()

	--ClearImportantPersonSection("OfficeSession")

	GetDynasty("", "dynasty")
	local Members = DynastyGetMemberCount("dynasty")
	local PeopleTbl = {}
	local Size = 0
	for i=0,Members-1 do
		if(DynastyGetMember("dynasty",i,"member")) then
			if(GetOfficeByApplicant("member","office"))then
				-- add the voters
				local VoterCnt = OfficePrepareSessionMembers("office","voterlist",1)
				for i=0,VoterCnt - 1 do
					ListGetElement("voterlist",i,"voter")
					local ID = GetID("voter")
					if not (gathering_OfficeMemberExists(PeopleTbl,Size,ID))then
						PeopleTbl[Size] = ID
						Size = Size + 1
						SetImportantPersonToSection(ID, "OfficeSession", GetDynastyID(""))
					end
				end

				-- add the applicants
				local MemberID = GetID("member")
				local ApplicantCnt = OfficePrepareSessionMembers("office","applicantlist",2)
				for i=0,ApplicantCnt - 1 do
					ListGetElement("applicantlist",i,"applicant")
					local ID = GetID("applicant")
					if not (ID == MemberID) then
						if not(gathering_OfficeMemberExists(PeopleTbl,Size,ID)) then
							PeopleTbl[Size] = ID
							Size = Size + 1
							SetImportantPersonToSection(ID, "OfficeSession", GetDynastyID(""))
						end
					end
				end

			end
		end
	end
end

function OfficeMemberExists(MemberList,MemberListSize,MemberID)
	for i=0,MemberListSize - 1 do
		if(MemberList[i] == MemberID) then
			return true
		end
	end

	return false
end



function ImportantPersonsGather_ProcessMember()

	--ClearImportantPersonSection("ProcessMember")

	local PSimID0 = -1
	local PSimID1 = -1
	local PSimID2 = -1

	GetDynasty("", "dynasty")
	local Members = DynastyGetMemberCount("dynasty")
	if (Members>=1) and DynastyGetMember("dynasty",0,"member")~=-1 then
		PSimID0 = GetID("member")
	end
	if (Members>=2) and DynastyGetMember("dynasty",1,"member")~=-1 then
		PSimID1 = GetID("member")
	end
	if (Members>=3) and DynastyGetMember("dynasty",2,"member")~=-1 then
		PSimID2 = GetID("member")
	end

	ListAllCutscenes("cutscene_list")
	local i
	local NumCutscenes = ListSize("cutscene_list")
	for i=0,NumCutscenes-1 do
		ListGetElement("cutscene_list",i,"cutscene")
		if GetID("cutscene")~=-1 then
			local idx = 0
			local PeopleTbl = {}

			if CopyAliasFromCutscene("accuser","cutscene","sim") then
				idx = idx + 1
				PeopleTbl[idx] = GetID("sim")
			end
			if CopyAliasFromCutscene("accused","cutscene","sim") then
				idx = idx + 1
				PeopleTbl[idx] = GetID("sim")
			end
			if CopyAliasFromCutscene("judge","cutscene","sim") then
				idx = idx + 1
				PeopleTbl[idx] = GetID("sim")
			end
			if CopyAliasFromCutscene("assessor1","cutscene","sim") then
				idx = idx + 1
				PeopleTbl[idx] = GetID("sim")
			end
			if CopyAliasFromCutscene("assessor2","cutscene","sim") then
				idx = idx + 1
				PeopleTbl[idx] = GetID("sim")
			end

			local IsRelevant = false
			for i = 1,idx do
				if PeopleTbl[i]~=-1 and (PeopleTbl[i]==PSimID0 or PeopleTbl[i]==PSimID1 or PeopleTbl[i]==PSimID2) then
					PeopleTbl[i] = -1
					IsRelevant = true
				end
			end
			if (IsRelevant) then
				for i=1,idx do
					local PersonID = PeopleTbl[i]
					if PersonID~=-1 then
						SetImportantPersonToSection(PersonID, "ProcessMember", GetDynastyID(""))
					end
				end
			end
		end
	end
end

function ImportantPersonsGather_DuellGegner()
	--ClearImportantPersonSection("DuellGegner")

	local PSimID0 = -1
	local PSimID1 = -1
	local PSimID2 = -1

	GetDynasty("", "dynasty")
	local Members = DynastyGetMemberCount("dynasty")
	if (Members>=1) and DynastyGetMember("dynasty",0,"member")~=-1 then
		PSimID0 = GetID("member")
	end
	if (Members>=2) and DynastyGetMember("dynasty",1,"member")~=-1 then
		PSimID1 = GetID("member")
	end
	if (Members>=3) and DynastyGetMember("dynasty",2,"member")~=-1 then
		PSimID2 = GetID("member")
	end

	ListAllCutscenes("cutscene_list")
	local i
	local NumCutscenes = ListSize("cutscene_list")
	for i=0,NumCutscenes-1 do
		ListGetElement("cutscene_list",i,"cutscene")
		if GetID("cutscene")~=-1 then
			local idx = 0
			local PeopleTbl = {}

			if CopyAliasFromCutscene("challenger","cutscene","sim") then
				idx = idx + 1
				PeopleTbl[idx] = GetID("sim")
			end
			if CopyAliasFromCutscene("challenged","cutscene","sim") then
				idx = idx + 1
				PeopleTbl[idx] = GetID("sim")
			end

			local IsRelevant = false
			for i = 1,idx do
				if PeopleTbl[i]~=-1 and (PeopleTbl[i]==PSimID0 or PeopleTbl[i]==PSimID1 or PeopleTbl[i]==PSimID2) then
					PeopleTbl[i] = -1
					IsRelevant = true
				end
			end
			if (IsRelevant) then
				for i=1,idx do
					local PersonID = PeopleTbl[i]
					if PersonID~=-1 then
						SetImportantPersonToSection(PersonID, "DuellGegner", GetDynastyID(""))
					end
				end
			end
		end
	end
end




function GetDataFromCutscene(CutsceneAlias, Data)
	if CutsceneGetData(CutsceneAlias,Data) then
		local returnData = GetData(Data)
		return returnData
	end
	return nil
end



function ImportantPersonsGather_Alliance()

	gathering_ImportantPersonsDiplomacyFilter(DIP_ALLIANCE, "Alliance")
end


function ImportantPersonsGather_Nap()

	gathering_ImportantPersonsDiplomacyFilter(DIP_NAP, "Nap")
end

function ImportantPersonsGather_Neutral()

	gathering_ImportantPersonsDiplomacyFilter(DIP_NEUTRAL, "Neutral")
end

function ImportantPersonsGather_Enemies()

	gathering_ImportantPersonsDiplomacyFilter(DIP_FOE, "Enemies")
end
-- mod by Nommy
function IsUnemployedSim(Alias)

	return not IsDynastySim(Alias)                              -- Is not a member of a dynasty
		and (SimGetProfession(Alias) == 0)                      -- Is unemployed
		and (SimGetAge(Alias) >= 16)                            -- Is old enough to work
		and (GetSettlementID(Alias) == GetSettlementID(""))     -- Lives in same settlement
end


-- Called by game to populate the "UnemployedByAge" section.
function ImportantPersonsGather_UnemployedByAge()
	local Debug = false
	if Debug then MsgQuick("", "ImportantPersonsGather_UnemployedByAge()") end

	-- Define the criteria sims must meet to be included.
	local SimListFilterFunction = gathering_IsUnemployedSim

	-- Define the sims list sort order.
	local SimListSortCompareFunction =
		function(a,b)
			return SimGetAge(a) <= SimGetAge(b)
		end

	-- Find, sort and add the sims.
	gathering_PopulateImportantPersonSection("UnemployedByAge", SimListFilterFunction, SimListSortCompareFunction, Debug)
end


-- Called by game to populate the "UnemployedByLevel" section.
function ImportantPersonsGather_UnemployedByLevel()
	local Debug = false
	if Debug then MsgQuick("", "ImportantPersonsGather_UnemployedByLevel()") end

	-- Define the criteria sims must meet to be included.
	local SimListFilterFunction = gathering_IsUnemployedSim

	-- Define the sims list sort order.
	local SimListSortCompareFunction =
		function(a,b)
			return SimGetLevel(a) > SimGetLevel(b)
		end

	-- Find, sort and add the sims.
	gathering_PopulateImportantPersonSection("UnemployedByLevel", SimListFilterFunction, SimListSortCompareFunction, Debug)
end


-- gathering_PopulateImportantPersonSection()
-- Finds, sorts and adds sims to the specified section using the provided filter and sort critera.
-- Arguments:
--     Label                        Section label. Should be same as first argument passed to CreateImportantPersonSection() in ImportantPersonsSetupSections().
--     SimListFilterFunction        Function defining the critera sims are required to match to be included in the list.
--                                     The function should take 1 argument (the sim alias string) and return true when the sim is to be included or false otherwise.
--                                     e.g:    function(Alias) return SimGetProfession(Alias) == 10 end
--     SimListSortCompareFunction   (optional) comparison function used to sort the elements. See compare argument of QuickSort() function below for more details.
--     Debug                        (optional) Whether to display debug messages in the game (sim counts etc). Default = false (no).
--
function PopulateImportantPersonSection(Label, SimListFilterFunction, SimListSortCompareFunction, Debug)
	-- Assign missing arguments default values
	SimListSortCompareFunction = SimListSortCompareFunction or function(a,b) return SimGetAge(a)<=SimGetAge(b) end
	Debug = Debug or false
	-- Assign control values
	local MaxSearchResults = -1  -- Number of sims returned by search is unlimited.

	-- Get a list of all sims in the world. (I couldn't get Find() to work, so resorted to this.)
	local GlobalSimCount = ScenarioGetObjects("cl_Sim", MaxSearchResults, "Sims")
	if Debug then MsgQuick("", "PopulateImportantPersonSection(\""..Label.."\", ...)   GlobalSimCount="..GlobalSimCount) end
	if GlobalSimCount == 0 then
		return
	end

	-- Filter the list to only include sims which match the supplied filter function.
	local FilteredSims = {}
	local FilteredSimCount = 0
	local Alias
	for i = 0, GlobalSimCount-1 do
		Alias = "Sims"..i
		if SimListFilterFunction(Alias) then
			FilteredSimCount = FilteredSimCount + 1
			FilteredSims[FilteredSimCount] = Alias
		end
	end
	if Debug then MsgQuick("", "FilteredSimCount="..FilteredSimCount) end

	-- Sort the list of sims (by age by default).
	-- Note: table.sort() and other table functions don't seem to work so the quicksort function defined below is used instead.
	gathering_QuickSort(FilteredSims, 1, FilteredSimCount, SimListSortCompareFunction)

	-- Add the sorted list of sims to the specified section.
	local Classes = ""
	for i = 1, FilteredSimCount do
		Alias = FilteredSims[i]
		SetImportantPersonToSection(GetID(Alias), Label, GetDynastyID(""))
		Classes = Classes.." "..SimGetClass(Alias)
	end
	if Debug then MsgQuick("", "Classes="..Classes) end
end



-- gathering_QuickSort()
-- Sorts a table opionally using specified comparison function.
-- http://rosettacode.org/wiki/Sorting_algorithms/Quicksort#Lua
-- Arguments:
--    t        table to be sorted
--    start    first element index
--    endi     last element index
--    compare  (optional) comparison function used to sort the elements. The function should take 2 arguments and
--             should return true when the first is less than or equal to the second and false otherwise. The default is:
--             function(a,b) return a<=b end
--
function QuickSort(t, start, endi, compare)
  start = start or 1
  compare = compare or function(a,b) return a<=b end
  -- partition w.r.t. first element
  if(endi - start < 2) then return t end
  local pivot = start
  for i = start + 1, endi do
    -- equivalent of:   if t[i] <= t[pivot] then
    if compare(t[i], t[pivot]) then
      local temp = t[pivot + 1]
      t[pivot + 1] = t[pivot]
      if(i == pivot + 1) then
        t[pivot] = temp
      else
        t[pivot] = t[i]
        t[i] = temp
      end
      pivot = pivot + 1
    end
  end
  t = gathering_QuickSort(t, start, pivot - 1, compare)
  return gathering_QuickSort(t, pivot + 1, endi, compare)
end

function CleanUp()
end
