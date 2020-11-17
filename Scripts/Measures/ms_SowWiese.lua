function Init()
	
	if not ResourceCanBeChanged("Destination") then
		StopMeasure()
		return
	end

	if SimGetWorkingPlace("", "Farm") then
		-- alles ok
	else
		if IsPartyMember("") then
			local NextBuilding = ai_GetNearestDynastyBuilding("",2,108)
			if not NextBuilding then
				StopMeasure()
			end
			CopyAlias(NextBuilding,"Farm")
		else
			StopMeasure()
		end
	end
    SetData("WorkPlatz","Farm")
	
	if GetData("Selection") then
		-- "Selection" is already added to this measure, so nothing must be done here
		return
	end
	
	local	Selection
	local setzItem
	
	local	TypeCount = ResourceGetTypeCount("Destination")
	if (TypeCount==0) or (TypeCount==nil) then
		-- this resource cannot be sow'ed
		StopMeasure()
		return
	end
	
	if TypeCount==1 then
		Selection = 1
	elseif TypeCount>1 then
		local	Buttons = ""
		local	l
		for l=0,TypeCount-1 do
			local ItemID = ResourceGetTypeItem("Destination", l)
			if (ItemID ~= -1) and BuildingCanProduce("Farm", ItemID) then
				Texture = "Hud/Items/Item_"..ItemGetName(ItemID)..".tga"
				Buttons = Buttons .. "@B[S" .. l .. ",," .. ItemGetLabel(ItemID, true) .. ","..Texture.."]"
			end
		end

		local result = InitData(Buttons,  ms_SowWiese_AIInit,
		"@L_GENERAL_MEASURES_SOWFIELD_HEAD_+0",
		"@L_GENERAL_MEASURES_SOWFIELD_BODY_+0")
		
		ResourceType = -1
		for l=0,TypeCount-1 do
			if result=="S"..l then
				Selection = l
				setzItem = ResourceGetTypeItem("Destination", l)
				break
			end
		end
	end
	
	if not Selection then
		StopMeasure()
		return
	end
	SetData("Selection", Selection)
	SetData("TheItem",setzItem)
end

function AIInit()

	local betrieb = GetData("WorkPlatz")
	local weights = { 1000, 1000 }
	
	if BuildingHasUpgrade(betrieb,720) == true then -- 720 = Honey
	    weights[1] = 0
	end
	if BuildingHasUpgrade(betrieb,721) == true then -- 721 = Fruits
	    weights[2] = 0
	end

	BuildingGetCity("WorkPlatz","checkTown")
  CityGetRandomBuilding("checkTown",5,14,-1,-1,FILTER_IGNORE,"Markt")
	local slots = InventoryGetSlotCount("Markt",INVENTORY_STD) -- Marktbestand 
	for v=0,slots-1 do
		local id, menge = InventoryGetSlotInfo("Markt",v,INVENTORY_STD)
		if id == 940 and weights[2] == 0 then -- Honey
		    weights[2] = menge
		end
		if id == 941 and weights[1] == 0 then -- Fruit
		    weights[1] = menge
		end
	end	

  local produkt = { "S0", "S1" }
	local round

	if weights[1] < weights[2] then
	    round = 1
	elseif weights[2] < weights[1] then
	    round = 2
	else 
		round = Rand(2)+1
	end
	
	return produkt[round]
	
end

function Run()
    local itID = GetData("TheItem")
	if not BlockChar("Destination") then
		return
	end
	
	f_MoveTo("", "Destination", GL_MOVESPEED_RUN)
	if itID == 941 then
	    CarryObject("","Handheld_Device/ANIM_Pitchfork.nif", false)
	    PlayAnimation("","churn")
	    CarryObject("","", false)
	    CarryObject("","Handheld_Device/ANIM_scheffel.nif", false)
	    PlayAnimation("","knee_work_in")
	    LoopAnimation("","knee_work_loop",4)
	    PlayAnimation("","knee_work_out")
		CarryObject("","", false)
	else
	    SetContext("","rangerhut")
	    CarryObject("","Handheld_Device/Anim_Hammer.nif", false)
	    Sleep(1)
	    PlayAnimation("","hammer_in")
	    LoopAnimation("","hammer_loop",6)
	    PlayAnimation("","hammer_out")
	end

	local ToSow = GetData("Selection")
	ResourceSow("Destination", ToSow)
	Sleep(1)
end

function CleanUp()
end
