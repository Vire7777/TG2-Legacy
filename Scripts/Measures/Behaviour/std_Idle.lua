function Run()
	
	if HasProperty("","Berserker") then
		RemoveProperty("","Berserker")   
	end
	
	if GetState("", STATE_WORKING) then
		std_idle_Worker("")
		return
	end
	
	local Activity = idlelib_GetActivity("")
	local ActiveMovement = false
	if Rand(100) < Activity then
		ActiveMovement = true
	end
	
	if (SimGetGender("")==GL_GENDER_FEMALE) then
		idlelib_KissMeHonza("")
	end
	
	if not ActiveMovement then
		if GetHomeBuilding("", "HomeBuilding") then
			local Distance = GetDistance("", "HomeBuilding")
			if Distance > 100 then
				idlelib_GoHome("")
			else
				idlelib_DoNothing("")
			end
		end
	end
	
	if SimGetAge("")<16 then
		return
	end
	
	if not IsDynastySim("")	then
		if not GetHomeBuilding("", "HomeBuilding") then
			if GetNearestSettlement("", "City") then
				if CityGetRandomBuilding("City", -1, GL_BUILDING_TYPE_WORKER_HOUSING, 1, -1, FILTER_IGNORE, "HomeBuilding") then
					SetHomeBuilding("", "HomeBuilding")
				end
			end
		end
	end 
	
	if not (GetImpactValue("","Sickness")>0) then
		MoveSetActivity("","")
	end	
	
	local DoNothing = GetProperty("", "_DO_NOTHING_TIME")
	if DoNothing then
		RemoveProperty("", "_DO_NOTHING_TIME")
		if DoNothing==0 then
			DoNothing = 0.5
		end
		DoNothing = Gametime2Realtime(DoNothing)
		Sleep(DoNothing)
	end 
	
	if ((GetImpactValue("","Sickness")>0) or (GetHP("") < GetMaxHP("")/2)) then
		if gameplayformulas_CheckMoneyForTreatment("")==1 then
			idlelib_VisitDoc("")
		end
	end
	
	if (GetImpactValue("","Fever")==1) or (GetImpactValue("","Cold")==1) or (GetImpactValue("","BurnWound")==1) or (GetImpactValue("","Caries")==1) then
		idlelib_Illness("")
		return
	end
	
	if GetSettlement("","MyCity") then
		if HasProperty("MyCity","InquisitionOnTheRun") then
			if (GetImpactValue("","WasInChurch")~=1) then
				local MyReligion = SimGetReligion("")
				local InquisitionReligion = GetProperty("MyCity","InquisitionOnTheRun")
				if InquisitionReligion ~= MyReligion then
					idlelib_ChangeReligion("",InquisitionReligion)
				end
			end
		end
	end
	
	if ActiveMovement then
		local checkBOK = false
		if HasProperty("", "TimeBank") then
			local gtime = GetProperty("", "TimeBank")
			if gtime < GetGametime() then
				checkBOK = true
			end
		else
			checkBOK = true
		end
		
		local Fneed = SimGetNeed("", 9)
		if (Fneed > 1) and (checkBOK) then
			idlelib_CheckBank("")
			return
		end
	end
	
	if GetHomeBuilding("","HomeBuilding") then
		if BuildingHasIndoor("HomeBuilding") and SimIsCourting("")==false then
			local MaID = GetID("")
			if MaID == nil then
				return
			end
			local offset 	= math.mod(MaID, 30) * 0.1
			local time 		= math.mod(GetGametime(),24)
			local	StartSleep 	= 22+offset
			local EndSleep 	= 6+offset
			
			if time > StartSleep or time < EndSleep then
				-- *******************************************
				--
				-- satisfy need sleep
				--
				-- *******************************************
				
				--debug
				idlelib_Sleep("", 23+offset, 7+offset)
				return
			end
		end
	end
	
	if not idlelib_CheckWeather() then
		if not SimIsCourting("") and GetHomeBuilding("", "HomeBuilding") then
			idlelib_GoHome("")
			Sleep(Rand(10)+10)
			return
		end
	end
	
	if ActiveMovement then
		if (SimGetGender("")==GL_GENDER_FEMALE) then
			idlelib_KissMeHonza("")
		end
		
		if (SimGetNeed("", 4)>1) and (GetImpactValue("","WasInChurch")~=1) then
			
			-- *******************************************
			--
			-- satisfy need religion
			--
			-- *******************************************
			if Rand(50) >= 40 then
				idlelib_Graveyard("")
				return
			else
				if SimGetProfession("")~=GL_PROFESSION_PRIEST then
					if SimGetChurch("", "church") then
						if BuildingGetOwner("church","churchowner") then
							MeasureRun("", "church", "AttendMass")
							return
						end
					end
				end
			end
		end
		if SimGetAge("")>20 then
			if SimGetNeed("", 8)>1 then
				-- *******************************************
				--
				-- satisfy need drinking
				--
				-- *******************************************
				if SimGetClass("") == 4 then
					idlelib_GoToDivehouse("")
				else
					if Rand(3) == 1 then
						idlelib_GoToDivehouse("")
					else
						idlelib_GoToTavern("")
					end
				end
				return
			end
			if SimGetNeed("", 2)>1 then
				-- *******************************************
				--
				-- satisfy need pleasure
				--
				-- *******************************************
				if Rand(2) == 0 then
					if SimGetClass("") == 4 then
						idlelib_GoToDivehouse("")
					else
						if Rand(3) == 1 then
							idlelib_GoToDivehouse("")
						else
							idlelib_GoToTavern("")
						end
					end				
				else
					if SimGetGender("")==GL_GENDER_MALE then
						idlelib_UseCocotte("")
					else
						idlelib_KissMeHonza("")
					end
				end
				
				return
			end
		end
		
		if SimGetNeed("", 1)>1 then
			-- *******************************************
			--
			-- satisfy need eat
			--
			-- *******************************************
			local time = math.mod(GetGametime(),24)
			if time >= 8 and time <= 18 then
				if Rand(2) == 0 then
					idlelib_BuySomethingAtTheMarket("")
					MoveSetActivity("","")
					CarryObject("","",false)
				else
					idlelib_CheckInsideStore("")
				end
			else
				idlelib_BuySomethingAtTheMarket("")
				MoveSetActivity("","")
				CarryObject("","",false)
			end
			return
		end
		
		if SimGetNeed("", 7)>1 then
			-- *******************************************
			--
			-- satisfy need konsum
			--
			-- *******************************************
			local time = math.mod(GetGametime(),24)
			if time >= 8 and time <= 18 then
				if Rand(3) == 0 then
					idlelib_BuySomethingAtTheMarket("")
					MoveSetActivity("","")
					CarryObject("","",false)
				else
					idlelib_CheckInsideStore("")
				end
			else
				idlelib_BuySomethingAtTheMarket("")
				MoveSetActivity("","")
				CarryObject("","",false)
			end
			return
		end
		
		if SimGetNeed("", 3)>1 then
			
			-- ******** THANKS TO KINVER ********
			if HasProperty("","SchuldenGeb") then
				SatisfyNeed("", 9, -0.13)
			else
				SatisfyNeed("", 9, -0.1)
			end
			-- **********************************
			
			-- *******************************************
			--
			-- satisfy need talk
			--
			-- *******************************************
			
			
			local TalkPartners = Find("", "__F((Object.GetObjectsByRadius(Sim)==1000)AND NOT(Object.GetStateImpact(no_idle))AND(Object.CanBeInterrupted(Babble)))","TalkPartner", -1)
			if TalkPartners>0 then
				MeasureRun("", "TalkPartner"..Rand(TalkPartners), "Babble" )
				return
			end
			
		end
	end
	
	if not IsPartyMember("") then
		
		if GetSettlement("","City") then
			local CityLevel = CityGetLevel("City")
			local SicknessChance = Rand(100)
			local Season = GetSeason()
			if season == EN_SEASON_AUTUMN or EN_SEASON_WINTER then
				SicknessChance = Rand(50)
			end
			if CityLevel > 4 then
				if SicknessChance == 1 then
					diseases_Cold("",true,false)
				elseif SicknessChance == 2 then
					diseases_Sprain("",true,false)
				elseif SicknessChance == 6 then
					diseases_Fracture("",true,false)
				elseif SicknessChance == 7 then
					diseases_Influenza("",true,false)
				end
			elseif CityLevel > 2 then
				if SicknessChance < 6 then
					diseases_Cold("",true,false)
				elseif SicknessChance < 9 then
					diseases_Sprain("",true,false)
				elseif SicknessChance < 11 then
					diseases_Influenza("",true,false)
				end
			else
				if SicknessChance < 10 then
					diseases_Cold("",true,false)
				elseif SicknessChance < 15 then
					diseases_Sprain("",true,false)
				end
			end
		
			--Repair Homebuilding if damaged and if not dynsim
			if GetDynastyID("") <= 0 then
				if not (GetImpactValue("","Sickness")>0) then
					if GetHomeBuilding("","HomeBuilding") then
						local CurrentHP = GetHPRelative("HomeBuilding")
						if CurrentHP <= 0.9 then
							if Rand(100) > 50 then
								idlelib_RepairHome("","HomeBuilding")
							end
						end
					end
				end
			end
		
		
			if ActiveMovement then
				f_ExitCurrentBuilding("")
				Sleep(Rand(10)+5)
				local toast = Rand(3)
				local WhatToDo = Rand(100)
				if GetImpactValue("","Sickness")>0 then
					if WhatToDo > 90 then
						if toast == 0 then
							idlelib_GoToRandomPosition("")
						elseif toast == 1 then
							idlelib_GoToTavern("")
						else
							idlelib_GoToDivehouse("")
						end
					elseif WhatToDo > 60 then
						if SimIsCourting("")==false then
							idlelib_GoHome("")
						end
					elseif WhatToDo > 30 then	
						idlelib_SitDown("")
					elseif WhatToDo > 0 then
						idlelib_DoNothing("")
					end
				else
					if WhatToDo == 99 then
						if GetHPRelative("")>0.3 then
							local FightPartners = Find("", "__F((Object.GetObjectsByRadius(Sim)==3000)AND(Object.MinAge(16))AND(Object.IsClass(3))AND NOT(Object.GetState(animal))AND NOT(Object.HasDynasty())AND NOT(Object.GetState(unconscious))AND NOT(Object.GetState(dead))AND(Object.CompareHP()>30))","FightPartner", 1)
							if FightPartners>0 then
								idlelib_ForceAFight("","FightPartner")
								return
							end
						end
					elseif WhatToDo > 85 and not HasProperty("","SchuldenGeb") then
						idlelib_TakeACredit("")
					elseif WhatToDo > 85 and HasProperty("", "SchuldenGeb") then
						idlelib_ReturnACredit("")
					elseif WhatToDo > 65 then
						if toast == 0 then
							idlelib_GoToTavern("")
						else
							idlelib_GoToDivehouse("")
						end
					elseif WhatToDo > 50 then
						if SimGetChurch("", "church") then
							if BuildingGetOwner("church","churchowner") then
								MeasureRun("", "church", "AttendMass")
							end
						end
					elseif WhatToDo > 35 then
						idlelib_Graveyard("")
					elseif WhatToDo > 20 then
						idlelib_CheckInsideStore("")
					elseif WhatToDo > 15 then
						idlelib_GoTownhall("")
					elseif WhatToDo > 10 then
						idlelib_SitDown("")
					elseif WhatToDo > 5 then
						idlelib_GetCorn("")
					elseif WhatToDo >= 0 then
						idlelib_CollectWater("")
					end
				end
			else
				if GetHomeBuilding("", "HomeBuilding") then
					idlelib_GoHome("")
				else
					idlelib_GoToRandomPosition("")
				end
			end
		end
	end
	--ChangeAnimation("", "idle")
	
	if AliasExists("") and (SimGetGender("")==GL_GENDER_FEMALE) then
		idlelib_KissMeHonza("")
	end
	
	Sleep(Rand(10)+5)
	
end

function Worker(Alias) --McCoy Fix
	
	if HasProperty(Alias, "StartWorkingTime") then
		RemoveProperty(Alias, "StartWorkingTime")
		local	AtPlace	= SimGetAssignedAreaID(Alias) == SimGetWorkingPlaceID(Alias)
		if SimGetWorkingPlace(Alias, "WorkingPlace") then
			if DynastyIsShadow(Alias) then
				if not f_MoveTo(Alias, "WorkingPlace", GL_MOVESPEED_RUN) then
					SimBeamMeUp(Alias,"WorkingPlace",false)
				end
			end
			local SicknessChance = Rand(100)
			if SicknessChance == 1 then
				diseases_Sprain(Alias,true,false)
			elseif SicknessChance == 2 then
				diseases_Cold(Alias,true,false)
			end
			
			if ((GetImpactValue(Alias,"Sickness")>0) or (GetHP(Alias) < GetMaxHP(Alias)/4)) then
				if gameplayformulas_CheckMoneyForTreatment(Alias)==1 then
					idlelib_VisitDoc(Alias)
				end
			end
			
		end
	end
	
	local	AtPlace	= SimGetAssignedAreaID(Alias) == SimGetWorkingPlaceID(Alias)
	
	if AtPlace then
		if SimGetProfession(Alias) == GL_PROFESSION_THIEF then
			if HasProperty(Alias,"SchuldenGeb") then
				idlelib_ReturnACredit(Alias)
			end
			idlelib_ThiefIdle(Alias)
			return
		elseif SimGetProfession(Alias) == GL_PROFESSION_ROBBER then
			if HasProperty(Alias,"SchuldenGeb") then
				idlelib_ReturnACredit(Alias)
			end
			idlelib_RobberIdle(Alias)
			--idlelib_GoToDivehouse(Alias)
			return
		elseif SimGetProfession(Alias) == GL_PROFESSION_MYRMIDON then
			if HasProperty(Alias,"SchuldenGeb") then
				idlelib_ReturnACredit(Alias)
			end
			idlelib_MyrmidonIdle(Alias)
			return
		elseif SimGetProfession(Alias) == 74 then
			if HasProperty(Alias,"SchuldenGeb") then
				idlelib_ReturnACredit(Alias)
			end
			idlelib_LeibwacheIdle(Alias)
			return
		elseif SimGetProfession(Alias) == 17 then
			if HasProperty(Alias,"SchuldenGeb") then
				idlelib_ReturnACredit(Alias)
			end
			idlelib_LeibwacheIdle(Alias)
			return
		end	
	else
		if HasProperty(Alias,"SchuldenGeb") then
			idlelib_ReturnACredit(Alias)
		end
	end
	
	Sleep(120)
	return
	
end


-- -----------------------
-- CleanUp
-- -----------------------
function CleanUp()
	StopAction("brawl","")
	if AliasExists("SitPos") then
		f_EndUseLocator("","SitPos",GL_STANCE_STAND)
	end
	if GetState("",STATE_SLEEPING) then
		SetState("",STATE_SLEEPING,false)
	end
	--RemoveAllOverheadSymbols("")
	StopAnimation("")
	MoveSetStance("",GL_STANCE_STAND)
	if not (GetImpactValue("","Sickness")>0) then
		MoveSetActivity("","")
	end
	CarryObject("","",true)
	CarryObject("","",false)
	if HasProperty("","WaitingForTreatment") then
		RemoveProperty("","WaitingForTreatment")
	end
	if AliasExists("SleepPosition") then
		f_EndUseLocatorNoWait("", "SleepPosition", GL_STANCE_STAND)
		RemoveAlias("SleepPosition")
	end
	if AliasExists("ChairPos") then
		f_EndUseLocatorNoWait("", "ChairPos", GL_STANCE_STAND)
		RemoveAlias("ChairPos")
	end
	if HasProperty("","ProTCBank") then
		RemoveProperty("","ProTCBank")
	end
	if HasProperty("","ProRCBank") then
		RemoveProperty("","ProRCBank")
	end
	if HasProperty("","KissMeHoney") then
		RemoveProperty("","KissMeHoney")
	end
end

