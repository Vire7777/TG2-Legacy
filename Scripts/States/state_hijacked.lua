function Init()
	-- SetStateImpact("no_idle")
	SetStateImpact("no_hire")
	SetStateImpact("no_fire")	
	SetStateImpact("no_control")
	SetStateImpact("no_measure_start")	
	SetStateImpact("no_measure_attach")	
	SetStateImpact("no_charge")
	SetStateImpact("no_arrestable")
	SetStateImpact("no_action")
	SetStateImpact("no_attackable")
	SetStateImpact("NoCameraJump")
	SetStateImpact("no_cancel_button")
end

function Run()
	-- Add xp
	if BuildingGetOwner("Base", "BuildingOwner") then
		xp_HijackCharacter("BuildingOwner", SimGetLevel(""))
	end
	
	if not GetInsideBuilding("", "Base") then
		return
	end
		
	local Time = mdata_GetDuration(10920) --ms_HijackCharacter
	if GetImpactValue("", "Escapee")==1 then
		Time = 8+Rand(8)
	end
	
	SimSetBehavior("", "Hijacked")
	feedback_MessageCharacter("Base",
		"@L_THIEF_065_HIJACKCHARACTER_MSG_ACTOR_SUCCESS_HEAD",
		"@L_THIEF_065_HIJACKCHARACTER_MSG_ACTOR_SUCCESS_BODY",GetID(""),GetID("Base"))
	
	local OutTime = (GetGametime() + Time)
	SetProperty("","HijackedEndTime",OutTime)
	
	StartGameTimer(Time)
	if HasProperty("","ForceFree") then
		RemoveProperty("","ForceFree")
	end
	while not CheckGameTimerEnd() do
		Sleep(2+Rand(9))
        if not GetInsideBuilding("", "Base") then
         	SetState("", STATE_HIJACKED, false)
			SetState("", STATE_CAPTURED, false)
			SetState("", STATE_CUTSCENE, false)
		 break
        end
        if HasProperty("","ForceFree") then
		break
		end
		
	end
	
	
end

function CleanUp()
	if HasProperty("","ForceFree") then
		RemoveProperty("","ForceFree")
	end
	SetState("", STATE_EXPEL, true)
	SetState("", STATE_HIJACKED, false)
	SetState("", STATE_CAPTURED, false)
	SetState("", STATE_CUTSCENE, false)
	
	SimResetBehavior("")
	-- can walk home after 24 hours
	if GetHomeBuilding("", "Home") then
		MeasureRun("", "Home", "Walk", true)
	end
end
