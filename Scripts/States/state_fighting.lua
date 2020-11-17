function Init()
	SetStateImpact("no_idle") 
	SetStateImpact("no_hire")
	SetStateImpact("no_fire")	
	SetStateImpact("no_measure_attach")
	SetStateImpact("no_action")
	SetState("", STATE_HIDDEN, false)
end


function Run()

	if IsType("", "cl_Sim") then
		if DynastyIsAI("") then
			-- check starting the rage ability
			if GetImpactValue("", "Rage")~=0 then
				if GetMeasureRepeat("", "Rage")==0 then
					chr_StartRage("")
				end
			end
		end
	end

	while true do
		local startresult = BattleGetNextEnemy("", "", "nextEnemy")
		if startresult then
			f_Fight("","nextEnemy","subdue")
		else
			SetState("", STATE_FIGHTING, false) 
			return
		end
	end
end

function CleanUp()
	
	BattleLeave("")
	if not GetState("", STATE_UNCONSCIOUS) then
		if not HasProperty("","AttBld") then
			SimResumePreFightMeasure("");
		end
	end
	if HasProperty("","AttBld") then
		RemoveProperty("","AttBld")
	end
	if IsType("", "Building") then
		SetRepeatTimer("", GetMeasureRepeatName2("RenovateBuilding"), 1)
	end
end

