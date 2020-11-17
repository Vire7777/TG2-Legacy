function Weight()
	local	Item = "Poem"
	
	if GetMeasureRepeat("SIM", "Use"..Item)>0 then
		return 0
	end

	if GetFavorToDynasty("dynasty", "VictimDynasty") < 50 then
		return 0
	end
	
	if SimGetGender("SIM") == SimGetGender("Victim") then
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
	if not GetCurrentMeasureName("SIM")=="UsePoem" then
		MeasureRun("SIM", "Victim", "UsePoem")
	end
end

function CleanUp()
end
