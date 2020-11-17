-------------------------------------------------------------------------------
----
----	OVERVIEW "ms_035_AssignCharacterToHome"
----
----	with this measure the player can assign a new residence to one of his
----	main characters
----
-------------------------------------------------------------------------------


function Run()

	if AliasExists("Destination") then
		if not f_MoveTo("", "Destination", GL_MOVESPEED_RUN) then
			return
		end
	end
	
	if GetHomeBuilding("","OldHome") then
		if GetState("OldHome",STATE_FEAST) then
			MsgQuick("", "@L_GENERAL_MEASURES_035_ASSIGNCHARACTERTOBUILDING_FAILURES_+1", GetID(""))
			return
		end
	end
	
	if not GetInsideBuilding("", "Building") then
		MsgQuick("", "@L_GENERAL_MEASURES_035_ASSIGNCHARACTERTOBUILDING_FAILURES_+0", GetID(""))
		return
	end
	
	if BuildingGetType("Building")~=GL_BUILDING_TYPE_RESIDENCE then
		MsgQuick("", "@L_GENERAL_MEASURES_035_ASSIGNCHARACTERTOBUILDING_FAILURES_+0", GetID(""))
		return
	end
	
	if GetSettlementID("")~=GetSettlementID("Building") then
	
		if SimGetOfficeID("")~=-1 then
			MsgQuick("", "@L_GENERAL_MEASURES_035_ASSIGNCHARACTERTOBUILDING_FAILURES_+2", GetID(""))
			return
		end
		
		if SimIsAppliedForOffice("") then
			MsgQuick("", "@L_GENERAL_MEASURES_035_ASSIGNCHARACTERTOBUILDING_FAILURES_+3", GetID(""))
			return
		end
		
		if SimGetCourtLover("", "Loverboy") then
			MsgQuick("", "@L_INTERFACE_ASSIGNCHARACTERTOBUILDING_+1")
			return
		end
		
	end
	
		
	if ChangeResidence("", "Building") then
		feedback_MessageWorkshop("",
			"@L_GENERAL_MEASURES_035_ASSIGNCHARACTERTOBUILDING_SUCCESS_HEAD_+0",
			"@L_GENERAL_MEASURES_035_ASSIGNCHARACTERTOBUILDING_SUCCESS_BODY_+0", GetID("Owner"), GetID("Building"))
	else
		MsgQuick("", "@L_GENERAL_MEASURES_035_ASSIGNCHARACTERTOBUILDING_FAILURES_+0", GetID("Owner"), GetID("Building"))
	end
end

function CleanUp()
end
