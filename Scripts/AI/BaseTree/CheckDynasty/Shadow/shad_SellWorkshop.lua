function Weight()
	if not DynastyIsShadow("SIM") then
		return 0
	end
	
	local ForSale = (SimGetOfficeID("SIM")==-1)
	
	if not DynastyGetRandomBuilding("SIM", GL_BUILDING_CLASS_WORKSHOP, -1, "sd_Workshop") then
		return 0
	end
	
	local fsale = GetProperty("sd_Workshop", "SSale")
	
	if BuildingGetForSale("sd_Workshop")==ForSale then
	
		if fsale and fsale == 1 then--ai is over-selling property currently

		else--ai has resigned itself to selling permanently
			RemoveProperty("sd_Workshop", "SSale")
			return 0
		end
	end
	
	local buildingcount = 0
	local Count = DynastyGetBuildingCount2("SIM")
	local Type
	for l=0,Count-1 do
		if DynastyGetBuilding2("SIM", l, "Check") then
			Type = BuildingGetClass("Check")
			if Type~=GL_BUILDING_CLASS_LIVINGROOM and Type~=GL_BUILDING_CLASS_RESOURCE then
				buildingcount = buildingcount + 1
			end
		end
	end	

	--over-sell property
	if fsale then
		if fsale == 0 then

			local sst = GetProperty("sd_Workshop", "SSaleTime")

			--sell phases adjusted heavily by difficulty, ranging from 2 rounds to 5 rounds on maximum difficulty and half a round maximum for easiest
			if sst+12+(ScenarioGetDifficulty()*4)+Rand(ScenarioGetDifficulty()*20) < ScenarioGetTimePlayed() then
				if GetImpactValue("","LevelingUp") == 0 then
					SetProperty("sd_Workshop", "SSale", 1)--set shadow dynasty building for sale
					SetProperty("sd_Workshop", "SSaleTime", ScenarioGetTimePlayed())
					return 100
				end
			end
		else
			
			local ft = GetProperty("sd_Workshop", "SSaleTime")

			if ft < ScenarioGetTimePlayed()-23 then--sale length
				SetState("sd_Workshop", STATE_SELLFLAG, false)
				BuildingSetForSale("sd_Workshop", false)
				
				SetProperty("sd_Workshop", "SSale", 0)
				SetProperty("sd_Workshop", "SSaleTime", ScenarioGetTimePlayed())
			end
			
			return 0
		end
	else
		SetProperty("sd_Workshop", "SSale", 0)
		SetProperty("sd_Workshop", "SSaleTime", ScenarioGetTimePlayed()-12)
	end
	
	if buildingcount < 2 then
		return 0
	end
	
	if GetMoney("SIM") > 3000 then
		return 0
	elseif GetMoney("SIM") > 1000 then
		return 15
	end
	
	return 30
	
end

function Execute()

	if BuildingGetForSale("sd_Workshop") then
		BuildingSetForSale("sd_Workshop", false)
		SetState("sd_Workshop", STATE_SELLFLAG, false)
	else
		BuildingSetForSale("sd_Workshop", true)
		SetState("sd_Workshop", STATE_SELLFLAG, true)
	end

--[[	if BuildingGetForSale("sd_Workshop") then
		BuildingSetForSale("sd_Workshop", false)
		SetState("sd_Workshop", STATE_SELLFLAG, false)
	end	
	]]
end

function CleanUp()
end
