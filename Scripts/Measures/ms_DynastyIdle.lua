function Run()
	if not AliasExists("") then
		StopMeasure()
	end
	
	if GetImpactValue("", "banned")==1 then
		MeasureRun("", nil, "DynastyBanned")
		StopMeasure()
	end

	local	Value = Rand(80)

	if GetImpactValue("","Cold")==1 or GetImpactValue("","BurnWound")==1 or GetImpactValue("","Caries")==1 then
		idlelib_Illness("")
	end

	if GetImpactValue("","Sickness")>0 then
		if gameplayformulas_CheckMoneyForTreatment("")==1 then
			idlelib_VisitDoc("")
		end
	end

	if GetHP("") < (GetMaxHP("")/2) then
		if DynastyGetRandomBuilding("",8,111,"Schlossie") then
			idlelib_DinnerAtEstate("")
		else
			if gameplayformulas_CheckMoneyForTreatment("")==1 then
				idlelib_VisitDoc("")
			end
		end
	end
	
	if Value < 10 then
	  idlelib_GoTownhall("")
	elseif Value < 15 then
		idlelib_GoToRandomPosition("")
	elseif Value < 30 then
	  if DynastyGetRandomBuilding("",8,111,"Schlossie") then
			idlelib_DinnerAtEstate("")
		else
		  idlelib_SitDown("")
		end
	elseif Value < 35 then
	  if IsPartyMember("") then
			idlelib_CheckInsideStore("")
		else
		  idlelib_BuySomethingAtTheMarket("")
		end
	elseif Value < 40 then
-- ******** THANKS TO KINVER ********
		local checkBOK = false
		if HasProperty("", "TimeBank") then
			local gtime = GetProperty("", "TimeBank")
			if gtime < GetGametime() then
				checkBOK = true
			end
		else
			checkBOK = true
		end

		if not HasProperty("","SchuldenGeb") and Rand(5)==0  then
			idlelib_TakeACredit("")
		elseif HasProperty("","SchuldenGeb") and (Rand(5)>2) and (checkBOK) then
			idlelib_ReturnACredit("")
		end
-- **********************************
	elseif Value < 60 then
	  local zufall = Rand(100)
		if zufall > 85 then
		  if Rand(2) == 0 then
			  idlelib_BeADrunkChamp("")
			else
				idlelib_BeADiceChamp("")
			end
		else
			idlelib_DoNothing("")
		end
	elseif Value < 70 then
		idlelib_UseCocotte("")
	elseif Value < 80 then
		idlelib_CollectWater("")
	else
	  if SimGetClass("") == 4 then
		  idlelib_GoToDivehouse("")
		else
		  if Rand(3) == 1 then
				idlelib_GoToDivehouse("")
			else
		    idlelib_GoToTavern("")
			end
		end
	end
end

function CleanUp()
end
