function Weight()
	local Hour = math.mod(GetGametime(), 24)
	if Hour > 21 and Hour < 5 then
		return 0
	end

	if IsDynastySim("SIM") then
		return 0
	end
	
	for trys=0,9 do
		if robber_plunder_Check() then
			return 100
		end
	end
	return 0
end

function Check()
	
	if not DynastyGetRandomVictim("SIM", 55, "PLU_VICTIM") then
		return false
	end
	
	if DynastyGetDiplomacyState("SIM", "PLU_VICTIM") > DIP_NEUTRAL then
		return false
	end
	
	if not DynastyGetRandomBuilding("PLU_VICTIM", GL_BUILDING_CLASS_WORKSHOP, -1, "PLU_BUILD") then
		return false
	end
	
	if GetState("PLU_BUILD", STATE_BUILDING) then
		return false
	end
	
	if GetImpactValue("PLU_BUILD","buildingburgledtoday") ~= 0 then
		return false
	end
	
	local Count = Find("PLU_BUILD", "__F((Object.GetObjectsByRadius(Building)==3000))","PLU_Found", -1)
	
	local	Var 	= 100
	local	Alias
	local Class
	
	for i=0, Count-1 do
		Alias = "PLU_Found"..i
		Class 	= BuildingGetClass(Alias)
		
		if Class~=GL_BUILDING_CLASS_RESOURCE and Class~=0 then
			Var = Var - 30
		end
	end
	
	if Rand(100) > Var then
		return false
	end

	return true
end

function Execute()
	SetProperty("SIM", "SpecialMeasureDestination", GetID("PLU_BUILD"))
	SetProperty("SIM", "SpecialMeasureId", -MeasureGetID("PlunderBuilding"))
end

function CleanUp()
end
