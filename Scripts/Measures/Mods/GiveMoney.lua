-- this measure allows a dynasty member to give another dynasty member money while playing MP games...this measure will show up in single player but as there is only one local player in the game there will be no targets !

function Run()

    local Money = GetMoney("")
	local Choice1 = Money * 0.05
	local Choice2 = Money * 0.15
	local Choice3 = Money * 0.25
	local Choice4 = Money * 0.5
	local Choice5 = Money * 0.75
	
	if Money < 10 then
		MsgQuick("","@L_INTRIGUE_GIVEMONEY_FAILURES_+0")
		StopMeasure()
	end
	
    local Result = MsgNews("","","@P"..
	        "@B[A,@L_GiveMoney_BUTTONS_+1]"..
			"@B[B,@L_GiveMoney_BUTTONS_+2]"..
			"@B[C,@L_GiveMoney_BUTTONS_+3]"..
			"@B[D,@L_GiveMoney_BUTTONS_+4]"..
			"@B[E,@L_GiveMoney_BUTTONS_+5]"..
			"@B[N,@L_REPLACEMENTS_BUTTONS_CANCEL_+0]",
			GiveMoney_AIDecision,  --AIFunc
			"intrigue", --Message Class
			2, --TimeOut
			"@L_INTRIGUE_GIVEMONEY_SCREENPLAY_ACTOR_HEAD_+0",
			"@L_INTRIGUE_GIVEMONEY_SCREENPLAY_ACTOR_BODY_+0",
			GetID("Destination"),Choice1,Choice2,Choice3,Choice4,Choice5,Choice6,Choice7,Choice8,Choice9,Choice10,Money)
	
	if Result == "A" then
	    Money = Money * 0.05
		SpendMoney("", Money, "CostSocial")
		chr_RecieveMoney("Destination",Money,"IncomeOther")
		feedback_MessageCharacter("",
			"@L_GIVEMONEY_ACTOR_SUCCESS_HEAD_+0",
			"@L_GIVEMONEY_ACTOR_SUCCESS_BODY_+0",GetID("Destination"), Money)
		feedback_MessageCharacter("Destination",
			"@L_RECEIVEMONEY_ACTOR_SUCCESS_HEAD_+0",
			"@L_RECEIVEMONEY_ACTOR_SUCCESS_BODY_+0",GetID(""), Money)
	end
	
	if Result == "B" then
		Money = Money * 0.15
		SpendMoney("", Money, "CostSocial")
		chr_RecieveMoney("Destination",Money,"IncomeOther")
		feedback_MessageCharacter("",
			"@L_GIVEMONEY_ACTOR_SUCCESS_HEAD_+0",
			"@L_GIVEMONEY_ACTOR_ACTOR_SUCCESS_BODY_+0",GetID("Destination"), Money)
		feedback_MessageCharacter("Destination",
			"@L_RECEIVEMONEY_ACTOR_SUCCESS_HEAD_+0",
		    "@L_RECEIVEMONEY_ACTOR_SUCCESS_BODY_+0",GetID(""), Money)
	end
	
	if Result == "C" then
		Money = Money * 0.25
		SpendMoney("", Money, "CostSocial")
		chr_RecieveMoney("Destination",Money,"IncomeOther")
		feedback_MessageCharacter("",
			"@L_GIVEMONEY_ACTOR_SUCCESS_HEAD_+0",
			"@L_GIVEMONEY_ACTOR_SUCCESS_BODY_+0",GetID("Destination"), Money)
		feedback_MessageCharacter("Destination",
			"@L_RECEIVEMONEY_ACTOR_SUCCESS_HEAD_+0",
			"@L_RECEIVEMONEY_ACTOR_SUCCESS_BODY_+0",GetID(""), Money)
	end
	
	if Result == "D" then
		Money = Money * 0.5
		SpendMoney("", Money, "CostSocial")
		chr_RecieveMoney("Destination",Money,"IncomeOther")
		feedback_MessageCharacter("",
			"@L_GIVEMONEY_ACTOR_SUCCESS_HEAD_+0",
			"@L_GIVEMONEY_ACTOR_SUCCESS_BODY_+0",GetID("Destination"), Money)
		feedback_MessageCharacter("Destination",
			"@L_RECEIVEMONEY_ACTOR_SUCCESS_HEAD_+0",
			"@L_RECEIVEMONEY_ACTOR_SUCCESS_BODY_+0",GetID(""), Money)
	end
	
	if Result == "E" then
		Money = Money * 0.75
		SpendMoney("", Money, "CostSocial")
		chr_RecieveMoney("Destination",Money,"IncomeOther")
		feedback_MessageCharacter("",
			"@L_GIVEMONEY_ACTOR_SUCCESS_HEAD_+0",
			"@L_GIVEMONEY_ACTOR_SUCCESS_BODY_+0",GetID("Destination"), Money)
		feedback_MessageCharacter("Destination",
			"@L_RECEIVEMONEY_ACTOR_SUCCESS_HEAD_+0",
			"@L_RECEIVEMONEY_ACTOR_SUCCESS_BODY_+0",GetID(""), Money)
	end
	
	if Result == "N" then
		StopMeasure()
	end		
end	

function CleanUp()
end
