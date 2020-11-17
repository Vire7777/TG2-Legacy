function Run()
	if GetInsideBuilding("","CurrentBuilding") then
		if GetSettlement("CurrentBuilding","City") then
			if BuildingGetType("CurrentBuilding")==GL_BUILDING_TYPE_HOSPITAL then
				CopyAlias("CurrentBuilding","Destination")
			end
		end
	end
	if not AliasExists("City") then
		if not GetNearestSettlement("", "City") then
			StopMeasure()
		end
	end
	
	if GetState("",STATE_TOWNNPC) then
		StopMeasure()
	end
	
	MeasureSetNotRestartable()
	
	if not AliasExists("Destination") then
	
		local Distance = -1
		local BestDistance = -1
		GetHomeBuilding("","MyHouse")
		local Filter = "__F((Object.GetObjectsOfWorld(Building))AND(Object.IsType(37)))"
		local NumHospitals = Find("MyHouse", Filter,"Hospital",-1)
		if (NumHospitals == 0) or (NumHospitals == nil) or (NumHospitals == false) then
			MsgQuick("","@L_MEDICUS_FAILURES_+1")
			StopMeasure()
		end
		
		for i=0,NumHospitals-1 do
			local HospAlias = "Hospital"..i
			local MinLevel = 1
			if GetImpactValue("","Sprain")==1 then
				MinLevel = 1
			elseif GetImpactValue("","Cold")==1 then
				MinLevel = 1
			elseif GetImpactValue("","Influenza")==1 then
				MinLevel = 2
			elseif GetImpactValue("","BurnWound")==1 then
				MinLevel = 2
			elseif GetImpactValue("","Pox")==1 then
				MinLevel = 2
			elseif GetImpactValue("","Pneumonia")==1 then
				MinLevel = 3
			elseif GetImpactValue("","Blackdeath")==1 then
				MinLevel = 3
			elseif GetImpactValue("","Fracture")==1 then
				MinLevel = 3
			elseif GetImpactValue("","Caries")==1 then
				MinLevel = 3
			end
			
			BuildingGetCity(HospAlias,"HospCity")
			if BuildingGetLevel(HospAlias) >= MinLevel and GetID("City")==GetID("HospCity") then  ---Send to local hospital
				Distance = GetDistance("",HospAlias)
				if GetDistance("",HospAlias) ~= -1 then
					BestDistance = Distance
					if Distance < BestDistance then
						CopyAlias(HospAlias,"Destination")
						LogMessage("Log: Alias = "..GetID("Destination"))
						Distance = GetDistance("","Destination")
						break
					elseif BestDistance < Distance then
						CopyAlias(HospAlias,"Destination")
						LogMessage("Log: Alias = "..GetID("Destination"))
						Distance = GetDistance("","Destination")
						break
					else
						CopyAlias(HospAlias,"Destination")
						LogMessage("Log: Alias = "..GetID("Destination"))
						Distance = GetDistance("","Destination")
						break
					end
				end
			elseif BuildingGetLevel(HospAlias) >= MinLevel then
				Distance = GetDistance("",HospAlias) --local hospital isn't big enough! Send to another city
				if GetDistance("",HospAlias) ~= -1 then
					BestDistance = Distance
					if Distance < BestDistance then
						CopyAlias(HospAlias,"Destination")
						LogMessage("Log: Alias = "..GetID("Destination"))
						Distance = GetDistance("","Destination")
					elseif BestDistance < Distance then
						CopyAlias(HospAlias,"Destination")
						LogMessage("Log: Alias = "..GetID("Destination"))
						Distance = GetDistance("","Destination")
					else
						CopyAlias(HospAlias,"Destination")
						LogMessage("Log: Alias = "..GetID("Destination"))
						Distance = GetDistance("","Destination")
					end
				end
			end
		end
		
		
		if Distance==-1 then
			MsgQuick("", "@L_MEASURE_AttendDoctor_NODOC_+0", GetID(""))
			return
		end
	end
	
	if (GetDynastyID("Destination")~=GetID("dynasty")) then
		local Costs = 0
		if GetImpactValue("","Sprain")==1 then
			Costs = diseases_GetTreatmentCost("Sprain")
		elseif GetImpactValue("","Cold")==1 then
			Costs = diseases_GetTreatmentCost("Cold")
		elseif GetImpactValue("","Influenza")==1 then
			Costs = diseases_GetTreatmentCost("Influenza")
		elseif GetImpactValue("","BurnWound")==1 then
			Costs = diseases_GetTreatmentCost("BurnWound")
		elseif GetImpactValue("","Pox")==1 then
			Costs = diseases_GetTreatmentCost("Pox")
		elseif GetImpactValue("","Pneumonia")==1 then
			Costs = diseases_GetTreatmentCost("Pneumonia")
		elseif GetImpactValue("","Blackdeath")==1 then
			Costs = diseases_GetTreatmentCost("Blackdeath")
		elseif GetImpactValue("","Fracture")==1 then
			Costs = diseases_GetTreatmentCost("Fracture")
		elseif GetImpactValue("","Caries")==1 then
			Costs = diseases_GetTreatmentCost("Caries")
		elseif GetHPRelative("") < 0.99 then
			Costs = GetMaxHP("")-GetHP("")
		else
			StopMeasure()
		end
		
		local Money = GetMoney("")
		if DynastyIsPlayer("") then
			if Costs > Money then
				StopMeasure()
			end
		end
	end
	local HospitalID = GetID("Destination")
	idlelib_VisitDoc("")
end

function AIDecide()
	return "O"
end

function CleanUp()
	if HasProperty("","WaitingForTreatment") then
		RemoveProperty("","WaitingForTreatment")
	end
end

-- -----------------------
-- GetOSHData
-- -----------------------
function GetOSHData(MeasureID)
	local Costs = 0
	if GetImpactValue("","Sprain")==1 then
		Costs = diseases_GetTreatmentCost("Sprain")
	elseif GetImpactValue("","Cold")==1 then
		Costs = diseases_GetTreatmentCost("Cold")
	elseif GetImpactValue("","Influenza")==1 then
		Costs = diseases_GetTreatmentCost("Influenza")
	elseif GetImpactValue("","BurnWound")==1 then
		Costs = diseases_GetTreatmentCost("BurnWound")
	elseif GetImpactValue("","Pox")==1 then
		Costs = diseases_GetTreatmentCost("Pox")
	elseif GetImpactValue("","Pneumonia")==1 then
		Costs = diseases_GetTreatmentCost("Pneumonia")
	elseif GetImpactValue("","Blackdeath")==1 then
		Costs = diseases_GetTreatmentCost("Blackdeath")
	elseif GetImpactValue("","Fracture")==1 then
		Costs = diseases_GetTreatmentCost("Fracture")
	elseif GetImpactValue("","Caries")==1 then
		Costs = diseases_GetTreatmentCost("Caries")
	elseif GetHPRelative("") < 0.99 then
		Costs = GetMaxHP("")-GetHP("")
	end
	OSHSetMeasureCost("@L_INTERFACE_HEADER_+6",Costs)
end


