function Run()
	if IsGUIDriven() then
		GetInsideBuilding("","Destination")
	end

	if not AliasExists("Destination") then
		return 
	end
	
	if GetInsideBuildingID("")~=GetID("Destination") then
		-- sim is not in building - first move to church
		if not GetOutdoorMovePosition("", "Destination", "MovePos") then
			return
		end
		
		if not f_MoveTo("", "MovePos") then
			return
		end
	end
	
	
	
	local	TimeOut

	if GetImpactValue("Destination","MassInProgress")~=1 then
	
		TimeOut = Gametime2Realtime(1)
		while GetImpactValue("Destination","MassInProgress")~=1 and TimeOut>0 do
			Sleep(2)
			TimeOut = TimeOut - 2
		end
		
		if GetImpactValue("Destination","MassInProgress")~=1 then
			return
		end

	end

	SetAvoidanceRange("",15)
	local success = false
	local	Value
	
	for trys=0,10 do
		Value = 1 + Rand(29)
		if GetFreeLocatorByName("Destination","Sit",Value,Value,"SitPos") then
			success = f_BeginUseLocator("","SitPos",GL_STANCE_SITBENCH,true)
			if success then
				break
			end
		end
	end
	
	if not success then
		if GetFreeLocatorByName("Destination","Sit",1,30,"SitPos") then
			success = f_BeginUseLocator("","SitPos",GL_STANCE_SITBENCH,true)
		end
	end
	
--	if not success then
--		LocIndex = 1 + Rand(5)
--		GetLocatorByName("Destination","Stroll"..LocIndex,"MovePos")
--		SetAvoidanceRange("",15)
--		success = f_MoveToNoWait("", "MovePos",GL_MOVESPEED_WALK,300)
--	end
	
	if not success then
		-- sim was unable to get to it's position, so the church is closed ?
--		GetLocalPlayerDynasty("Player")
--		MsgQuick("Player", "@Li cant find chair :(")
		return
	end
	
	local WaitStep = Gametime2Realtime(0.25)
	local	Attr		= GetImpactValue("Destination", "Attractivity")	-- 0 - 0.75
	local Money		= math.floor(1.5*(7+(1+Attr*4)*SimGetRank(""))) 
	SetData("MessMoney",Money)
	local Transfered
	local HouselTaken = false
	
	local	Progress = 0.5 - 0.3*0.01*SimGetFaith("")
	
	while SimGetNeed("", 4)>0 do
	
		Sleep(WaitStep)

		if not HouselTaken then
			if GetItemCount("Destination", "Housel", INVENTORY_SELL)>0 then
				Transfer(nil, nil, INVENTORY_STD, "Destination", INVENTORY_SELL, "Housel", 1)
				SatisfyNeed("", 4, -0.25)
				HouselTaken = true
			end
		end

		SatisfyNeed("", 4, Progress)
		if GetDynastyID("Destination") ~= GetDynastyID("") then
			CreditMoney("Destination", Money, "Offering")
		end
		if GetImpactValue("Destination","MassInProgress")~=1 then
			break
		end
		
		if Rand(20) == 1 then
			MsgSayNoWait("","@L_CHURCH_091_PREPAREWORSHIP_WORSHIPPING_COMMENT")
		end
	end
	
	ms_attendmass_AffectFaith()
end

function CleanUp()
	SetAvoidanceRange("",-1)
	AddImpact("","WasInChurch",1,4)
	if SimIsInside("") and IsGUIDriven() then
		SetState("", STATE_EXPEL, true)
	end
end

function AffectFaith()
	-- eigener Glauben steigt
	SimSetFaith("",SimGetFaith("")+10)
	local MyFaith = SimGetFaith("")
	
	if SpendMoney("",GetData("MessMoney"),"MessMoney") then
		-- gunst steigt bei allen Dynastien deren Anf?rer die gleiche Religion hat 
		GetSettlement("Destination","city")
		CityGetDynastyCharList("city","dyn_chars")
		for i=0,ListSize("dyn_chars")-1 do
			ListGetElement("dyn_chars",i,"char")
			if GetDynasty("char","dyn") then
				if DynastyGetMember("dyn",0,"member") then
					if GetID("member")==GetID("char") then
						if SimGetReligion("")==SimGetReligion("char") then
							ModifyFavorToDynasty("","dyn",MyFaith*SimGetFaith("char")/1000) -- 0..10
						end
					end
				end
			end
		end	
		
		-- gunst steigt bei anwesenden dynastielosen sims gleichen glaubens
		if GetInsideBuilding("","church") then
			BuildingGetInsideSimList("church","sim_list")
			for i=0,ListSize("sim_list")-1 do
				ListGetElement("sim_list",i,"sim")
				if GetDynastyID("sim")<1 and SimGetReligion("")==SimGetReligion("sim") then
					chr_ModifyFavor("","sim",MyFaith*SimGetFaith("sim")/1000)	-- 0..10
				end
			end
		end
	end
end

