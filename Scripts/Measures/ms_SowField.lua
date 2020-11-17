function Init()
	
	if not ResourceCanBeChanged("Destination") then
		StopMeasure()
		return
	end

	if SimGetWorkingPlace("", "Farm") then
		-- alles ok
	else
		if IsPartyMember("") then
			local NextBuilding = ai_GetNearestDynastyBuilding("",GL_BUILDING_CLASS_WORKSHOP,GL_BUILDING_TYPE_FARM)
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

		local result = InitData(Buttons,  ms_SowField_AIInit,
		"@L_GENERAL_MEASURES_SOWFIELD_HEAD_+0",
		"@L_GENERAL_MEASURES_SOWFIELD_BODY_+0")
		
		ResourceType = -1
		for l=0,TypeCount-1 do
			if result=="S"..l then
				Selection = l
				break
			end
		end
	end
	
	if not Selection then
		StopMeasure()
		return
	end
	SetData("Selection", Selection)
end

function AIInit()

	local betrieb = GetData("WorkPlatz")
	local weights = { 1000, 1000, 1000, 1000 }
	local weights_type = { 0, 0, 0, 0 }
	local maxweights = 0
	
	--LogMessage("Sowing:")
	--need to find out how order of building upgrades goes: sure hope this is correct!
	
	if BuildingHasUpgrade(betrieb,718) == true then--fruit
	   	maxweights = maxweights + 1
		weights[maxweights] = 0
		weights_type[maxweights] = 941
		--LogMessage("fruit")
	end
	if BuildingHasUpgrade(betrieb,719) == true then--honey
	    maxweights = maxweights + 1
		weights[maxweights] = 0
		weights_type[maxweights] = 940
		--LogMessage("honey")
	end
	if BuildingHasUpgrade(betrieb,165) == true then--barley
		maxweights = maxweights + 1
		weights[maxweights] = 0
		weights_type[maxweights] = 3
		--LogMessage("barley")
	end
	if BuildingHasUpgrade(betrieb,83) == true then--wheat
		maxweights = maxweights + 1
		weights[maxweights] = 0
		weights_type[maxweights] = 2
		--LogMessage("wheat")
	end

	--LogMessage("weights:" .. maxweights)
	
	BuildingGetCity("WorkPlatz","checkTown")
    CityGetRandomBuilding("checkTown",5,14,-1,-1,FILTER_IGNORE,"Markt")
	
	local slots = InventoryGetSlotCount("Markt",INVENTORY_STD)
	for v=0,slots-1 do
		local id, menge = InventoryGetSlotInfo("Markt",v,INVENTORY_STD)
		
		for itt=1,maxweights do
			if id==weights_type[itt] and weights[itt] == 0 then
				weights[itt] = menge
			end
		end
		
		-- if id == 2 and weights[2] == 0 then
		    -- weights[2] = menge
		-- end
		-- if id == 3 and weights[1] == 0 then
		    -- weights[1] = menge
		-- end
		-- if id == 941 and weights[3] == 0 then--fruit
		    -- weights[3] = menge
		-- end
		-- if id == 940 and weights[4] == 0 then--honey
		    -- weights[4] = menge
		-- end
	end	

    local produkt = { "S0", "S1", "S2", "S3" }
	local round

	local lowest = 99999
	for itt=1,maxweights do
		if weights[itt] < lowest then
			lowest = weights[itt]
			round = itt
		end
	end
	
	-- if weights[1] >= weights[2] then
	    -- round = 2
	-- elseif weights[1] < weights[2] then
	    -- round = 1
	-- end
	
	return produkt[round]
	
end

function Run()
	if not BlockChar("Destination") then
		return
	end
	SetContext("", "sow")
	f_MoveTo("", "Destination", GL_MOVESPEED_RUN)
	GetPosition("", "ParticleSpawnPos")
	CarryObject("","Handheld_Device/ANIM_Seed.nif", true)
	PlayAnimation("","sow_field_in")
	for i=0,2 do
		local wait = PlayAnimationNoWait("","sow_field_loop")
		Sleep(0.5)
		PlaySound3DVariation("", "measures/sowfield")
		Sleep(wait-0.5)
	end
	PlayAnimation("","sow_field_out")
	CarryObject("","", true)
	local ToSow = GetData("Selection")
	ResourceSow("Destination", ToSow)
	Sleep(1)
end

function CleanUp()
end
