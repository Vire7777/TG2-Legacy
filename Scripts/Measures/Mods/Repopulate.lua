function Run()
	SetState("", STATE_LOCKED, true)
	if HasProperty("", "FirstRun") then --Checks for FirstRun Property....InitiateOnce function will only run once EVER. Even if you cancel and repush the AI helper button. That is the purpose of setting this property
		if not HasProperty("", "CancelRun") then --Checks for mentioned property
			local TownHall = Find("", "__F((Object.GetObjectsOfWorld(Building))AND(Object.IsType(23)))","CityCenter", -1) --returns all townhalls in the current game
			local idx
			for idx=0, TownHall-1 do --for all town halls in the game do the following code one at the time for each townhall and remove from the list when done
				local CityH = "CityCenter"..idx --returns generic useable alias for all the townhalls on the maps
				SetProperty(CityH, "CancelRun", 1) --ensures all townhalls have the cancelrun property...this makes the help button disappear and the cancel button appear in its place 
			end
		end
		repopulate_SetEarlyHours()
		Sleep(2)
		repopulate_CreateGirl() --run create girl funtion...All the codes were put into seperate functions because together they were causing annoying conflicts
		Sleep(2)
		repopulate_CreateBoy() -- should be obvious as you read through the file a bit (repopulate is the the name of this file in lowercase letters...it is needed to call these functions. The name of the function by itself will not work)
		Sleep(2)
		repopulate_FinancialBailout()
		Sleep(2)
		repopulate_BuildingCheck()
		Sleep(2)
		repopulate_CharismaBonus()
		Sleep(2)
		if GetImpactValue("","Timer")==0 then
			AddImpact("","Timer",1,24)
			repopulate_AICardinalFavor()
			Sleep(2)
			repopulate_AddArmour()
			Sleep(2)
			repopulate_AIDoctorTitle()
			Sleep(2)
			if GetImpactValue("","Delay")==0 then
				repopulate_AIAggressive()
			end
		end
	else --this else will only be read once when the button is first pushed
		repopulate_SetEarlyHours() 
		Sleep(2)
		repopulate_FamilyCheck()
		Sleep(2)
		repopulate_AssignBuildingOwners()
		Sleep(2)
		repopulate_AIEducation()
		Sleep(2)
	--	repopulate_PoisonWell()
		Sleep(2)
	--	repopulate_MarketItemCountCheck() ***Not sure why this is disabled :P <---If no one complains of market bug then I might as well leave this off!!!
	--	Sleep(1)
		repopulate_AIHospitalCheck()
		Sleep(2)
		repopulate_NewPopeMeasures()
		Sleep(2)
		repopulate_NewKingMeasures()
		Sleep(2)
		repopulate_NewEmperorMeasures()
		Sleep(2)
		repopulate_AIDoctorTitle()
		Sleep(2)
		repopulate_FillEmptyOffices()
		Sleep(6)
		mccoy_AIOfficeCheck() --this function was moved into the Scripts/Library/McCoy.lua file and is only run once in this file as it is now called immediately after an officesession 
		Sleep(2)
		repopulate_BuildingCheck()
		Sleep(2)
		repopulate_InitiateOnce() --This MUST be last so that the cleanup function will not be called when this file is called the first time!!!! I added clean up funtion to all the automated functions but they are only automated after the first call!!!!
	end
	SetState("", STATE_LOCKED, false)
end

function CleanUp()
	
end

function Repeat() --This is the function in the Scriptcall code and is the meat behind the Run() function constantly repeating
	repopulate_Run() --This initiates the Run() function.
end

function SetEarlyHours()
	if HasProperty("","FirstRun") then
		while GetGametime() >= 2 and GetGametime() <= 3 do
			Sleep(30)
		end
	end
	CreateScriptcall("RepeatRepopulate",24,"Measures/Mods/Repopulate.lua","Repeat","",nil)
end

function FamilyCheck()
	CreateScriptcall("FamilyCheck",12,"Measures/Mods/Repopulate.lua","FamilyCheck","",nil)
	local sim
	local SimCount = ScenarioGetObjects("cl_Sim", 99999, "SimList")
	for sim=0,SimCount-1 do
		local SimAlias = "SimList"..sim
		if GetDynasty(SimAlias,"Player") then
			if DynastyIsPlayer("Player") then
				if not HasProperty("Player","BugFix") then
					SetProperty("Player","Bugfix",1)
				end
				for x=0,DynastyGetFamilyMemberCount("Player")-1 do
					if DynastyGetFamilyMember("Player", x, "FamMembers") then
						if not HasProperty("FamMembers","BugFix") then
							SetProperty("FamMembers","BugFix",1)	
						end
					end
				end
				for i=0,DynastyGetMemberCount("Player")-1 do
					if DynastyGetMember("Player", i, "FamMembers") then
						if not HasProperty("FamMembers","BugFix") then
							SetProperty("FamMembers","BugFix",1)	
						end
					end
				end
				for i=0,DynastyGetWorkerCount("Player",-1)-1 do
					if DynastyGetWorker("Player",-1, i, "Worker") then
						if not HasProperty("Worker","BugFix") then
							SetProperty("Worker","BugFix",1)	
						end
					end
				end
			elseif HasProperty(SimAlias,"BugFix") then
				if DynastyGetFamilyMember("Player", 0, "CheckThisShit") then
					if AliasExists("CheckThisShit") then
						if not DynastyIsPlayer("CheckThisShit") then
							RemoveProperty(SimAlias,"BugFix")
						end
					else
						RemoveProperty(SimAlias,"BugFix")
					end
				end
			end
		end
	end
end

--*****Function Has Been Moved To Scripts/Library/McCoy.lua file. That function now runs immediately after an officesession in order to keep offices occupied!
-- function AIOfficeCheck()
-- 	if HasProperty("","FirstRun") then
-- 		while GetGametime() >= 5 and GetGametime() <= 6 do
-- 			Sleep(30)
-- 		end
-- 	end
-- 	CreateScriptcall("OfficeCheck",24,"Measures/Mods/Repopulate.lua","AIOfficeCheck","",nil)
-- 	
-- 	local SimCount = ScenarioGetObjects("cl_Sim", 99999, "Politicians")
-- 	for i=0, SimCount-1 do
-- 		local SimAlias = "Politicians"..i
-- 		if not DynastyIsPlayer(SimAlias) then
-- 			-- search through all offices and check if I am allready an applicant
-- 			if SimGetOfficeID(SimAlias) ~= -1 then
-- 				LogMessage("LastName="..SimGetLastname(SimAlias).." 0 <---Already running for office. Smart AI")
-- 			--	if GetCurrentMeasureID(SimAlias) ~= 0 then
-- 			--		SimStopMeasure(SimAlias)
-- 			--		LogMessage("LastName="..SimGetLastname(SimAlias).." 666 <---Stopped current measure")
-- 			--	end
-- 				if SimIsAppliedForOffice(SimAlias) then
-- 					if SimGetOffice(SimAlias,"CurrentOffice") then
-- 						LogMessage("Office Index="..SimGetOfficeIndex(SimAlias).." OfficeLevel="..SimGetOfficeLevel(SimAlias).." OfficeID="..SimGetOfficeID(SimAlias).." OfficeName="..OfficeGetTextLabel("CurrentOffice"))
-- 						if GetOfficeByApplicant(SimAlias,"AppliedOffice") then
-- 							local X = SimGetOfficeIndex(SimAlias)
-- 							local OfficeIdx = {}
-- 								OfficeIdx[0] = 1
-- 								OfficeIdx[1] = 0
-- 							if OfficeGetLevel("AppliedOffice") == OfficeGetLevel("CurrentOffice") and OfficeGetIdx("AppliedOffice") == X  then --If this returns false it means that the AI has already applied for an office and no help is required
-- 								local OffLevel = SimGetOfficeLevel(SimAlias)
-- 								if OffLevel < 5 then
-- 									if find_HomeCity(SimAlias,"OffCity") then
-- 										if CityGetOffice("OffCity", OffLevel+1, X, "Seat") then
-- 											if not OfficeGetHolder("Seat", "SeatHolder") then
-- 												SimRunForAnOffice(SimAlias,"Seat")
-- 											elseif CityGetOffice("OffCity", OffLevel+1, OfficeIdx[X], "SeatTwo") then
-- 												if not OfficeGetHolder("SeatTwo", "SeatHolderTwo") then
-- 													SimRunForAnOffice(SimAlias,"SeatTwo")
-- 												end
-- 											end
-- 										elseif CityGetOffice("OffCity", OffLevel+1, OfficeIdx[X], "SeatThree") then
-- 											if not OfficeGetHolder("SeatThree", "SeatHolderThree") then
-- 												SimRunForAnOffice(SimAlias,"SeatThree")
-- 											end
-- 										end
-- 									end
-- 								end
-- 							end
-- 						end
-- 					end
-- 				else
-- 					local OffLevel = SimGetOfficeLevel(SimAlias)
-- 					if OffLevel < 5 then
-- 						if SimGetOffice(SimAlias,"CurrentOffice") then
-- 							LogMessage("Office Index="..SimGetOfficeIndex(SimAlias).." OfficeLevel="..SimGetOfficeLevel(SimAlias).." OfficeName="..OfficeGetTextLabel("CurrentOffice"))
-- 							local X = SimGetOfficeIndex(SimAlias)
-- 							local OfficeIdx = {}
-- 								OfficeIdx[0] = 1
-- 								OfficeIdx[1] = 0
-- 							if find_HomeCity(SimAlias,"OffCity") then
-- 								LogMessage("LastName="..SimGetLastname(SimAlias).." 1")
-- 								if CityGetOffice("OffCity", OffLevel+1, X, "Seat") then
-- 									LogMessage("LastName="..SimGetLastname(SimAlias).." 2")
-- 									if not OfficeGetHolder("Seat", "SeatHolder") then
-- 										LogMessage("LastName="..SimGetLastname(SimAlias).." 3")
-- 										SimRunForAnOffice(SimAlias,"Seat")
-- 									elseif CityGetOffice("OffCity", OffLevel+1, OfficeIdx[X], "SeatTwo") then
-- 										LogMessage("LastName="..SimGetLastname(SimAlias).." 4")
-- 										if not OfficeGetHolder("SeatTwo", "SeatHolderTwo") then
-- 											LogMessage("LastName="..SimGetLastname(SimAlias).." 5")
-- 											SimRunForAnOffice(SimAlias,"SeatTwo")
-- 										end
-- 									end
-- 								elseif CityGetOffice("OffCity", OffLevel+1, OfficeIdx[X], "SeatThree") then
-- 									LogMessage("LastName="..SimGetLastname(SimAlias).." 6")
-- 									if not OfficeGetHolder("SeatThree", "SeatHolderThree") then
-- 										LogMessage("LastName="..SimGetLastname(SimAlias).." 7")
-- 										SimRunForAnOffice(SimAlias,"SeatThree")
-- 									end
-- 								end
-- 							end
-- 						end
-- 					end
-- 				end
-- 			end
-- 		end
-- 	end
-- 	
-- 	if HasProperty("","FirstRun") then
-- 		repopulate_CleanUp()
-- 	end
-- end

--Called only once at game start to fill offices and set AI Ages so dynasties do not die too soon 
function FillEmptyOffices()
	
	local sim
	local SimCount = ScenarioGetObjects("cl_Sim", 99999, "SimList")
	for sim=0,SimCount-1 do
		local SimAlias = "SimList"..sim
		if IsDynastySim(SimAlias) and SimGetAge(SimAlias) >= GL_AGE_FOR_GROWNUP then
			if not DynastyIsPlayer(SimAlias) then
				SimSetAge(SimAlias,Rand(16)+16) --Sets Random Age between 16 and 32 for all dynasty sim so that they do not die off right away
				if find_HomeCity(SimAlias,"DisMaCity") then
					if CityGetLevel("DisMaCity") > 4 then
						if CityGetOffice("DisMaCity",5,0,"Off50") then
							if GetNobilityTitle(SimAlias) > 6 and not OfficeGetHolder("Off50","MaOff50") then
								SimSetOffice(SimAlias,"Off50")
							elseif CityGetOffice("DisMaCity",4,0,"Off40") then
								if GetNobilityTitle(SimAlias) > 3 and not OfficeGetHolder("Off40","MaOff40") then
									SimSetOffice(SimAlias,"Off40")
								elseif CityGetOffice("DisMaCity",4,1,"Off41") then
									if GetNobilityTitle(SimAlias) > 3 and not OfficeGetHolder("Off41","MaOff41") then
										SimSetOffice(SimAlias,"Off41")
									elseif CityGetOffice("DisMaCity",3,0,"Off30") then
										if GetNobilityTitle(SimAlias) > 3 and not OfficeGetHolder("Off30","MaOff30") then
											SimSetOffice(SimAlias,"Off30")
										elseif CityGetOffice("DisMaCity",3,1,"Off31") then
											if GetNobilityTitle(SimAlias) > 3 and not OfficeGetHolder("Off31","MaOff31") then
												SimSetOffice(SimAlias,"Off31")
											elseif CityGetOffice("DisMaCity",2,0,"Off20") then
												if GetNobilityTitle(SimAlias) > 3 and not OfficeGetHolder("Off20","MaOff20") then
													SimSetOffice(SimAlias,"Off20")
												elseif CityGetOffice("DisMaCity",2,1,"Off21") then
													if GetNobilityTitle(SimAlias) > 3 and not OfficeGetHolder("Off21","MaOff21") then
														SimSetOffice(SimAlias,"Off21")
													elseif CityGetOffice("DisMaCity",1,0,"Off10") then
														if GetNobilityTitle(SimAlias) > 2 and not OfficeGetHolder("Off10","MaOff10") then
															SimSetOffice(SimAlias,"Off10")
														elseif CityGetOffice("DisMaCity",1,1,"Off11") then
															if GetNobilityTitle(SimAlias) > 2 and not OfficeGetHolder("Off11","MaOff11") then
																SimSetOffice(SimAlias,"Off11")
															end
														end
													end
												end
											end
										end
									end
								end
							end
						end
					elseif CityGetLevel("DisMaCity") == 4 then
						if CityGetOffice("DisMaCity",4,0,"Off40") then
							if GetNobilityTitle(SimAlias) > 6 and not OfficeGetHolder("Off40","MaOff40") then
								SimSetOffice(SimAlias,"Off40")
							elseif CityGetOffice("DisMaCity",3,0,"Off30") then
								if GetNobilityTitle(SimAlias) > 3 and not OfficeGetHolder("Off30","MaOff30") then
									SimSetOffice(SimAlias,"Off30")
								elseif CityGetOffice("DisMaCity",3,1,"Off31") then
									if GetNobilityTitle(SimAlias) > 3 and not OfficeGetHolder("Off31","MaOff31") then
										SimSetOffice(SimAlias,"Off31")
									elseif CityGetOffice("DisMaCity",2,0,"Off20") then
										if GetNobilityTitle(SimAlias) > 3 and not OfficeGetHolder("Off20","MaOff20") then
											SimSetOffice(SimAlias,"Off20")
										elseif CityGetOffice("DisMaCity",2,1,"Off21") then
											if GetNobilityTitle(SimAlias) > 3 and not OfficeGetHolder("Off21","MaOff21") then
												SimSetOffice(SimAlias,"Off21")
											elseif CityGetOffice("DisMaCity",1,0,"Off10") then
												if GetNobilityTitle(SimAlias) > 2 and not OfficeGetHolder("Off10","MaOff10") then
													SimSetOffice(SimAlias,"Off10")
												elseif CityGetOffice("DisMaCity",1,1,"Off11") then
													if GetNobilityTitle(SimAlias) > 2 and not OfficeGetHolder("Off11","MaOff11") then
														SimSetOffice(SimAlias,"Off11")
													end
												end
											end
										end
									end
								end
							end
						end
					elseif CityGetLevel("DisMaCity") == 3 then
						if CityGetOffice("DisMaCity",3,0,"Off30") then
							if GetNobilityTitle(SimAlias) > 6 and not OfficeGetHolder("Off30","MaOff30") then
								SimSetOffice(SimAlias,"Off30")
							elseif CityGetOffice("DisMaCity",2,0,"Off20") then
								if GetNobilityTitle(SimAlias) > 3 and not OfficeGetHolder("Off20","MaOff20") then
									SimSetOffice(SimAlias,"Off20")
								elseif CityGetOffice("DisMaCity",2,1,"Off21") then
									if GetNobilityTitle(SimAlias) > 3 and not OfficeGetHolder("Off21","MaOff21") then
										SimSetOffice(SimAlias,"Off21")
									elseif CityGetOffice("DisMaCity",1,0,"Off10") then
										if GetNobilityTitle(SimAlias) > 2 and not OfficeGetHolder("Off10","MaOff10") then
											SimSetOffice(SimAlias,"Off10")
										elseif CityGetOffice("DisMaCity",1,1,"Off11") then
											if GetNobilityTitle(SimAlias) > 2 and not OfficeGetHolder("Off11","MaOff11") then
												SimSetOffice(SimAlias,"Off11")
											end
										end
									end
								end
							end
						end
					elseif CityGetLevel("DisMaCity") == 2 then
						if CityGetOffice("DisMaCity",2,0,"Off20") then
							if GetNobilityTitle(SimAlias) > 6 and not OfficeGetHolder("Off20","MaOff20") then
								SimSetOffice(SimAlias,"Off20")
							elseif CityGetOffice("DisMaCity",1,0,"Off10") then
								if GetNobilityTitle(SimAlias) > 2 and not OfficeGetHolder("Off10","MaOff10") then
									SimSetOffice(SimAlias,"Off10")
								elseif CityGetOffice("DisMaCity",1,1,"Off11") then
									if GetNobilityTitle(SimAlias) > 2 and not OfficeGetHolder("Off11","MaOff11") then
										SimSetOffice(SimAlias,"Off11")
									end
								end
							end
						end
					end
				end
			end
		end
	end
end

function MarketItemCountCheck()
	if HasProperty("","FirstRun") then
		while GetGametime() >= 3 and GetGametime() <= 4 do
			Sleep(30)
		end
	end
	CreateScriptcall("MarketHelper",24,"Measures/Mods/Repopulate.lua","MarketItemCountCheck","",nil)
	
	local Market = Find("", "__F((Object.GetObjectsOfWorld(Building))AND(Object.IsType(14)))","Merchant", -1) --returns all Markets in the current game
	local idx
	for idx=0, Market-1 do
		local MarketPlace = "Merchant"..idx
		local LavCount = GetItemCount(MarketPlace, "Lavender", INVENTORY_STD)
		local WheatCount = GetItemCount(MarketPlace, "Wheat", INVENTORY_STD)
		if LavCount > 2000 then
			RemoveItems(MarketPlace,"Lavender",LavCount,INVENTORY_STD)
			AddItems(MarketPlace,"Lavender",150,INVENTORY_STD)
		end
		if WheatCount > 2000 then
			RemoveItems(MarketPlace,"Wheat",WheatCount,INVENTORY_STD)
			AddItems(MarketPlace,"Wheat",150,INVENTORY_STD)
		end
	end
	if HasProperty("","FirstRun") then
		repopulate_CleanUp()
	end
end	

function AIHospitalCheck()
	if not HasProperty("","FirstRun") then
		CreateScriptcall("HospitalChecker",24,"Measures/Mods/Repopulate.lua","AIHospitalCheck","",nil)
	end
	local Hospital = Find("", "__F((Object.GetObjectsOfWorld(Building))AND(Object.IsType(37)))","Doctor", -1) --returns all hospitals in the current game
	local idx
	for idx=0, Hospital-1 do
		local PestHouse = "Doctor"..idx
		if BuildingGetOwner(PestHouse,"SirDoctor") then
			if AliasExists("SirDoctor") then
				if not DynastyIsPlayer("SirDoctor") then
					if not HasProperty("","FirstRun") then
						if BuildingGetLevel(PestHouse) == 2 then
							BuildingLevelMeUp(PestHouse,-1)
							break
						end
					end
					if GetItemCount(PestHouse, "Medicine", INVENTORY_STD) < 10 then
						if CanAddItems(PestHouse,"Medicine",10,INVENTORY_STD) then
							AddItems(PestHouse,"Medicine",10,INVENTORY_STD)
						end
					end
					if GetItemCount(PestHouse, "PainKiller", INVENTORY_STD) < 10 then
						if CanAddItems(PestHouse,"PainKiller",10,INVENTORY_STD) then
							AddItems(PestHouse,"PainKiller",10,INVENTORY_STD)
						end
					end
				end
			end
		end
		
	end
	if not HasProperty("","FirstRun") then
		repopulate_CleanUp()
	else
		while GetGametime() >= 3 and GetGametime() <= 4 do
			Sleep(30)
		end
		CreateScriptcall("HospitalChecker",24,"Measures/Mods/Repopulate.lua","AIHospitalCheck","",nil)
	end
end

function PoisonWell()
	if HasProperty("","FirstRun") then
		while GetGametime() >= 4 and GetGametime() <= 5 do
			Sleep(30)
		end
	end
	CreateScriptcall("PoisonWell",24,"Measures/Mods/Repopulate.lua","PoisonWell","",nil)
	
	local AlchemistShop = Find("", "__F((Object.GetObjectsOfWorld(Building))AND(Object.IsType(16)))","Alchemy", -1) --returns all townhalls in the current game
	local idx
	for idx=0, AlchemistShop-1 do --for all achemist shops in the game do the following code one at the time for each townhall and remove from the list when done
		local Alchemist = "Alchemy"..idx --returns generic useable alias for all the townhalls on the maps
		if BuildingGetOwner(Alchemist,"AlchemistBldOwner") then
			if AliasExists("AlchemistBldOwner") then
				if not DynastyIsPlayer("AlchemistBldOwner") then
					if BuildingGetCity(Alchemist,"XCityX") then
						if CityGetRandomBuilding("XCityX", -1, GL_BUILDING_TYPE_WELL, -1, -1, FILTER_IGNORE, "Well") then
							if AliasExists("Well") then
								if Rand(100) < 15 then
									if not GetState("Well", STATE_CONTAMINATED) then
										--	LogMessage("Log Message: PoisonWell "..GetID("Well"))
										local duration = 4 + Rand(12)
										AddImpact("Well","polluted",1,duration)
										SetState("Well",STATE_CONTAMINATED,true)
									end
								end
							end
						end
					end
				end
			end
		end
	end
	if HasProperty("","FirstRun") then
		repopulate_CleanUp()
	end
end		

function NewKingMeasures()
	if HasProperty("","FirstRun") then
		while GetGametime() >= 3 and GetGametime() <= 4 do
			Sleep(30)
		end
	end
	CreateScriptcall("NewKingMeasures",24,"Measures/Mods/Repopulate.lua","NewKingMeasures","",nil)

	Sleep(2)
	if find_King("King") then
		if AliasExists("King") then
			if not DynastyIsPlayer("King") then
				local Attitude = SimGetAlignment("King")
				if MeasureRun("King",nil,"RoyalGuard",true) then
					Sleep(5)
					local sim
					ListNew("KingFoes")
					local SimCount = Find("King", "__F(Object.GetObjectsOfWorld(Sim)AND(Object.MinAge(16))AND NOT(Object.GetState(animal)))","SimList", -1)
					local Difficulty = ScenarioGetDifficulty()
					if Difficulty < 2 then --<-----Easy Setting.
						for sim=0,SimCount-1 do
							local SimAlias = "SimList"..sim
							if (DynastyGetDiplomacyState("King", SimAlias) == DIP_FOE) and (SimGetAge(SimAlias) >= GL_AGE_FOR_GROWNUP) then
								if SimGetAlignment(SimAlias) > 50 and Attitude > 25 then
									if not HasProperty(SimAlias,"ChurchOfficial") and GetImpactValue(SimAlias,"RPunished") == 0 then
										if not DynastyIsPlayer(SimAlias) then
											ListAdd("KingFoes",SimAlias)
										end
									end
								end
							end
						end
					elseif Difficulty == 2 then --<-----Medium Setting.
						for sim=0,SimCount-1 do	
							local SimAlias = "SimList"..sim
							if (DynastyGetDiplomacyState("King", SimAlias) == DIP_FOE) and (SimGetAge(SimAlias) >= GL_AGE_FOR_GROWNUP) then
								if SimGetAlignment(SimAlias) > 50 then
									if not HasProperty(SimAlias,"ChurchOfficial") and GetImpactValue(SimAlias,"RPunished") == 0 then
										ListAdd("KingFoes",SimAlias)
									end
								end
							end
						end
					else
						for sim=0,SimCount-1 do --<-----Hard Setting.
							local SimAlias = "SimList"..sim
							if (DynastyGetDiplomacyState("King", SimAlias) == DIP_FOE) and (SimGetAge(SimAlias) >= GL_AGE_FOR_GROWNUP) then
							--	if SimGetAlignment(SimAlias) > 20 then --<----Ruthless and unpredictable removal of all enemies
									if not HasProperty(SimAlias,"ChurchOfficial") and GetImpactValue(SimAlias,"RPunished") == 0 then
										ListAdd("KingFoes",SimAlias)
									end
							--	end
							end
						end
					end
					local Size = ListSize("KingFoes")
					if ListGetElement("KingFoes",Rand(Size),"Jerk") then 
						if AliasExists("Jerk") then
							LogMessage("Log Message: KingPunish"..GetID("Jerk"))
							MeasureRun("King","Jerk","RoyalPunish",true)
						end
					end
				end
			end
		end
	end
	
	if HasProperty("","FirstRun") then
		repopulate_CleanUp()
	end
end

function NewEmperorMeasures()
	if HasProperty("","FirstRun") then
		while GetGametime() >= 3 and GetGametime() <= 4 do
			Sleep(30)
		end
	end
	CreateScriptcall("NewEmperorMeasures",24,"Measures/Mods/Repopulate.lua","NewEmperorMeasures","",nil)

	Sleep(2)
	if find_Emperor("Emperor") then
		if AliasExists("Emperor") then
			if not DynastyIsPlayer("Emperor") then
				local Attitude = SimGetAlignment("Emperor")
				if MeasureRun("Emperor",nil,"ImperialGuard",true) then
					Sleep(2)
					local sim
					ListNew("EmperorFoes")
					local SimCount = Find("Emperor", "__F(Object.GetObjectsOfWorld(Sim)AND(Object.MinAge(16))AND NOT(Object.GetState(animal)))","SimList", -1)
					local Difficulty = ScenarioGetDifficulty()
					if Difficulty < 2 then --<-----Easy Setting.
						for sim=0,SimCount-1 do
							local SimAlias = "SimList"..sim
							if (DynastyGetDiplomacyState("Emperor", SimAlias) == DIP_FOE) and (SimGetAge(SimAlias) >= GL_AGE_FOR_GROWNUP) then
								if SimGetAlignment(SimAlias) > 50 and Attitude > 25 then
									if not HasProperty(SimAlias,"ChurchOfficial") and GetImpactValue(SimAlias,"IPunished") == 0 then
										if not DynastyIsPlayer(SimAlias) then
											ListAdd("EmperorFoes",SimAlias)
										end
									end
								end
							end
						end
					elseif Difficulty == 2 then --<-----Medium Setting.
						for sim=0,SimCount-1 do
							local SimAlias = "SimList"..sim
							if (DynastyGetDiplomacyState("Emperor", SimAlias) == DIP_FOE) and (SimGetAge(SimAlias) >= GL_AGE_FOR_GROWNUP) then
								if SimGetAlignment(SimAlias) > 50 then
									if not HasProperty(SimAlias,"ChurchOfficial") and GetImpactValue(SimAlias,"IPunished") == 0 then
										ListAdd("EmperorFoes",SimAlias)
									end
								end
							end
						end
					else
						for sim=0,SimCount-1 do --<-----Hard Setting.
							local SimAlias = "SimList"..sim
							if (DynastyGetDiplomacyState("Emperor", SimAlias) == DIP_FOE) and (SimGetAge(SimAlias) >= GL_AGE_FOR_GROWNUP) then
								-- if SimGetAlignment(SimAlias) > 20 then --<---Ruthless and unpredictable removal of enemies
									if not HasProperty(SimAlias,"ChurchOfficial") and GetImpactValue(SimAlias,"IPunished") == 0 then
										ListAdd("EmperorFoes",SimAlias)
									end
								-- end
							end
						end
					end
					local Size = ListSize("EmperorFoes")
					if ListGetElement("EmperorFoes",Rand(Size),"Jerk") then 
						if AliasExists("Jerk") then
							LogMessage("Log Message: ImperialPunish "..GetID("Jerk"))
							MeasureRun("Emperor","Jerk","ImperialPunish",true)
						end
					end
					Sleep(6)
					ListNew("EmperorOfficeFoes")
					if Difficulty == 2 then --<-----Medium Setting.	
						for sim=0,SimCount-1 do
							local SimAlias = "SimList"..sim
							if SimGetOfficeID(SimAlias) ~= -1 then
								if (DynastyGetDiplomacyState("Emperor", SimAlias) == DIP_FOE) and (SimGetAge(SimAlias) >= GL_AGE_FOR_GROWNUP) then
									if SimGetAlignment(SimAlias) > 50 then
										if not HasProperty(SimAlias,"ChurchOfficial") then
											ListAdd("EmperorOfficeFoes",SimAlias)
										end
									end
								end
							end
						end
					elseif Difficulty > 2 then --<-----Hard Setting.	
						for sim=0,SimCount-1 do
							local SimAlias = "SimList"..sim
							if SimGetOfficeID(SimAlias) ~= -1 then
								if (DynastyGetDiplomacyState("Emperor", SimAlias) == DIP_FOE) and (SimGetAge(SimAlias) >= GL_AGE_FOR_GROWNUP) then
									if not HasProperty(SimAlias,"ChurchOfficial") then
										ListAdd("EmperorOfficeFoes",SimAlias)
									end
								end
							end
						end
					end
					local EOFSize = ListSize("EmperorOfficeFoes")
					if ListGetElement("EmperorOfficeFoes",Rand(EOFSize),"Jerk") then 
						if AliasExists("Jerk") then
							LogMessage("Log Message: ImperialRemove "..GetID("Jerk"))
							MeasureRun("Emperor","Jerk","ImperialRemove",true)
						end
					end
				end
			end
		end
	end
	
	if HasProperty("","FirstRun") then
		repopulate_CleanUp()
	end
end

function NewPopeMeasures()
	if HasProperty("","FirstRun") then
		while GetGametime() >= 3 and GetGametime() <= 4 do
			Sleep(30)
		end
	end
	CreateScriptcall("NewPopeMeasures",24,"Measures/Mods/Repopulate.lua","NewPopeMeasures","",nil)
	
	Sleep(2)
	if find_Pope("Pope") then
		if AliasExists("Pope") then
			if not DynastyIsPlayer("Pope") then
				local PopeFaith = SimGetFaith("Pope")
				if MeasureRun("Pope",nil,"ImperialGuard",true) then
					Sleep(2)
					local sim
					ListNew("PopeFoes")
					local Difficulty = ScenarioGetDifficulty()
					local SimCount = Find("Pope", "__F(Object.GetObjectsOfWorld(Sim)AND(Object.MinAge(16))AND NOT(Object.GetState(animal)))","SimList", -1)
					if Difficulty == 2 then --<-----Medium Setting.
						for sim=0,SimCount-1 do
							local SimAlias = "SimList"..sim
							if SimGetOfficeID(SimAlias) ~= -1 then
								if HasProperty(SimAlias,"ChurchOfficial") then
									if DynastyGetDiplomacyState("Pope", SimAlias) == DIP_FOE and (SimGetAge(SimAlias) >= GL_AGE_FOR_GROWNUP) then
										if SimGetFaith(SimAlias) < 50 then
											ListAdd("PopeFoes",SimAlias)
										end
									end
								end
							end
						end
					elseif Difficulty > 2 then
						for sim=0,SimCount-1 do	--<----Hard Setting
							local SimAlias = "SimList"..sim
							if SimGetOfficeID(SimAlias) ~= -1 then
								if HasProperty(SimAlias,"ChurchOfficial") then
									if DynastyGetDiplomacyState("Pope", SimAlias) == DIP_FOE and (SimGetAge(SimAlias) >= GL_AGE_FOR_GROWNUP) then
										if SimGetFaith(SimAlias) < 90 then
											ListAdd("PopeFoes",SimAlias)
										end
									end
								end
							end
						end
					end
					if ListGetElement("PopeFoes",0,"Jerk") then 
						if AliasExists("Jerk") then
							LogMessage("Log Message: PapalRemove"..GetID("Jerk"))
							MeasureRun("Pope","Jerk","PapalRemove",true)
						end
					end
					Sleep(4)
					ListNew("PopeFoesTwo")
					if Difficulty < 2 then --<-----Easy Setting.
						for sim=0,SimCount-1 do
							local SimAlias = "SimList"..sim
							if SimGetOfficeID(SimAlias) ~= -1 then
								if not HasProperty(SimAlias,"ChurchOfficial") then
									if DynastyGetDiplomacyState("Pope", SimAlias) == DIP_FOE and (SimGetAge(SimAlias) >= GL_AGE_FOR_GROWNUP) then
										if SimGetFaith(SimAlias) < 50 and PopeFaith > 50 then
											if not DynastyIsPlayer(SimAlias) then
												if GetImpactValue(SimAlias,"Excommed") == 0 then
													ListAdd("PopeFoesTwo",SimAlias)
												end
											end
										end
									end
								end
							end
						end
					elseif Difficulty == 2 then --<-----Medium Setting.
						for sim=0,SimCount-1 do
							local SimAlias = "SimList"..sim
							if SimGetOfficeID(SimAlias) ~= -1 then
								if not HasProperty(SimAlias,"ChurchOfficial") then
									if DynastyGetDiplomacyState("Pope", SimAlias) == DIP_FOE and (SimGetAge(SimAlias) >= GL_AGE_FOR_GROWNUP) then
										if SimGetFaith(SimAlias) < 50  then
											if GetImpactValue(SimAlias,"Excommed") == 0 then
												ListAdd("PopeFoesTwo",SimAlias)
											end
										end
									end
								end
							end
						end 
					else
						for sim=0,SimCount-1 do --<-----Hard Setting
							local SimAlias = "SimList"..sim
							if SimGetOfficeID(SimAlias) ~= -1 then
								if not HasProperty(SimAlias,"ChurchOfficial") then
									if DynastyGetDiplomacyState("Pope", SimAlias) == DIP_FOE and (SimGetAge(SimAlias) >= GL_AGE_FOR_GROWNUP) then
										if SimGetFaith(SimAlias) < 90  then
											if GetImpactValue(SimAlias,"Excommed") == 0 then
												ListAdd("PopeFoesTwo",SimAlias)
											end 
										end
									end
								end
							end
						end
					end
					local Size = ListSize("PopeFoesTwo")
					if ListGetElement("PopeFoesTwo",Rand(Size),"Jerk") then 
						if AliasExists("Jerk") then
							LogMessage("Log Message: Excommunicate "..GetID("Jerk"))
							MeasureRun("Pope","Jerk","Excommunicate",true)
						end
					end
				end                
			end
		end
	end
	if HasProperty("","FirstRun") then
		repopulate_CleanUp()
	end
end

function AIAggressive()
	local Difficulty = ScenarioGetDifficulty()
	ListNew("Foes")
	local i
	local idx
	local index
	local sim
	local SimCount = ScenarioGetObjects("cl_Sim", 99999, "SimList")
	if Difficulty < 2 then --<-----Easy Setting. Human players not considered on the aggressive target list
		for sim=0,SimCount-1 do
			local SimAlias = "SimList"..sim
			if DynastyIsShadow(SimAlias) then --Let the player wipe out the AI Dynasties
				if IsDynastySim(SimAlias) then       
					if SimGetAlignment(SimAlias) > 50 then
						ListAdd("Foes",SimAlias)
					end
				end
			end
		end
	elseif Difficulty == 2 then ---<--- Medium Setting 50% chance human players are not considered even on the aggressive target list
		for sim=0,SimCount-1 do
			local SimAlias = "SimList"..sim
			if DynastyIsShadow(SimAlias) or DynastyIsPlayer(SimAlias) then --Let the player wipe out the AI Dynasties
				if SimGetAlignment(SimAlias) > 50 then        
					ListAdd("Foes",SimAlias)
				end
			end
		end 
	else
		for sim=0,SimCount-1 do
			local SimAlias = "SimList"..sim
			if DynastyIsShadow(SimAlias) or DynastyIsPlayer(SimAlias) then --Let the player wipe out the AI Dynasties
				ListAdd("Foes",SimAlias)
			end
		end
	end
	
	for sim=0,SimCount-1 do
	local SimAlias = "SimList"..sim
		if DynastyIsShadow(SimAlias) or DynastyIsAI(SimAlias) then
			if not HasProperty(SimAlias,"BugFix") then
				if IsDynastySim(SimAlias) then
					if GetNobilityTitle(SimAlias) > 2 then
						for i=0,ListSize("Foes")-1 do
							if ListGetElement("Foes",i,"DynEnemy") then
								if AliasExists("DynEnemy") then
									if DynastyGetDiplomacyState(SimAlias, "DynEnemy") ~= DIP_FOE then
										ListRemove("Foes","DynEnemy")
									end
								end
							end
							local DynCount = ListSize("Foes")
							if ListGetElement("Foes",Rand(DynCount),"DynEnemy") then
								if AliasExists("DynEnemy") then
									local Count = DynastyGetFamilyMemberCount("dynasty")
									if DynastyGetFamilyMember("DynEnemy",Rand(Count),"Jerk") then
										if AliasExists("Jerk") then
											if find_HomeCity(SimAlias,"City") then
												if find_HomeCity("Jerk","CurrentCity") then
													if GetID("City")==GetID("CurrentCity") then
														if (Rand(100) < 30) and (SimGetFaith("Jerk") < 75) and (SimGetFaith(SimAlias) > 60) then
															local Value = SimGetReligion(SimAlias)
															if Value == 0 then
																if CityGetRandomBuilding("City", -1, GL_BUILDING_TYPE_CHURCH_CATH, -1, -1, FILTER_IGNORE, "Temple") then
																	if AliasExists("Temple") then
																		if BuildingGetOwner("Temple","ChurchOwner") then
																			if AliasExists("ChurchOwner") then
																				if not HasProperty("Jerk","Dead") then
																					SetProperty("Jerk","Dead",1)
																					Sleep(1)
																					GetLocatorByName("Church","Priest1","PriestPos")
																					SetState(SimAlias, STATE_LOCKEDALT, true)
																					f_MoveTo(SimAlias,"PriestPos")
																					SetState(SimAlias, STATE_LOCKEDALT, false)
																					LogMessage("Log Message: AccuseWitch"..GetID("Jerk"))
																					MeasureRun(SimAlias,"Jerk","AccuseWitch",true)
																				end
																			end
																		end
																	end
																elseif CityGetRandomBuilding("City", -1, GL_BUILDING_TYPE_CHURCH_EV, -1, -1, FILTER_IGNORE, "Temple") then
																	if AliasExists("Temple") then
																		if BuildingGetOwner("Temple","ChurchOwner") then
																			if AliasExists("ChurchOwner") then
																				if not HasProperty("Jerk","Dead") then
																					SetProperty("Jerk","Dead",1)
																					Sleep(1)
																					GetLocatorByName("Church","Priest1","PriestPos")
																					SetState(SimAlias, STATE_LOCKEDALT, true)
																					f_MoveTo(SimAlias,"PriestPos")
																					SetState(SimAlias, STATE_LOCKEDALT, false)
																					LogMessage("Log Message: AccuseWitch"..GetID("Jerk"))
																					MeasureRun(SimAlias,"Jerk","AccuseWitch",true)
																				end
																			end
																		end
																	end
																end
															end
														elseif Rand(100) > 90 then
															if find_HomeCity(SimAlias,"City") then
																if CityGetRandomBuilding("City", -1, GL_BUILDING_TYPE_TAVERN, -1, -1, FILTER_IGNORE, "Tavern") then
																	if AliasExists("Tavern") then
																		if BuildingGetOwner("Tavern","TavernOwner") then
																			if AliasExists("TavernOwner") then
																				if not HasProperty("Jerk","Dead") then
																					SetProperty("Jerk","Dead",1)
																					Sleep(1)
																					GetLocatorByName("Tavern", "Dance1", "Pos")
																					SetState(SimAlias, STATE_LOCKEDALT, true)
																					f_MoveTo(SimAlias,"Pos")
																					SetState(SimAlias, STATE_LOCKEDALT, false)
																					LogMessage("Log Message: Assassinate "..GetID("Jerk"))
																					MeasureRun(SimAlias,"Jerk","Assassin",true)
																				end
																			end
																		end
																	end 
																end
															end
														end
													end
												end
											end
										end
									end
								end
							end
						end
					end
				end
			end
		end
	end
end

function CreateBoy()
--	GetLocatorByName("","Entry1","SpawnPoint") -- All this is explained in the CreateGirl() Function. The only difference is in this code we are infact creating a boy...that particular difference should be easy to spot!!
	local sim
	local SimCount = ScenarioGetObjects("cl_Sim", 99999, "SimList")
	for sim=0,SimCount-1 do
		local SimAlias = "SimList"..sim
		if DynastyIsShadow(SimAlias) == false then
			if SimGetGender(SimAlias) == GL_GENDER_FEMALE then
				if IsDynastySim(SimAlias) then
					if DynastyIsAI(SimAlias) then
						if IsDynastySim(SimAlias) then
							if SimGetAge(SimAlias) >= GL_AGE_FOR_GROWNUP then
								if GetDynasty(SimAlias,"AIOnly") then
									if not HasProperty("AIOnly","BugFix") then
										if not HasProperty(SimAlias,"BugFix") then
											if DynastyGetFamilyMemberCount(SimAlias) < 10 then
												if GetHomeBuilding(SimAlias,"MyHome") then
													if AliasExists("MyHome") then	
														if SimGetSpouse(SimAlias,"Father") then
															if AliasExists("Father") then	
																GetLocatorByName("MyHome","Entry1","SpawnPoint")
																SimCreate(7,"MyHome","SpawnPoint","Boy")
																DynastyAddMember("AIOnly","Boy")
																SimSetFamily("Boy",SimAlias,"Father")
																SimSetAge("Boy",Rand(5))
																ChangeResidence("Boy","MyHome")
																SimSetBehavior("Boy", "Childness")
															--	f_MoveToNoWait("Boy","MyHome",GL_MOVESPEED_RUN)
															else
																SimCreate(7,"MyHome","SpawnPoint","Boy")
																DynastyAddMember("AIOnly","Boy")
																SimSetFamily("Boy",SimAlias,SimAlias)
																SimSetAge("Boy",Rand(5))
																ChangeResidence("Boy","MyHome")
																SimSetBehavior("Boy", "Childness")
															--	f_MoveToNoWait("Boy","MyHome",GL_MOVESPEED_RUN)
															end
														end
													end
												end
											end
										end
									end
								end
							end
						end
					end
				end
--				GetLocalPlayerDynasty("Humans")
--				MsgQuick("Humans","As of this line the mod is Working!!!!")
			end
		end
	end
end

function CreateGirl()
	local sim
	local SimCount = ScenarioGetObjects("cl_Sim", 99999, "SimList")
	for sim=0,SimCount-1 do
		local SimAlias = "SimList"..sim
		if DynastyIsShadow(SimAlias) == false then
			if SimGetGender(SimAlias) == GL_GENDER_FEMALE then
				if IsDynastySim(SimAlias) then
					if DynastyIsAI(SimAlias) then
						if IsDynastySim(SimAlias) then
							if SimGetAge(SimAlias) >= GL_AGE_FOR_GROWNUP then
								if GetDynasty(SimAlias,"AIOnly") then
									if not HasProperty("AIOnly","BugFix") then
										if not HasProperty(SimAlias,"BugFix") then
											if DynastyGetFamilyMemberCount(SimAlias) < 10 then
												if GetHomeBuilding(SimAlias,"MyHome") then
													if AliasExists("MyHome") then	
														if SimGetSpouse(SimAlias,"Father") then
															if AliasExists("Father") then	
																GetLocatorByName("MyHome","Entry1","SpawnPoint")
																SimCreate(8,"MyHome","SpawnPoint","Girl")
																DynastyAddMember("AIOnly","Girl")
																SimSetFamily("Girl",SimAlias,"Father")
																SimSetAge("Girl",Rand(5))
																ChangeResidence("Girl","MyHome")
																SimSetBehavior("Girl", "Childness")
															--	f_MoveToNoWait("Girl","MyHome",GL_MOVESPEED_RUN)
															else
																SimCreate(8,"MyHome","SpawnPoint","Girl")
																DynastyAddMember("AIOnly","Girl")
																SimSetFamily("Girl",SimAlias,SimAlias)
																SimSetAge("Girl",Rand(5))
																ChangeResidence("Girl","MyHome")
																SimSetBehavior("Girl", "Childness")
															--	f_MoveToNoWait("Girl","MyHome",GL_MOVESPEED_RUN)
															end
														end
													end
												end
											end
										end
									end
								end
							end
						end
					end
				end
--				GetLocalPlayerDynasty("Humans")
--				MsgQuick("Humans","As of this line the mod is Working!!!!")
			end
		end
	end
end

function FinancialBailout() --name of created function
	local Dyn --Not sure if this is needed or not. Just copying format I found in other files
	local DynCount = ScenarioGetObjects("cl_Dynasty", 9999, "DynList") --This finds all dynasties in the game
	for Dyn=0,DynCount-1 do --this creates an index for each dynasty and calls all the following code on those dynastys one at a time. Hence the DynCount-1...essentially it is removing itself from the list
		local DynAlias = "DynList"..Dyn --This returns a useable Dynasty alias...Look at how it combines elements from different lines to achieve this. How it works I dont know but the format never changes and you will see I use this multiple times throughout this file
		if not DynastyIsPlayer(DynAlias) then --This filters out Human dynasties
			if not HasProperty(DynAlias,"BugFix") then
				local DynMembers = DynastyGetFamilyMemberCount(DynAlias) --DynMembers becomes the number of family members each individual dynasty has. 
				local Money = GetMoney(DynAlias) --This gets the amount of money the Dynasty has
				local MemberMoney = Money/DynMembers --This is simple math. The amount of money divided by the number of family members in the dynasty. Basically finds out how much each member has if it is divided equally
				if MemberMoney < 5000 then --If the average dynasty members money is less then 5000 then
					local IdealMoney = DynMembers * 5000 --Multiplying the amount of dynasty members by 5000 so each member has $5000 to work with
					local HelpMoney = IdealMoney - Money --This ensures we do not give the AI too much money...So we take how much we want them to have then subtract what they currently have. Looks like this (Dynastymembercount X 5000 - CurrentMoney = HelpMoney)
					CreditMoney(DynAlias, HelpMoney) -- Obviously where we credit the extra little bit that they need
	--				GetLocalPlayerDynasty("Humans") --Used this line and the line below to test the frequency this code is called (I have never seen it NOT called therefore the money helper must be needed hahaha)		--				MsgQuick("Humans","As of this line the mod is Working!!!!")
				end
			end
		end
	end
end


--*****This function is now automatically initiated in Scripts/AI/BaseTree/CheckDynasty/Actions/ac_ApplyForOffice.lua file! As soon as the first AI purchases a title the repopulate mod is automatically run!! WoooooT!!!! Last of code is moved into SetEarlyHours()

function InitiateOnce() --This function will NOT be called again no matter how many times you cancel and reactivate it...
	local TownHall = Find("", "__F((Object.GetObjectsOfWorld(Building))AND(Object.IsType(23)))","CityCenter", -1) --this finds all the townhalls on the map
	local idx
	for idx=0, TownHall-1 do --This reads...For all the town halls on the map do the following code on each one at a time
		local CityH = "CityCenter"..idx --returns a useable alias for the below codes
	--	AddImpact(CityH,"Delay",1,120)
		SetProperty(CityH, "FirstRun", 1) --This is the property I used to ensure this function only gets called once...the check for this property is performed in the Run() function. Both lines are needed to ensure this function only is called once
	--	SetProperty(CityH, "CancelRun", 1) --This is used in the Run() function of this file, in CancelRepopulate.lua file and filter.dbt file so that when the Repopulate button disappears the Cancel button appears and vice versa 
	end
	-- local Dyn --all this code below is to create a more realistic world where some dynasties already control vast wealth and high titles
	-- local DynCount = ScenarioGetObjects("cl_Dynasty", 9999, "DynList") --Finds all the dynasties in the current game
	-- for Dyn=0,DynCount-1 do --For each dynasty do the following code and remove from the list when done
		-- local DynAlias = "DynList"..Dyn --useable alias for dynasty...when using "for" and "do" you must copy this format to achieve a useable alias.
		-- if DynastyIsAI(DynAlias) then
			-- if not DynastyIsPlayer(DynAlias) then --This makes sure only AI dynasties are called for the below code (basically filters out human players)
				-- local Count = DynastyGetFamilyMemberCount(DynAlias)
				-- local RdmMbr = Rand(Count)
				-- if DynastyGetFamilyMember(DynAlias, RdmMbr, "RdmMember") then  -- This code gets a random member of the DynAlias dynasty and returns that alias as "RdmMember"
					-- local Money = Rand(10) --Money = a random number between 0-10 (Very important to realize that zero is included!!! If you are not aware of this it can create bugs!!!
					-- local HighTitle = -1 --All these -1 are checks for the below codes
					-- local MedHighTitle = -1
					-- local MedLowTitle = -1
					-- local LowTitle = -1
					-- if Money == 10 then -- Money is random so there is less then 10% chance that it will equal 10....I know you are thinking its EXACTLY 10% but its not...zero is included!!!! technically that makes it a 1 in 11 chance!
						-- CreditMoney(DynAlias, 1000000, "IncomeOther") -- Award dynasty a million dollars
						-- HighTitle = 1 -- Converts HighTitle from -1 to 1
					-- elseif Money < 10 and Money > 7 then --so if money ends up being 8 or 9 then do that following
						-- CreditMoney(DynAlias, 100000, "IncomeOther") --award 100,000
						-- MedHighTitle = 1 --Converts MedHighTitle from -1 to 1
					-- elseif Money > 4 and Money < 8 then --if the random number ends up being 5, 6, or 7 then do the following
						-- CreditMoney(DynAlias, 20000, "IncomeOther") --award $20000
						-- MedLowTitle = Rand(2) --and MedLowTitle becomes a random number between 0-2 (0,1,2)
					-- else --since 5-10 are accounted for then this else just means for all other numbers (0-4) do the following
						-- CreditMoney(DynAlias, 10000, "IncomeOther") --award $10,000
						-- LowTitle = Rand(2) --lowtitle is changed from -1 to a random number between 0-2 (0,1,2)
					-- end --This ends the money part of the code. Next is how we figure out which title to award!!! Remember the signifcance of changing the -1 values!!! This allows us to match money with titles (to avoid civilians for being millionaires)
					-- if HighTitle ~= -1 then --This reads exactly "if HighTitle does not equal -1" then  
						-- SetNobilityTitle("RdmMember",13,true) --set highest nobility title
					-- elseif MedHighTitle ~= -1 then 
						-- if MedHighTitle == 2 then --this is where those random numbers set above come in (Betweeon 0-2) this allows us to spread out all the titles so they are properly balanced (this is all theoretical though...because numbers are random sometimes by fluke they will not quite balance as nicely)
							-- SetNobilityTitle("RdmMember",12,true) --This format continues all the way down...The numbers (12 in this case) are found in nobilitytitles.dbt be prepared to use google translate...some files are in german lol
						-- elseif MedHighTitle == 1 then	
							-- SetNobilityTitle("RdmMember",11,true)
						-- else
							-- SetNobilityTitle("RdmMember",10,true)
						-- end
					-- elseif MedLowTitle ~= -1 then
						-- if MedLowTitle == 2 then
							-- SetNobilityTitle("RdmMember",9,true)
						-- elseif MedLowTitle == 1 then
							-- SetNobilityTitle("RdmMember",8,true)
						-- else
							-- SetNobilityTitle("RdmMember",7,true)
						-- end
					-- elseif LowTitle == 2 then
						-- SetNobilityTitle("RdmMember",6,true)
					-- elseif LowTitle == 1 then
						-- SetNobilityTitle("RdmMember",5,true)
					-- else
						-- SetNobilityTitle("RdmMember",4,true)
					-- end
				-- end
			-- end
		-- end
	-- end
end

function AddArmour()
	local SimCount = ScenarioGetObjects("cl_Sim", 99999, "SimList")
	local sim 
	for sim=0,SimCount-1 do --For every sim in the game do the following code for each one at a time and then remove from list
		local SimAlias = "SimList"..sim
		if not HasProperty(SimAlias,"BugFix") then
			if GetDynasty(SimAlias,"PlyrDyn") then
				if AliasExists("PlyrDyn") then
					if not HasProperty("PlyrDyn","BugFix") and not GetState(SimAlias,STATE_ANIMAL) then
						--Armour Check
						if not HasProperty(SimAlias,"Armour") then	
							if GetItemCount(SimAlias,"LeatherArmor",INVENTORY_EQUIPMENT)>0 then
								RemoveItems(SimAlias,"LeatherArmor",1,INVENTORY_EQUIPMENT)
							elseif GetItemCount(SimAlias,"Chainmail",INVENTORY_EQUIPMENT)>0 then
								RemoveItems(SimAlias,"Chainmail",1,INVENTORY_EQUIPMENT)
							elseif GetItemCount(SimAlias,"Platemail",INVENTORY_EQUIPMENT)>0 then
								RemoveItems(SimAlias,"Platemail",1,INVENTORY_EQUIPMENT)
							end
							if Rand(100)<15 then
								AddItems(SimAlias,"LeatherArmor",1,INVENTORY_EQUIPMENT)
								SetProperty(SimAlias,"Armour",1)
							end
						elseif GetProperty(SimAlias,"Armour")==1 then
							RemoveItems(SimAlias,"LeatherArmor",1,INVENTORY_EQUIPMENT)
							if Rand(100)<10 then
								AddItems(SimAlias,"Chainmail",1,INVENTORY_EQUIPMENT)
								SetProperty(SimAlias,"Armour",2)
							end
						elseif GetProperty(SimAlias,"Armour")==2 then
							RemoveItems(SimAlias,"Chainmail",1,INVENTORY_EQUIPMENT)
							if Rand(100)<5 then
								AddItems(SimAlias,"Platemail",1,INVENTORY_EQUIPMENT)
								SetProperty(SimAlias,"Armour",3)
							end
						end
						--Weapon Check
						if not HasProperty(SimAlias,"Weapon") then	
							if GetItemCount(SimAlias,"Dagger",INVENTORY_EQUIPMENT)>0 then
								RemoveItems(SimAlias,"Dagger",1,INVENTORY_EQUIPMENT)
							elseif GetItemCount(SimAlias,"Shortsword",INVENTORY_EQUIPMENT)>0 then
								RemoveItems(SimAlias,"Shortsword",1,INVENTORY_EQUIPMENT)
							elseif GetItemCount(SimAlias,"Mace",INVENTORY_EQUIPMENT)>0 then
								RemoveItems(SimAlias,"Mace",1,INVENTORY_EQUIPMENT)
							elseif GetItemCount(SimAlias,"Longsword",INVENTORY_EQUIPMENT)>0 then
								RemoveItems(SimAlias,"Longsword",1,INVENTORY_EQUIPMENT)
							elseif GetItemCount(SimAlias,"Axe",INVENTORY_EQUIPMENT)>0 then
								RemoveItems(SimAlias,"Axe",1,INVENTORY_EQUIPMENT)
							end
							if Rand(100)<15 then
								AddItems(SimAlias,"Dagger",1,INVENTORY_EQUIPMENT)
								SetProperty(SimAlias,"Weapon",1)
							end
						elseif GetProperty(SimAlias,"Weapon")==1 then
							RemoveItems(SimAlias,"Dagger",1,INVENTORY_EQUIPMENT)
							if Rand(100)<10 then
								if Rand(100)<50 then
									AddItems(SimAlias,"Shortsword",1,INVENTORY_EQUIPMENT)
								else
									AddItems(SimAlias,"Mace",1,INVENTORY_EQUIPMENT)
								end
								SetProperty(SimAlias,"Weapon",2)
							end
						elseif GetProperty(SimAlias,"Weapon")==2 then
							if GetItemCount(SimAlias,"Shortsword",INVENTORY_EQUIPMENT)>0 then
								RemoveItems(SimAlias,"Shortsword",1,INVENTORY_EQUIPMENT)
							else
								RemoveItems(SimAlias,"Mace",1,INVENTORY_EQUIPMENT)
							end
							if Rand(100)<5 then 
								if Rand(100)<50 then
									AddItems(SimAlias,"Longsword",1,INVENTORY_EQUIPMENT)
								else
									AddItems(SimAlias,"Axe",1,INVENTORY_EQUIPMENT)
								end
								SetProperty(SimAlias,"Weapon",3)
							end
						end
						--Helm Check
						if not HasProperty(SimAlias,"AIHelm") then	
							if GetItemCount(SimAlias,"IronCap",INVENTORY_EQUIPMENT)>0 then
								RemoveItems(SimAlias,"IronCap",1,INVENTORY_EQUIPMENT)
							elseif GetItemCount(SimAlias,"FullHelmet",INVENTORY_EQUIPMENT)>0 then
								RemoveItems(SimAlias,"FullHelmet",1,INVENTORY_EQUIPMENT)
							end
							if Rand(100)<10 then
								AddItems(SimAlias,"IronCap",1,INVENTORY_EQUIPMENT)
								SetProperty(SimAlias,"AIHelm",1)
							end
						elseif GetProperty(SimAlias,"AIHelm")==1 then
							RemoveItems(SimAlias,"IronCap",1,INVENTORY_EQUIPMENT)
							if Rand(100)<5 then
								AddItems(SimAlias,"FullHelmet",1,INVENTORY_EQUIPMENT)
								SetProperty(SimAlias,"AIHelm",2)
							end
						end
						--Glove Check
						if not HasProperty(SimAlias,"AIGlove") then	
							if GetItemCount(SimAlias,"LeatherGloves",INVENTORY_EQUIPMENT)>0 then
								RemoveItems(SimAlias,"LeatherGloves",1,INVENTORY_EQUIPMENT)
							elseif GetItemCount(SimAlias,"IronBrachelet",INVENTORY_EQUIPMENT)>0 then
								RemoveItems(SimAlias,"IronBrachelet",1,INVENTORY_EQUIPMENT)
							end
							if Rand(100)<10 then
								AddItems(SimAlias,"LeatherGloves",1,INVENTORY_EQUIPMENT)
								SetProperty(SimAlias,"AIGlove",1)
							end
						elseif GetProperty(SimAlias,"AIGlove")==1 then
							RemoveItems(SimAlias,"LeatherGloves",1,INVENTORY_EQUIPMENT)
							if Rand(100)<5 then
								AddItems(SimAlias,"IronBrachelet",1,INVENTORY_EQUIPMENT)
								SetProperty(SimAlias,"AIGlove",2)
							end
						end
					end
				end
			end
		end
	end
end

function AICardinalFavor()
	
	local SimCount = ScenarioGetObjects("cl_Sim", 99999, "SimList")
	local sim 
	for sim=0,SimCount-1 do --For every sim in the game do the following code for each one at a time and then remove from list
		local SimAlias = "SimList"..sim
		if SimGetFaith(SimAlias) > 95 then
			if GetHomeBuilding(SimAlias,"Home") then
				if AliasExists("Home") then 
					if BuildingGetOwner("Home","HomeOwner") then
						if AliasExists("HomeOwner") then
							if GetID(SimAlias) == GetID("HomeOwner") then
								if DynastyIsAI(SimAlias) or DynastyIsShadow(SimAlias) then
									if not HasProperty(SimAlias,"BugFix") then
										if IsDynastySim(SimAlias) then
											if not HasProperty(SimAlias,"CardinalFavor") then
												if Rand(100) > 75 then
													SetProperty(SimAlias,"CardinalFavor",1)
													LogMessage("Log Message: CardinalFavor=1"..GetID(SimAlias))
													if find_HomeCity(SimAlias,"City") then
														if CityGetRandomBuilding("City", -1, GL_BUILDING_TYPE_CHURCH_CATH, -1, -1, FILTER_IGNORE, "Church") then
															if AliasExists("Church") then
																if BuildingGetOwner("Church","ChurchOwner") then
																	if AliasExists("ChurchOwner") then
																		CreditMoney("ChurchOwner",1000,"IncomeOther")
																	end
																end
															else
																if CityGetRandomBuilding("City", -1, GL_BUILDING_TYPE_CHURCH_EV, -1, -1, FILTER_IGNORE, "Church") then
																	if AliasExists("Church") then
																		if BuildingGetOwner("Church","ChurchOwner") then
																			if AliasExists("ChurchOwner") then
																				CreditMoney("ChurchOwner",100000,"IncomeOther")
																			end
																		end
																	end
																end
															end
														end
													end
												end
											elseif GetProperty(SimAlias,"CardinalFavor") == 1 then
												if Rand(100) > 80 then
													SetProperty(SimAlias,"CardinalFavor",2)
													LogMessage("Log Message: CardinalFavor=2"..GetID(SimAlias))
													if find_HomeCity(SimAlias,"City")then
														if CityGetRandomBuilding("City", -1, GL_BUILDING_TYPE_CHURCH_CATH, -1, -1, FILTER_IGNORE, "Church") then
															if AliasExists("Church") then
																if BuildingGetOwner("Church","ChurchOwner") then
																	if AliasExists("ChurchOwner") then
																		CreditMoney("ChurchOwner",5000,"IncomeOther")
																	end
																end
															else
																if CityGetRandomBuilding("City", -1, GL_BUILDING_TYPE_CHURCH_EV, -1, -1, FILTER_IGNORE, "Church") then
																	if AliasExists("Church") then
																		if BuildingGetOwner("Church","ChurchOwner") then
																			if AliasExists("ChurchOwner") then
																				CreditMoney("ChurchOwner",100000,"IncomeOther")
																			end
																		end
																	end
																end
															end
														end
													end
												end
											elseif GetProperty(SimAlias,"CardinalFavor") == 2 then
												if Rand(100) > 85 then
													SetProperty(SimAlias,"CardinalFavor",3)
													LogMessage("Log Message: CardinalFavor=3"..GetID(SimAlias))
													if find_HomeCity(SimAlias,"City") then
														if CityGetRandomBuilding("City", -1, GL_BUILDING_TYPE_CHURCH_CATH, -1, -1, FILTER_IGNORE, "Church") then
															if AliasExists("Church") then
																if BuildingGetOwner("Church","ChurchOwner") then
																	if AliasExists("ChurchOwner") then
																		CreditMoney("ChurchOwner",10000,"IncomeOther")
																	end
																end
															else
																if CityGetRandomBuilding("City", -1, GL_BUILDING_TYPE_CHURCH_EV, -1, -1, FILTER_IGNORE, "Church") then
																	if AliasExists("Church") then
																		if BuildingGetOwner("Church","ChurchOwner") then
																			if AliasExists("ChurchOwner") then
																				CreditMoney("ChurchOwner",100000,"IncomeOther")
																			end
																		end
																	end
																end
															end
														end
													end
												end
											elseif GetProperty(SimAlias,"CardinalFavor") == 3 then
												if Rand(100) > 90 then
													SetProperty(SimAlias,"CardinalFavor",4)		
													LogMessage("Log Message: CardinalFavor=4"..GetID(SimAlias))
													if find_HomeCity(SimAlias,"City") then
														if CityGetRandomBuilding("City", -1, GL_BUILDING_TYPE_CHURCH_CATH, -1, -1, FILTER_IGNORE, "Church") then
															if AliasExists("Church") then
																if BuildingGetOwner("Church","ChurchOwner") then
																	if AliasExists("ChurchOwner") then
																		CreditMoney("ChurchOwner",50000,"IncomeOther")
																	end
																end
															else
																if CityGetRandomBuilding("City", -1, GL_BUILDING_TYPE_CHURCH_EV, -1, -1, FILTER_IGNORE, "Church") then
																	if AliasExists("Church") then
																		if BuildingGetOwner("Church","ChurchOwner") then
																			if AliasExists("ChurchOwner") then
																				CreditMoney("ChurchOwner",100000,"IncomeOther")
																			end
																		end
																	end
																end 
															end
														end
													end
												end
											elseif GetProperty(SimAlias,"CardinalFavor") == 4 then
												if Rand(100) > 95 then
													SetProperty(SimAlias,"CardinalFavor",5)				
													LogMessage("Log Message: CardinalFavor=5"..GetID(SimAlias))
													if find_HomeCity(SimAlias,"City") then
														if CityGetRandomBuilding("City", -1, GL_BUILDING_TYPE_CHURCH_CATH, -1, -1, FILTER_IGNORE, "Church") then
															if AliasExists("Church") then
																if BuildingGetOwner("Church","ChurchOwner") then
																	if AliasExists("ChurchOwner") then
																		CreditMoney("ChurchOwner",100000,"IncomeOther")
																	end
																end
															else
																if CityGetRandomBuilding("City", -1, GL_BUILDING_TYPE_CHURCH_EV, -1, -1, FILTER_IGNORE, "Church") then
																	if AliasExists("Church") then
																		if BuildingGetOwner("Church","ChurchOwner") then
																			if AliasExists("ChurchOwner") then
																				CreditMoney("ChurchOwner",100000,"IncomeOther")
																			end
																		end
																	end
																end
															end
														end
													end
												end
											end
										end
									end
								end
							end
						end
					end
				end
			end
		end
	end
end

function AIEducation()
	local Options = FindNode("\\Settings\\Options")
	local YearsPerRound = Options:GetValueInt("YearsPerRound")
	local Time = 24 / YearsPerRound --This takes into account years per turn so that AI children are not 20yrs old before they become playable adults
	CreateScriptcall("AIEducation",Time,"Measures/Mods/Repopulate.lua","AIEducation","",nil) --Keeps this mod running even if the player turns off the AIHelper
	local SimCount = ScenarioGetObjects("cl_Sim", 99999, "SimList")
	local sim 
	for sim=0,SimCount-1 do --For every sim in the game do the following code for each one at a time and then remove from list
		local SimAlias = "SimList"..sim
		if HasProperty(SimAlias,"IAMAI") then
			if IsDynastySim(SimAlias) then
				if not HasProperty(SimAlias,"AISchool") then
					SetProperty(SimAlias,"AISchool",1)
					local Class = Rand(3)
					if Class == 0 then 
						SimSetClass(SimAlias, 1) --Patron
						IncrementSkillValue(SimAlias,2,1+Rand(3)) -- 2=Dexterity 
						IncrementSkillValue(SimAlias,3,1+Rand(3)) -- 3=Charisma
						IncrementSkillValue(SimAlias,5,1+Rand(3)) -- 5=Handicraft
						IncrementSkillValue(SimAlias,7,1+Rand(3)) -- 7=Rhetoric
						IncrementSkillValue(SimAlias,8,1+Rand(3)) -- 8=Empathy
						IncrementSkillValue(SimAlias,9,1+Rand(3)) -- 9=Bargaining
						IncrementSkillValue(SimAlias,10,1+Rand(3)) -- 10=Secret Knowledge
					elseif Class == 1 then 
						SimSetClass(SimAlias, 2) --Craftsmen
						IncrementSkillValue(SimAlias,1,1+Rand(2)) -- 1=Constitution
						IncrementSkillValue(SimAlias,2,1+Rand(2)) -- 2=Dexterity 
						IncrementSkillValue(SimAlias,3,1+Rand(2)) -- 3=Charisma
						IncrementSkillValue(SimAlias,4,1+Rand(2)) -- 4=Martial Arts
						IncrementSkillValue(SimAlias,5,1+Rand(2)) -- 5=Handicraft
						IncrementSkillValue(SimAlias,9,1+Rand(2)) -- 9=Bargaining
					elseif Class == 2 then 
						SimSetClass(SimAlias, 3) --Scholar
						IncrementSkillValue(SimAlias,3,1+Rand(3)) -- 3=Charisma
						IncrementSkillValue(SimAlias,5,1+Rand(3)) -- 5=Handicraft
						IncrementSkillValue(SimAlias,7,1+Rand(3)) -- 7=Rhetoric
						IncrementSkillValue(SimAlias,8,1+Rand(3)) -- 8=Empathy
						IncrementSkillValue(SimAlias,9,1+Rand(3)) -- 9=Bargaining
						IncrementSkillValue(SimAlias,10,1+Rand(3)) -- 10=Secret Knowledge
					else
						SimSetClass(SimAlias, 4) --Rogue
						IncrementSkillValue(SimAlias,1,1+Rand(1)) -- 1=Constitution
						IncrementSkillValue(SimAlias,2,1+Rand(1)) -- 2=Dexterity 
						IncrementSkillValue(SimAlias,4,1+Rand(1)) -- 4=Martial Arts
						IncrementSkillValue(SimAlias,5,1+Rand(1)) -- 5=Handicraft
						IncrementSkillValue(SimAlias,6,1+Rand(1)) -- 6=Stealth
						IncrementSkillValue(SimAlias,8,1+Rand(1)) -- 8=Empathy
						IncrementSkillValue(SimAlias,9,1+Rand(1)) -- 9=Bargaining
					end
				elseif not HasProperty(SimAlias,"AIApprenticeship") then
					SetProperty(SimAlias,"AIApprenticeship",1)
					if SimGetClass(SimAlias)==1 then
						IncrementSkillValue(SimAlias,2,1+Rand(3)) -- 2=Dexterity 
						IncrementSkillValue(SimAlias,3,1+Rand(3)) -- 3=Charisma
						IncrementSkillValue(SimAlias,5,1+Rand(3)) -- 5=Handicraft
						IncrementSkillValue(SimAlias,7,1+Rand(3)) -- 7=Rhetoric
						IncrementSkillValue(SimAlias,8,1+Rand(3)) -- 8=Empathy
						IncrementSkillValue(SimAlias,9,1+Rand(3)) -- 9=Bargaining
						IncrementSkillValue(SimAlias,10,1+Rand(3)) -- 10=Secret Knowledge
					elseif 	SimGetClass(SimAlias)==2 then
						IncrementSkillValue(SimAlias,1,1+Rand(2)) -- 1=Constitution
						IncrementSkillValue(SimAlias,2,1+Rand(2)) -- 2=Dexterity 
						IncrementSkillValue(SimAlias,3,1+Rand(2)) -- 3=Charisma
						IncrementSkillValue(SimAlias,4,1+Rand(2)) -- 4=Martial Arts
						IncrementSkillValue(SimAlias,5,1+Rand(3)) -- 5=Handicraft
						IncrementSkillValue(SimAlias,9,1+Rand(2)) -- 9=Bargaining
					elseif	SimGetClass(SimAlias)==3 then
						IncrementSkillValue(SimAlias,3,1+Rand(3)) -- 3=Charisma
						IncrementSkillValue(SimAlias,5,1+Rand(3)) -- 5=Handicraft
						IncrementSkillValue(SimAlias,7,1+Rand(3)) -- 7=Rhetoric
						IncrementSkillValue(SimAlias,8,1+Rand(3)) -- 8=Empathy
						IncrementSkillValue(SimAlias,9,1+Rand(3)) -- 9=Bargaining
						IncrementSkillValue(SimAlias,10,1+Rand(3)) -- 10=Secret Knowledge
					else
						IncrementSkillValue(SimAlias,1,1+Rand(3)) -- 1=Constitution
						IncrementSkillValue(SimAlias,2,1+Rand(3)) -- 2=Dexterity 
						IncrementSkillValue(SimAlias,4,1+Rand(3)) -- 4=Martial Arts
						IncrementSkillValue(SimAlias,5,1+Rand(2)) -- 5=Handicraft
						IncrementSkillValue(SimAlias,6,1+Rand(3)) -- 6=Stealth
						IncrementSkillValue(SimAlias,8,1+Rand(2)) -- 8=Empathy
						IncrementSkillValue(SimAlias,9,1+Rand(2)) -- 9=Bargaining
					end
				elseif	SimGetClass(SimAlias) == 3 then 
					if not HasProperty(SimAlias,"AIUniversity") then	
						SetProperty(SimAlias,"AIUniversity",1)
						IncrementSkillValue(SimAlias,3,1+Rand(3)) -- 3=Charisma
						IncrementSkillValue(SimAlias,5,1+Rand(3)) -- 5=Handicraft
						IncrementSkillValue(SimAlias,7,1+Rand(3)) -- 7=Rhetoric
						IncrementSkillValue(SimAlias,8,1+Rand(3)) -- 8=Empathy
						IncrementSkillValue(SimAlias,9,1+Rand(3)) -- 9=Bargaining
						IncrementSkillValue(SimAlias,10,1+Rand(3)) -- 10=Secret Knowledge
					elseif SimGetAge(SimAlias) >= GL_AGE_FOR_GROWNUP then
						local Age = SimGetAge(SimAlias)
						SimSetAge(SimAlias, Age)
						-- Remove the child state so that the child can be controlled
						SetState(SimAlias, STATE_CHILD, false)		
						SimSetBehavior(SimAlias,"")
						SimResetBehavior(SimAlias)
						f_EndUseLocator(SimAlias,"PlayPos",GL_STANCE_STAND)
						RemoveProperty(SimAlias,"IAMAI")
					end
				elseif SimGetAge(SimAlias) >= GL_AGE_FOR_GROWNUP then
					local Age = SimGetAge(SimAlias)
					SimSetAge(SimAlias, Age)
					-- Remove the child state so that the child can be controlled
					SetState(SimAlias, STATE_CHILD, false)		
					SimSetBehavior(SimAlias,"")
					SimResetBehavior(SimAlias)
					f_EndUseLocator(SimAlias,"PlayPos",GL_STANCE_STAND)
					RemoveProperty(SimAlias,"IAMAI")
				end 
			end
		end
	end
	if HasProperty("","FirstRun") then
		repopulate_CleanUp()
	end
end

function AIDoctorTitle()
	local Doctor = Find("", "__F((Object.GetObjectsOfWorld(Building))AND(Object.IsType(37)))","DrOffice", -1) --returns Hospitals in the current game
	local idx
	for idx=0, Doctor-1 do --for all Hospitals in the game do the following code one at the time for each Hospital and remove from the list when done
		local Hospital = "DrOffice"..idx --returns generic useable alias for all the Hospitals on the map
		if BuildingGetOwner(Hospital,"SirDoctor") then
			if AliasExists("SirDoctor") then
				if not DynastyIsPlayer("SirDoctor") then
					if not SimGetClass("SirDoctor")==3 then
						SimSetClass("SirDoctor", 3)
					end	
				end 
				if not HasProperty("SirDoctor","IAmDoctor") then
					SetProperty("SirDoctor","IAmDoctor",1)
					SetNobilityTitle("SirDoctor", NOBILITY_DOCTOR)
				end
			end
		end
	end
end

function AssignBuildingOwners()
	local WorldBuildings = Find("", "__F((Object.GetObjectsOfWorld(Building))AND(Object.IsClass(2)))","AllBuildings", -1)
	local Idx
	for Idx=0, WorldBuildings-1 do
		local OwnerlessBuilding = "AllBuildings"..Idx
		if not BuildingGetOwner(OwnerlessBuilding,"Check") then
			local Class = BuildingGetCharacterClass(OwnerlessBuilding)
			local Level
			if BuildingGetLevel(OwnerlessBuilding) == 1 then
				Level = 1
			elseif BuildingGetLevel(OwnerlessBuilding) == 2 then
				Level = 3
			else
				Level = 5
			end
			
			if Class ~= -1 then
				local sim
				local SimCount = ScenarioGetObjects("cl_Sim", 99999, "SimList")
				ListNew("Bums")
				for sim=0,SimCount-1 do
					local SimAlias = "SimList"..sim
					if DynastyIsShadow(SimAlias) then
						if SimGetAge(SimAlias) >= GL_AGE_FOR_GROWNUP then
							if GetNobilityTitle(SimAlias) > 1 then
								if SimGetClass(SimAlias) == Class then -- <--- Ensure the Sim will be able to use the building by making sure only sims with the buildings class make it on the list
									if SimGetLevel(SimAlias) >= Level then -- <-- The Shadow dynasty needs to have the right to own the buiding or an error pops up (level 3 building requires the sim to be at level 5..ect)
										if IsDynastySim(SimAlias) then
											if BuildingCanBeOwnedBy(OwnerlessBuilding,SimAlias) then
												ListAdd("Bums",SimAlias)
											end
										end
									end
								end
							end
						end
					end
				end
				local LotteryTicket = ListSize("Bums")
				if ListGetElement("Bums",Rand(LotteryTicket),"LotteryWinner") then -- <---this makes sure a random person on the list gets the buiding...it may sort alphabetically meaning 4 people from the same class would be getting all the buildings...this ensures that possibility does not happen :)
					if AliasExists("LotteryWinner") then
						CreateScriptcall("AIAcquireBuilding",0.05,"Measures/Mods/NoOwner.lua","AIBuy",OwnerlessBuilding,"LotteryWinner")
						CreateScriptcall("SellBuilding",0.25,"Measures/Mods/NoOwner.lua","AISell",OwnerlessBuilding,nil)
					else --if no Shadow dynasty owner is acceptable then AI dynasty is better then no one :)
						for sim=0,SimCount-1 do
							local SimAlias = "SimList"..sim
							if DynastyIsAI(SimAlias) then
								if not DynastyIsShadow(SimAlias) then
									if not HasProperty(SimAlias,"BugFix") then
										if SimGetAge(SimAlias) >= GL_AGE_FOR_GROWNUP then
											if GetNobilityTitle(SimAlias) > 1 then
												if SimGetClass(SimAlias) == Class then -- <--- Ensure the Sim will be able to use the building by making sure only sims with the buildings class make it on the list
													if SimGetLevel(SimAlias) >= Level then -- <-- The Shadow dynasty needs to have the right to own the buiding or an error pops up (level 3 building requires the sim to be at level 5..ect)
														if BuildingCanBeOwnedBy(OwnerlessBuilding,SimAlias) then
															if IsDynastySim(SimAlias) then
																ListAdd("Bums",SimAlias)
															end
														end
													end
												end
											end
										end
									end
								end
							end
						end
						local SecondLottery = ListSize("Bums")
						if ListGetElement("Bums",Rand(SecondLottery),"NewLotteryWinner") then
							if AliasExists("NewLotteryWinner") then
								CreateScriptcall("AIAcquireBuilding",0.05,"Measures/Mods/NoOwner.lua","AIBuy",OwnerlessBuilding,"NewLotteryWinner")
								CreateScriptcall("SellBuilding",0.25,"Measures/Mods/NoOwner.lua","AISell",OwnerlessBuilding,nil)
							else
								MsgQuick("All","@L_NOOWNER_ERROR_ONE")
							end
						end
					end
				end
			end
		end
	end
end

function CharismaBonus()
	
	ListNew("Dynasties")
	local Difficulty = ScenarioGetDifficulty()
	local Formula = 0
	if Difficulty < 2 then
		Formula = 10
	elseif Difficulty == 2 then
		Formula = 5
	else
		Formula = 3
	end
	
	local j
	local Dyn
	local DynCount = ScenarioGetObjects("cl_Dynasty", 9999, "DynList")
	for Dyn=0,DynCount-1 do
		local DynAlias = "DynList"..Dyn
		ListAdd("Dynasties",DynAlias)
		local Count = DynastyGetFamilyMemberCount(DynAlias)
		for j=0, Count-1 do
			if DynastyGetFamilyMember(DynAlias,j,"FamMbr") then
			--	LogMessage("Family Member = "..SimGetLastname("FamMbr"))
				if SimGetAge("FamMbr") >= GL_AGE_FOR_GROWNUP then
					if DynastyIsShadow("FamMbr") or IsPartyMember("FamMbr") then
						local Charisma = GetSkillValue("FamMbr", "CHARISMA")
						if HasProperty(DynAlias,"AdultCount") then
							local Count = GetProperty(DynAlias,"AdultCount")
							local PCharisma = GetProperty(DynAlias,"TotalCharisma")
							SetProperty(DynAlias,"AdultCount",Count+1)
							SetProperty(DynAlias,"TotalCharisma",PCharisma+Charisma)
						else
							SetProperty(DynAlias,"AdultCount",1)
							SetProperty(DynAlias,"TotalCharisma",Charisma)
						end
					end
				end
			end
		end
	end
	
	
	local Modifier = {}
		Modifier[-5] = 0
		Modifier[-4] = 0
		Modifier[-3] = 0
		Modifier[-2] = 0
		Modifier[-1] = 0
		Modifier[0] = 0
		Modifier[1] = 1
		Modifier[2] = 3
		Modifier[3] = 5
		Modifier[4] = 7
		Modifier[5] = 10
		Modifier[6] = 15
		Modifier[7] = 20
		Modifier[8] = 30
		Modifier[9] = 40
		Modifier[10] = 50
		Modifier[11] = 55
		Modifier[12] = 60
		Modifier[13] = 65
		Modifier[14] = 70
		Modifier[15] = 75
		
	local i
	local Dy
	for i=0,ListSize("Dynasties")-1 do
		if ListGetElement("Dynasties",i,"Elvis") then 
			for Dy=0,DynCount-1 do
				local DynAlias = "DynList"..Dy
				if GetID(DynAlias) ~= GetID("Elvis") then
					local Relations = DynastyGetDiplomacyState("Elvis",DynAlias)
					local Z = GetProperty("Elvis","TotalCharisma")
					local Y = GetProperty("Elvis","AdultCount")
					if (Z ~= nil) and (Y ~= nil) then
						local X = math.floor(Z/Y+0.5) ---<---Neat trick to get result to round properly to the nearest whole number
					--	LogMessage("Charisma: RoundedNumber = "..X)
						if Relations == DIP_ALLIANCE then
							Formula = Formula+10
							ModifyFavorToSim(DynAlias,"Elvis",Formula+Modifier[X])
						elseif Relations == DIP_NAP then
							Formula = Formula+5
							ModifyFavorToSim(DynAlias,"Elvis",Formula+Modifier[X])
						elseif Relations == DIP_FOE then
							Formula = Formula-5
							ModifyFavorToSim(DynAlias,"Elvis",Formula+Modifier[X])
						else
							ModifyFavorToSim(DynAlias,"Elvis",Formula+Modifier[X])
						end
					end
					if HasProperty("Elvis","TotalCharisma") then
						RemoveProperty("Elvis","TotalCharisma")
					end
					if HasProperty("Elvis","AdultCount") then
						RemoveProperty("Elvis","AdultCount")
					end
				end
			end
		end
	end
end

function BuildingCheck()
	Sleep(30)
	local CityCount = ScenarioGetObjects("Settlement", -1, "City")
	local idx
	local i
	for idx=0, CityCount-1 do
		local MaCity = "City"..idx
		if CityGetLevel(MaCity) > 3 then --Large Cities
			local AIBusiness = CityGetBuildings(MaCity, 2, -1, 2, -1, FILTER_IGNORE, "AIWorkshop")
			for i=0,AIBusiness-1 do
				local AIWorkplace = "AIWorkshop"..i
				if AliasExists(AIWorkplace) then
					BuildingGetOwner(AIWorkplace,"AIOwner")
					if AliasExists("AIOwner") then
						if not DynastyIsPlayer("AIOwner") then
							BuildingLevelMeUp(AIWorkplace)
						end
					end
				end
			end
		end
	end
end
