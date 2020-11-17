function Weight() 
	
-- 	local Time = math.mod(GetGametime(), 24)
-- 	if not (Time>20 or Time<6) then
-- 		return 0
-- 	end
	if not AliasExists("SIM") then
		return 0
	end
	
	if not GetDynastyID("SIM") then
		return 0
	end
	
	if SimGetClass("SIM") ~= 4 or SimGetProfession("SIM") ~= 26 then
		return 0
	end
		
	if not DynastyGetRandomVictim("SIM", 55, "victimburgle") then
		return 0
	end
		
	if DynastyGetDiplomacyState("SIM", "victimburgle") > DIP_NEUTRAL then
		return 0
	end
	
	if not DynastyGetRandomBuilding("victimburgle", -1, -1, "BurgleHouse") then
		return 0
	end
	
	if BuildingGetType("BurgleHouse") == -1 or BuildingGetType("BurgleHouse") == 1 then
		return 0
	end
	
	if GetState("BurgleHouse",STATE_BUILDING) then
		return 0
	end
	
	if GetImpactValue("BurgleHouse","Unantastbar") > 0 then
		return 0
	end
	
	if BuildingGetClass("BurgleHouse") == 1 or BuildingGetClass("BurgleHouse") == 2 then
		if not BuildingGetOwner("BurgleHouse","Boss") then
			return 0
		end
		
		if IsDynastySim("SIM") then
			if DynastyGetDiplomacyState("SIM", "Boss") > DIP_NEUTRAL then
				return 0
			end
		else
			if SimGetWorkingPlace("SIM","MaiWrk") and BuildingGetOwner("MaiWrk","MeBoss") then
				if DynastyGetDiplomacyState("MeBoss", "Boss") > DIP_NEUTRAL then
					return 0
				end
			else
				return 0
			end
		end
		
		if GetImpactValue("BurgleHouse","buildingburgledtoday")==1 then
			return 0
		end
		
		return 100
	else
		return 0
	end
end

function Execute()
	
	local DynID = nil 
	if IsDynastySim("SIM") then
		DynID = GetDynastyID("SIM")
	elseif SimGetWorkingPlace("SIM","MaWrk") and BuildingGetOwner("MaWrk","MeBossMan") then
		DynID = GetDynastyID("MeBossMan")
	else
		return
	end
	
	if DynID ~= nil then
		if not HasProperty("BurgleHouse","ScoutedBy"..DynID) then
			MeasureRun("SIM","BurgleHouse","ScoutAHouse")
			return
		end
		MeasureRun("SIM","BurgleHouse","BurgleAHouse")
		return
	else
		return
	end
end

function CleanUp()
end
