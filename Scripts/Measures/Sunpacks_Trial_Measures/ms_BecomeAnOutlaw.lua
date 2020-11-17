function Run()
	-- Get all Settlements and check where the Player has a Fugitiv penalty
	local CityCount = ScenarioGetObjects("cl_Settlement", 999, "OutlawCity")
	
	local Buttons = "@P"
	for i = 0,CityCount-1 do
		--Buttons = Buttons.."@B["..i..", "..GetName("City"..i).." ("..(GetProperty("", GetName("City"..i).."FugitiveRounds")*2)..")]"#
		Buttons = Buttons.."@B["..i..", @L"..GetName("City"..i).."_+0@(10 Years)]"
	end
	Buttons = Buttons.."@P@B[C,@L_REPLACEMENTS_BUTTONS_NEIN_+0]"
	
	local result = MsgNews("","",Buttons, 0, "military", 2, "head", "body", GetID(""))
	
	if result == "C" then
		return
	end

	CityAddPenalty("OutlawCity"..result,"",PENALTY_FUGITIVE,24)
	AddImpact("", "REVOLT", 1, 24)
	local outlawed = 1
	if HasProperty("", "Outlawed") then
		outlawed = outlawed + GetProperty("", "Outlawed")
	end
	SetProperty("", "Outlawed", outlawed)
	SetProperty("", GetName("OutlawCity"..result).."Start", GetRound())
	SetProperty("", GetName("OutlawCity"..result).."FugitiveHours", 24)
end

function CleanUp()
end
