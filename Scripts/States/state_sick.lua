function Init()
end

function Run()
	local Incubate = true
	if IsPartyMember("") then
		feedback_MessageCharacter("","@L_ARTEFACTS_178_USETOADSLIME_MSG_VICTIM_DYNSIM_HEAD_+0",
						"@L_ARTEFACTS_178_USETOADSLIME_MSG_VICTIM_DYNSIM_BODY_+0",GetID(""))
	end
	
	while Incubate == true do
		StopAction("sickness","")
		RemoveOverheadSymbols("")
		
		------------------------------------------------------
		-- increase the number of infections
		-- this is only done twice because incubate is only true if
		-- the disease changed to a higher level
		if GetSettlement("","City") then
			if GetImpactValue("","Sprain")==1 then
				chr_incrementInfectionCount("SprainInfected", "City")
			elseif GetImpactValue("","Cold")==1 then
				chr_incrementInfectionCount("ColdInfected", "City")
			elseif GetImpactValue("","Influenza")==1 then
				chr_incrementInfectionCount("InfluenzaInfected", "City")
			elseif GetImpactValue("","BurnWound")==1 then
				chr_incrementInfectionCount("BurnWoundInfected", "City")
			elseif GetImpactValue("","Pox")==1 then
				chr_incrementInfectionCount("PoxInfected", "City")
			elseif GetImpactValue("","Pneumonia")==1 then
				chr_incrementInfectionCount("PneumoniaInfected", "City")
			elseif GetImpactValue("","Blackdeath")==1 then
				chr_incrementInfectionCount("BlackdeathInfected", "City")
			elseif GetImpactValue("","Fracture")==1 then
				chr_incrementInfectionCount("FractureInfected", "City")
			elseif GetImpactValue("","Caries")==1 then
				chr_incrementInfectionCount("CariesInfected", "City")
			else
				StopMeasure()
			end
		end
		------------------------------------------------------
		
		
		if GetImpactValue("","Sprain")==1 then
			Incubate = state_sick_SprainBehaviour()
		elseif GetImpactValue("","Cold")==1 then
			Incubate = state_sick_ColdBehaviour()
		elseif GetImpactValue("","Influenza")==1 then
			Incubate = state_sick_InfluenzaBehaviour()
		elseif GetImpactValue("","BurnWound")==1 then
			Incubate = state_sick_BurnWoundBehaviour()
		elseif GetImpactValue("","Pox")==1 then
			Incubate = state_sick_PoxBehaviour()
		elseif GetImpactValue("","Pneumonia")==1 then
			Incubate = state_sick_PneumoniaBehaviour()
		elseif GetImpactValue("","Blackdeath")==1 then
			Incubate = state_sick_BlackdeathBehaviour()
		elseif GetImpactValue("","Fracture")==1 then
			Incubate = state_sick_FractureBehaviour()
		elseif GetImpactValue("","Caries")==1 then
			Incubate = state_sick_CariesBehaviour()
		else
			StopMeasure()
		end
		Sleep(1)
	end
	StopMeasure()
end

function SprainBehaviour()
	--ShowOverheadSymbol("",true,true,0,"Scheisse, ich hab mir den Fuss verstaucht!")
	if not IsPartyMember("") then
		if not GetDynasty("","Tdyn") then
			MoveSetActivity("","hobble")
		end
	end
	while GetImpactValue("","Sprain")==1 do
		Sleep(Rand(20)+10)
	end
	
	-- disease finished
	if GetSettlement("","City") then
		chr_decrementInfectionCount("SprainInfected", "City")
	end
	
	return false
end

function ColdBehaviour()
	--ShowOverheadSymbol("",true,true,0,"Scheisse, ich hab ne Erk�ltung")
	CommitAction("sickness","","")
	if not IsPartyMember("") then
		if not GetDynasty("","Tdyn") then
			MoveSetActivity("","sick")
		end
	end
	while GetImpactValue("","Cold")==1 do
		Sleep(Rand(20)+10)
		if (GetState("", STATE_IDLE) and MoveGetStance("")==GL_STANCE_STAND) then
			local AnimTime
			local Gender = SimGetGender("")
			if Rand(10)>4 then
				AnimTime = PlayAnimationNoWait("","sneeze")
				Sleep(0.5)
				PlaySound3DVariation("","CharacterFX/sneeze",1)
				Sleep(AnimTime-0.5)
			else
				AnimTime = PlayAnimationNoWait("","cough")
				Sleep(1)
				PlaySound3DVariation("","CharacterFX/disease_light_cough",1)
				
				Sleep(AnimTime-1)
				
			end
		end
	end
	
	-- disease finished
	if GetSettlement("","City") then
		chr_decrementInfectionCount("ColdInfected", "City")
	end
	
	if not IsPartyMember("") then
		diseases_Influenza("",true,true)
	end
	return true
end

function InfluenzaBehaviour()
	--ShowOverheadSymbol("",true,true,0,"Scheisse, ich hab Grippe!")
	if not IsPartyMember("") then
		if not GetDynasty("","Tdyn") then
			MoveSetActivity("","sick")
		end
	end
	CommitAction("sickness","","")
	while GetImpactValue("","Influenza")==1 do
		Sleep(Rand(20)+10)
		if (GetState("", STATE_IDLE) and MoveGetStance("")==GL_STANCE_STAND) then
			local AnimTime
			local Gender = SimGetGender("")
			if Rand(10)>4 then
				AnimTime = PlayAnimationNoWait("","sneeze")
				Sleep(0.5)
				PlaySound3DVariation("","CharacterFX/sneeze",1)
				Sleep(AnimTime-0.5)
			else
				AnimTime = PlayAnimationNoWait("","cough")
				Sleep(1)
				PlaySound3DVariation("","CharacterFX/disease_light_cough",1)
				Sleep(AnimTime-1)
				
			end
		end
	end
	
	-- disease finished
	if GetSettlement("","City") then
		chr_decrementInfectionCount("InfluenzaInfected", "City")
	end
	
	if not IsPartyMember("") then
		diseases_Pneumonia("",true,true)
	end
	return true
end

function BurnWoundBehaviour()
	--ShowOverheadSymbol("",true,true,0,"Scheisse, ich hab mich verbrannt!")
	local HPChange = GetMaxHP("") * 0.1

	while true do
		Sleep(60)
		if not AliasExists("") or GetImpactValue("","BurnWound")~=1 then
			break
		end
		if IsDynastySim("") then
			SetProperty("", "WasDynastySim",1)
		end
		if not GetState("",STATE_CUTSCENE) then
			ModifyHP("",-HPChange,true)
		end
	end
		
	-- disease finished
	if GetSettlement("","City") then
		chr_decrementInfectionCount("BurnWoundInfected", "City")
	end
	
	return false
end

function PoxBehaviour()
	--ShowOverheadSymbol("",true,true,0,"Verdammt, ich hab die Pocken!")
	if not IsPartyMember("") then
		if not GetDynasty("","Tdyn") then
			MoveSetActivity("","sick")
		end
	end
	CommitAction("sickness","","")
	while GetImpactValue("","Pox")==1 do
		Sleep(Rand(20)+10)
		if (GetState("", STATE_IDLE) and MoveGetStance("")==GL_STANCE_STAND) then
			local AnimTime
			local Gender = SimGetGender("")
			
			AnimTime = PlayAnimationNoWait("","cough")
			Sleep(1)
			PlaySound3DVariation("","CharacterFX/disease_seriously_cough",1)
			Sleep(AnimTime-1)
		end
	end
	
	-- disease finished
	if GetSettlement("","City") then
		chr_decrementInfectionCount("PoxInfected", "City")
	end
	
	return false
end

function PneumoniaBehaviour()
	if IsDynastySim("") then
		DynastyGetFamilyMember("",1,"Member")
		if not AliasExists("Member") then
			return false
		end
	end
	if (SimGetProfession("") > 19) and (SimGetProfession("") < 26) then
		return false
	end
	if SimGetProfession("") == 28 then
		return false
	end 
	if (SimGetProfession("") > 30) and (SimGetProfession("") < 40) then
		return false
	end
	if (SimGetProfession("") > 42) and (SimGetProfession("") < 53) then
		return false
	end
	if (SimGetProfession("") > 53) and (SimGetProfession("") < 59) then
		return false
	end
	if (SimGetProfession("") > 62) and (SimGetProfession("") < 68) then
		return false
	end
	if (SimGetProfession("") > 72) and (SimGetProfession("") < 76) then
		return false
	end
	--ShowOverheadSymbol("",true,true,0,"Verdammt, Lungenentz�ndung! *hust*")
	if not IsPartyMember("") then
		if not GetDynasty("","Tdyn") then
			MoveSetActivity("","sick")
		end
	end
	while GetImpactValue("","Pneumonia")==1 do
		Sleep(Rand(20)+10)
		if (GetState("", STATE_IDLE) and MoveGetStance("")==GL_STANCE_STAND) then
			local AnimTime
			local Gender = SimGetGender("")
			if Rand(10)>4 then
				AnimTime = PlayAnimationNoWait("","sneeze")
				Sleep(0.5)
				PlaySound3DVariation("","CharacterFX/sneeze",1)
				Sleep(AnimTime-0.5)
			else
				AnimTime = PlayAnimationNoWait("","cough")
				Sleep(1)
				PlaySound3DVariation("","CharacterFX/disease_seriously_cough",1)
				Sleep(AnimTime-1)
				
			end
		end
	end
	
	-- disease finished
	if GetSettlement("","City") then
		chr_decrementInfectionCount("PneumoniaInfected", "City")
	end
	
	SetProperty("","WasSick",1)
	if IsDynastySim("") then
		SetProperty("", "WasDynastySim",1)
	end
	while GetState("",STATE_CUTSCENE) do
		Sleep(20)
	end
	ModifyHP("",-GetMaxHP(""),true)
	return false
end

function BlackdeathBehaviour()
	if IsDynastySim("") then
		DynastyGetFamilyMember("",1,"Member")
		if not AliasExists("Member") then
			return false
		end
	end
	if (SimGetProfession("") > 19) and (SimGetProfession("") < 26) then
		return false
	end
	if SimGetProfession("") == 28 then
		return false
	end 
	if (SimGetProfession("") > 30) and (SimGetProfession("") < 40) then
		return false
	end
	if (SimGetProfession("") > 42) and (SimGetProfession("") < 53) then
		return false
	end
	if (SimGetProfession("") > 53) and (SimGetProfession("") < 59) then
		return false
	end
	if (SimGetProfession("") > 62) and (SimGetProfession("") < 68) then
		return false
	end
	if (SimGetProfession("") > 72) and (SimGetProfession("") < 76) then
		return false
	end
	--ShowOverheadSymbol("",true,true,0,"Argh, PEST!")
	if not IsPartyMember("") then
		if not GetDynasty("","Tdyn") then
			MoveSetActivity("","sick")
		end
	end
	CommitAction("sickness","","")
	
	--extra visuals for blackdeath
--	GfxAttachObject("Trine","particles/ship_burn.nif")
--	AttachModel("", "Trine")
--	GfxSetPosition("Trine", 0, 100, 0, true)
--	GfxScale("Trine",1)
	
	while GetImpactValue("","Blackdeath")==1 do
		Sleep(Rand(20)+10)
		if (GetState("", STATE_IDLE) and MoveGetStance("")==GL_STANCE_STAND) then
			local AnimTime
			local Gender = SimGetGender("")
			
			AnimTime = PlayAnimationNoWait("","cough")
			Sleep(1)
			PlaySound3DVariation("","CharacterFX/disease_seriously_cough",1)
			Sleep(AnimTime-1)
		end
	end
	
	-- disease finished
	if GetSettlement("","City") then
		chr_decrementInfectionCount("BlackdeathInfected", "City")	
	end
	
	SetProperty("","WasSick",1)
	if IsDynastySim("") then
		SetProperty("", "WasDynastySim",1)
	end
	while GetState("",STATE_CUTSCENE) do
		Sleep(20)
	end
	ModifyHP("",-GetMaxHP(""),true)
	return false
end

function FractureBehaviour()
	--ShowOverheadSymbol("",true,true,0,"Aua, hab mir mein Bein gebrochen!")
	if not IsPartyMember("") then
		if not GetDynasty("","Tdyn") then
			MoveSetActivity("","hobble")
		end
	end
		
	while GetImpactValue("","Fracture")==1 do
		Sleep(Rand(20)+10)
	end

	-- disease finished
	if GetSettlement("","City") then
		chr_decrementInfectionCount("FractureInfected", "City")
	end
	
	return false
end

function CariesBehaviour()
	--ShowOverheadSymbol("",true,true,0,"Meine Z�hne faulen!")
	while GetImpactValue("","Caries")==1 do
		Sleep(Rand(20)+10)
	end
	
	-- disease finished
	if GetSettlement("","City") then
		chr_decrementInfectionCount("CariesInfected", "City")		
	end
	
	return false
end

function CleanUp()
	GfxDetachAllObjects()
	if GetSettlement("","City") then
		if AliasExists("City") then
			if HasProperty("City","InfectedSims") then
				local CurrentInfected = GetProperty("City","InfectedSims") - 1
				SetProperty("City","InfectedSims",CurrentInfected)
			end
		end
	end
	StopAction("sickness","")
	AddImpact("","Resist",1,6)
	RemoveOverheadSymbols("")
	
end

