function Run()

	local	TimeOut
	
	if not HasProperty("", "ATLOF_TimeOut") then
		TimeOut = GetData("TimeOut")
		if TimeOut then
			TimeOut = TimeOut + GetGametime()
			SetProperty("", "ATLOF_TimeOut", TimeOut)
		end
	else
		TimeOut = GetProperty("", "ATLOF_TimeOut")
	end
	
	if not ai_GetWorkBuilding("", GL_BUILDING_TYPE_PIRAT, "WorkBuilding") then
		StopMeasure() 
		return
	end 
	MeasureSetStopMode(STOP_NOMOVE)
	
	if not AliasExists("Destination") then
		return
	end

	SetProperty("","CocotteHasClient",0)
	SetProperty("","CocotteProvidesLove",1)
	
	-- start the labor
	SetData("IsProductionMeasure", 0)
	SimSetProduceItemID("", -GetCurrentMeasureID(""), -1)
	SetData("IsProductionMeasure", 1)

	while true do
		if not f_MoveTo("","Destination",GL_MOVESPEED_RUN) then
			if not f_MoveTo("","Destination",GL_MOVESPEED_RUN,100) then
				break
			end
		end
		-- some animation stuff
		-- random speech
		local SimFilter = "__F( (Object.GetObjectsByRadius(Sim)<500)AND(Object.HasDifferentSex())AND(Object.GetState(idle))AND NOT(Object.GetState(townnpc))AND NOT(Object.HasImpact(FullOfLove)))"
		local NumSims = Find("",SimFilter,"Sims",-1)
		if NumSims > 0 then
			local DestAlias = "Sims"..Rand(NumSims-1)
			AlignTo("",DestAlias)
			Sleep(1)
			local AnimTime = PlayAnimationNoWait("","point_at")
			MsgSayNoWait("","@L_PIRATE_LABOROFLOVE_PROPOSE")
			Sleep(AnimTime)
			if GetDynastyID(DestAlias)<1 then
				if Rand(100)>50 then
					MeasureRun(DestAlias,"","UseLaborOfLove")
				else
					AddImpact(DestAlias,"FullOfLove",1,4)
				end
			else
				AddImpact(DestAlias,"FullOfLove",1,4)
			end
			
			if not GetSettlement("", "City") then
				return
			end
		end
		Sleep(5)
	end
	
	StopMeasure()
end

function CleanUp()
  StopAnimation("")
  RemoveProperty("","CocotteProvidesLove")
end

function GetOSHData(MeasureID)
end


