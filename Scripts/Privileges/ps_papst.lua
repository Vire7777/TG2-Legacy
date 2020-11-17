function GetPrivilegeList()
	return "HaveImmunity", "WorkWonders", "Set_ChurchTithe", "PapalGuard", "CommandInquisitor", "LeadCrusade", "PapalRemove", "Excommunicate"
end

function InitOffice()
	SetOfficePrivileges( "Office", ps_papst_GetPrivilegeList() )
	SetOfficeServants("Office", "Inquisitor", 1, GL_PROFESSION_INQUISITOR)
end

function TakeOffice(Messages)
	if (Messages == 1) then
		StartHighPriorMusic(MUSIC_POSITIVE_EVENT)
		feedback_MessageOffice("",
			ps_papst_GetPrivilegeList,
			"@L_PRIVILEGES_OFFICE_GAIN_HEAD_+0",
			"@L_PRIVILEGES_OFFICE_GAIN_BODY",GetID(""),GetSettlementID(""))
	end
	SetProperty("","ChurchOfficial",1)
	chr_SetOfficeImpactList( "Office", ps_papst_GetPrivilegeList() )
end

function LooseOffice(Messages)
	if (Messages == 1) then
		feedback_MessageOffice("",
			ps_papst_GetPrivilegeList,
			"@L_PRIVILEGES_OFFICE_LOST_HEAD_+0",
			"@L_PRIVILEGES_OFFICE_LOST_BODY",GetID(""),GetSettlementID(""))
	end
	RemoveProperty("","ChurchOfficial")
	RemoveAllObjectDependendImpacts("", "Office" )
end
 
function CleanUp()
end
