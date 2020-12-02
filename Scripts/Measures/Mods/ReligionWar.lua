function ReligionDisclaim()

	if not HasData("#religionWarLevel") then
		return
	end
	
	local hasNotSent = true
	
	-- For each citizen in empire
	local simCount = ScenarioGetObjects("cl_Sim", 9999, "SimList")
	for sim=0,simCount-1 do
		local simAlias = "SimList"..sim
		if AliasExists(simAlias) and GetSettlement(simAlias) == GetSettlement("") then
    		
    		-- if religion different from disclaim launch, get disclaim effect for 24h
    		if SimGetReligion(simAlias)~=SimGetReligion("") then
    			AddImpact(simAlias,"ReligionDisclaim",1,24)
      			SetState(simAlias,STATE_CONTAMINATED,true)
    		end
    		
        	-- Send report that their was a religion disclaim
    		if IsPartyMember(simAlias) and hasNotSent then
        		hasNotSent = false
        		if SimGetReligion("")==0 then
            		feedback_MessageCharacter(simAlias,
                    "@L_RELIGIONWAR_LEVEL1_HEAD_+0",
                    "@L_RELIGIONWAR_LEVEL1_BODY_+0",GetID(simAlias))
                else
                    feedback_MessageCharacter(simAlias,
                    "@L_RELIGIONWAR_LEVEL1_HEAD_+1",
                    "@L_RELIGIONWAR_LEVEL1_BODY_+1",GetID(simAlias))
                end
            end
    	end
	end
	
	-- Increase Religion War level
	SetData("#religionWarLevel", 1)
end

function ReligionSchism()
	local religionWarLevel = GetData("#religionWarLevel")
	
	--if religionWarLevel == 1 then
	--	return
	--end
	
	local hasNotSent = true
	
	-- For each citizen in empire
	local simCount = ScenarioGetObjects("cl_Sim", 9999, "SimList")
	for sim=0,simCount-1 do
		local simAlias = "SimList"..sim
		if AliasExists(simAlias) and GetSettlement(simAlias) == GetSettlement("") then

    		-- other religion get an effect of schism
    		if SimGetReligion(simAlias)~=SimGetReligion("") then
    			AddImpact(simAlias,"ReligionSchism",1,48)
      			SetState(simAlias,STATE_CONTAMINATED,true)
    		end
    		
        	-- Send report that religion had a schism
    		if IsPartyMember(simAlias) and hasNotSent then
        		hasNotSent = false
        		feedback_MessageCharacter(simAlias,
                "@L_RELIGIONWAR_LEVEL2_HEAD_+0",
                "@L_RELIGIONWAR_LEVEL2_BODY_+0",GetID(simAlias))
            end
        end
	end
	
	-- Increase Religion War level
    SetData("#religionWarLevel", 2)
end

function BanReligion()
	local religionWarLevel = GetData("#religionWarLevel")
	
	if religionWarLevel == 2 then
		return
	end
	
	-- for each building of the empire
	religionwar_BuildingCheck()
	
	-- For each citizen in empire
	religionwar_CitizenCheck()
	
	-- increase religion war level
    SetData("#religionWarLevel", 3)
end

function BuildingCheck()
	local buildingCount = ScenarioGetObjects("cl_Building", 9999, "BuildingList")
	for building=0,buildingCount-1 do
		local buildingAlias = "BuildingList"..building
		BuildingGetCity(buildingAlias, "BuildingCity")
		
		-- check if the city is a church in the city and from a different religion
		if AliasExists(buildingAlias) and GetID("BuildingCity") == GetSettlementID("") 
		and (BuildingGetType(buildingAlias) == 19 and SimGetReligion("") == 0)
		or (BuildingGetType(buildingAlias) == 20 and SimGetReligion("") == 1) then
      		SetState(buildingAlias,STATE_BURNING,true)
      		CreateScriptcall("DestroyBuilding",2,"Measures/Mods/ReligionWar.lua","DestroyBuilding",buildingAlias,nil)
		end
	end
end

function CitizenCheck()
	-- variables
	GetSettlement("", "CityAlias")
	if not GetOutdoorLocator("MapExit1",1,"Away") then
		if not GetOutdoorLocator("MapExit2",1,"Away") then
		    if not GetOutdoorLocator("MapExit3",1,"Away") then	
            end
		end
	end
	local hasNotSent = true	
	
	-- looking for each citizen
	local simCount = ScenarioGetObjects("cl_Sim", 9999, "SimList")
	for sim=0,simCount-1 do
		local simAlias = "SimList"..sim
		if AliasExists(simAlias) and GetSettlement(simAlias) == GetSettlement("") then
			
    		if IsPartyMember(simAlias) and hasNotSent then
        		-- Send report that religion is banned
        		hasNotSent = false
        		if SimGetReligion("") == 0 then
            		feedback_MessageCharacter(simAlias,
                    "@L_RELIGIONWAR_LEVEL3_HEAD_+0",
                    "@L_RELIGIONWAR_LEVEL3_BODY_+0",GetID("CityAlias"))
                else
                    feedback_MessageCharacter(simAlias,
                    "@L_RELIGIONWAR_LEVEL3_HEAD_+0",
                    "@L_RELIGIONWAR_LEVEL3_BODY_+1",GetID("CityAlias"))
                end
            end
            
    		if SimGetReligion(simAlias) ~= SimGetReligion("") then
    			-- sim loose his office (if he has)
    			if not (SimGetOfficeLevel(simAlias) == -1) then
					CityRemoveFromOffice("CityAlias",simAlias)
				end
	
				-- remove the victim from office applicants
				CityRemoveApplicant("CityAlias",simAlias)
				
				if IsPartyMember(simAlias) then
					-- Prepare the ban
					AddImpact(simAlias,"prebanned",1,4)
					CreateScriptcall("BanCharacter_Ban_Start",4,"Measures/ms_114_BanCharacter.lua","JailTime","",simAlias,0)
				else
					-- choose what to do for AI
					local choice = Rand(SimGetFaith(simAlias))
					if (choice < 20) then
						-- convert to the other religion
						SimSetReligion(simAlias, SimGetReligion(""))
						SimSetFaith(simAlias, Rand(20))
						MsgSay(simAlias, "@L_RELIGIONWAR_LEVEL3_CHANGEFAITH")
					else
						-- prefer to leave the city (death for ai)
						AddImpact(simAlias,"prebanned",1,4)
						MsgSay(simAlias, "@L_RELIGIONWAR_LEVEL3_EXILE")
						SetState(simAlias,STATE_LOCKED,true)
						Sleep(1)
						f_MoveToNoWait(simAlias, "Away", GL_MOVESPEED_WALK)
						CreateScriptcall("SimDisappear",3,"Measures/Mods/ReligionWar.lua","SimDisappear",simAlias,"",0)
					end
				end
    		end
    	end
	end
end

function SimDisappear()
	SetInvisible("", true)
	Sleep(1)
	Kill("")
end

function DestroyBuilding()
	SetState("",STATE_DEAD,true)
end

function CleanUp()
end
