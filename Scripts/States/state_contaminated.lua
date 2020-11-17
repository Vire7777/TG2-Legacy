function Init()
	if IsType("","Building") and GetImpactValue("","toadslime")==0 then
		SetStateImpact("no_enter")
	end
end

function Run()
	--Toad Slime
	if IsType("","Building") then
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
					if not ListContains("OldSimList", "Sim") then	--sim just entered, do stuff on Sim
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
					if not ListContains("NewSimList", "Sim") then	--sim just exited, do stuff on Sim
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
	end

--Negative effect for Dr Faust's Elixer
	if IsType("","Sim") then
		if GetImpactValue("","FaustBad")==1 then
			local Delay = 2
			Sleep(5)
			while GetImpactValue("","FaustBad")>0 do
				CommitAction("FaustBad","","")
				GetPosition("", "EffectPosition")
				StartSingleShotParticle("particles/toadexcrements_hit.nif", "EffectPosition",4,5)
				PlaySound3D("", "CharacterFX/nasty/Furzen+1.wav", 1.0)
				PlaySound3D("", "CharacterFX/nasty/Furzen+1.wav", 1.0)
				
				Sleep(3)
				StopAction("FaustBad", "")
				
				Sleep(Rand(10)+Rand(Delay))
				Delay = Delay + 1
			end
			
			SetState("",STATE_CONTAMINATED,false)
			return
		end
	end

	--contaminated also works for perfume on sims
	if IsType("","Sim") then
		if GetImpactValue("","perfume")==1 then
			CommitAction("perfume","","")
			while GetImpactValue("","perfume")>0 do
				Sleep(5)
			end
			StopAction("perfume", "")
			SetState("",STATE_CONTAMINATED,false)
			return
		end
	end

	--die Schärpe wirkt auf die Sims (beide Geschlechter)
	if IsType("","Sim") then
		if GetImpactValue("","schaerpe")==2 then
			CommitAction("schaerpe","","")
			while GetImpactValue("","schaerpe")>1 do
				Sleep(5)
			end
			SetState("",STATE_CONTAMINATED,false)
			return
		end
	end

	--die Hypnose zur Belustigung beider Geschlechter
	if IsType("","Sim") then
		if GetImpactValue("","UnterHypnose")==1 then
			CommitAction("bard","","")
			while GetImpactValue("","UnterHypnose")>0 do
				Sleep(5)
			end
                        SetState("", STATE_CONTAMINATED, false)
			return
		end
	end

	--der Moschus macht mit
	if IsType("","Sim") then
		if GetImpactValue("","moschusduft")==1 then
			CommitAction("moschusduft","","")
			while GetImpactValue("","moschusduft")>0 do
				Sleep(5)
			end
			SetState("",STATE_CONTAMINATED,false)
			return
		end
	end

	--der Kamm wirkt bei Amtskollegen
	if IsType("","Sim") then
		if GetImpactValue("","kamm")==1 then
			CommitAction("kamm","","")
			while GetImpactValue("","kamm")>0 do
				Sleep(5)
			end
			SetState("",STATE_CONTAMINATED,false)
			return
		end
	end
	
	if HasProperty("","IsStinkBomb") then
		RemoveProperty("","IsStinkBomb")
		GetPosition("","ParticleSpawnPos")
		PlaySound3D("","measures/toadexcrements+0.wav", 1.0)
		StartSingleShotParticle("particles/toadexcrements_hit.nif", "ParticleSpawnPos",6,5)
		GfxAttachObject("stinkbomb", "Handheld_Device/ANIM_Bomb_02.nif")
		GfxSetPositionTo("stinkbomb", "ParticleSpawnPos")
		GfxMoveToPosition("stinkbomb",0,20,0,0.1,false)
		GfxStartParticle("Smoke", "particles/toadexcrements.nif", "ParticleSpawnPos", 7)
		while true do
			Sleep(4)
		end
		return
	end
	
	-- Solange der State contaminated gesetzt ist, immer alle Leute aus dem Gebäude schmeissen
	-- Der State wird aufgehoben, sobald der impact zurueckgesetzt wird
	if (BuildingGetType("")==GL_BUILDING_TYPE_WELL) then
		GetPosition("","ParticleSpawnPos")
		GfxStartParticle("Smoke", "particles/toadexcrements.nif", "ParticleSpawnPos", 4)
		while (GetImpactValue("","polluted")==1) do
			if GetImpactValue("","toadexcrements")==1 then
				Evacuate("")
			end
			Sleep(5)
		end
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
	
	while (GetImpactValue("","toadexcrements")==1)  do
		Evacuate("Owner")
		Sleep(2)
	end
end

function CleanUp()
	
	SetState("Owner", STATE_CONTAMINATED, false)
	if HasProperty("Owner", "perfume") then
		RemoveProperty("Owner","perfume")
	end
	
end

