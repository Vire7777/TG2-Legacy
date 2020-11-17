function GetTimerName()
	return "AI_DynPrivilegeDefensive"
end

function Weight()
	if SimGetOfficeLevel("SIM") < 1 then
		return 0
	end
	local TimerName = def_useprivilege_GetTimerName()
	if not ReadyToRepeat("SIM", TimerName) then
		return 0
	end
	
	if GetGametime() < 24 then
		return 0
	end
		
	
	return 100
end

function GetVictim(maxfavor)
	if not GetDynasty("SIM", "dynasty") then
		return false
	end

	if not DynastyGetRandomVictim("dynasty", maxfavor, "VictimDynasty") then
		return false
	end

	local Count = DynastyGetMemberCount("VictimDynasty")
	local Victim = Rand(Count)
	if not (DynastyGetMember("VictimDynasty", Victim, "Victim")) then
		return false
	end

	return true
end

function Execute()
		
----------------------------------------------------------------------------------------------------------
----	Defensive Privileges
----	-AbsolveSinner				
----	-EmbezzlePublicMoney			
----	-PropitiateEnemies	
----	-Set_ChurchTithe
----	-Set_SeverityOfLaw
----	-Set_TurnoverTax
----  -LevelUpCity			
----------------------------------------------------------------------------------------------------------	
		
	local success = false
	local	Names = { "AbsolveSinner", def_useprivilege_AbsolveSinner,
			"EmbezzlePublicMoney",def_useprivilege_EmbezzlePublicMoney,
			"PropitiateEnemies",def_useprivilege_PropitiateEnemies,
			"Set_ChurchTithe",def_useprivilege_Set_ChurchTithe,
			"Set_SeverityOfLaw",def_useprivilege_Set_SeverityOfLaw,
			"Set_TurnoverTax",def_useprivilege_Set_TurnoverTax,
			"LevelUpCity",def_useprivilege_LevelUpCity,
			nil, nil }
	
	local Lauf = 1
	local Count = 0
	local Func
	Func = {}
	while Names[Lauf]~=nil do
		if  GetImpactValue("SIM",Names[Lauf])==1 then
			Func[Count] = Names[Lauf+1]
			Count = Count + 1
		end
		Lauf = Lauf + 2
	end
	
	if Count>0 then
		local Choice = Rand(Count)
		success = true
		Func[Choice]()
	end
end

function AbsolveSinner()
	TimerName = def_useprivilege_GetTimerName()
	if not def_useprivilege_GetVictim(80) then
		SetRepeatTimer("SIM", TimerName, 2)
		return 
	end
	SetRepeatTimer("SIM", def_useprivilege_GetTimerName(), 24)
	if GetEvidenceValues("SIM","Victim")>0 then
		SetRepeatTimer("SIM", def_useprivilege_GetTimerName(), 24)
		MeasureRun("SIM", "Victim", "AbsolveSinner")
	else 
		SetRepeatTimer("SIM", TimerName, 2)
		return
	end
end

function EmbezzlePublicMoney()
	local Disposition = SimGetAlignment("SIM")
	SetRepeatTimer("SIM", def_useprivilege_GetTimerName(), 24)
	if Disposition >= 40 and Disposition <= 70 and Rand(1) == 0 then
		MeasureRun("SIM", 0, "EmbezzlePublicMoney")
	elseif Disposition > 70 then
		MeasureRun("SIM", 0, "EmbezzlePublicMoney")
	else
		return
	end
end

function LevelUpCity()
	SetRepeatTimer("SIM", def_useprivilege_GetTimerName(), 24)
	MeasureRun("SIM", 0, "LevelUpCity")
end

function PropitiateEnemies()

	local TimerName = def_useprivilege_GetTimerName()
	if not def_useprivilege_GetVictim(80) then
		SetRepeatTimer("SIM", TimerName, 2)
		return 
	end
	CopyAlias("Victim","Destination")
	
	if not def_useprivilege_GetVictim(80) then
		SetRepeatTimer("SIM", TimerName, 2)
		return 
	end
	if GetID("Destination") == GetID("Victim") then
		return
	end
	
	CopyAlias("Victim","Destination2")
	SetRepeatTimer("SIM", def_useprivilege_GetTimerName(), 24)
	MeasureCreate("Measure")
	MeasureAddAlias("Measure","Destination2", "Destination2", false)
	MeasureStart("Measure","SIM","Destination","PropitiateEnemies")
end

function Set_ChurchTithe()
	MeasureRun("SIM", 0, "Set_ChurchTithe")
end

function Set_SeverityOfLaw()
	MeasureRun("SIM", 0, "Set_SeverityOfLaw")
end

function Set_TurnoverTax()
	MeasureRun("SIM", 0, "Set_TurnoverTax")
end

function CleanUp()
end
