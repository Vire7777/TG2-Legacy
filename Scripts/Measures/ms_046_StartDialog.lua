-------------------------------------------------------------------------------
----
----	OVERVIEW "ms_046_StartDialog"
----
----	with this measure the player can start a dialog with another sim
----
-------------------------------------------------------------------------------

-- -----------------------
-- Run
-- -----------------------
function Run()

	-- the action number for the courting
	local CourtingActionNumber = 0
	
	-- case for talk need
	if not(AliasExists("Destination")) then
		return
	end
	
	if not ai_StartInteraction("", "Destination", 350, 100) then
		StopMeasure()
		return
	end

	-- only a player should be able to start a quests
	if DynastyIsPlayer("") then
		if (QuestTalk("","Destination")) then
			StopMeasure()
			return
		end		
	elseif GetState("Destination", STATE_NPC) then
		StopMeasure()
	return
	end

	SetAvoidanceGroup("", "Destination")
	
	SetProperty("","InTalk",1)
	SetProperty("Destination","InTalk",1)
	
	CreateCutscene("default","cutscene")
	CutsceneAddSim("cutscene","")
	CutsceneAddSim("cutscene","destination")
	CutsceneCameraCreate("cutscene","")			
	
	PlayAnimationNoWait("", "talk")
	Sleep(1.0)
	PlayAnimation("Destination", "talk")

	Talk("", "Destination")
	
	-------------------------
	------ Court Lover ------
	-------------------------
	if SimGetCourtLover("", "CourtLover") then
		if GetID("CourtLover")==GetID("Destination") then
			
			MoveSetActivity("", "converse")
			MoveSetActivity("Destination", "converse")
			
			camera_CutscenePlayerLock("cutscene", "Destination")
			
			EnoughVariation, CourtingProgress = SimDoCourtingAction("", CourtingActionNumber)
			if (EnoughVariation == false) then
				feedback_OverheadCourtProgress("Destination", CourtingProgress)
				MsgSay("Destination", chr_AnswerMissingVariation(SimGetGender("Destination"), GetSkillValue("Destination", RHETORIC)));
			else
				feedback_OverheadCourtProgress("Destination", CourtingProgress)
				MsgSay("Destination", chr_AnswerCourtingMeasure("TALK", GetSkillValue("Destination", RHETORIC), SimGetGender("Destination"), CourtingProgress));
			end
			
			Sleep(3.0)

			-- Add the archieved progress
			SimAddCourtingProgress("")
			
		end
	end

	SatisfyNeed("", 3, 1.0)
	SatisfyNeed("Destination", 3, 1.0)
	
end

-- -----------------------
-- CleanUp
-- -----------------------
function CleanUp()

	DestroyCutscene("cutscene")

	MoveSetActivity("")
	

	if(AliasExists("Destination")) then
		MoveSetActivity("Destination")
		RemoveProperty("Destination","InTalk")
		StopAnimation("Destination")
	end

	RemoveProperty("", "InTalk")
	StopAnimation("")
	
	ReleaseAvoidanceGroup("")
	
end

