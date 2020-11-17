function Weight()

	if not ReadyToRepeat("SIM", "AI_CheckHome") then
		return 0
	end	

	if GetHomeBuilding("SIM", "Home") then
		if BuildingGetType("Home")==GL_BUILDING_TYPE_RESIDENCE then
			return 0
		end
	end

	if DynastyIsShadow("SIM") then
		if SimGetOfficeLevel("SIM") < 5 or GetNobilityTitle("SIM",0) < 8 then
			return 0
		end
	end

	return 100
end

function Execute()

	SetRepeatTimer("SIM", "AI_CheckHome", 24)

	if DynastyGetRandomBuilding("SIM", nil, GL_BUILDING_TYPE_RESIDENCE, "Residence") then
		MeasureRun("SIM", "Residence", "AssignCharacterToHome")
		return
	end
	
	if not SimGetCityOfOffice("SIM", "City") then
		if not ScenarioGetRandomObject("Settlement", "City") then
			return
		end
	end
	
	if not CityGetRandomBuilding("City", nil, GL_BUILDING_TYPE_RESIDENCE, 1, -1, FILTER_IS_BUYABLE, "Residence") then
		CityGetRandomBuilding("City", nil, GL_BUILDING_TYPE_RESIDENCE, -1, -1, FILTER_IS_BUYABLE, "Residence")
	end
	
	if AliasExists("Residence") then
		MeasureRun("Residence", "SIM", "BuyBuilding")
		return
	end
	
	--****We don't want shadows building homes
	--local	Proto = ScenarioFindBuildingProto(nil, GL_BUILDING_TYPE_RESIDENCE, 5, -1)
	--if Proto ~= -1 then
	--	if not CityBuildNewBuilding("City", Proto, "SIM", "Residence") then
	--		return
	--	end
	--end
	
end

