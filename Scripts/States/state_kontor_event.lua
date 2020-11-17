function Run()

	local Count = GetData("#KontorEventCount")
	if not Count then
		Count = 0
	end
	SetData("#KontorEventCount", Count+1)

	local	Selection = Rand(2)
	SetData("Selection", Selection)
	
	if Selection==0 then
		state_kontor_event_NeedItems()
	elseif Selection==1 then
		state_kontor_event_OfferItems()
	end

end

function CleanUp()

	local Count = GetData("#KontorEventCount")
	if Count and Count>0 then
		SetData("#KontorEventCount", Count-1)
	end

	local Selection = GetData("Selection")
	if Selection==0 then
		state_kontor_event_NeedItemsCleanUp()
	elseif Selection==1 then
		state_kontor_event_OfferItemsCleanUp()
	end

	-- remove the hud countdown
	local ID = "Event"..GetID("")
	HudRemoveCountdown(ID,false)
end




-- *******************************************
--
-- Event: Kontor needs items
-- 
-- *******************************************

function NeedItems()

	-- use an random event
	local random = Rand(6)

	local	Item = state_kontor_event_NeedItemsFindItem(random)
	if not Item then
		return
	end
	
	local BasePrice = ItemGetBasePrice(Item)
	if BasePrice<1 then
		return
	end
	
	local Needed = Rand(12)*5 + 10
	SetData("Item", Item)
	SetProperty("", "EventItem", Item)
	
	local CurrentTime = GetGametime()
	local Gametime	= Rand(12) + 12
	local DestTime  = CurrentTime + Gametime
	local	ToDo	= Gametime2Realtime(Gametime)
	local ItemLabel	= ItemGetLabel(Item, false)
	local	Count
	local	Success 	= false
	local ID = "Event"..GetID("")

	-- message to insert here: start of the event
	if not GetSettlement("", "City") then
		if not GetNearestSettlement("","City") then
			return
		end
	end

	MsgNewsNoWait("All","","@C[@L_KONTOR_MISSIONS_NEED_ITEMS_COOLDOWN_+0,%5i,%6l]","economie",-1,
			       "@L_KONTOR_MISSIONS_NEED_ITEMS_HEAD_+"..random,
			       "@L_KONTOR_MISSIONS_NEED_ITEMS_TEXT_+"..random,
			       GetID("City"), Needed, ItemLabel, Gametime, DestTime,ID)

	CitySetFixedPrice("", Item, BasePrice*2, BasePrice*2, Gametime)

	while ToDo>0 do

		Count = GetItemCount("", Item, INVENTORY_STD)
		if Count >= Needed then
			Success = true
			break
		end
		
		if Count==0 then
			AddItems("", Item, 1, INVENTORY_STD)
		end
		
		ToDo = ToDo - 2
		Sleep(2)
	end

	-- message to insert here: end of the event
	
	if Success then
		feedback_MessageEconomie("All", "@L_KONTOR_MISSIONS_NEED_ITEMS_SUCCESS_HEAD_+0",
						"@L_KONTOR_MISSIONS_NEED_ITEMS_SUCCESS_TEXT_+0",
						GetID("City"), Needed, ItemLabel)
	else
		feedback_MessageEconomie("All", "@L_KONTOR_MISSIONS_NEED_ITEMS_FAILED_HEAD_+0",
						"@L_KONTOR_MISSIONS_NEED_ITEMS_FAILED_TEXT_+0",
						GetID("City"), Needed, ItemLabel)
	end
end

function NeedItemsFindItem(event)

	local	Items = {}

	if event == 0 then
		Items = { 
			"ToadExcrements", "Blanket", 
			"HerbTea", "Poem", "ThesisPaper", 
			"AboutTalents1", "AboutTalents2",
			"Torch", 
			"optieisen", "optisilber",
			"optigold", "HexerdokumentI",
			"HexerdokumentII", "spindel"
			}
	elseif event == 1 then
		Items = { 
			"BuildMaterial", "Pinewood", 
			"Oakwood", "Tool",
			"Beschlag", "Holzzapfen"
			}
	elseif event == 2 then
		Items = { 
			"Wheat", "Barleybread", "FriedHerring", "BreadRoll",
			"GrainPap", "Wheatbread", "Shellsoup", "RoastBeef",
			"SmokedSalmon"
			}
	elseif event == 3 then
		Items = { 
			"IronCap", "IronBrachelet", "LeatherGloves", 
			"LeatherArmor", "Chainmail", "FullHelmet", 
			"Platemail",
			"Dagger", "Longsword", "Axe", "Mace", "Shortsword"
			}
	elseif event == 4 then
		Items = { 
			"Perfume", "SmallBeer", "WheatBeer", "CreamPie", 
			"Cake", "Soap", "Candy",
			"Kamm", "pddv"
			}
	else
		Items = { 
			"Iron", "Silver", "Gold", 
			"Pinewood", "Oakwood", "Wool", "Fungi", 
			"Ektoplasma", "Charcoal"
			}
	end

	local	Count = 1
	while Items[Count] do
		Count = Count + 1
	end

	local	Sel	= Rand(Count-1)+1
	return Items[Sel]
end

function NeedItemsCleanUp()
	local Item = GetData("Item")
	if Item then
		local Count = GetItemCount("", Item, INVENTORY_STD)
		RemoveItems("", Item, Count, INVENTORY_STD)
		CitySetFixedPrice("", Item, -1, -1, -1)
	end
end



-- *******************************************
--
-- Event: Kontor offers resources/gathers
-- 
-- *******************************************

function OfferItems()

	-- use an random event
	local random = Rand(4)

	local	Item = state_kontor_event_OfferItemsFindItem(random)
	if not Item then
		return
	end
	
	local BasePrice = ItemGetBasePrice(Item)
	if BasePrice<1 then
		return
	end
	
	local Offering = Rand(12)*5 + 10
	SetData("Item", Item)
	SetProperty("", "EventItem", Item)
	
	local CurrentTime = GetGametime()
	local Gametime	= Rand(12)+12
	local DestTime     = CurrentTime + Gametime
	local	ToDo			= Gametime2Realtime(Gametime)
	local ItemLabel	= ItemGetLabel(Item, false)
	local	Count
	local	Success 	= false
	local ID = "Event"..GetID("")
	
	GetSettlement("", "City")

	MsgNewsNoWait("All","","@C[@L_KONTOR_MISSIONS_OFFER_ITEMS_COOLDOWN_+0,%5i,%6l]","economie",-1,
			       "@L_KONTOR_MISSIONS_OFFER_ITEMS_HEAD_+"..random,
			       "@L_KONTOR_MISSIONS_OFFER_ITEMS_TEXT_+"..random,
			       GetID("City"), Offering, ItemLabel, Gametime,DestTime,ID)
	
	CitySetFixedPrice("", Item, BasePrice*0.5, BasePrice*0.8, Gametime)

	-- first remove all items of this type	
	Count = GetItemCount("", Item, INVENTORY_STD)
	RemoveItems("", Item, Count, INVENTORY_STD)
	
	AddItems("", Item, Offering, INVENTORY_STD)
	
	while ToDo>0 do
		Sleep(2)
		Count = GetItemCount("", Item, INVENTORY_STD)
		if Count < 1 then
			Success = true
			break
		end
		ToDo = ToDo - 2
	end

	-- message to insert here: end of the event
	if Success then
		feedback_MessageEconomie("All", "@L_KONTOR_MISSIONS_OFFER_ITEMS_SUCCESS_HEAD_+0",
						"@L_KONTOR_MISSIONS_OFFER_ITEMS_SUCCESS_TEXT_+0",
						GetID("City"), ItemLabel)
	else
		feedback_MessageEconomie("All", "@L_KONTOR_MISSIONS_OFFER_ITEMS_FAILED_HEAD_+0",
						"@L_KONTOR_MISSIONS_OFFER_ITEMS_FAILED_TEXT_+0",
						GetID("City"), ItemLabel)
	end

end

function OfferItemsFindItem(event)

	local	Items = {}

	if event == 0 then
		Items = { 
			"ToadExcrements", "Blanket", 
			"HerbTea", "Poem", "ThesisPaper", 
			"AboutTalents1", "AboutTalents2",
			"Medicine", "Torch", 
			"CitizensClothes", "FarmersClothes",
			"Perfume", "SmallBeer", "WheatBeer", "CreamPie", 
			"Cake", "Soap", "Candy",
			"optieisen", "optisilber",
			"optigold", "HexerdokumentI",
			"HexerdokumentII",
			"Kamm", "pddv", "spindel"
			}
	elseif event == 1 then
		Items = { 
			"IronCap", "IronBrachelet", "LeatherGloves", 
			"LeatherArmor", "Chainmail", "FullHelmet", 
			"Platemail",
			"Dagger", "Longsword", "Axe", "Mace", "Shortsword"
			}
	elseif event == 2 then
		Items = { 
			"Wheat", "Barleybread", "FriedHerring", "BreadRoll",
			"GrainPap", "Wheatbread", "Shellsoup", "RoastBeef",
			"SmokedSalmon"
			}
	else
		Items = { 
			"Iron", "Silver", "Gold",
			"Pinewood", "Oakwood", "Leather",
			"Beschlag", "Holzzapfen",
			"Wool", "Ektoplasma", "Charcoal", "Fungi"
			}
	end

	local	Count = 1
	while Items[Count] do
		Count = Count + 1
	end

	local	Sel	= Rand(Count-1)+1
	return Items[Sel]
end

function OfferItemsCleanUp()
	local Item = GetData("Item")
	if Item then
		local Count = GetItemCount("", Item, INVENTORY_STD)
		RemoveItems("", Item, Count, INVENTORY_STD)
		CitySetFixedPrice("", Item, -1, -1, -1)
	end
end

