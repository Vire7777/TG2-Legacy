function Weight()
	if Rand(100)>20 then
		return 0
	end
	
	local count = DynastyGetBuildingCount("SIM", GL_BUILDING_CLASS_WORKSHOP)
	if count == nil or count<1 then
		return 0
	end

	return 100
end

function Execute()

	local Inside = GetInsideBuilding("SIM", "INSIDE")

	if Inside then
	
		if BuildingGetOwner("INSIDE","cwh_BuildingOwner") then
			if GetID("SIM") == GetID("cwh_BuildingOwner") then
				if GetMeasureRepeat("SIM", "PropelEmployees", nil)<=0 then
				    local z = BuildingGetWorkerCount("INSIDE")
					if z > 0 then
						BuildingGetWorker("INSIDE",(Rand(z)),"MitarbeiterX")
						if HasProperty("MitarbeiterX", "courted") then
							return
						end
					    if GetFavorToSim("MitarbeiterX","SIM") < 10 then
					        if SimGetClass("MitarbeiterX") == 4 then
						        MeasureRun("SIM", 0, "DoGelage")
						    else
						        MeasureRun("SIM", 0, "PayBonus")
						    end
					    else
						    MeasureRun("SIM", 0, "PropelEmployees")
					    end
					    return
					else
					    return
					end
				end
			end
		end

		MeasureRun("Sim", 0, "AIDoNothing")
		return
	end
	
	if DynastyGetRandomBuilding("dynasty", GL_BUILDING_CLASS_WORKSHOP, -1, "building") then
		if GetID("building")~=GetID("INSIDE") then
			MeasureRun("SIM", "building", "Walk")
			return
		end
	end
	
	MeasureRun("Sim", 0, "AIDoNothing")
	return
end

function CleanUp()
end

