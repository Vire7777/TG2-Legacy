function Run()
	if AliasExists("Destination") then
		if not f_MoveTo("", "Destination", GL_MOVESPEED_RUN) then
			return
		end
	end

	if not GetInsideBuilding("", "Building") then
		MsgQuick("", "@L_GENERAL_MEASURES_035_ASSIGNCHARACTERTOBUILDING_FAILURES_+0", GetID(""))
		return
	end
	
	if not BuildingSetOwner("Building", "") then
		MsgQuick("", "@L_GENERAL_MEASURES_035_ASSIGNCHARACTERTOBUILDING_FAILURES_+0", GetID("Owner"), GetID("Building"))
	end
end

function CleanUp()
end
