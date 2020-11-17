function Run()
	-- Get all Settlements and check where the Player has a Fugitive penalty
	local CityCount = ScenarioGetObjects("cl_Settlement", 999, "OutlawCity")
	
	local Buttons = "@P"
	for i = 0,CityCount-1 do
		if CityGetPenalty("OutlawCity"..i, "", PENALTY_FUGITIVE, true, "Penalty") then
			Buttons = Buttons.."@B["..i..", @L"..GetName("OutlawCity"..i).."_+0]"
		end
	end
	Buttons = Buttons.."@P@B[C,@L_REPLACEMENTS_BUTTONS_NEIN_+0]"
	
	local result = MsgNews("","",Buttons, 0, "military", 2, "@L_OUTLAW_PAY_TOWN_HEAD_+0", "@L_OUTLAW_PAY_TOWN_BODY_+0", GetID(""))
	
	if result == "C" then
		return
	end

	local factor = 0.5
	if HasProperty("", "Outlawed") then
		factor = factor * GetProperty("", "Outlawed")
	end
	
	local diff = GetRound() - GetProperty("", GetName("OutlawCity"..result).."Start")
	local FugitiveRoundsLeft = GetProperty("", GetName("OutlawCity"..result).."FugitiveHours") - diff
	local TotalCost = 2000 * factor * FugitiveRoundsLeft

	local Cost = {}
		  Cost[1] = TotalCost
		  Cost[2] = TotalCost * 2 / 3
		  Cost[3] = TotalCost / 3
		  
	if GetMoney("") < Cost[3] then
		MsgQuick("", "@L_PayOutlaw_FAILURE_+0")
	end
		  
	local buttons = "@P"
	if GetMoney("") >= Cost[1] then
		buttons = buttons.."@B[1,@L_PayOutlaw_BUTTON_+0]"
	end
	if GetMoney("") >= Cost[2] then
		buttons = buttons.."@B[2,@L_PayOutlaw_BUTTON_+1]"
	end
	
	if GetMoney("") >= Cost[3] then
		buttons = buttons.."@B[3,@L_PayOutlaw_BUTTON_+2]"
	end
	buttons = buttons.."@B[C,@L_REPLACEMENTS_BUTTONS_NEIN_+0]"
		  
	local payresult = MsgNews("", "", buttons,
								   0,
								   "military",
								   2,
								   "@L_PayOutlaw_HEAD_+0",
								   "@L_PayOutlaw_BODY_+0",
								   GetID(""), GetID("OutlawCity"..result), Cost[1], Cost[2], Cost[3])
								  
	if payresult == "C" then
		return
	end
								  
	if CityGetPenalty("OutlawCity"..result, "", PENALTY_FUGITIVE, true, "Penalty") then
		if SpendMoney("", Cost[payresult], "payfree") then
			PenaltyReset("Penalty", 0)
			PenaltyFinish("Penalty")
			RemoveImpact("", "REVOLT")
			if payresult == 1 then
				return
			end
			if payresult == 2 then
				local roundsleft = FugitiveRoundsLeft / 3
				CityAddPenalty("OutlawCity"..result, "", PENALTY_FUGITIVE, roundsleft)
				AddImpact("", "REVOLT", 1, roundsleft)
			end
			if payresult == 3 then
				local roundsleft = FugitiveRoundsLeft * 2 / 3
				CityAddPenalty("OutlawCity"..result, "", PENALTY_FUGITIVE, roundsleft)
				AddImpact("", "REVOLT", 1, roundsleft)
			end
		end
	end
end

function CleanUp()
end
