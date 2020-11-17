function Weight()
	
	if SimGetAge("SIM") < GL_AGE_FOR_GROWNUP then
		return 0
	end
	
	if not ReadyToRepeat("dynasty", "AI_evidence"..GetID("dynasty")) then
		return 0
	end

	-- local Hour = math.mod(GetGametime(), 24)
	-- if Hour < 23 or Hour > 1 then
		-- return 0
	-- end

	if find_HomeCity("SIM","_city") then
		local TopDynastyID = GetProperty("_city","Crimes_TopAccuserDynastyID")
		local TopActorID = GetProperty("_city","Crimes_TopActorID")
		local TopBias = GetProperty("_city","Crimes_TopBias")
		
		if TopDynastyID==GetID("dynasty") then
			if GetAliasByID(TopActorID,"Actor") then
				if GetSettlementID("SIM") == GetSettlementID("Actor") then
					if GetDynastyID("SIM") ~= GetDynastyID("Actor") then
						return 100
					end
				end
			end
		end
		if SimGetBestEvidence("SIM",5,"BestEvidence") then
			if EvidenceGetActor("BestEvidence","Actor") then
				if GetSettlementID("SIM") == GetSettlementID("Actor") then
					if GetDynastyID("SIM") ~= GetDynastyID("Actor") then
						return 100
					end
				end
			end
		end
	end
	return 0
end

function Execute()
	
	if SimGetAge("Actor") < GL_AGE_FOR_GROWNUP then
		return
	end
	
	local Blackmail = false
	local ActorLevel = SimGetOfficeLevel("Actor")
	
	if SimGetClass("SIM") == 4 or ActorLevel > 0 then
		local EvSum = GetEvidenceAlignmentSum("SIM", "Actor")
		if EvSum > 2 then
			Blackmail = true
		end
	end

	SetRepeatTimer("dynasty", "AI_evidence"..GetID("dynasty"),12)
		
	if Blackmail then
		MeasureRun("SIM", "Actor", "BlackmailCharacter")
	else
		MeasureRun("SIM", "Actor", "ChargeCharacter")
	end
end

function CleanUp()
end
