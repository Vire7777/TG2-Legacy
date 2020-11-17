function Init()

	if not ResourceCanBeChanged("Destination") then
		StopMeasure()
		return
	end
	

	local CheckItem = false
	if SimGetWorkingPlace("", "Farm") then
		CheckItem = true
	else
		if IsPartyMember("") then
			local NextBuilding = ai_GetNearestDynastyBuilding("",GL_BUILDING_CLASS_WORKSHOP,GL_BUILDING_TYPE_FARM)
			if not NextBuilding then
				StopMeasure()
			end
			CopyAlias(NextBuilding,"Farm")
			CheckItem = true
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
		local   buttPic
		local   l
		for l=0,TypeCount-1 do
			local ItemID = ResourceGetTypeItem("Destination", l)
						
			if (ItemID ~= -1) then
				if not CheckItem or BuildingCanProduce("Farm", ItemID) then
				    if ItemID == 8 then
					    buttPic = 7
					elseif ItemID == 10 then
					    buttPic = 9
					elseif ItemID == 11 then
					    buttPic = 4
					end
					Texture = "Hud/Items/Item_"..ItemGetName(buttPic)..".tga"
					Buttons = Buttons .. "@B[S" .. l .. ",," .. ItemGetLabel(buttPic, true) .. ","..Texture.."]"
				end
			end
		end

		local result = InitData(Buttons,  ms_raisecattle_AIInit,
		"@L_GENERAL_MEASURES_RAISECATTLE_HEAD_+0",
		"@L_GENERAL_MEASURES_RAISECATTLE_BODY_+0")
		
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

	local filter
	if ResourceGetItemId("Destination") == 8 then
		filter ="__F( (Object.GetObjectsByRadius(Sim)==700)AND(Object.GetProfession()==55))"
	elseif ResourceGetItemId("Destination") == 10 then
	filter ="__F( (Object.GetObjectsByRadius(Sim)==700)AND(Object.GetProfession()==57))"
	elseif ResourceGetItemId("Destination") == 11 then
	filter ="__F( (Object.GetObjectsByRadius(Sim)==700)AND(Object.GetProfession()==58))"	
	end
	if filter then
	    local k = Find("Destination",filter,"PflegeViehs",6)
	    for l=0, k do
		    InternalDie("PflegeViehs"..l)
	        InternalRemove("PflegeViehs"..l)
	    end
	end	
	
	SetData("Selection", Selection)	
	
end

function AIInit()

	local betrieb = GetData("WorkPlatz")
	local weights = { 1000, 1000, 1000 }
	
    if BuildingHasUpgrade(betrieb,68) == true then
	    weights[1] = 0
	end
	if BuildingHasUpgrade(betrieb,64) == true then
	    weights[2] = 0
	end
	if BuildingHasUpgrade(betrieb,65) == true then
	    weights[3] = 0
	end
	
	BuildingGetCity("WorkPlatz","checkTown")
    CityGetRandomBuilding("checkTown",5,14,-1,-1,FILTER_IGNORE,"Markt")
	local slots = InventoryGetSlotCount("Markt",INVENTORY_STD)
	for v=0,slots-1 do
		local id, menge = InventoryGetSlotInfo("Markt",v,INVENTORY_STD)
		if id == 8 and weights[1] == 0 then
		    weights[1] = menge
		end
		if id == 10 and weights[2] == 0 then
		    weights[2] = menge
		end
		if id == 11 and weights[3] == 0 then
		    weights[3] = menge
		end
	end

    local produkt = { "S0", "S1", "S2" }
	local round

	if weights[1] >= weights[2] then
	    round = 2
	elseif weights[1] < weights[2] then
	    round = 1
	end
	
	if weights[round] >= weights[3] then
	    round = 3
	elseif weights[round] < weights[3] then
	    round = round
	end
	
	return produkt[round]

end

function Run()

	if not BlockChar("Owner") then
		return
	end
	
    if not f_MoveTo("","Destination",GL_MOVESPEED_RUN) then
	    StopMeasure()
	end	
	
    SetContext("", "sow")
	CarryObject("","Handheld_Device/ANIM_Seed.nif", true)
	PlayAnimation("","sow_field_in")
	LoopAnimation("", "sow_field_loop", 2)
	ms_raisecattle_neuvieh(1)
	LoopAnimation("", "sow_field_loop", 2)
	ms_raisecattle_neuvieh(2)
	LoopAnimation("", "sow_field_loop", 2)
	ms_raisecattle_neuvieh(3)
	LoopAnimation("", "sow_field_loop", 2)
	ms_raisecattle_neuvieh(4)
	PlayAnimation("","sow_field_out")
	CarryObject("","",true)
	Sleep(2)
	
	local ToSow = GetData("Selection")
	ResourceSow("Destination", ToSow)
	Sleep(1)
	
end

function neuvieh(s)

    local wahl = GetData("Selection")
	local hoftier, hoftierID
	GetPosition("Destination","HueterPos")

	local x,y,z = PositionGetVector("HueterPos")
	x = x + ((Rand(200)*2)-200)
	z = z + ((Rand(200)*2)-200)
	PositionModify("HueterPos",x,y,z)
	SetPosition("HueterPos",x,y,z)

	if wahl == 0 then
	    hoftierID = 920
	    hoftier = "Sheep"
	elseif wahl == 1 then
	    hoftierID = 922
	    hoftier = "Cattle"
	elseif wahl == 2 then
	    hoftierID = 923
	    hoftier = "Pig"
	end
	SimCreate(hoftierID,"","HueterPos","Tier"..s)
	SimSetFirstname("Tier"..s, "@L_UPGRADE_"..hoftier.."_NAME_+0")
	SimSetLastname("Tier"..s, "@L_EMPTY_NAME_+0")

	if not AddImpact("Tier"..s,390,1,-1) then
	    -- nix da ohne Impact o_O
	end
	SetState("Tier"..s, STATE_ANIMAL, true)

	return

end

function CleanUp()

    CarryObject("","",true)
    CarryObject("","",false)
	RemoveProperty("","ToBeSowed")
    MoveSetActivity("","")
	StopAnimation("")

end
