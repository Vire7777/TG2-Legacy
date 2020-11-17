function Weight()

	if not SimGetWorkingPlace("SIM","Divehouse") then
		return 0
	end

	if not BuildingHasUpgrade("Divehouse","PiratenGrog") then
	    return 0
	end

    if GetItemCount("Divehouse", "PiratenGrog", INVENTORY_STD) > 100 then
		return 0
	end
	
    if GetItemCount("Divehouse", "Schadelbrand", INVENTORY_STD) > 100 then
	    return 0
	end
	
	return 100
end

function Execute()
	MeasureCreate("Measure")
	MeasureStart("Measure", "Divehouse", -1, "DiveGetAlc")
end

function CleanUp()
end
