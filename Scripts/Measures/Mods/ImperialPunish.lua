function Run()
	MeasureSetNotRestartable()
	if HasProperty("destination","Pope") then
		MsgQuick("","@L_IMPERIALPUNISH_ERROR_ONE") 
		StopMeasure()
	end
	
	if HasProperty("destination","King") then
		if SimGetAlignment("destination") < 50 then
			MsgQuick("","@L_IMPERIALPUNISH_ERROR_TWO") 
			StopMeasure()
		end
	end
	
	if not find_HomeCity("destination","City") then
		StopMeasure()
	end
	
	local panel
	panel = ("@P"..
        "@B[1,@L_IMPERIALPUNISH_BUTTONS_+1]"..
        "@B[2,@L_IMPERIALPUNISH_BUTTONS_+2]"..
        "@B[3,@L_IMPERIALPUNISH_BUTTONS_+3]"..
        "@B[4,@L_IMPERIALPUNISH_BUTTONS_+4]"..
        "@B[0,@L_REPLACEMENTS_BUTTONS_CANCEL_+0]")
	
	local Result = MsgNews("","",panel,
            imperialpunish_AIDecision,  --AIFunc 
            "intrigue", --Message Class 
            2, --TimeOut 
            "@L_INTRIGUE_IMPERIALPUNISH_SCREENPLAY_ACTOR_HEAD_+0", 
            "@L_INTRIGUE_IMPERIALPUNISH_SCREENPLAY_ACTOR_BODY_+0", 
            GetID("destination"))

	if Result == 1 then
		local Money = GetMoney("destination")
		local Percentage = {}
			Percentage[1] = Money * 0.1
			Percentage[2] = Money * 0.25
			Percentage[3] = Money * 0.5
			Percentage[4] = Money * 0.75
		
		local Panel
		Panel = ("@P"..
        "@B[1,@L_IMPERIALTAX_BUTTONS_+1]"..
        "@B[2,@L_IMPERIALTAX_BUTTONS_+2]"..
        "@B[3,@L_IMPERIALTAX_BUTTONS_+3]"..
        "@B[4,@L_IMPERIALTAX_BUTTONS_+4]"..
        "@B[0,@L_REPLACEMENTS_BUTTONS_CANCEL_+0]")
	
		local result = MsgNews("","",Panel,
            imperialpunish_AIDecision,  --AIFunc 
            "intrigue", --Message Class 
            2, --TimeOut 
            "@L_INTRIGUE_IMPERIALTAX_SCREENPLAY_ACTOR_HEAD_+0", 
            "@L_INTRIGUE_IMPERIALTAX_SCREENPLAY_ACTOR_BODY_+0", 
            GetID("destination"),Percentage[1],Percentage[2],Percentage[3],Percentage[4])
		
		if result == 0 then
			StopMeasure()
		elseif result == 1 then
			CreditMoney("",Percentage[1],"IncomeOther")
			SpendMoney("destination",Percentage[1],"Taxes")
			feedback_MessageCharacter("",
				"@L_IMPERIALTAX_ACTOR_SUCCESS_HEAD_+0",
				"@L_IMPERIALTAX_ACTOR_SUCCESS_BODY_+0",GetID("destination"),Percentage[1])
			feedback_MessageCharacter("destination",
				"@L_IMPERIALTAX_ACTOR_SUCCESS_HEAD_+1",
				"@L_IMPERIALTAX_ACTOR_SUCCESS_BODY_+1",GetID(""),Percentage[1])
		elseif result == 2 then
			CreditMoney("",Percentage[2],"IncomeOther")
			SpendMoney("destination",Percentage[2],"Taxes")
			feedback_MessageCharacter("",
				"@L_IMPERIALTAX_ACTOR_SUCCESS_HEAD_+0",
				"@L_IMPERIALTAX_ACTOR_SUCCESS_BODY_+0",GetID("destination"),Percentage[2])
			feedback_MessageCharacter("destination",
				"@L_IMPERIALTAX_ACTOR_SUCCESS_HEAD_+1",
				"@L_IMPERIALTAX_ACTOR_SUCCESS_BODY_+1",GetID(""),Percentage[2])
		elseif result == 3 then
			CreditMoney("",Percentage[3],"IncomeOther")
			SpendMoney("destination",Percentage[3],"Taxes")
			feedback_MessageCharacter("",
				"@L_IMPERIALTAX_ACTOR_SUCCESS_HEAD_+0",
				"@L_IMPERIALTAX_ACTOR_SUCCESS_BODY_+0",GetID("destination"),Percentage[3])
			feedback_MessageCharacter("destination",
				"@L_IMPERIALTAX_ACTOR_SUCCESS_HEAD_+1",
				"@L_IMPERIALTAX_ACTOR_SUCCESS_BODY_+1",GetID(""),Percentage[3])
		else
			CreditMoney("",Percentage[4],"IncomeOther")
			SpendMoney("destination",Percentage[4],"Taxes")
			feedback_MessageCharacter("",
				"@L_IMPERIALTAX_ACTOR_SUCCESS_HEAD_+0",
				"@L_IMPERIALTAX_ACTOR_SUCCESS_BODY_+0",GetID("destination"),Percentage[4])
			feedback_MessageCharacter("destination",
				"@L_IMPERIALTAX_ACTOR_SUCCESS_HEAD_+1",
				"@L_IMPERIALTAX_ACTOR_SUCCESS_BODY_+1",GetID(""),Percentage[4])
		end
	elseif Result == 2 then
		local Duration = {}
			Duration[1] = 12
			Duration[2] = 24
			Duration[3] = 48
			Duration[4] = 96
		
		local Panel
		Panel = ("@P"..
        "@B[1,@L_IMPERIALPRISON_BUTTONS_+1]"..
        "@B[2,@L_IMPERIALPRISON_BUTTONS_+2]"..
        "@B[3,@L_IMPERIALPRISON_BUTTONS_+3]"..
        "@B[4,@L_IMPERIALPRISON_BUTTONS_+4]"..
        "@B[0,@L_REPLACEMENTS_BUTTONS_CANCEL_+0]")
		
		local result = MsgNews("","",Panel,
            imperialpunish_AIDecision,  --AIFunc 
            "intrigue", --Message Class 
            2, --TimeOut 
            "@L_INTRIGUE_IMPERIALPRISON_SCREENPLAY_ACTOR_HEAD_+0", 
            "@L_INTRIGUE_IMPERIALPRISON_SCREENPLAY_ACTOR_BODY_+0", 
            GetID("destination"),Duration[1],Duration[2],Duration[3],Duration[4])
		
		if result == 0 then
			StopMeasure()
		elseif result == 1 then
			CityAddPenalty("City","destination",PENALTY_PRISON,Duration[1])
			feedback_MessageCharacter("",
				"@L_IMPERIALPRISON_ACTOR_SUCCESS_HEAD_+0",
				"@L_IMPERIALPRISON_ACTOR_SUCCESS_BODY_+0",GetID("destination"),Duration[1])
			feedback_MessageCharacter("destination",
				"@L_IMPERIALPRISON_ACTOR_SUCCESS_HEAD_+1",
				"@L_IMPERIALPRISON_ACTOR_SUCCESS_BODY_+1",GetID(""),Duration[1])
		elseif result == 2 then
			CityAddPenalty("City","destination",PENALTY_PRISON,Duration[2])
			feedback_MessageCharacter("",
				"@L_IMPERIALPRISON_ACTOR_SUCCESS_HEAD_+0",
				"@L_IMPERIALPRISON_ACTOR_SUCCESS_BODY_+0",GetID("destination"),Duration[2])
			feedback_MessageCharacter("destination",
				"@L_IMPERIALPRISON_ACTOR_SUCCESS_HEAD_+1",
				"@L_IMPERIALPRISON_ACTOR_SUCCESS_BODY_+1",GetID(""),Duration[2])
		elseif result == 3 then
			CityAddPenalty("City","destination",PENALTY_PRISON,Duration[3])
			feedback_MessageCharacter("",
				"@L_IMPERIALPRISON_ACTOR_SUCCESS_HEAD_+0",
				"@L_IMPERIALPRISON_ACTOR_SUCCESS_BODY_+0",GetID("destination"),Duration[3])
			feedback_MessageCharacter("destination",
				"@L_IMPERIALPRISON_ACTOR_SUCCESS_HEAD_+1",
				"@L_IMPERIALPRISON_ACTOR_SUCCESS_BODY_+1",GetID(""),Duration[3])
		else 
			CityAddPenalty("City","destination",PENALTY_PRISON,Duration[4])
			feedback_MessageCharacter("",
				"@L_IMPERIALPRISON_ACTOR_SUCCESS_HEAD_+0",
				"@L_IMPERIALPRISON_ACTOR_SUCCESS_BODY_+0",GetID("destination"),Duration[4])
			feedback_MessageCharacter("destination",
				"@L_IMPERIALPRISON_ACTOR_SUCCESS_HEAD_+1",
				"@L_IMPERIALPRISON_ACTOR_SUCCESS_BODY_+1",GetID(""),Duration[4])
		end
	elseif Result == 3 then
		local Duration = {}
			Duration[1] = 12
			Duration[2] = 24
			Duration[3] = 48
			Duration[4] = 96
		
		local Panel
		Panel = ("@P"..
        "@B[1,@L_IMPERIALPILLORY_BUTTONS_+1]"..
        "@B[2,@L_IMPERIALPILLORY_BUTTONS_+2]"..
        "@B[3,@L_IMPERIALPILLORY_BUTTONS_+3]"..
        "@B[4,@L_IMPERIALPILLORY_BUTTONS_+4]"..
        "@B[0,@L_REPLACEMENTS_BUTTONS_CANCEL_+0]")
		
		local result = MsgNews("","",Panel,
            imperialpunish_AIDecision,  --AIFunc 
            "intrigue", --Message Class 
            2, --TimeOut 
            "@L_INTRIGUE_IMPERIALPILLORY_SCREENPLAY_ACTOR_HEAD_+0", 
            "@L_INTRIGUE_IMPERIALPILLORY_SCREENPLAY_ACTOR_BODY_+0", 
            GetID("destination"),Duration[1],Duration[2],Duration[3],Duration[4])
		
		if result == 0 then
			StopMeasure()
		elseif result == 1 then
			CityAddPenalty("City","destination",PENALTY_PILLORY,Duration[1])
			feedback_MessageCharacter("",
				"@L_IMPERIALPILLORY_ACTOR_SUCCESS_HEAD_+0",
				"@L_IMPERIALPILLORY_ACTOR_SUCCESS_BODY_+0",GetID("destination"),Duration[1])
			feedback_MessageCharacter("destination",
				"@L_IMPERIALPILLORY_ACTOR_SUCCESS_HEAD_+1",
				"@L_IMPERIALPILLORY_ACTOR_SUCCESS_BODY_+1",GetID(""),Duration[1])
		elseif result == 2 then
			CityAddPenalty("City","destination",PENALTY_PILLORY,Duration[2])
			feedback_MessageCharacter("",
				"@L_IMPERIALPILLORY_ACTOR_SUCCESS_HEAD_+0",
				"@L_IMPERIALPILLORY_ACTOR_SUCCESS_BODY_+0",GetID("destination"),Duration[2])
			feedback_MessageCharacter("destination",
				"@L_IMPERIALPILLORY_ACTOR_SUCCESS_HEAD_+1",
				"@L_IMPERIALPILLORY_ACTOR_SUCCESS_BODY_+1",GetID(""),Duration[2])
		elseif result == 3 then
			CityAddPenalty("City","destination",PENALTY_PILLORY,Duration[3])
			feedback_MessageCharacter("",
				"@L_IMPERIALPILLORY_ACTOR_SUCCESS_HEAD_+0",
				"@L_IMPERIALPILLORY_ACTOR_SUCCESS_BODY_+0",GetID("destination"),Duration[3])
			feedback_MessageCharacter("destination",
				"@L_IMPERIALPILLORY_ACTOR_SUCCESS_HEAD_+1",
				"@L_IMPERIALPILLORY_ACTOR_SUCCESS_BODY_+1",GetID(""),Duration[3])
		else
			CityAddPenalty("City","destination",PENALTY_PILLORY,Duration[4])
			feedback_MessageCharacter("",	
				"@L_IMPERIALPILLORY_ACTOR_SUCCESS_HEAD_+0",
				"@L_IMPERIALPILLORY_ACTOR_SUCCESS_BODY_+0",GetID("destination"),Duration[4])
			feedback_MessageCharacter("destination",
				"@L_IMPERIALPILLORY_ACTOR_SUCCESS_HEAD_+1",
				"@L_IMPERIALPILLORY_ACTOR_SUCCESS_BODY_+1",GetID(""),Duration[4])
		end
	elseif Result == 4 then
		CityAddPenalty("City","destination",PENALTY_DEATH,96)
		feedback_MessageCharacter("",
            "@L_IMPERIALEXECUTION_ACTOR_SUCCESS_HEAD_+0",
            "@L_IMPERIALEXECUTION_ACTOR_SUCCESS_BODY_+0",GetID("destination"))
		feedback_MessageCharacter("destination",
            "@L_IMPERIALEXECUTION_ACTOR_SUCCESS_HEAD_+1",
            "@L_IMPERIALEXECUTION_ACTOR_SUCCESS_BODY_+1",GetID(""))
	else
		StopMeasure()
	end	
	AddImpact("destination","IPunished",1,120)
	SetFavorToSim("","destination",0)
	local MeasureID = GetCurrentMeasureID("")
	local TimeOut = mdata_GetTimeOut(MeasureID)
	SetRepeatTimer("", GetMeasureRepeatName(), TimeOut)
end

function AIDecision()
	return Rand(4)
end

function GetOSHData(MeasureID)
	--can be used again in:
	OSHSetMeasureRepeat("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+2",Gametime2Total(mdata_GetTimeOut(MeasureID)))
end

function CleanUp()
	StopMeasure()
end
