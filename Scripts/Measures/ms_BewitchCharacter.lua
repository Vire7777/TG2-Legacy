-------------------------------------------------------------------------------
----
----	OVERVIEW "ms_BewitchCharacter"
----
----	with this measure the player can bewitch another character in the tavern
----
-------------------------------------------------------------------------------

-- -----------------------
-- Run
-- -----------------------
function Run()

	if IsStateDriven() then
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
					if LocatorStatus("DestTavern","Divanbed1",true)==1 then
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
	
	local InteractionDistance = 128
	
	-- The time in hours until the measure can be repeated
	local MeasureID = GetCurrentMeasureID("")
	local TimeUntilRepeat = mdata_GetTimeOut(MeasureID)
	
	-- calculate the price according to the basicprice and the rank of the sims
	-- local Price1 = SimGetRank("Destination")
	-- local Price2 = SimGetRank("Owner")
	-- local BasicPrice = 20
	-- local RankPrice = 20
	-- local OverallPrice = BasicPrice + (Price1 * RankPrice) + (Price2 * RankPrice)
	local OverallPrice = 200
	SetData("Price", OverallPrice)
	
	-- The minimum favor of the destination sim to success
	local CharismaSkill = GetSkillValue("", CHARISMA)
	local MinimumFavor = 50 - CharismaSkill
	local FavorWon = 5 + (CharismaSkill * 0.5)
	local FavorLoss = - 9 + Rand(4)
	
	-- the action number for the courting
	local CourtingActionNumber = 5
	
--	if not BlockChar("Destination") then
--		StopMeasure()
--		return
--	end
	
	-- Get the tavern
	if not GetInsideBuilding("", "Tavern") then
		StopMeasure()
		return
	end
	if not BuildingHasUpgrade("Tavern", "Divanbed") then
		StopMeasure()
	end

	
	GetOutdoorMovePosition("","Tavern","MovePos")
	
	-- Pay if the tavern does not belong to the owners dynasty
	if GetDynastyID("Tavern") ~= GetDynastyID("") then
		if not SpendMoney("", GetData("Price"), "CostSocial") then
			MsgQuick("", "@L_GENERAL_MEASURES_BEWITCHCHARACTER_FAILURES_+0", GetID(""), GetData("Price"))
			StopMeasure()
			return
		end
		CreditMoney("Tavern",GetData("Price"),"Offering")
	end	
	local AnimType = "bench_talk"
	if not BuildingHasUpgrade("Tavern", "Divanbed") then
		StopMeasure()
	end
		
	if not GetLocatorByName("Tavern", "Divanbed1", "Bewitcher") then
		MsgQuick("", "@L_GENERAL_MEASURES_BEWITCHCHARACTER_FAILURES_+1", GetID("Tavern"))
		StopMeasure()
		return
	end

	if not GetLocatorByName("Tavern", "Divanbed2", "Bewitched") then
		MsgQuick("", "@L_GENERAL_MEASURES_BEWITCHCHARACTER_FAILURES_+1", GetID("Tavern"))
		StopMeasure()
		return
	end
	
--	else
--		AnimType = "sit_talk"
--		if not GetLocatorByName("Tavern", "DivanbedAlt1", "Bewitcher") then
--			MsgQuick("", "@L_GENERAL_MEASURES_BEWITCHCHARACTER_FAILURES_+1", GetID("Tavern"))
--			StopMeasure()
--			return
--		end
--		
--		if not GetLocatorByName("Tavern", "DivanbedAlt2", "Bewitched") then
--			MsgQuick("", "@L_GENERAL_MEASURES_BEWITCHCHARACTER_FAILURES_+1", GetID("Tavern"))
--			StopMeasure()
--			return
--		end
--	
--	end
 	
	if not ai_StartInteraction("", "Destination", 500, InteractionDistance) then
 		StopMeasure()
 		return
 	end
 	
	local WasCourtLover = 0
	
	-------------------------
	------ Court Lover ------
	-------------------------
	if SimGetCourtLover("", "CourtLover") then
		if GetID("CourtLover")==GetID("Destination") then
					
			WasCourtLover = 1
			local ModifyFavor = FavorWon
			
			EnoughVariation, CourtingProgress = SimDoCourtingAction("", CourtingActionNumber)
			if (EnoughVariation == false) then
				
				DestinationAnimationLength = PlayAnimationNoWait("Destination", "cheer_01")
				Sleep(DestinationAnimationLength * 0.4)
				
				feedback_OverheadCourtProgress("Destination", CourtingProgress)
				
				MsgSay("Destination", chr_AnswerMissingVariation(SimGetGender("Destination"), GetSkillValue("Destination", RHETORIC)));
				
			else
	
			
				if (CourtingProgress < -5) then
					chr_MultiAnim("", "got_a_slap", "Destination", "give_a_slap", InteractionDistance, 0.4)
					ModifyFavor = FavorLoss
				elseif (CourtingProgress < 1) then
					chr_MultiAnim("", "talk", "Destination", "cheer_01", InteractionDistance, 0.4)
					ModifyFavor = FavorLoss
				else
					
					-- Go to the divanbed
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
					SetData("BewitchedLocatorInUse", 1)
					if not f_BeginUseLocator("", "Bewitcher", GL_STANCE_SITBENCH, true) then
						StopMeasure()
					end
					SetData("BewitcherLocatorInUse", 1)
					while not HasData("BewitchedLocatorInUse") do
						Sleep(1)
					end
					CreateCutscene("default","cutscene")
					CutsceneAddSim("cutscene","")
					CutsceneAddSim("cutscene","destination")
					CutsceneCameraCreate("cutscene","")				
					camera_CutscenePlayerLockSit("cutscene", "")
					FadeInFE("", "eyelids_up", 0.5, 0.3, 1)
					FadeInFE("", "smile", 0.7, 0.4, 0)
					local TimeAnim = 0
					TimeAnim = PlayAnimationNoWait("", AnimType)
					Sleep(TimeAnim-1.5)
					camera_CutscenePlayerLockSit("cutscene", "Destination")
					FadeInFE("Destination", "eyelids_up", 0.5, 0.3, 1)
					FadeInFE("Destination", "smile", 0.7, 0.4, 0)
					TimeAnim = PlayAnimationNoWait("Destination", AnimType)
					Sleep(TimeAnim-1.5)
				end
				
				if GetID("cutscene")>0 then
					camera_CutscenePlayerLockSit("cutscene", "Destination")
				end
				feedback_OverheadCourtProgress("Destination", CourtingProgress)								
				MsgSay("Destination", chr_AnswerCourtingMeasure("BEWITCH", GetSkillValue("Destination", RHETORIC), SimGetGender("Destination"), CourtingProgress));
				--CutsceneCameraRelease("cutscene")
				
			end
			
			-- Add the archieved progress
			SetMeasureRepeat(TimeUntilRepeat)
			chr_ModifyFavor("Destination", "", ModifyFavor)
			SimAddCourtingProgress("")
			
		end
	end
	
	----------------------------
	------ No Court Lover ------
	----------------------------
	if (WasCourtLover==0) then
	
		-- check if the favor is high enough for bathing
		local success = (GetFavorToSim("Destination", "Owner") > MinimumFavor)
		if success then
			
			-- Go to the divanbed
			if GetInsideBuilding("","CurrentBuilding") then
				if GetID("CurrentBuilding") ~= GetID("Tavern") then
					f_ExitCurrentBuilding("")
					f_ExitCurrentBuilding("Destination")
					f_FollowNoWait("Destination","",200)
					f_MoveTo("","MovePos")
				end
			else
				f_FollowNoWait("Destination","",200)
				f_MoveTo("","MovePos")
			end
			
			--f_MoveToNoWait("", "Bewitcher")
--			if not f_BeginUseLocator("Destination", "Bewitched", GL_STANCE_SIT, true) then
--				StopMeasure()
--			end
			if not SendCommandNoWait("Destination","MoveToPosition") then
				StopMeasure()
			end
			if not f_BeginUseLocator("", "Bewitcher", GL_STANCE_SITBENCH, true) then
				StopMeasure()
			end
			SetData("BewitcherLocatorInUse", 1)
			
			while not HasData("BewitchedLocatorInUse") do
				Sleep(1)
			end
			
			CreateCutscene("default","cutscene")
			CutsceneAddSim("cutscene","")
			CutsceneAddSim("cutscene","destination")
			CutsceneCameraCreate("cutscene","")
			camera_CutscenePlayerLockSit("cutscene", "")
			local TimeAnim = 0					
			FadeInFE("", "eyelids_up", 0.5, 0.3, 1)
			FadeInFE("", "smile", 0.7, 0.4, 0)
			TimeAnim = PlayAnimationNoWait("", AnimType)
			Sleep(TimeAnim-1.5)
			camera_CutscenePlayerLockSit("cutscene", "Destination")
			FadeInFE("Destination", "eyelids_up", 0.5, 0.3, 1)
			FadeInFE("Destination", "smile", 0.7, 0.4, 0)
			TimeAnim = PlayAnimationNoWait("Destination", AnimType)
			Sleep(TimeAnim-1.5)
			SetMeasureRepeat(TimeUntilRepeat)	
			
			-- forget the evidences
			-- for testing purposes always forget the best evidence
			if GetEvidenceAlignmentSum("Destination", "") > 0 then		
				feedback_MessageCharacter("Owner", 
					"@L_GENERAL_MEASURES_BEWITCHCHARACTER_MSG_SUCCESS_HEAD_+0",
					"@L_GENERAL_MEASURES_BEWITCHCHARACTER_MSG_SUCCESS_BODY_+0",
						GetID("Tavern"), GetID("Destination"), GetEvidenceAlignmentSum("Destination", ""), GetID("Owner"))
				RemoveEvidences("Destination", "")
			else
				feedback_MessageCharacter("Owner", 
					"@L_GENERAL_MEASURES_BEWITCHCHARACTER_MSG_NO_EVIDENCE_HEAD_+0",
					"@L_GENERAL_MEASURES_BEWITCHCHARACTER_MSG_NO_EVIDENCE_BODY_+0",
						GetID("Tavern"), GetID("Destination"), GetID("Owner"))
			end
			
		end
	end
	StopMeasure()
	
	
end

function MoveToPosition()
	if not f_BeginUseLocator("", "Bewitched", GL_STANCE_SITBENCH, true) then
		StopMeasure()
	end
	SetData("BewitchedLocatorInUse", 1)
	while true do
		Sleep(2)
	end
end

-- -----------------------
-- CleanUp
-- -----------------------
function CleanUp()

	DestroyCutscene("cutscene")	
	FadeOutAllFE("", 0)	
	StopAnimation("")
	
	if HasData("BewitcherLocatorInUse") then
		f_EndUseLocatorNoWait("", "Bewitcher", GL_STANCE_STAND)
	end
	
	if GetData("BewitchedLocatorInUse") == 1 then
		f_EndUseLocator("Destination", "Bewitched", GL_STANCE_STAND)
	end
	
	if AliasExists("Destination") then
		SimLock("Destination", 0.4)
	end

	if IsStateDriven() then
		MeasureRun("", nil, "DynastyIdle")
	end
	
end

function GetOSHData(MeasureID)
	--can be used again in:
	OSHSetMeasureRepeat("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+2",Gametime2Total(mdata_GetTimeOut(MeasureID)))
	OSHSetMeasureCost("@L_INTERFACE_HEADER_+6",200)
end

