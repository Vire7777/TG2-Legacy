function Run()
	if GetImpactValue("","spying") == 1 then
		return ""
	end
	
	if SimGetProfession("")==11 then --priest
		return ""
	end
	
	if not GetState("", STATE_IDLE) then
		return ""
	end
	
	if GetState("",STATE_ROBBERGUARD) then
		return ""
	end

	if IsDynastySim("") then
		return ""
	end

	if not ReadyToRepeat("", "Listen2Preacher") then
		return ""
	end

	if GetCurrentMeasureID("")==660 then  --burglary
		return ""
	end

	if GetCurrentMeasureID("")==680 then  --pickpocketing
		return ""
	end
	
	if GetCurrentMeasureID("")==360 then  --attackenemy
		return ""
	end
	
	if GetCurrentMeasureID("")==3505 then  --SquadWaylayMember
		return ""
	end
	
	return "ListenPreacher"
end

function CleanUp()
end
