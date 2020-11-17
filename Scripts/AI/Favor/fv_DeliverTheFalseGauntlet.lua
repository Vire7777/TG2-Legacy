function Weight()
	
	if SimGetOfficeLevel("SIM") < 1 then
		return 0
	end
	
	if GetImpactValue("SIM", "DeliverTheFalseGauntlet")==0 then
		return 0
	end

	if GetFavorToDynasty("dynasty", "VictimDynasty") > 40 then
		return 0
	end
	
	if not DynastyGetRandomVictim("VictimDynasty", -50, "VictimDynasty2") then
		return 0
	end
	
	local Count = DynastyGetMemberCount("VictimDynasty2")
	local Victim = Rand(Count)
	if not (DynastyGetMember("VictimDynasty2", Victim, "Victim2")) then
		return 0
	end	

	return 100
end


function Execute()
	MeasureCreate("Measure")
	MeasureAddAlias("Measure","Believer","Victim2",false)
	MeasureStart("Measure","SIM","Victim","DeliverTheFalseGauntlet")
end

function CleanUp()
end
