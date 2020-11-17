-------------------------------------------------------------------------------
----
----	OVERVIEW "QuickPoliticalBribe"
----
----	Enables you to use the bank to bribe politicians quickly
----
-------------------------------------------------------------------------------


function Run()

	local Difficulty = ScenarioGetDifficulty()
	local MyMoney = GetMoney("")
	local money = SimGetWealth("Destination") 
	local Money = {}
		Money[1] = math.floor(money * 0.01)
		Money[2] = math.floor(money * 0.025)
		Money[3] = math.floor(money * 0.05)
	
	local X = SimGetOfficeLevel("Destination")
	local Title = GetNobilityTitle("Destination")
	local TitleCost = Title * 100
	local Level = {}
		Level[-1] = 0
		Level[1] = 500
		Level[2] = 1000
		Level[3] = 1500
		Level[4] = 2000
		Level[5] = 2500
		Level[6] = 3000
		Level[7] = 5000
		
	local OfficeCost = Level[X]
	local PowerCost = TitleCost + OfficeCost		
	local Choice = {}
		Choice[1] = Money[1] + PowerCost
		Choice[2] = Money[2] + PowerCost
		Choice[3] = Money[3] + PowerCost
	
	local Favor = {}
		Favor[1] = 5
		Favor[2] = 10
		Favor[3] = 20
	
	if Difficulty < 2 then
		Choice[1] = 500
		Choice[2] = 750
	    Choice[3] = 1000
		Favor[1] = Favor[1] * 5
	    Favor[2] = Favor[2] * 5
	    Favor[3] = Favor[3] * 5
	elseif Difficulty == 2 then
		Choice[1] =	Choice[1] * 0.5
	    Choice[2] = Choice[2] * 0.5
	    Choice[3] = Choice[3] * 0.5
		Favor[1] = Favor[1] * 2
	    Favor[2] = Favor[2] * 2
	    Favor[3] = Favor[3] * 2
	end
	
	if not DynastyIsPlayer("") and Choice[1] > 10000 then
		Choice[1] = 10000
	end
	if not DynastyIsPlayer("") and Choice[2] > 10000 then
		Choice[2] = 10000
	end
	if not DynastyIsPlayer("") and Choice[3] > 10000 then
		Choice[3] = 10000
	end
	
	if MyMoney < Choice[1] then
		MsgQuick("","@L_INTRIGUE_POLITICALBRIBE_FAILURES_+0")
		StopMeasure()
	end

    
    
    local panel
    if MyMoney >= Choice[3] then
		panel = ("@P"..
		"@B["..Choice[1]..",@L_PoliticalBribe_BUTTONS_+1]"..
		"@B["..Choice[2]..",@L_PoliticalBribe_BUTTONS_+2]"..
		"@B["..Choice[3]..",@L_PoliticalBribe_BUTTONS_+3]"..
		"@B[N,@L_REPLACEMENTS_BUTTONS_CANCEL_+0]")
    elseif MyMoney >= Choice[2] and MyMoney < Choice[3] then
		panel = ("@P"..
		"@B["..Choice[1]..",@L_PoliticalBribe_BUTTONS_+1]"..
		"@B["..Choice[2]..",@L_PoliticalBribe_BUTTONS_+2]"..
		"@B[N,@L_REPLACEMENTS_BUTTONS_CANCEL_+0]")
	elseif MyMoney >= Choice[1] and MyMoney < 2 then	
		panel = ("@P"..
		"@B["..Choice[1]..",@L_PoliticalBribe_BUTTONS_+1]"..
		"@B[N,@L_REPLACEMENTS_BUTTONS_CANCEL_+0]")
    end
    
    local Result = MsgNews("","",panel,
	        QuickPoliticalBribe_AIDecision,  --AIFunc
			"intrigue", --Message Class
			2, --TimeOut
			"@L_INTRIGUE_POLITICALBRIBE_SCREENPLAY_ACTOR_HEAD_+0",
			"@L_INTRIGUE_POLITICALBRIBE_SCREENPLAY_ACTOR_BODY_+0",
			GetID("Destination"),Choice[1],Choice[2],Choice[3],MyMoney)
	
	if Result ~= "N" then
	    SpendMoney("", Result, "CostBribes")
		chr_RecieveMoney("Destination",Result,"IncomeBribes")
		feedback_MessageCharacter("",
			"@L_BRIBEGIVE_ACTOR_SUCCESS_HEAD_+0",
			"@L_BRIBEGIVE_ACTOR_SUCCESS_BODY_+0",GetID("Destination"),Result)
		feedback_MessageCharacter("Destination",
			"@L_RECEIVEBRIBE_ACTOR_SUCCESS_HEAD_+0",
			"@L_RECEIVEBRIBE_ACTOR_SUCCESS_BODY_+0",GetID(""),Result)
		
		local ModifyFavor
		if Result == Choice[1] then
			ModifyFavor = Favor[1]
		elseif Result == Choice[2] then
			ModifyFavor = Favor[2]
		else 
			ModifyFavor = Favor[3]
		end	
		
		chr_ModifyFavor("Destination","",ModifyFavor)
		local MeasureID = GetCurrentMeasureID("")
		local TimeOut = mdata_GetTimeOut(MeasureID)
		SetRepeatTimer("", GetMeasureRepeatName(), TimeOut)
	else
		StopMeasure()
	end		
end

function CleanUp()
end

function GetOSHData(MeasureID)
	--can be used again in:
	OSHSetMeasureRepeat("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+2",Gametime2Total(mdata_GetTimeOut(MeasureID)))
end
