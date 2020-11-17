function Init()
end

function Run()
	local duration = 4
	AddImpact("","InfectedByDisease",1,24)	
	--is infected with fever. go buy herb tea or blanket
	if (GetImpactValue("","Fever")==1) then
		if GetDynastyID("") then
			if not IsDynastySim("") then		
				SetState("",STATE_WORKING,false)
				idlelib_Illness("")

				duration = 6
			end
		else
			duration = 8 
		end
	end	
	--ShowOverheadSymbol("",true,true,0,":(")
	local Runtime = GetGametime() + duration
	CommitAction("disease","","")
	SimResetBehavior("")
	while GetGametime()<Runtime do
		Sleep(5)
	end
end

function CleanUp()
	RemoveAllOverheadSymbols("")
	StopAction("disease","")
	SetState("Owner", STATE_BLACKDEATH, false)
	if SimGetWorkingPlace("","Workbuilding") then
		local Hour = math.mod(GetGametime(), 24)
		if (Hour < BuildingGetWorkingEnd("Workbuilding")) and (Hour > BuildingGetWorkingStart("Workbuilding")) then
			SetState("",STATE_WORKING,true)
		end
	end
end

