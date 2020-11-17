function GetPrivilegeList()
	return	"CommandCityGuard"
end

function InitOffice()
	SetOfficePrivileges( "Office", ps_weibel_GetPrivilegeList() )
	SetOfficeServants("Office", "CityGuard", 6, GL_PROFESSION_CITYGUARD)
end

function TakeOffice(Messages)
	if (Messages == 1) then
		gameplayformulas_StartHighPriorMusic(MUSIC_POSITIVE_EVENT)
		feedback_MessageOffice("",
			ps_weibel_GetPrivilegeList,
			"@L_PRIVILEGES_OFFICE_GAIN_HEAD_+0",
			"@L_PRIVILEGES_OFFICE_GAIN_BODY",GetID(""),GetSettlementID(""))
	end

	chr_SetOfficeImpactList( "Office", ps_weibel_GetPrivilegeList() )
end

function LooseOffice(Messages)
	if (Messages == 1) then
		feedback_MessageOffice("",
			ps_weibel_GetPrivilegeList,
			"@L_PRIVILEGES_OFFICE_LOST_HEAD_+0",
			"@L_PRIVILEGES_OFFICE_LOST_BODY",GetID(""),GetSettlementID(""))
	end

	RemoveAllObjectDependendImpacts("", "Office" )
end

function CleanUp()
end
