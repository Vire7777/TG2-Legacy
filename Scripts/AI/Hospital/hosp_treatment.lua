function Weight()
	if IsDynastySim("SIM") then
		if not GetInsideBuilding("SIM", "Hospital") then
			return 0
		end
		if BuildingGetType("Hospital")~=GL_BUILDING_TYPE_HOSPITAL then
			return 0
		end
		if not SimCanWorkHere("SIM", "Hospital") then
			return 0
		end
	else
		if not SimGetWorkingPlace("SIM", "Hospital") then
			return 0
		end
	end

	if GetState("SIM",STATE_DUEL) then
		return 0
	end
	
	if GetInsideBuildingID("SIM") ~= GetID("Hospital") then
		if not f_MoveTo("SIM","Hospital") then
			return 0
		end
	end

	local SickSimFilter = "__F((Object.GetObjectsByRadius(Sim) == 10000) AND (Object.Property.WaitingForTreatment==1))"
	local NumSickSims = Find("SIM", SickSimFilter,"SickSim", -1)
	if NumSickSims < 1 then
		return 0
	end

	-- local Producer = BuildingGetProducerCount("Hospital", PT_MEASURE, "MedicalTreatment")
	-- if NumSickSims <= 3*Producer then
		-- return 0
	-- end

	return 100
end

function Execute()
	SetProperty("SIM", "SpecialMeasureId", -MeasureGetID("MedicalTreatment"))
	MeasureRun("SIM", nil, "MedicalTreatment")
end

function CleanUp()
end
