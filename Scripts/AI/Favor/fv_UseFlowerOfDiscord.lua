function Weight()
	local	Item = "FlowerOfDiscord"
	
	if GetMeasureRepeat("SIM", "Use"..Item)>0 then
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

	if GetItemCount("", Item,INVENTORY_STD)>0 then
		return 50
	end
	
	local Price = ai_CanBuyItem("SIM", Item)
	if Price<0 then
		return 0
	end

	return 10
end

function Execute()

	MeasureCreate("Measure")
	MeasureAddAlias("Measure","Believer","Victim2",false)
	MeasureStart("Measure","SIM","Victim","UseFlowerOfDiscord")

end

function CleanUp()
end
