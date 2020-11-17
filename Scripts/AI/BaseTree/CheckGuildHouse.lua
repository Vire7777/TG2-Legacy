function Weight()
	TotalFound = 0
	Count = DynastyGetMemberCount("dynasty")
	for i=0,Count-1 do
		if DynastyGetMember("dynasty", i, "sim") then
			if DynastyIsShadow("sim") then
				return 0
			end
			if GetState("sim", STATE_IDLE) then
				if GetSettlement("sim", "my_settlement") then
					if (gameplayformulas_CheckPublicBuilding("my_settlement", GL_BUILDING_TYPE_BANK)[1]>0) then
						if CityGetRandomBuilding("my_settlement", -1, GL_BUILDING_TYPE_BANK, -1, -1, FILTER_IGNORE, "guildhouse") then
							TotalFound = TotalFound + 1
						end
					end
				end
			end
		end
	end
	
	if TotalFound==0 then
		return 0
	end
	
	return TotalFound*50
end

function Execute()

	-- if TotalFound==0 then
		-- str		= "CheckGuildhouse: none"
	-- else
		-- str		= "CheckGuildhouse: "..TotalFound
	-- end

	-- LogMessage(str);
	return TotalFound
end

function CleanUp()
end
