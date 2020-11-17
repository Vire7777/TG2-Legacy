-- this function is called at the beginning of the game and returns the level the settlement

Include("Campaign/DefaultCampaign.lua")

function GetValue(Level)
	if Level==2 then
		return {0, 80}
	elseif Level==3 then
		return {90, 130}
	elseif Level==4 then
		return {140, 200}
	elseif Level==5 then
		return {200, 300}
	elseif Level==6 then
		return {260, 99999}
	end
end

function GetMinLevel()
	local Level = 2
	if CityGetRandomBuilding("",GL_BUILDING_CLASS_PUBLICBUILDING,GL_BUILDING_TYPE_TOWNHALL,-1,-1,FILTER_IGNORE,"Townhall") then
		if HasProperty("Townhall", "Level") then
			Level = GetProperty("Townhall", "Level")
		end
	end
	return Level 
end

function CalcStartupLevel()

	if CityIsKontor("") then
		return 1
	end
	
	local Count = CityGetCitizenCount("")
--	Count = Count + 50 -- initbuffer

	local Level = citylevel_GetMinLevel()
	while Level < GL_MAX_CITY_LEVEL and citylevel_GetValue(Level)[2] < Count do
		Level = Level + 1
	end

	if worldambient_CheckAmbient()==true then
		worldambient_CreateCityAnimals("",true)
		worldambient_CreateCityBettler("",Level)
		if not AliasExists("#Eseltreiber") or not AliasExists("#Packo") then
			worldambient_CreateTeamDonkey("")
		end
		
		if WorldAnimals == 0 then
			WorldAnimals = 1
			worldambient_CreateWorldAnimals()
		end
	end

	-- init buyable buildings
	local buyablehouses = CityGetBuildingCount("",1,2,-1,-1,FILTER_IS_BUYABLE)
	CityGetBuildings("",1,2,-1,-1,FILTER_IS_BUYABLE,"FreeHouse")
	for i=0, buyablehouses-1 do
		if BuildingGetBuyPrice("FreeHouse"..i) then
			SetState("FreeHouse"..i, STATE_SELLFLAG, true)
		end
	end
	
	local buyableworkshops = CityGetBuildingCount("",2,-1,-1,-1,FILTER_IS_BUYABLE)
	CityGetBuildings("",2,-1,-1,-1,FILTER_IS_BUYABLE,"FreeWorkshop")
	for k=0, buyableworkshops-1 do
		if BuildingGetBuyPrice("FreeWorkshop"..k) then
			SetState("FreeWorkshop"..k, STATE_SELLFLAG, true)
		end
	end

	return Level
end

-- this function is called every ingame hour and checks, if the city is able to grow or shrink
function CalcNewLevel()

	if CityIsKontor("") then
		return 1
	end

	local Level = CityGetLevel("")
	local Count	= CityGetCitizenCount("")
	local Bounds = citylevel_GetValue(Level)
	local CurrentYear = GetYear()
	if not HasData("#LastUpdateYear") then
		SetData("#LastUpdateYear", CurrentYear) -- no updates in first round
	end
	
	CityGetRandomBuilding("",GL_BUILDING_CLASS_PUBLICBUILDING,GL_BUILDING_TYPE_TOWNHALL,-1,-1,FILTER_IGNORE,"Townhall")
	
	local LastUpdateYear = GetData("#LastUpdateYear")
	if not HasProperty("Townhall","CityLevelUpAhead") and CurrentYear <= LastUpdateYear then
		SetProperty("","LevelUpCity",0)
		return Level
	end
		
--		if a cutscene is running in the townhall do not upgrade the city
--		!!! otherwise the townhall could be blocked with a never ending cutscene !!!
	
	if (BuildingGetCutscene("Townhall", "cutscene") == false) then
		if Bounds[2] < Count then
			if HasProperty("","LevelUpPaid") and GetProperty("","LevelUpPaid")==1 and HasProperty("","LevelUpCity") and GetProperty("","LevelUpCity")==1 then
			--	if Level==5 then
			--		local	ImperialId = ScenarioGetImperialCapitalId()
			--		if ImperialId~=GetID("") then
			--			return Level
			--		end
			--	end
				SetProperty("","LevelUpCity",0)
				SetData("#LastUpdateYear", CurrentYear)
				return (Level + 1)
			else
				SetProperty("","LevelUpCity",1)
				return Level
			end
		end
	end
	
	SetProperty("","LevelUpCity",0)
	return Level
end

function SetNewLevel(OldLevel, NewLevel)
	
	-- output a message
	if NewLevel>0 and NewLevel<=GL_MAX_CITY_LEVEL and ScenarioGetTimePlayed()>0.1 then
		-- only output messages, when the game is running, not at gamestart
		local Attribute = "@L_GENERAL_INFORMATION_CITY_LEVEL_MSG_PLUS_ATTRIBUTE_+"..(OldLevel-1)
		GetScenario("scenario")
		local mapid = GetProperty("scenario", "mapid")
		local lordlabel = "@L_SCENARIO_LORD_"..GetDatabaseValue("maps", mapid, "lordship").."_+1"
		MsgNewsNoWait("All", "", nil, "default", -1, 
			"@L_GENERAL_INFORMATION_CITY_LEVEL_MSG_PLUS_HEAD_+0",
			"@L_GENERAL_INFORMATION_CITY_LEVEL_MSG_PLUS_BODY_+0", CityLevel2Label(OldLevel), GetID(""), Attribute, CityLevel2Label(NewLevel), lordlabel )

		if HasProperty("","LevelUpPaid") and GetProperty("","LevelUpPaid")==1 then
			SetProperty("","LevelUpPaid",0)
		end
	end

	if worldambient_CheckAmbient()==true then
		worldambient_CreateCityAnimals("",false)
		worldambient_CreateCityBettler("",1)
	end

	if NewLevel==6 then
		citylevel_CheckForEmperor()
		Sleep(15)
		citylevel_CheckForPope()
		Sleep(15)
		citylevel_CheckForKing()
	end
end

function CheckForEmperor()
	
	CreateScriptcall("EmperorCheck",24,"City/CityLevel.lua","CheckForEmperor","",nil)
	if not CityGetOffice("", 7, 0, "OFFICE") then
		return
	end
	
	if OfficeGetHolder("OFFICE", "OfficeHolder") then
		return
	end
	
	find_Pope("Pope")
	local PopeID = -1
	if AliasExists("Pope") then
		PopeID = GetID("Pope")
	end
	local candidates = {nil}
	local SimCount = ScenarioGetObjects("cl_Sim", 9999, "SimList")
	for sim=0,SimCount-1 do
		local SimAlias = "SimList"..sim
		if AliasExists(SimAlias) then
			if SimGetAge(SimAlias) >= GL_AGE_FOR_GROWNUP then
				if IsDynastySim(SimAlias) then
					find_HomeCity(SimAlias,"HomeCity")
					if AliasExists("HomeCity") then
						if GetNobilityTitle(SimAlias) > 7  then
							if CityGetLevel("HomeCity") == 6 then
								local Check = GetID(SimAlias)
								if Check ~= PopeID then
									x = 1
									while x < 2 do
										if candidates[x]~=nil and GetAliasByID(candidates[x],"candidate") then
											if find_TrueWealthSim(SimAlias) > find_TrueWealthSim("candidate") then
												
												y = 2
												while y>x do
													candidates[y] = candidates[y-1]
													y = y - 1
												end
		
												candidates[x] = GetID(SimAlias)
												break
											end
										else
											candidates[x] = GetID(SimAlias)
											break
										end
										x = x + 1
									end
								end
							end
						end
					end
				end
			end
		end
	end
	
	for z=1,1 do
		if GetAliasByID(candidates[z],"TheChosen") then
			if SimIsAppliedForOffice("TheChosen") then
				CityRemoveApplicant("","TheChosen")
			end
			SimSetOffice("TheChosen", "OFFICE")
			chr_SimAddImperialFame("TheChosen",5)
			chr_SimAddFame("TheChosen",50)
			return
		end
	end
	
	for sim=0,SimCount-1 do
		local SimAlias = "SimList"..sim
		if AliasExists(SimAlias) then
			if SimGetAge(SimAlias) >= GL_AGE_FOR_GROWNUP then
				if DynastyIsShadow(SimAlias) then
					if IsDynastySim(SimAlias) then
						find_HomeCity(SimAlias,"HomeCity")
						if AliasExists("HomeCity") then
							if CityGetLevel("HomeCity") == 6 then
								local Check = GetID(SimAlias)
								if Check ~= PopeID then
									x = 1
									while x < 2 do
										if candidates[x]~=nil and GetAliasByID(candidates[x],"candidate") then
											if find_TrueWealthSim(SimAlias) > find_TrueWealthSim("candidate") then
												
												y = 2
												while y>x do
													candidates[y] = candidates[y-1]
													y = y - 1
												end
		
												candidates[x] = GetID(SimAlias)
												break
											end
										else
											candidates[x] = GetID(SimAlias)
											break
										end
										x = x + 1
									end
								end
							end
						end
					end
				end
			end
		end
	end
	
	for z=1,1 do
		if GetAliasByID(candidates[z],"TheChosen") then
			if SimIsAppliedForOffice("TheChosen") then
				CityRemoveApplicant("","TheChosen")
			end
			SimSetOffice("TheChosen", "OFFICE")
			chr_SimAddImperialFame("TheChosen",5)
			chr_SimAddFame("TheChosen",50)
			SetNobilityTitle("TheChosen",11)
			return
		end
	end
end
	
function CheckForPope()
	
	CreateScriptcall("PopeCheck",24,"City/CityLevel.lua","CheckForPope","",nil)
	if not CityGetOffice("", 6, 0, "OFFICE") then
		return
	end
	
	if OfficeGetHolder("OFFICE", "OfficeHolder") then
		return
	end
	
	find_Emperor("Emperor")
	find_King("King")
	local PopeID = -1
	local KingID = -1
	local EmpID = -1 
	if AliasExists("Emperor") then
		EmpID = GetID("Emperor") 
	end
	if AliasExists("King") then
		EmpID = GetID("King") 
	end
	local sim
	local candidates = {nil}
	local SimCount = ScenarioGetObjects("cl_Sim", 9999, "SimList")
	for sim=0,SimCount-1 do
		local SimAlias = "SimList"..sim
		if AliasExists(SimAlias) then
			find_HomeCity(SimAlias,"HomeCity")
			if AliasExists("HomeCity") then
				if CityGetLevel("HomeCity") == 6 then
					if IsDynastySim(SimAlias) then
						if SimGetAge(SimAlias) >= GL_AGE_FOR_GROWNUP then
							local Check = GetID(SimAlias)
							if Check ~= EmpID and  Check ~= KingID then
								x = 1
								while x < 2 do
									if candidates[x]~=nil and GetAliasByID(candidates[x],"candidate") then
										if find_CardinalPoints(SimAlias) > find_CardinalPoints("candidate") then
											
											y = 2
											while y>x do
												candidates[y] = candidates[y-1]
												y = y - 1
											end
					
											candidates[x] = GetID(SimAlias)
											break
										end
									else
										candidates[x] = GetID(SimAlias)
										break
									end
									x = x + 1
								end
							end
						end
					end
				end
			end
		end
	end

	for z=1,1 do
		if GetAliasByID(candidates[z],"TheChosen") then
			if SimIsAppliedForOffice("TheChosen") then
				CityRemoveApplicant("","TheChosen")
			end
			SimSetOffice("TheChosen", "OFFICE")
			SimSetFaith("TheChosen",100)
			chr_SimAddImperialFame("TheChosen",3)
			chr_SimAddFame("TheChosen",50)
			return
		end
	end
end

function CheckForKing()

	CreateScriptcall("KingCheck",24,"City/CityLevel.lua","CheckForKing","",nil)
	if not CityGetOffice("", 6, 1, "OFFICE") then
		return
	end
	
	if OfficeGetHolder("OFFICE", "OfficeHolder") then
		return
	end
	
	find_Pope("Pope")
	find_Emperor("Emperor")
	local PopeID = -1
	local EmpID = -1
	if AliasExists("Pope") then
		PopeID = GetID("Pope")
	end
	if AliasExists("Emperor") then
		EmpID = GetID("Emperor")
	end
	local candidates = {nil}
	local SimCount = ScenarioGetObjects("cl_Sim", 9999, "SimList")
	for sim=0,SimCount-1 do
		local SimAlias = "SimList"..sim
		if AliasExists(SimAlias) then
			if SimGetAge(SimAlias) >= GL_AGE_FOR_GROWNUP then
				if IsDynastySim(SimAlias) then
					find_HomeCity(SimAlias,"HomeCity")
					if AliasExists("HomeCity") then
						if GetNobilityTitle(SimAlias) > 7  then
							if CityGetLevel("HomeCity") == 6 then
								local Check = GetID(SimAlias)
								if Check ~= PopeID and Check ~= EmpID  then
									x = 1
									while x < 2 do
										if candidates[x]~=nil and GetAliasByID(candidates[x],"candidate") then
											if find_TrueWealthSim(SimAlias) > find_TrueWealthSim("candidate") then
												
												y = 2
												while y>x do
													candidates[y] = candidates[y-1]
													y = y - 1
												end
		
												candidates[x] = GetID(SimAlias)
												break
											end
										else
											candidates[x] = GetID(SimAlias)
											break
										end
										x = x + 1
									end
								end
							end
						end
					end
				end
			end
		end
	end
	
	for z=1,1 do
		if GetAliasByID(candidates[z],"TheChosen") then
			if SimIsAppliedForOffice("TheChosen") then
				CityRemoveApplicant("","TheChosen")
			end
			SimSetOffice("TheChosen", "OFFICE")
			chr_SimAddImperialFame("TheChosen",5)
			chr_SimAddFame("TheChosen",50)
			return
		end
	end
	
	for sim=0,SimCount-1 do
		local SimAlias = "SimList"..sim
		if AliasExists(SimAlias) then
			if SimGetAge(SimAlias) >= GL_AGE_FOR_GROWNUP then
				if DynastyIsShadow(SimAlias) then
					if IsDynastySim(SimAlias) then
						find_HomeCity(SimAlias,"HomeCity")
						if AliasExists("HomeCity") then
							if CityGetLevel("HomeCity") == 6 then
								local Check = GetID(SimAlias)
								if Check ~= PopeID and Check ~= EmpID  then
									x = 1
									while x < 2 do
										if candidates[x]~=nil and GetAliasByID(candidates[x],"candidate") then
											if find_TrueWealthSim(SimAlias) > find_TrueWealthSim("candidate") then
												
												y = 2
												while y>x do
													candidates[y] = candidates[y-1]
													y = y - 1
												end
		
												candidates[x] = GetID(SimAlias)
												break
											end
										else
											candidates[x] = GetID(SimAlias)
											break
										end
										x = x + 1
									end
								end
							end
						end
					end
				end
			end
		end
	end
	
	for z=1,1 do
		if GetAliasByID(candidates[z],"TheChosen") then
			if SimIsAppliedForOffice("TheChosen") then
				CityRemoveApplicant("","TheChosen")
			end
			SimSetOffice("TheChosen", "OFFICE")
			chr_SimAddImperialFame("TheChosen",4)
			chr_SimAddFame("TheChosen",25)
			SetNobilityTitle("TheChosen",9)
			return
		end		
	end			
end
	
function CheckForKingVanilla()

	if not CityGetOffice("", 6, 1, "OFFICE") then
		return
	end
	
	if OfficeGetHolder("OFFICE", "OfficeHolder") then
		return
	end
	
	local DynCount 	= ScenarioGetObjects("Dynasty", 999, "DynList")
	
	local	Points
	local	Candidate = nil
	local	BestPoints = 0
	local	DynAlias
	local fame = 0
	find_Emperor("Emperor")
	local Dynasty = GetDynasty("Emperor")
	for dyn=0,DynCount-1 do
		DynAlias = "DynList"..dyn
		if DynAlias ~= Dynasty then
			if DynastyGetBuilding2(DynAlias, 0, "DynHome") then
				if GetSettlementID("DynHome")==GetID("") then
					if DynastyIsShadow(DynAlias) then
						if GetProperty(DynAlias,"ImperialFame") then
							fame = GetProperty(DynAlias,"ImperialFame")
						end
						Points = (GetNobilityTitle(DynAlias) * 10000) + (fame * 1000) + GetMoney(DynAlias)
						if not Candidate or Points>BestPoints then
							Candidate = "DynList"..dyn
							BestPoints  = Points
						end
					end
				end
			end
		end
	end
	if not Candidate then
		if defaultcampaign_CreateShadowDynasty(-1, "", "KingDynasty") then
			Candidate = "KingDynasty"
		end
	end
	
	if not Candidate then
		return
	end

	if not DynastyGetMemberRandom(Candidate, "Boss") then
		return
	end
	
	if GetNobilityTitle("Boss")<8 then
		SetNobilityTitle("Boss", 8)
	end
	
	SimSetOffice("Boss", "OFFICE")
end