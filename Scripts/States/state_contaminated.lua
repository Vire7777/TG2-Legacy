function Init()
	if IsType("","Building") and GetImpactValue("","toadslime")==0 then
		SetStateImpact("no_enter")
	end
end
 
function Run()
	-- Variables for every impacts
	local impactNames = {"BlackSheep", "perfume", "BountyHunt", "UnterHypnose", "moschusduft", "kamm", "schaerpe", "FaustBad", "ReligionDisclaim", "ReligionSchism"}
	local impactActives={}	 

	-- Code to initialize the impactActives at 0 for each Impact
	local count = 1
	while impactNames[count] do
		impactActives[count]=0
		count = count + 1
	end
	
	--Launch the verify impacts method
	if IsType("","Sim") then
		-- for sims, the impacts are check all the time
		while true do
			if state_contaminated_SimImpacts(impactNames, impactActives) then
				-- if true, we leave the loop
				return
			end
			Sleep(5)
		end
	elseif IsType("","Building") then
		state_contaminated_BuildingImpacts()
		state_contaminated_OtherImpacts()
	end
end

-- Standard impacts for sims
function SimImpacts(impactNames, impactActives)
	local count = 1
	local inactive = 1
	while impactNames[count] do
		-- Verify each impact one by one (should we start or stop it)
		if (GetImpactValue("",impactNames[count])>0 and impactActives[count] == 0) then	
			-- put active and commit action
			impactActives[count] = 1
			state_contaminated_SpecificCommitSimImpacts()
			CommitAction(impactNames[count],"","")
		elseif (GetImpactValue("",impactNames[count])==0 and impactActives[count]>0) then 
			-- put inactive and stop action
			impactActives[count] = 0
			state_contaminated_SpecificCloseSimImpacts()
			StopAction(impactNames[count], "")
		elseif (GetImpactValue("",impactNames[count])==0 and impactActives[count]==0) then 
			inactive = inactive + 1
		end
		count = count + 1
	end
	
	-- if every impact is inactive, quit the contaminated state
	if (inactive == count) then
		return true
	end
	
	return false
end

function SpecificCommitSimImpacts()
	if GetImpactValue("","FaustBad")>0 then
		GetPosition("", "EffectPosition")
		StartSingleShotParticle("particles/toadexcrements_hit.nif", "EffectPosition",4,5)
		PlaySound3D("", "CharacterFX/nasty/Furzen+1.wav", 1.0)
		PlaySound3D("", "CharacterFX/nasty/Furzen+1.wav", 1.0)
	end
end

-- function to add specific code when closing action
function SpecificCloseSimImpacts()
	if GetImpactValue("","perfume")==0 and HasProperty("", "perfume") then
		RemoveProperty("","perfume")
	end
end

-- Only for building impacts
function BuildingImpacts()
	--Toad Slime
	if GetImpactValue("","toadslime")==1 then
		while GetImpactValue("","toadslime")>0 do
			--monitor building traffic (enter/exit)
			BuildingGetInsideSimList("", "OldSimList")	--get a list of everyone inside
			Sleep(1) --wait one second
			BuildingGetInsideSimList("", "NewSimList")	--get a list of everyone inside one second later	
			--compare the lists, anyone on new list and not on old list just entered
			local count = ListSize("NewSimList")
			for i=0, count-1 do
				ListGetElement("NewSimList", i, "Sim")
				if not ListContains("OldSimList", "Sim") then --sim just entered, do stuff on Sim
					--ShowOverheadSymbol("Sim",false,true,0,"Toadslime Enter!") --for testing
					if CheckSkill("Sim",1,4) then
						if IsDynastySim("Sim") then
							if not (GetImpactValue("Sim","Cold")==1) then
								diseases_Cold("Sim",true)
							end
						else
							if not GetState("Sim",STATE_BLACKDEATH) then
								diseases_Fever("Sim",true)
							end
						end		 
					end
				end
			end
			--compare the lists, anyone on old list and not on new list just exited	
			count = ListSize("OldSimList")
			for i=0, count-1 do
				ListGetElement("OldSimList", i, "Sim")
				if not ListContains("NewSimList", "Sim") then --sim just exited, do stuff on Sim
					--ShowOverheadSymbol("Sim",false,true,0,"Toadslime Exit!")--for testing
					if CheckSkill("Sim",1,4) then
						if IsDynastySim("Sim") then
							if not (GetImpactValue("Sim","Cold")==1) then
								diseases_Cold("Sim",true)
							end
						else
							if not GetState("Sim",STATE_BLACKDEATH) then
								diseases_Fever("Sim",true)
							end
						end		 
					end
				end
			end
		end
		SetState("",STATE_CONTAMINATED,false)
		return
	end
	
	-- count the fire locator
	FireLocatorCount = 1
	while GetFreeLocatorByName("Owner", "Fire"..FireLocatorCount, -1, -1, "SmokeLocator"..FireLocatorCount) do
		FireLocatorCount = FireLocatorCount + 1
	end
	FireLocatorCount = FireLocatorCount - 1
	-- create the smoke particles, size and position them
	SmokeCount = FireLocatorCount-1
	while(SmokeCount > 0) do
		GfxStartParticle("Smoke"..SmokeCount, "particles/toadexcrements.nif", "SmokeLocator"..SmokeCount, 7)
		SmokeCount = SmokeCount -1	
	end
	
	-- Solange der State contaminated gesetzt ist, immer alle Leute aus dem Gebäude schmeissen
	-- Der State wird aufgehoben, sobald der impact zurueckgesetzt wird
	if (GetImpactValue("","toadexcrements")>0) then
		GetPosition("","ParticleSpawnPos")
		GfxStartParticle("Smoke", "particles/toadexcrements.nif", "ParticleSpawnPos", 4)
		while (GetImpactValue("","toadexcrements")==1)	do
			Evacuate("Owner")
			Sleep(5)
		end
	end
end

-- Only for... whatever impacts
function OtherImpacts()
	if HasProperty("","IsStinkBomb") then
		RemoveProperty("","IsStinkBomb")
		GetPosition("","ParticleSpawnPos")
		PlaySound3D("","measures/toadexcrements+0.wav", 1.0)
		StartSingleShotParticle("particles/toadexcrements_hit.nif", "ParticleSpawnPos",6,5)
		GfxAttachObject("stinkbomb", "Handheld_Device/ANIM_Bomb_02.nif")
		GfxSetPositionTo("stinkbomb", "ParticleSpawnPos")
		GfxMoveToPosition("stinkbomb",0,20,0,0.1,false)
		GfxStartParticle("Smoke", "particles/toadexcrements.nif", "ParticleSpawnPos", 7)
	end
end

function CleanUp()	
	SetState("Owner", STATE_CONTAMINATED, false)
end

