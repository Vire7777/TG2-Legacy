function Weight()
	
	if not GetSettlement("SIM", "cg_City") then
		return 0
	end
	
	local Hour = math.mod(GetGametime(), 24)
	if Hour < 8 or Hour > 16 then
		return 0
	end
	
	-- jemanden beschützen
	-- 1 - Major
	-- 2 - Sheriff
	-- 3 - Judge
	
	local	Position = 1 + Rand(3)
	if not GetOfficeTypeHolder("cg_City", 2, "cg_BodyGuardDest") then
		return 0
	end

    if HasProperty("cg_BodyGuardDest","CityBodyguard") then
	    return 0
	end

	if SimIsInside("cg_BodyGuardDest") then
	    return 0
	end
	
	if GetState("cg_BodyGuardDest", STATE_IMPRISONED) or GetState("cg_BodyGuardDest", STATE_CAPTURED) then
		return 0
	end
	
	if GetState("cg_BodyGuardDest", STATE_DEAD) or GetState("cg_BodyGuardDest", STATE_DYING) then
		return 0
	end
	
	if GetState("cg_BodyGuardDest", STATE_HIJACKED) then
		return 0
	end
	
	if GetState("cg_BodyGuardDest", STATE_HIDDEN) then
		return 0
	end
	
	if HasProperty("cg_BodyGuardDest","InvitedBy") then
		return 0
	end
	
	return 100
end

function Execute()
    SetProperty("cg_BodyGuardDest","CityBodyguard",1)
	MeasureRun("SIM", "cg_BodyGuardDest", "EscortCharacterOrTransport")
end

function CleanUp()
end