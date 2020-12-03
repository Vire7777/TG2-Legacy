function Run()
	
	if not ai_GetWorkBuilding("", GL_BUILDING_TYPE_FARM, "Farm") then
		StopMeasure() 
		return
	end
	MeasureSetStopMode(STOP_NOMOVE)

	if not AliasExists("Destination") then
		if IsStateDriven() then
			if not GetSettlement("Farm", "City") then
				return
			end
			
			if CityFindCrowdedPlace("City", "", "Destination")==0 then
				return
			end
		else
			if HasProperty("","MyQuacksalvePosX") then
				if not ScenarioCreatePosition(GetProperty("","MyQuacksalvePosX"), GetProperty("","MyQuacksalvePosZ"), "Destination") then
					return
				end
			else
				return
			end
		end

	else	
		if GetID("Farm")==GetID("Destination") then
			if IsStateDriven() then
				if not GetSettlement("Farm", "City") then
					return
				end
				
				if CityFindCrowdedPlace("City", "", "Destination")==0 then
					return
				end
			else
				if HasProperty("","MyQuacksalvePosX") then
					if not ScenarioCreatePosition(GetProperty("","MyQuacksalvePosX"), GetProperty("","MyQuacksalvePosZ"), "Destination") then
						return
					end
				else
					return
				end
			end
		end
	end
	
	SetData("IsProductionMeasure", 0)
	SimSetProduceItemID("", -GetCurrentMeasureID(""), -1)
	SetData("IsProductionMeasure", 1)

	if not f_MoveTo("","Destination",GL_MOVESPEED_RUN) then
		StopMeasure()
	end
	
  	GetPosition("","MyPos")
  	local x,y,z = PositionGetVector("MyPos")
	SetProperty("","MyQuacksalvePosX",x)
	SetProperty("","MyQuacksalvePosZ",z)

	SetRepeatTimer("", GetMeasureRepeatName(), 1)

	CommitAction("quacksalver", "", "")
	
	local maxStages = Rand(5)+5
	SetProcessMaxProgress("",Rand(5)+5)
	local progress = 0
	SetProcessProgress("",0)
	while progress < maxStages do
	
		if SimGetGender("")==GL_GENDER_MALE then
			PlaySound3DVariation("","CharacterFX/male_jolly",1)
		else
			PlaySound3DVariation("","CharacterFX/female_jolly",1)
		end
		local random = Rand(4)
		
		PlayAnimation("","pray_standing")
		MsgSay("", "@L_MEASURE_SELLMAGICBEANS_CONVINCE_+"..random)
		PlayAnimation("","preach")
		
		-- increase progress
		progress = progress + 1
		SetProcessProgress("",progress)
		Sleep( 1 + 0.1*Rand(20) )
	end
	
	StopAction("quacksalver", "")
	StopMeasure()
end

function CleanUp()
	StopAnimation("")
	StopAction("quacksalver", "")
end

function GetOSHData(MeasureID)
	--can be used again in:
	--OSHSetMeasureRepeat("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+2",Gametime2Total(mdata_GetTimeOut(MeasureID)))
end


