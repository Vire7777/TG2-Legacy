function Weight()
	
	if SimGetAge("SIM") < GL_AGE_FOR_GROWNUP then
		return 0
	end
	
	local Time = math.mod(GetGametime(),24)
	if Time < 4 or Time > 10 then
		return 0
	end
	
	local ApplyTime = 24-Time
	local TimerName = "AI_Office"
	if not ReadyToRepeat("SIM", TimerName) then
		return 0
	end
	SetRepeatTimer("SIM", "AI_Office", 1)
	
	if GetNobilityTitle("SIM") < 5 and SimGetOfficeLevel("SIM") > 0 then
		return 0
	end
	
	if SimGetOfficeID("Sim") == -1 then
		if SimIsAppliedForOffice("Sim") then
			return 0
		end
	end
	
	if not find_HomeCity("SIM", "CITY_OF_OFFICE") then
		return 0
	end

	--Prevent Office Applications on the first turn otherwise higher office holders run for lower offices.
	
	if GetRound() == 0 then
		local DelayTime = 1
		local Difficulty = ScenarioGetDifficulty()
		if Difficulty < 2 then
			DelayTime = 240
		elseif Difficulty == 2 then
			DelayTime = 120
		else
			DelayTime = 60
		end
		--Added Repopulate Initialization into this check as it will be ignored after the first round. PERFECT!
		CityGetBuildings("CITY_OF_OFFICE",GL_BUILDING_CLASS_PUBLICBUILDING,GL_BUILDING_TYPE_TOWNHALL,-1,-1,FILTER_IGNORE,"Parliament")
		if GetProperty("Parliament0","InitiateRepopulate") ~= 1 then
			local TownHall = Find("Parliament0", "__F((Object.GetObjectsOfWorld(Building))AND(Object.IsType(23)))","CityCenter", -1) --this finds all the townhalls on the map
			local idx
			for idx=0, TownHall-1 do --This reads...For all the town halls on the map do the following code on each one at a time
				local CityH = "CityCenter"..idx --returns a useable alias for the below codes
				SetProperty(CityH, "InitiateRepopulate", 1) -- Needed a new property to ensure AI did not spam measure to start the game
				AddImpact(CityH,"Delay",1,DelayTime)
				SetProperty(CityH, "CancelRun", 1) --This is used in the Run() function of this file, in CancelRepopulate.lua file and filter.dbt file so that when the Repopulate button disappears the Cancel button appears and vice versa 
			end
			MeasureRun("Parliament0",nil,"Repopulate",true)
		end
		return 0
	end
	
	local X = SimGetOfficeLevel("SIM")
 	if X > 4 then
		return 0
	end
	
	-- Checks if OfficeSim Has Applied For New Office
	if SimGetOfficeID("SIM") ~= -1 then
		if SimIsAppliedForOffice("SIM") then
			if SimGetOffice("SIM","CurrentOffice") then
				if GetOfficeByApplicant("SIM","AppliedOffice") then
					local Y = SimGetOfficeIndex("SIM")
					if OfficeGetLevel("AppliedOffice") ~= OfficeGetLevel("CurrentOffice") or OfficeGetIdx("AppliedOffice") ~= Y  then --If this returns false it means that the AI has already applied for an office and no help is required
						return 0
					end
				end
			end
		end
	end
	
	local Level = {}
		Level[-1] = 1
		Level[0] = 1
		Level[1] = 2
		Level[2] = 3
		Level[3] = 4
		Level[4] = 5
		Level[5] = -1
		Level[6] = -1
		
	local Ret
	if X > 0 then
		local Z = SimGetOfficeIndex("SIM")
		local OfficeIdx = {}
			OfficeIdx[0] = 1
			OfficeIdx[1] = 0
		if CityGetOffice("CITY_OF_OFFICE", Level[X], Z, "OFFICE") then
			Ret = ac_applyforoffice_CheckOffice("OFFICE")
			if Ret=="Apply" then
				CopyAlias("OFFICE", "APPLY_OFFICE")
				return 100
			elseif CityGetOffice("CITY_OF_OFFICE", Level[X], OfficeIdx[Z], "OFFICETWO") then
				Ret = ac_applyforoffice_CheckOffice("OFFICETWO")
				if Ret=="Apply" then
					CopyAlias("OFFICETWO", "APPLY_OFFICE")
					return 100
				end
			end
		elseif CityGetOffice("CITY_OF_OFFICE", Level[X], OfficeIdx[Z], "OFFICE") then
			Ret = ac_applyforoffice_CheckOffice("OFFICE")
			if Ret=="Apply" then
				CopyAlias("OFFICE", "APPLY_OFFICE")
				return 100
			end
		end
	elseif CityGetOffice("CITY_OF_OFFICE", Level[X], 0, "OFFICE") then
		if CityGetOffice("CITY_OF_OFFICE", Level[X], 1, "OFFICETWO") then
			local AppCnt1 = OfficeGetApplicantCount("OFFICE")
			local AppCnt2 = OfficeGetApplicantCount("OFFICETWO")
			if AppCnt1 == 0 then
				Ret = ac_applyforoffice_CheckOffice("OFFICE")
				if Ret=="Apply" then
					CopyAlias("OFFICE", "APPLY_OFFICE")
					return 100
				else
					Ret = ac_applyforoffice_CheckOffice("OFFICETWO")
					if Ret=="Apply" then
						CopyAlias("OFFICETWO", "APPLY_OFFICE")
						return 100
					end
				end
			elseif AppCnt2 == 0 then
				Ret = ac_applyforoffice_CheckOffice("OFFICETWO")
				if Ret=="Apply" then
					CopyAlias("OFFICETWO", "APPLY_OFFICE")
					return 100
				else
					Ret = ac_applyforoffice_CheckOffice("OFFICE")
					if Ret=="Apply" then
						CopyAlias("OFFICE", "APPLY_OFFICE")
						return 100
					end
				end
			elseif AppCnt2 > AppCnt1 then
				Ret = ac_applyforoffice_CheckOffice("OFFICE")
				if Ret=="Apply" then
					CopyAlias("OFFICE", "APPLY_OFFICE")
					return 100
				else
					Ret = ac_applyforoffice_CheckOffice("OFFICETWO")
					if Ret=="Apply" then
						CopyAlias("OFFICETWO", "APPLY_OFICE")
						return 100
					end
				end
			else
				Ret = ac_applyforoffice_CheckOffice("OFFICE")
				if Ret=="Apply" then
					CopyAlias("OFFICE", "APPLY_OFFICE")
					return 100
				else
					Ret = ac_applyforoffice_CheckOffice("OFFICETWO")
					if Ret=="Apply" then
						CopyAlias("OFFICETWO", "APPLY_OFFICE")
						return 100
					end
				end
			end
		else
			Ret = ac_applyforoffice_CheckOffice("OFFICE")
			if Ret=="Apply" then
				CopyAlias("OFFICE", "APPLY_OFFICE")
				return 100
			end
		end
	end
	return 0
end

function CheckOffice(Alias)
	if OfficeGetHolder(Alias, "OfficeHolder") then
		-- check if the holder is in the same Dynasty
		if GetDynastyID("SIM") == GetDynastyID("OfficeHolder") then
			return 0
		end
		
		-- -- check office with a holder
		local DipToSim = DynastyGetDiplomacyState("OfficeHolder","SIM")
		if DipToSim == DIP_ALLIANCE then
		-- if --[[DynastyIsShadow("SIM")==false and]] GetFavorToSim("SIM", "OfficeHolder") < 95 then
			return 0
		end
	end

	if OfficeGetApplicantCount(Alias) > 2 then
		return 0
	end

	return "Apply"
end

function Execute()
	MeasureRun("SIM", "APPLY_OFFICE", "RunForAnOffice",true)
	return
end

function CleanUp()
end
