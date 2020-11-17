function GetPrivilegeList()
	return "AimForInquisitionalProceeding","CommandMonitor"
end

function InitOffice()
	SetOfficePrivileges( "Office", ps_inquisitor_GetPrivilegeList() )
	SetOfficeServants("Office", "Monitor", 2, GL_PROFESSION_MONITOR)
end

function TakeOffice(Messages)
	if (Messages == 1) then
		gameplayformulas_StartHighPriorMusic(MUSIC_POSITIVE_EVENT)
		feedback_MessageOffice("",
			ps_inquisitor_GetPrivilegeList,
			"@L_PRIVILEGES_OFFICE_GAIN_HEAD_+0",
			"@L_PRIVILEGES_OFFICE_GAIN_BODY",GetID(""),GetSettlementID(""))
	end
	SetProperty("","ChurchOfficial",1)
	chr_SetOfficeImpactList( "Office", ps_inquisitor_GetPrivilegeList() )
end

function LooseOffice(Messages)
	if (Messages == 1) then
		feedback_MessageOffice("",
			ps_inquisitor_GetPrivilegeList,
			"@L_PRIVILEGES_OFFICE_LOST_HEAD_+0",
			"@L_PRIVILEGES_OFFICE_LOST_BODY",GetID(""),GetSettlementID(""))
	end
	RemoveProperty("","ChurchOfficial")
	RemoveAllObjectDependendImpacts( "", "Office" )
end
 
function CleanUp()
end
