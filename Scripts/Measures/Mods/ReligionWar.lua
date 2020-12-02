function ReligionDisclaim()

	if not HasData("#ReligionWarLevel") then
		return
	end
	
	local bossReligion = SimGetReligion("")
	local HasNotSent = true
	
	-- For each citizen in empire
	local SimCount = ScenarioGetObjects("cl_Sim", 9999, "SimList")
	for sim=0,SimCount-1 do
		local SimAlias = "SimList"..sim
		if AliasExists(SimAlias) then
    		
    		-- if religion different from disclaim launch, get disclaim effect for 24h
    		if SimGetReligion(SimAlias)~=bossReligion then
    			AddImpact(SimAlias,"ReligionDisclaim",1,24)
      			SetState(SimAlias,STATE_CONTAMINATED,true)
    		end
    		
        	-- Send report that their was a religion disclaim
    		if IsPartyMember(SimAlias) and HasNotSent then
        		HasNotSent = false
        		if bossReligion==0 then
            		feedback_MessageCharacter(SimAlias,
                    "@L_RELIGIONWAR_LEVEL1_HEAD_+0",
                    "@L_RELIGIONWAR_LEVEL1_BODY_+0",GetID(SimAlias))
                else
                    feedback_MessageCharacter(SimAlias,
                    "@L_RELIGIONWAR_LEVEL1_HEAD_+1",
                    "@L_RELIGIONWAR_LEVEL1_BODY_+1",GetID(SimAlias))
                end
            end
    	end
	end
	
	-- Increase Religion War level
	SetData("#ReligionWarLevel", 1)
end

function ReligionSchism()
	local ReligionWarLevel = GetData("#ReligionWarLevel")
	
	--if ReligionWarLevel == 1 then
	--	return
	--end
	
	local bossReligion = SimGetReligion("")
	local HasNotSent = true
	
	-- For each citizen in empire
	local SimCount = ScenarioGetObjects("cl_Sim", 9999, "SimList")
	for sim=0,SimCount-1 do
		local SimAlias = "SimList"..sim
		if AliasExists(SimAlias) then

    		-- other religion get an effect of schism
    		if SimGetReligion(SimAlias)~=bossReligion then
    			AddImpact(SimAlias,"ReligionSchism",1,48)
      			SetState(SimAlias,STATE_CONTAMINATED,true)
    		end
    		
        	-- Send report that religion had a schism
    		if IsPartyMember(SimAlias) and HasNotSent then
        		HasNotSent = false
        		feedback_MessageCharacter(SimAlias,
                "@L_RELIGIONWAR_LEVEL2_HEAD_+0",
                "@L_RELIGIONWAR_LEVEL2_BODY_+0",GetID(SimAlias))
            end
        end
	end
	
	-- Increase Religion War level
    SetData("#ReligionWarLevel", 2)
end

function BanReligion()
	local ReligionWarLevel = GetData("#ReligionWarLevel")
	
	if ReligionWarLevel == 2 then
		return
	end
	
	GetSettlement("", "CityAlias")
	local bossReligion = SimGetReligion("")
	local HasNotSent = true	
	
	-- For each citizen in empire
	local SimCount = ScenarioGetObjects("cl_Sim", 9999, "SimList")
	for sim=0,SimCount-1 do
		local SimAlias = "SimList"..sim
		if AliasExists(SimAlias) then
		
    		if IsPartyMember(SimAlias) and HasNotSent then
        		-- Send report that religion is banned
        		HasNotSent = false
        		if bossReligion==0 then
            		feedback_MessageCharacter(SimAlias,
                    "@L_RELIGIONWAR_LEVEL3_HEAD_+0",
                    "@L_RELIGIONWAR_LEVEL3_BODY_+0",GetID(SimAlias))
                else
                    feedback_MessageCharacter(SimAlias,
                    "@L_RELIGIONWAR_LEVEL3_HEAD_+0",
                    "@L_RELIGIONWAR_LEVEL3_BODY_+1",GetID(SimAlias))
                end
            end
            
    		if SimGetReligion(SimAlias)~=SimGetReligion("") then
    			-- sim loose his office (if he has)
    			if not (SimGetOfficeLevel(SimAlias) == -1) then
					CityRemoveFromOffice("CityAlias",SimAlias)
				end
	
				-- remove the victim from office applicants
				CityRemoveApplicant("CityAlias",SimAlias)
				
				if IsPartyMember(SimAlias) then
					-- Prepare the ban
					AddImpact(SimAlias,"prebanned",1,4)
					CreateScriptcall("BanCharacter_Ban_Start",4,"Measures/ms_114_BanCharacter.lua","JailTime","",SimAlias,72)
					CreateScriptcall("BanCharacter_Ban_End",76,"Measures/ms_114_BanCharacter.lua","BanIsOver","",SimAlias)
				else
					-- choose what to do for AI
					local choice = Rand(2)
					if (choice == 1) then
						-- convert to the other religion
						SimSetReligion("", bossReligion)
						SimSetFaith("", Rand(20))
					else
						-- prefer to leave the city (death for ai)
						AddImpact(SimAlias,"prebanned",1,4)
						CreateScriptcall("BanCharacter_Ban_Start",4,"Measures/ms_114_BanCharacter.lua","JailTime","",SimAlias,9)
						CreateScriptcall("SimDisappear",9,"Measures/ReligionWar.lua","SimDisappear","",SimAlias,0)
					end
				end
    		end
    	end
	end
	
    SetData("#ReligionWarLevel", 3)
end

function SimDisappear()
	Kill("")
end

function CleanUp()
end
