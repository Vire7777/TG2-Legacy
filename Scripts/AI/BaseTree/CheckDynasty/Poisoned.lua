function Weight()
	if GetImpactValue("SIM","poisoned")>0 then
		if GetProperty("SIM", "poisoned")>1 then
			return 50
		end
	end
	
	return 0
end


function Execute()
	if GetImpactValue("SIM","poisoned")>0 then
		if GetProperty("SIM", "poisoned")>1 then
			MeasureRun("SIM", "", "UseAntidote")
		end
	end
end

