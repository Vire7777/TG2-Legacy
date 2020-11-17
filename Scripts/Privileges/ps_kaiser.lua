function GetPrivilegeList()
    return "HaveImmunity", "ImperialGuard", "Disappropriate", "FlamingSpeech", "RepealImmunity",
	"BanCharacter", "DemolishBuilding", "CommandStructure", "Rage", "ImperialRemove", "ImperialPunish"
end

function InitOffice()
    SetOfficePrivileges( "Office", ps_kaiser_GetPrivilegeList() )
end

function TakeOffice(Messages)
    if (Messages == 1) then
	    StartHighPriorMusic(MUSIC_POSITIVE_EVENT)
	    feedback_MessageOffice("",
		    ps_kaiser_GetPrivilegeList,
		    "@L_PRIVILEGES_OFFICE_GAIN_HEAD_+0",
		    "@L_PRIVILEGES_OFFICE_GAIN_BODY",GetID(""),GetSettlementID(""))
	end
	SetProperty("","Emperor",1)
	chr_SetOfficeImpactList("Office", ps_kaiser_GetPrivilegeList())
end

function LooseOffice(Messages)
	if (Messages == 1) then
		feedback_MessageOffice("",
			ps_kaiser_GetPrivilegeList,
			"@L_PRIVILEGES_OFFICE_LOST_HEAD_+0",
			"@L_PRIVILEGES_OFFICE_LOST_BODY",GetID(""),GetSettlementID(""))
	end

    -- Remove the probably earlier given "RepealImmunity" impact
	if HasProperty("", "RepealedImmunity") then
		local SimID = GetProperty("", "RepealedImmunity")
		if GetAliasByID(SimID, "AffectedSim") then
			RemoveImpact("AffectedSim", 345)
			RemoveProperty("", "RepealedImmunity")
			feedback_MessageCharacter("AffectedSim", "@L_PRIVILEGES_REPEALIMMUNITY_MSG_LOOSE_HEAD_+0", "@L_PRIVILEGES_REPEALIMMUNITY_MSG_LOOSE_BODY_+0")
		end
	end
	RemoveProperty("","Emperor")
	RemoveAllObjectDependendImpacts("", "Office" )
end

function CleanUp()
end
