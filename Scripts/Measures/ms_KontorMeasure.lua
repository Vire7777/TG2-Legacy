function Run()

	if not GetSettlement("", "City") then
		StopMeasure()
	end

	local	Firsttime		= true
	local	TimeToSleep = Gametime2Realtime(0.5)
	local	Count
	local	Item
	local Demand
	local	Stock
	local	LocalCityId = GetID("City")
	
	
	while true do
	
		if Rand(100)>97 then
			Count = GetData("#KontorEventCount")
			if (not Count) or Count<1 then
				if not GetState("", STATE_KONTOR_EVENT) then
					SetState("", STATE_KONTOR_EVENT, true)
				end
			end
		end

		Sleep(TimeToSleep)
		
		local	Check = {}
		
		Count = ScenarioGetKontorGoodCount()
		for g=0,Count-1 do
			Item, Demand, CityId = ScenarioGetKontorGoodInfo(g)
			if Item~=-1 and CityId==LocalCityId then
				if Demand>0 then
					ms_kontormeasure_CheckItem(Item, Demand*2, Firsttime)
					Check[Item] = true
				end
			end
		end
		
		local	EventItem = GetProperty("", "EventItem")
		local	EvID  = -1
		if EventItem then
			EvID = ItemGetID(EventItem)
		end
		
		Count = InventoryGetSlotCount("", INVENTORY_STD)
		for g=0,Count-1 do
		
			Item, Demand = InventoryGetSlotInfo("", g, INVENTORY_STD)
			if Item and Check[Item] ~= true and Item~=EvID then
				if Demand>0 then
					RemoveItems("", Item, 1, INVENTORY_STD)
				end
			end
		end
		
		RemoveEmptySlots("", INVENTORY_STD)
		Firsttime = false

	end
end

function CheckItem(Item, Wanted, FirstTime)
	if Wanted==0 then
		return
	end
	
	local Count	= GetItemCount("", Item, INVENTORY_STD)
	if Count>=Wanted then
		return
	end
	
	local	Var		= 95 - (Wanted-Count)*0.5
	
	local Grow = (Wanted-Count) * 0.05
	if Grow<1 then
		Grow = 1
	end
	
	if Grow>4 then
		Grow = 4
	end
	
	
	if Count < Wanted then
		if not FirstTime then
			if Rand(100) > Var then
				AddItems("", Item, Grow, INVENTORY_STD)
			end
		else
			AddItems("", Item, Rand(Wanted), INVENTORY_STD)
		end
	end
	
	local	Base = ItemGetBasePrice(Item)
	if Base~=-1 then
	
		local PriceIn = Base * 0.25
		Count = GetItemCount("", Item, INVENTORY_STD)
	
		local	Quote		= 0.5 + 0.75*(1 - Count / Wanted)
		local PriceOut = Base * Quote
	
		CitySetFixedPrice("", Item, PriceIn, PriceOut, -1)
	end
	
end

function CleanUp()
end
