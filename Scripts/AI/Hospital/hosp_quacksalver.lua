function Weight()
	if GetMeasureRepeat("SIM", "Quacksalver") > 0 then
		return 0
	end
	
	if not ai_HasAccessToItem("SIM", "MiracleCure") then
		return 0
	end
	
	if not SimGetWorkingPlace("SIM", "Hospital") then
		return 0
	end
	
	if GetCurrentMeasureID("SIM") == 10933 then --<---- The sim is already treating patients (Much more important)
		return 0
	end
	
	if BuildingGetProducerCount("Hospital", PT_MEASURE, "Quacksalver") > 0 then
		return 0
	end
	
	if not BuildingGetCity("Hospital","City") then
		return 0 
	end
	
	if (CityFindCrowdedPlace("City", "", "Destination")==0) or (CityFindCrowdedPlace("City", "", "Destination")==nil) then
		return 0 
	end
	
	if GetInsideBuilding("SIM","CurrentBuilding") then
		local TargetID=GetID("CurrentBuilding")
		GetAliasByID(TargetID,"Building")
		local CheckOk = false
		if GetItemCount(Building, "MiracleCure", INVENTORY_STD) > 1 then
			CheckOk = true
		else
			if GetItemCount(Building, "MiracleCure", INVENTORY_SELL) > 1 then
				CheckOk = true
			end
		end
	end
	if CheckOk then
		return 100
	end
	
	return 0
end

function Execute()
	
	SetProperty("SIM", "SpecialMeasureId", -MeasureGetID("Quacksalver"))
	MeasureRun("SIM", "Destination", "Quacksalver")
end

function CleanUp()
end
