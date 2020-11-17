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
	
	local result = MsgNews("","",Buttons, 0, "military", 2, "@L_OUTLAW_SURRENDER_TOWN_HEAD_+0", "@L_OUTLAW_SURRENDER_TOWN_BODY_+0", GetID(""))
	
	if result == "C" then
		return
	end
	
	if CityGetPenalty("OutlawCity"..result, "", PENALTY_FUGITIVE, true, "Penalty") then
		PenaltyReset("Penalty", 0)
		PenaltyFinish("Penalty")
		RemoveImpact("", "REVOLT")
		
		local factor = 0.5
		if HasProperty("", "Outlawed") then
			factor = factor + GetProperty("", "Outlawed")
		end
		
		CityAddPenalty("OutlawCity"..result,"",PENALTY_PRISON, GetProperty("", GetName("OutlawCity"..result).."FugitiveHours") * factor)
		if CityGetRandomBuilding("OutlawCity"..result, -1, GL_BUILDING_TYPE_PRISON, -1, -1, FILTER_IGNORE, "Prison") then
			f_MoveTo("", "Prison")
		end
	end
end

function CleanUp()
end
