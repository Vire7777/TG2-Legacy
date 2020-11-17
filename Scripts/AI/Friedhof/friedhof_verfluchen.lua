function Weight() 
	
	if not SimGetWorkingPlace("SIM", "friedhof") then
		return 0
	end

	if BuildingGetLevel("friedhof") < 2 then
		return 0
	else
		if not BuildingHasUpgrade("friedhof","steinkreis") then
			return 0
		end		
	end

	if not IsDynastySim("SIM") then
		return 0
	end

	if GetMeasureRepeat("SIM", "VerFluchen") > 0 then
		return 0
	end

	if DynastyGetRandomVictim("dynasty", 20, "victim") then
		if DynastyGetDiplomacyState("dynasty", "victim") > DIP_NEUTRAL then
			return 0
		end
		if not DynastyGetRandomBuilding("victim", -1, -1, "victimhouse") then
			return 0
		end
	end 

	if GetItemCount("SIM", "Schadelkerze")>=6 then
		return 100
	else

		if not GetRemainingInventorySpace("",966,INVENTORY_STD) then
			return 0	
		end
		
		local CheckOk = false

		if GetItemCount("friedhof", "Schadelkerze", INVENTORY_STD) > 6 then
			CheckOk = true
		else
			if GetItemCount("friedhof", "Schadelkerze", INVENTORY_SELL) > 6 then
				CheckOk = true
			end
		end

		if CheckOk then
			if not f_MoveTo("SIM", "friedhof", GL_MOVESPEED_RUN) then
				return 0
			end
		end

		CheckOk = false
		if GetItemCount("friedhof", "Schadelkerze", INVENTORY_STD) > 6 then
			CheckOk = true
		else
			if GetItemCount("friedhof", "Schadelkerze", INVENTORY_SELL) > 6 then
				CheckOk = true
			end
		end

		if CheckOk then
			local Done
			local Result
				
			Result, Done = Transfer("", "", INVENTORY_STD, "friedhof", INVENTORY_STD, "Schadelkerze", 6)
			if not (Done>0) then
				Result, Done = Transfer("", "", INVENTORY_STD, "friedhof", INVENTORY_SELL, "Schadelkerze", 6)
			end
			
			if (Done > 0) then
				return 100
			else
				return 0
			end
		end	
	end	
--	orginal code
	return 0
end

function Execute()
--	GetLocalPlayerDynasty("Player")
--	MsgQuick("Player", "time to curse some one!")
	Sleep(2)
	MeasureRun("SIM","victimhouse","VerFluchen")
--	orginal code
--	return
end

function CleanUp()
end
