function Weight()
	local	Item = "ToadExcrements"
	if GetMeasureRepeat("SIM", "Use"..Item)>0 then
		return 0
	end

	if not DynastyGetRandomBuilding("VictimDynasty",2,-1,"diute_Target") then
		return 0
	end
	
	if BuildingGetType("diute_Target")==GL_BUILDING_TYPE_FARM or BuildingGetType("diute_Target")==GL_BUILDING_TYPE_ROBBER or BuildingGetType("diute_Target")==GL_BUILDING_TYPE_MINE or BuildingGetType("diute_Target")==GL_BUILDING_TYPE_RANGERHUT or BuildingGetType("diute_Target")==GL_BUILDING_TYPE_THIEF then
		return 0
	end
	
	local Hour = math.mod(GetGametime(), 24)
	local Start = BuildingGetWorkingStart("diute_Target")
	local End		= BuildingGetWorkingEnd("diute_Target")

	if Hour<Start or Hour>(End-6) then
		return 0
	end

	if gameplayformulas_CheckDistance("","diute_Target")==0 then
		return 0
	end

	if GetItemCount("", Item, INVENTORY_STD)>0 then
		return 50
	end

	local Price = ai_CanBuyItem("SIM", Item)
	local Round = GetRound()
	if HasProperty("dynasty", "ItemBudget"..Round) then
		ai_CalcItemBudget("dynasty")
	end
	
	if GetProperty("dynasty", "ItemBudget"..Round) < Price then
		return 0
	end	
	if Price<0 then
		return 0
	end

	return 10
end

function Execute()
	MeasureRun("SIM", "diute_Target", "UseToadExcrements")
end

function CleanUp()
end
