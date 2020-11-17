function Weight()
	if GetFavorToDynasty("dynasty", "VictimDynasty") > gameplayformulas_GetMaxFavByDiffForAttack() then
		return 0
	end

	if not DynastyGetMemberRandom("VictimDynasty", "member") then
		return 0
	else
		if GetFavorToDynasty("dynasty", "VictimDynasty") > 65 then
			return 15
		end
	end
	return 100
end

function Execute()
	MeasureCreate("Measure")
	MeasureAddData("Measure", "TimeOut", 8, false)
	MeasureStart("Measure", "SIM", "member", "OrderASpying")
end

function CleanUp()
end
