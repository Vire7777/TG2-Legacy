function GetPrivilegeList()
	return "HaveImmunity", "EmbezzlePublicMoney", "Set_TurnoverTax", "LevelUpCity",
	"BanCharacter", "DemolishBuilding", "CanApplyForEpicOffice"
end

function InitOffice()
	SetOfficePrivileges( "Office", ps_landesherr_GetPrivilegeList() )
end

function TakeOffice(Messages)
	if (Messages == 1) then
		gameplayformulas_StartHighPriorMusic(MUSIC_POSITIVE_EVENT)
		feedback_MessageOffice("",
			ps_landesherr_GetPrivilegeList,
			"@L_PRIVILEGES_OFFICE_GAIN_HEAD_+0",
			"@L_PRIVILEGES_OFFICE_GAIN_BODY",GetID(""),GetSettlementID(""))
	end
	SetProperty("","Sovereign",1)
	chr_SetOfficeImpactList( "Office", ps_landesherr_GetPrivilegeList() )
	RemoveImpact("","CanApplyForEpicOfficeTimed")
end

function LooseOffice(Messages)
	if (Messages == 1) then
		feedback_MessageOffice("",
			ps_landesherr_GetPrivilegeList,
			"@L_PRIVILEGES_OFFICE_LOST_HEAD_+0",
			"@L_PRIVILEGES_OFFICE_LOST_BODY",GetID(""),GetSettlementID(""))
	end

	RemoveAllObjectDependendImpacts( "", "Office" )
	RemoveImpact("","CanApplyForEpicOfficeTimed")
	AddImpact("","CanApplyForEpicOfficeTimed",1,24)
end
 
function CleanUp()
end
