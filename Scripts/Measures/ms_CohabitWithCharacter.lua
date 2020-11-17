-------------------------------------------------------------------------------
----
----	OVERVIEW "ms_CohabitWithCharacter"
----
----	With this measure the player can beget new blood with his spouse
----
-------------------------------------------------------------------------------

-- -----------------------
-- Run
-- -----------------------
function Run()
	local MeasureID = GetCurrentMeasureID("")
	local TimeOut = mdata_GetTimeOut(MeasureID)
	local InteractionDistance = 128
	
	-- Get the spouse and call it "Destination" because the older version of the measure worked with a selection
	if not SimGetSpouse("", "Destination") then
		StopMeasure()
		return
	end
	
	if GetState("Destination",STATE_DUEL) then
		StopMeasure()
		return
	end

	if not GetHomeBuilding("", "HomeBuilding") then
		StopMeasure()
		return
	end
	
	if not f_MoveToNoWait("", "HomeBuilding", GL_MOVESPEED_RUN) then
		StopMeasure()
	end
	if not f_MoveToNoWait("Destination", "HomeBuilding", GL_MOVESPEED_RUN) then
		StopMeasure()
	end

	local check = true
	while check do
		Sleep(2)

		if not AliasExists("Destination") then
			StopMeasure()
		end

		if GetInsideBuilding("", "Building1") and GetInsideBuilding("Destination", "Building2") then
			if (GetID("Building1")==GetID("Building2")) then
				check = false
			else
				Sleep(5)
			end
		else
			Sleep(5)
		end
	end

	if ai_StartInteraction("", "Destination", 500, InteractionDistance) then
		

		-- Ask the question
		MsgSay("", chr_AskCohabit(GetSkillValue("", RHETORIC), SimGetGender("")));
		
		-- chr_AlignExact("", "Destination", InteractionDistance)
		
		-- Hug the spouse
		-- local OwnerAnimLength = PlayAnimationNoWait("", "hug_male")
		-- local DestinationAnimLength = PlayAnimationNoWait("Destination", "hug_female")
		-- Sleep(math.max(OwnerAnimLength, DestinationAnimLength)
					
		-- Check the success
		local Success = 0
		local Favor = GetFavorToSim("", "Destination")
		if (Favor > 89) then
			MsgSay("Destination", chr_AnswerCohabit(GetSkillValue("Destination", RHETORIC), SimGetGender("Destination"), 1));
			Success = 1
		elseif (Favor > 70) then
			MsgSay("Destination", chr_AnswerCohabit(GetSkillValue("Destination", RHETORIC), SimGetGender("Destination"), 2));
			OwnerAnimLength = PlayAnimationNoWait("", "talk")
			DestinationAnimLength = PlayAnimationNoWait("Destination", "shake_head")
		elseif (Favor > 60) then
			MsgSay("Destination", chr_AnswerCohabit(GetSkillValue("Destination", RHETORIC), SimGetGender("Destination"), 2));
			OwnerAnimLength = PlayAnimationNoWait("", "talk")
			DestinationAnimLength = PlayAnimationNoWait("Destination", "cheer_01")
		else
			MsgSay("Destination", chr_AnswerCohabit(GetSkillValue("Destination", RHETORIC), SimGetGender("Destination"), 3));
			OwnerAnimLength = PlayAnimationNoWait("", "got_a_slap")
			DestinationAnimLength = PlayAnimationNoWait("Destination", "give_a_slap")
		end
		
		if (Success == 1) then
			
			if (SimGetGender("") == GL_GENDER_MALE) then
				CopyAlias("Owner", "male")
				CopyAlias("Destination", "female")
			else
				CopyAlias("Owner", "female")
				CopyAlias("Destination", "male")
			end
			
			if not GetInsideBuilding("", "Residence") then
				MsgQuick("", "@L_FAMILY_2_COHABITATION_FAILURES_+0", GetID("Building"))
				StopMeasure()
				return
			end
			
			if not GetLocatorByName("Residence", "Cohabit1", "CohabitPos1") then
				MsgQuick("", "@L_FAMILY_2_COHABITATION_FAILURES_+1", GetID("Building"))
				StopMeasure()
				return
			end
			
			if not GetLocatorByName("Residence", "Cohabit2", "CohabitPos2") then
				MsgQuick("", "@L_FAMILY_2_COHABITATION_FAILURES_+1", GetID("Building"))
				StopMeasure()
				return
			end
			SetRepeatTimer("Dynasty", GetMeasureRepeatName(), TimeOut)
			-----------------------------
			------ Go to the bed ------
			-----------------------------
			f_MoveToNoWait("male", "CohabitPos1")
			f_BeginUseLocator("female", "CohabitPos2", GL_STANCE_STAND, true)
			f_BeginUseLocator("male", "CohabitPos1", GL_STANCE_STAND, true)
			if GetLocatorByName("Residence","Curtain","CurtainPos") then
				GfxAttachObject("Curtain","Locations/Residence/Curtain_Residence.nif")
				GfxSetPositionTo("Curtain","CurtainPos")
				GfxSetRotation("Curtain",0,0,0,true)
			end
			SetData("Cohabit1LocatorInUse", 1)
			
			
			Sleep(7)
			
			-----------------------------
			------ Pregnant chance ------
			-----------------------------
			local Age = (SimGetAge("male") + SimGetAge("female")) * 0.5
			local PregnantChance = 100
			if (Age > 40) then
				PregnantChance = 100 - (Age - 40) * 5
			end
			
			-- ImpactValue 42 -> CreateChild
			PregnantChance = PregnantChance + GetImpactValue("male", 42) + GetImpactValue("female", 42)
			
			-- If any of the cahrs is sterile then PregnantChance = 0 (Made for Campaign)
			if(HasProperty("male","sterile") or HasProperty("female","sterile")) then
				PregnantChance = 0
			end
			
			--------------------------------
			------ Initiate Pregnancy ------
			--------------------------------
			if (Rand(100) < PregnantChance) then
				
				f_EndUseLocator("female", nil, GL_STANCE_LAY)
				MsgSay("", feedback_PregnancySuccess(SimGetGender(""), 1));
				SimGetPregnant("female")
				
				-- Add xp
				xp_CohabitWithCharacter("male", SimGetChildCount("male"))
				xp_CohabitWithCharacter("female", SimGetChildCount("female"))
				
			else				
				MsgSay("", feedback_PregnancySuccess(SimGetGender(""), 0));				
			end

			f_EndUseLocator("male", "CohabitPos1", GL_STANCE_STAND)
			SetData("Cohabit1LocatorInUse", 0)
			GfxDetachObject("Curtain")
			
		else
			chr_ModifyFavor("", "Destination", -5)
		end
		
	end
	
	StopMeasure()
	
end

function CleanUp()
	if AliasExists("Curtain") then
		GfxDetachObject("Curtain")
	end
	GfxDetachAllObjects()
	
	if IsStateDriven() then
		MeasureRun("", nil, "DynastyIdle")
		MeasureRun("Destination", nil, "DynastyIdle")
	end
end

function GetOSHData(MeasureID)
	--can be used again in:
	OSHSetMeasureRepeat("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+2",Gametime2Total(mdata_GetTimeOut(MeasureID)))
end

