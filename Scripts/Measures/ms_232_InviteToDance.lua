-------------------------------------------------------------------------------
----
----	OVERVIEW "ms_232_InviteToDance"
----
----	with this measure the player can invite an other character to a dance
----	in the tavern
----
-------------------------------------------------------------------------------

-- -----------------------
-- Run
-- -----------------------
function Run()
	
	-- The time in hours until the measure can be repeated
	local MeasureID = GetCurrentMeasureID("")
	local TimeUntilRepeat = mdata_GetTimeOut(MeasureID)
	
	-- the minimum favor of the destination sim to success
	local CharismaSkill = GetSkillValue("", CHARISMA)
	local MinimumFavor = 50 - CharismaSkill
	local FavorWon = 5 + (CharismaSkill * 0.5)
	local FavorLoss = Rand(4)-9
	
	local OverallPrice = 300
	SetData("Price", OverallPrice)
	
	if IsStateDriven() then
--		if not ai_StartBuildingAction("", "Destination", -1, GL_BUILDING_TYPE_TAVERN) then
--			return
--		end

		if not GetSettlement("","city") then
			StopMeasure()
		end
		if not CityGetNearestBuilding("city", "", -1, GL_BUILDING_TYPE_TAVERN, -1, -1, FILTER_IGNORE, "DestTavern") then
			StopMeasure()
		end

		if not f_MoveToNoWait("", "DestTavern", GL_MOVESPEED_RUN) then
			StopMeasure()
		end
		if not f_MoveToNoWait("Destination", "DestTavern", GL_MOVESPEED_RUN) then
			StopMeasure()
		end

		local check = true
		local WaitTime = GetGametime() + 3
		while check do
			Sleep(2)
			
			if not AliasExists("Destination") then
				StopMeasure()
			end
			if WaitTime < GetGametime() then
				StopMeasure()
			end
			
			if GetInsideBuilding("", "Building1") and GetInsideBuilding("Destination", "Building2") then
				if (GetID("Building1")==GetID("Building2")) and (GetID("Building1")==GetID("DestTavern")) then
					if LocatorStatus("DestTavern","Social_Dance",true)==1 then
						check = false
					end
				else
					Sleep(5)
				end
			else
				Sleep(5)
			end
		end
	end
	
	-- Get the tavern
	if not GetInsideBuilding("", "Tavern") then
		StopMeasure()
		return
	end
	
	-- Pay if the tavern does not belong to the owners dynasty
	if GetDynastyID("Tavern") ~= GetDynastyID("") then
		if not SpendMoney("", GetData("Price"), "CostSocial") then
			MsgQuick("", "@L_TAVERN_232_INVITETODANCE_FAILURES_MONEY_+0", GetID(""), GetData("Price"))
			StopMeasure()
			return
		end
		CreditMoney("Tavern",GetData("Price"),"Offering")
	end	

	if GetDynastyID("Tavern") ~= GetDynastyID("") then --<------ Bugfix where tavern owners gain $300 if they dance in their own tavern. This was obviously intended to be free not a cheat!
		CreditMoney("Tavern",GetData("Price"),"Offering")
	end
	-- the action number for the courting
	local CourtingActionNumber = 2
	
	-- The distance between both sims to interact with each other
	local InteractionDistance=128
	
	if not ai_StartBuildingAction("", "Destination", -1, GL_BUILDING_TYPE_TAVERN) then
		return
	end
	
	SetData("BathpartnerBlocked", 1)

	GetOutdoorMovePosition("","Tavern","MovePos")
	---------------------------------------
	------ Check dancefloor free ------
	---------------------------------------
	if not GetLocatorByName("Tavern", "Social_Dance", "DancePos") then
		MsgQuick("", "@L_TAVERN_232_INVITETODANCE_FAILURES_+0", GetID("Tavern"))
		StopMeasure()
		return
	end
	
	if not GetLocatorByName("Tavern", "Social_Dance2", "DancePos2") then
		MsgQuick("", "@L_TAVERN_232_INVITETODANCE_FAILURES_+0", GetID("Tavern"))
		StopMeasure()
		return
	end
	
	feedback_OverheadActionName("Destination")
	AlignTo("Destination", "")
	Sleep(0.5)
	
--	if not ai_StartInteraction("", "Destination", 500, InteractionDistance) then
--		StopMeasure()
-- 		return
-- 	end 	
 	
 	MeasureSetNotRestartable()
	local WasCourtLover = 0
	SetRepeatTimer("", GetMeasureRepeatName2("InviteToDance"), 2)
	
	-------------------------
	------ Court Lover ------
	-------------------------
	if SimGetCourtLover("", "CourtLover") then
		if GetID("CourtLover")==GetID("Destination") then
			
			WasCourtLover = 1
			local ModifyFavor = FavorWon
			
			EnoughVariation, CourtingProgress = SimDoCourtingAction("", CourtingActionNumber)
			if (EnoughVariation == false) then
			
				local time1 = PlayAnimationNoWait("Destination", "cheer_01")
				Sleep(time1 * 0.4)
				
				feedback_OverheadCourtProgress("Destination", CourtingProgress)
				
				MsgSay("Destination", chr_AnswerMissingVariation(SimGetGender("Destination"), GetSkillValue("Destination", RHETORIC)));
				
			else
				
				local OwnerAnimation = ""
				local DestinationAnimation = ""
				
				if (CourtingProgress > 0) then
				
					-- Go to the dancefloor
					if GetInsideBuilding("","CurrentBuilding") then
						if GetID("CurrentBuilding") ~= GetID("Tavern") then
							f_ExitCurrentBuilding("")
							f_ExitCurrentBuilding("Destination")
							f_FollowNoWait("Destination","",150)
							f_MoveTo("","MovePos")
						end
					else
						f_FollowNoWait("Destination","",150)
						f_MoveTo("","MovePos")
					end
					--f_MoveToNoWait("", "Bewitcher")
					if not SendCommandNoWait("Destination","MoveToPosition") then
						StopMeasure()
					end
					f_BeginUseLocator("", "DancePos", GL_STANCE_STAND, true)
					SetData("Dance2LocatorInUse", 1)
					while not HasData("DanceLocatorInUse") do
						Sleep(1)
					end
					
					SetAvoidanceGroup("", "Destination")		
					ms_232_invitetodance_EnterCutscene()
--					camera_CutsceneBothLock("", "Destination")
					chr_MultiAnim("", "dance_social_male", "Destination", "dance_social_female", InteractionDistance)
					
				elseif (CourtingProgress < -5) then
					ms_232_invitetodance_EnterCutscene()
--					camera_CutsceneBothLock("", "Destination")
					chr_MultiAnim("", "got_a_slap", "Destination", "give_a_slap", InteractionDistance, 0.4)
					ModifyFavor = FavorLoss
				else
					ms_232_invitetodance_EnterCutscene()
--					camera_CutscenePlayerLock("", "Destination")
					chr_MultiAnim("", "talk", "Destination", "cheer_01", InteractionDistance, 0.4)
					ModifyFavor = FavorLoss
				end
				feedback_OverheadCourtProgress("Destination", CourtingProgress)				
				MsgSay("Destination", chr_AnswerCourtingMeasure("DANCE", GetSkillValue("Destination", RHETORIC), SimGetGender("Destination"), CourtingProgress));
				
			end
			
			-- Add the archieved progress
			chr_ModifyFavor("Destination", "", ModifyFavor)
			SimAddCourtingProgress("")
			SetMeasureRepeat(TimeUntilRepeat)
		end
	end
	
	----------------------------
	------ No Court Lover ------
	----------------------------
	if (WasCourtLover==0) then
	
		local slap = false
		local outraged = false
		
		-- React negativ if the destination married or if the favor is not high enough
		if SimGetSpouse("Destination", "Spouse") then
			if (GetID("Spouse")~=GetID("")) then
				outraged = true
			end
		elseif GetFavorToSim("Destination", "") < MinimumFavor then
			if Rand(20) > 14 then
				slap = true
			end
		elseif Rand(10) == 5 then
			outraged = true
		end
		
		if slap then
			
			-- Set the favor here so that the player will not be able to cancel the measure if he recognizes the defeat (cheat)
			chr_ModifyFavor("Destination", "", FavorLoss)
			SetMeasureRepeat(TimeUntilRepeat)
			
			ms_232_invitetodance_EnterCutscene()
--			camera_CutsceneBothLock("", "Destination")
			chr_MultiAnim("", "got_a_slap", "Destination", "give_a_slap", InteractionDistance, 1.0, true)
			MsgSay("Destination", chr_SocialMeasureFailedBeforeStart(SimGetGender("Destination"), GetSkillValue("Destination", RHETORIC), "Slap"))
			
		elseif outraged then
			
			-- Set the favor here so that the player will not be able to cancel the measure if he recognizes the defeat (cheat)
			chr_ModifyFavor("Destination", "", FavorLoss)
			SetMeasureRepeat(TimeUntilRepeat)
			
			ms_232_invitetodance_EnterCutscene()
			camera_CutscenePlayerLock("", "Destination")
			chr_MultiAnim("", "devotion", "Destination", "propel", InteractionDistance, 1.0, true)
			MsgSay("Destination", chr_SocialMeasureFailedBeforeStart(SimGetGender("Destination"), GetSkillValue("Destination", RHETORIC), "Outraged"))
			
		else
			if AliasExists("cutscene") then
				DestroyCutscene("cutscene")			
			end
			-- Go to the dancefloor
			if GetInsideBuilding("","CurrentBuilding") then
				if GetID("CurrentBuilding") ~= GetID("Tavern") then
					f_ExitCurrentBuilding("")
					f_ExitCurrentBuilding("Destination")
					f_FollowNoWait("Destination","",150)
					f_MoveTo("","MovePos")
				end
			else
				f_FollowNoWait("Destination","",150)
				f_MoveTo("","MovePos")
			end
			--f_MoveToNoWait("", "Bewitcher")
			if not SendCommandNoWait("Destination","MoveToPosition") then
				StopMeasure()
			end
			f_BeginUseLocator("", "DancePos", GL_STANCE_STAND, true)
			SetData("Dance2LocatorInUse", 1)
			while not HasData("DanceLocatorInUse") do
				Sleep(1)
			end
			
			SetAvoidanceGroup("", "Destination")
			chr_MultiAnim("", "dance_social_male", "Destination", "dance_social_female", InteractionDistance)
			MsgSay("Destination", chr_AnswerCourtingMeasure("DANCE", GetSkillValue("Destination", RHETORIC), SimGetGender("Destination"), 6))
			
			-- Set the favor here so that the player will not be able to cancel the measure if he recognizes the success in order to save time (cheat)
			chr_ModifyFavor("Destination", "", FavorWon)
			SetMeasureRepeat(TimeUntilRepeat)
			
		end
	end
	StopMeasure()
end

-- -----------------------
-- CleanUp
-- -----------------------
function CleanUp()
	DestroyCutscene("cutscene")
	
	ReleaseAvoidanceGroup("")
	StopAnimation("")
	
	if AliasExists("Destination") then
		SimLock("Destination", 0.4)
	end
	
	if HasData("BathpartnerBlocked") then	
		StopAnimation("Destination")
	end
	
	if HasData("DanceLocatorInUse") then
		f_EndUseLocatorNoWait("", "DancePos")
	end
	
	if HasData("Dance2LocatorInUse") then
		f_EndUseLocator("", "DancePos2")
	end

	if IsStateDriven() then
		MeasureRun("", nil, "DynastyIdle")
	end
	
end

function MoveToPosition()
	if not f_BeginUseLocator("", "DancePos2", GL_STANCE_STAND, true) then
		StopMeasure()
	end
	SetData("DanceLocatorInUse", 1)
	while true do
		Sleep(2)
	end
end

function GetOSHData(MeasureID)
	--can be used again in:
	OSHSetMeasureRepeat("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+2",Gametime2Total(mdata_GetTimeOut(MeasureID)))
	OSHSetMeasureCost("@L_INTERFACE_HEADER_+6",300)
end

function EnterCutscene()
	if not AliasExists("cutscene") then
		CreateCutscene("default","cutscene")
		CutsceneAddSim("cutscene","")
		CutsceneAddSim("cutscene","destination")
		CutsceneCameraCreate("cutscene","")			
		camera_CutsceneBothLock("cutscene", "destination")
	end
end
