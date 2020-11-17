----------------------------------------------------------------------------------
--- Main Body
----------------------------------------------------------------------------------
-- Setup / Termin / Einladung
function Start()
	-- wichtigste rollen zuweisen
		CityAssignTrialRoles("","settlement")
		local TrialAlias = GetID("")
		local CityAlias = GetID("settlement")
		
		LogMessage("TrialAlias = "..TrialAlias.." CityAlias = "..CityAlias)
		-- Beisitzer aus Liste der DynastyChars des Settlements bestimmen
		CityGetDynastyCharList("settlement","assessor_candidates") --NEW
		ListRemove("assessor_candidates","judge")
		ListRemove("assessor_candidates","accuser")
		ListRemove("assessor_candidates","accused")

		local lsize = ListSize("assessor_candidates")
		if lsize>=1 then
			local index = Rand(lsize)
			ListGetElement("assessor_candidates",index,"assessor1")
			ListRemove("assessor_candidates","assessor1")
		end

		lsize = ListSize("assessor_candidates")
		if lsize>=1 then
			local index = Rand(lsize)
			ListGetElement("assessor_candidates",index,"assessor2")
			ListRemove("assessor_candidates","assessor2")
		end
	-- ein termin wird festgelegt: event_alias, settlement, cutscene, function
		
		--CityScheduleCutsceneEvent("settlement","trial_date","","EverybodySitDown",9,8,"@L_LAWSUIT_DIARY_CITY_+0",GetID("accuser"),GetID("accused"))	-- hourofday=9,mintimeinfuture=8
		
		local EventTime = 1980 --1980/60 = 33 **** 33-24 = 9 <---9am is when we want to set the trial for :)

		local GameTime = GetGametime()*60
		local WaitTime = EventTime - GameTime - (6*60)
		--		local day = math.floor(GetGametime()/24)
		local hour = math.mod(GetGametime(),24)
		
		if (WaitTime<0) then
			trial_SetBuildingInfo()
		else
			CutsceneAddEvent("","SetBuildingInfo",WaitTime)
		end
		local Evidences = 0+CutsceneCollectEvidences("","accuser","accused")

		-- an den Richter
		if GetID("judge")>0 then

			feedback_MessagePolitics("judge",
					"@L_LAWSUIT_2_MESSAGES_2A_SEND_RICHTER_+0",
					"@L_LAWSUIT_2_MESSAGES_2A_SEND_RICHTER_+1",
					GetID("judge"),GetID("accuser"),GetID("accused"), EventTime, EventTime ,GetID("settlement"))
		end
		SetData("judge",GetID("judge"))

		-- an den Ankläger
		if GetID("accuser")>0 then

			feedback_MessagePolitics("accuser",
					"@L_LAWSUIT_2_MESSAGES_2A_SEND_KLAEGER_+0",
					"@L_LAWSUIT_2_MESSAGES_2A_SEND_KLAEGER_+1",
					GetID("accuser"),GetID("accused"),GetID("settlement"),Evidences,EventTime,EventTime)

			SetProperty("accuser","trial_destination_ID",GetID(""))
			SetProperty("accuser","HaveCutscene",1)
		end
		SetData("accuser",GetID("accuser"))

		if GetID("accused")>0 then

			feedback_MessagePolitics("accused",
					"@L_LAWSUIT_2_MESSAGES_2A_SEND_ANGEKLAGTER_+0",
					"@L_LAWSUIT_2_MESSAGES_2A_SEND_ANGEKLAGTER_+1",
					GetID("accused"),GetID("accuser"),GetID("settlement"),EventTime,EventTime)

			SetProperty("accused","trial_destination_ID",GetID(""))
			SetProperty("accused","HaveCutscene",1)
		end
		SetData("accused",GetID("accused"))

		SetData("assessor1",GetID("assessor1"))

		SetData("assessor2",GetID("assessor2"))
		SetData("surrendered", 0)
		
		CityScheduleCutsceneEvent("settlement","offer_light_judgement","","OfferLightJudgement",hour+1,0,"@L_LAWSUIT_DIARY_CITY_+0",GetID("accuser"),GetID("accused"))
end

function OfferLightJudgement()
	local NumEvidences = 0+CutsceneCollectEvidences("","accuser","accused")
	local EvidenceType		= GetData("evidence0type")
	local VictimID			= GetData("evidence0victim")
	local EvidenceStrength  = GetData("evidence0quality")
	local EvidenceValue		= GetData("evidence0value") 
	local EventTime         = 1980 --SettlementEventGetTime("trial_date")  **Event has not been created since we cannot delete it once it has been intiated
	local SurrenderOffer = 0
	local SurrenderAnswer = 0
	local PenaltyType = 0
	local PenaltyValue = 0	
	
	if EvidenceValue==nil then
		EvidenceValue = 0
	end
	
	if(EvidenceValue < 8) then
		local EvidenceString = trial_EvidenceIntToString(EvidenceType)
		local Offer
		if(EvidenceValue < 3) then
			Offer = "@B[1, @L_LAWSUIT_5_DEFENSE_A_SCREENPLAYER_ACCUSER_+1]"..  -- Money
					"@B[2, @L_LAWSUIT_5_DEFENSE_A_SCREENPLAYER_ACCUSER_+2]"..  -- Pillory
					"@B[0, @L_TRIAL_START_QUESTION_TO_JUDGE_+2]"			   -- Process
		elseif(EvidenceValue < 6 and GetNobilityTitle("accused") > 1) then
			Offer =	"@B[3, @L_LAWSUIT_5_DEFENSE_A_SCREENPLAYER_ACCUSER_+3]"..  -- Much money
					"@B[4, @L_LAWSUIT_5_DEFENSE_A_SCREENPLAYER_ACCUSER_+4]"..  -- Title
					"@B[0, @L_TRIAL_START_QUESTION_TO_JUDGE_+2]"			   -- Process
		elseif(EvidenceValue < 6) then
			Offer =	"@B[3, @L_LAWSUIT_5_DEFENSE_A_SCREENPLAYER_ACCUSER_+3]"..  -- Much money
					"@B[5, @L_LAWSUIT_5_DEFENSE_A_SCREENPLAYER_ACCUSER_+5]"..  -- Prison
					"@B[0, @L_TRIAL_START_QUESTION_TO_JUDGE_+2]"			   -- Process		
		else
			Offer = "@B[5, @L_LAWSUIT_5_DEFENSE_A_SCREENPLAYER_ACCUSER_+5]"..  -- Prison
					"@B[0, @L_TRIAL_START_QUESTION_TO_JUDGE_+2]"			   -- Process
		end

		SurrenderOffer = MsgNews("judge","accused",
			Offer,
			trial_AiGetJudgeOffer,
			"politics",
			2,
			"@L_TRIAL_START_QUESTION_TO_JUDGE_+1",
			"@L_TRIAL_START_QUESTION_TO_JUDGE_+0",
			GetID("judge"),
			GetID("accuser"),
			GetID("accused"),
			NumEvidences,
			VictimID,
			EvidenceString
			)
				
		SetData("surrenderoffer", SurrenderOffer)

		local PenaltyString
		if SurrenderOffer ~= "C" and SurrenderOffer ~= 0 then
			if SurrenderOffer == 1 then
				PenaltyType = PENALTY_MONEY
				PenaltyValue = SimGetWealth("accused")/20
				if PenaltyValue <= 0 then
					PenaltyValue = 250
				end
				CreditMoney("settlement",PenaltyValue,"CostAdministration")
			elseif SurrenderOffer == 2 then
				PenaltyType = PENALTY_PILLORY
				PenaltyValue = 8
			elseif SurrenderOffer == 3 then
				PenaltyType = PENALTY_MONEY
				PenaltyValue = SimGetWealth("accused")/5
				if PenaltyValue <= 0 then
					PenaltyValue = 1500
				end
				CreditMoney("settlement",PenaltyValue,"CostAdministration")
			elseif SurrenderOffer == 4 then
				PenaltyType = PENALTY_TITLE
				PenaltyValue = 1
			elseif SurrenderOffer == 5 then
				PenaltyType = PENALTY_PRISON
				PenaltyValue = 18
			end
			
			SurrenderAnswer = MsgNews("accused","judge",
			"@B[1, @L_TRIAL_OFFER_TO_ACCUSED_+1]".. -- accept
			"@B[0, @L_TRIAL_OFFER_TO_ACCUSED_+2]",  -- don't accept
			trial_AiGetAccusedAnswer,
			"politics",
			2,
			"@L_TRIAL_OFFER_TO_ACCUSED_+3",
			"@L_TRIAL_OFFER_TO_ACCUSED_+0",
			GetID("accused"),
			GetID("judge"),
			EvidenceString,
			"@L_LAWSUIT_5_DEFENSE_A_SCREENPLAYER_ACCUSER_+"..SurrenderOffer)
				
			feedback_MessagePolitics("judge","@L_TRIAL_OFFER_ANSWER_HEADER_+"..SurrenderAnswer, "@L_TRIAL_OFFER_ANSWER_+"..SurrenderAnswer, GetID("judge"), GetID("accused"))
			-- SetData("PenaltyValue", PenaltyValue)
			-- SetData("PenaltyType", PenaltyType)
		end
	end
			
	if SurrenderOffer == "C" or SurrenderOffer == 0 or SurrenderAnswer == "C" or SurrenderAnswer == 0 then
		CityScheduleCutsceneEvent("settlement","trial_date","","EverybodySitDown",9,8,"@L_LAWSUIT_DIARY_CITY_+0",GetID("accuser"),GetID("accused"))	-- hourofday=9,mintimeinfuture=8
		--LogMessage("EventGetTime = "..SettlementEventGetTime("trial_date")) This was used to find the event time code
		if GetID("judge")>0 then
			SimAddDate("judge","courtbuilding","Court Hearing", EventTime-2,"AttendTrialMeeting")
			SimAddDatebookEntry("judge",EventTime,"courtbuilding","@L_NEWSTUFF_TRIAL_DATEBOOK_HEADER","@L_LAWSUIT_2_MESSAGES_2B_TIMEPLANNERENTRY_RICHTER",
				GetID("accuser"),GetID("accused"),GetID("settlement"))
		end
		
		if GetID("accuser")>0 then
			SimAddDate("accuser","courtbuilding","Court Hearing", EventTime-2,"AttendTrialMeeting")
			SimAddDatebookEntry("accuser",EventTime,"courtbuilding","@L_NEWSTUFF_TRIAL_DATEBOOK_HEADER","@L_LAWSUIT_2_MESSAGES_2B_TIMEPLANNERENTRY_KLAEGER",
				GetID("accused"),GetID("settlement"))
		end
		
		if GetID("accused")>0 then
			SimAddDate("accused","courtbuilding","Court Hearing", EventTime-2,"AttendTrialMeeting")
			SimAddDatebookEntry("accused",EventTime,"courtbuilding","@L_NEWSTUFF_TRIAL_DATEBOOK_HEADER","@L_LAWSUIT_2_MESSAGES_2B_TIMEPLANNERENTRY_ANGEKLAGTER",
				GetID("accuser"),GetID("settlement"))
		end
			
		--local assessor1 = GetData("assessor1")	
		--local assessor2 = GetData("assessor2")	

		if (GetID("assessor1")~=-1) then
			SimAddDate("assessor1","courtbuilding","Court Hearing", EventTime-2,"AttendTrialMeeting")
			feedback_MessagePolitics("assessor1",
				"@L_LAWSUIT_2_MESSAGES_2A_SEND_BEISITZER_+0",
				"@L_LAWSUIT_2_MESSAGES_2A_SEND_BEISITZER_+1",
				GetID("assessor1"),GetID("accuser"),GetID("accused"),SettlementEventGetTime("trial_date"),SettlementEventGetTime("trial_date"),GetID("settlement"))
			SimAddDatebookEntry("assessor1",EventTime,"courtbuilding","@L_NEWSTUFF_TRIAL_DATEBOOK_HEADER","@L_LAWSUIT_2_MESSAGES_2B_TIMEPLANNERENTRY_BEISITZER",
				GetID("accuser"),GetID("accused"),GetID("settlement"))
		end
				
		if (GetID("assessor2")~=-1) then
			SimAddDate("assessor2","courtbuilding","Court Hearing", EventTime-2,"AttendTrialMeeting")
			feedback_MessagePolitics("assessor2",
				"@L_LAWSUIT_2_MESSAGES_2A_SEND_BEISITZER_+0",
				"@L_LAWSUIT_2_MESSAGES_2A_SEND_BEISITZER_+1",
				GetID("assessor2"),GetID("accuser"),GetID("accused"),SettlementEventGetTime("trial_date"),SettlementEventGetTime("trial_date"),GetID("settlement"))
			SimAddDatebookEntry("assessor2",EventTime,"courtbuilding","@L_NEWSTUFF_TRIAL_DATEBOOK_HEADER","@L_LAWSUIT_2_MESSAGES_2B_TIMEPLANNERENTRY_BEISITZER",
						GetID("accuser"),GetID("accused"),GetID("settlement"))
		end	
	else
		if HasProperty("settlement","TrialBooked") then
			RemoveProperty("settlement","TrialBooked")
		end
		feedback_MessagePolitics("accuser",
			"@L_TRIAL_CANCELED_+0",
			"@L_TRIAL_CANCELED_TO_ACCUSOR_+0",
			GetID("accuser"),GetID("accused"),"@L_LAWSUIT_5_DEFENSE_A_SCREENPLAYER_ACCUSER_+"..SurrenderOffer)
			
		CityAddPenalty("settlement","accused",PenaltyType,PenaltyValue)
		local Courthouse = GetID("courtbuilding")
		local LocalAlias = GetID("")
		LogMessage("courtbuilding = "..Courthouse.." LocalAlias = "..LocalAlias)
		CutsceneCollectEvidences("","accuser","accused",true)
		SetData("surrendered", 1)
		BuildingGetRoom("courtbuilding", "Judge", "judgeroom")
		RemoveProperty("judgeroom","NextCutsceneID")
		EndCutscene("")
		DestroyCutscene("")
	end
end

function AiGetJudgeOffer()
	local NumEvidences = CutsceneCollectEvidences("","accuser","accused")
	local EvidenceType		= GetData("evidence0type")
	local VictimID			= GetData("evidence0victim")
	local EvidenceStrength  = GetData("evidence0quality")
	local EvidenceValue		= GetData("evidence0value") 
	local EventTime         = 1980 --SettlementEventGetTime("trial_date")
	local SurrenderOffer = 0
	
	if NumEvidences == nil then
		return 0
	end
	if EvidenceValue == nil then
		return 0
	end
	if EvidenceStrength == nil then
		return 0
	end
	
	if EvidenceValue > 7 then
		return 0
	end
	
	local Value = EvidenceValue + (Rand(2) - 1)
	if EvidenceStrength < 51 and Value > 1 then
		Value = Value - 1
	elseif EvidenceStrength > 75 then
		Value = Value + 1
	end
	
	if NumEvidences > 6 then
		Value = Value + 1
	end
	
	local DipStateAccused = DynastyGetDiplomacyState("judge","accused")
	if (DipStateAccused == DIP_FOE) then
		Value = Value + 1
	elseif (DipStateAccused == DIP_ALLIANCE) and Value > 1 then
		Value = Value - 1
	end
	
	local DipStateAccuser = DynastyGetDiplomacyState("judge","accuser")
	if DipStateAccuser == DIP_ALLIANCE then
		if DipStateAccused ~= DIP_ALLIANCE and Rand(2) > 1 then
			Value = 0
		else 
			Value = Value + 1
		end
	end
	
	if Value > 5 then
		Value = 5
	elseif Value < 0 then
		Value = 0
	end
	
	return Value
end

function AiGetAccusedAnswer()
	local SurrenderOffer = GetData("surrenderoffer")
	local NumEvidences = 0+CutsceneCollectEvidences("","accuser","accused")
	local EvidenceValue	= GetData("evidence0value")

	local Descriptor = EvidenceValue - Rand(1)
	if NumEvidences > 5 then
		Descriptor = Descriptor + 1
	end
	
	if SurrenderOffer > Descriptor then
		return 0
	else
		return 1
	end
end

function SetBuildingInfo()
	BuildingGetRoom("courtbuilding", "Judge", "judgeroom")
	SetProperty("judgeroom","NextCutsceneID",GetID(""))
end

-- Beisitzer erzeugen / Auf die Plätze
function EverybodySitDown()
		RoomLockForCutscene("judgeroom","") 
		BuildingLockForCutscene("courtbuilding","")
		
		if IsMultiplayerGame() then 
			if CameraIndoorGetBuilding("IndoorBuilding") ~= nil then
				if GetID("IndoorBuilding") == GetID("courtbuilding") then
					ExitBuildingWithCamera()  
				end
			end
			MsgBoxNoWait("All", nil, "@L_OOS_PREVENTION_HEAD_+0", "@L_OOS_PREVENTION_BODY_+0")
		end
		BuildingGetRoom("courtbuilding", "Judge", "judgeroom")
		
		local visitor_cnt = ListSize("visitor_list")
		for i=0,visitor_cnt-1 do
			ListGetElement("visitor_list",i,"visitor")
			if HasProperty("visitor","BUILDING_NPC")==false then
				trial_LeaveBuilding("visitor")
			end
		end
		ListClear("visitor_list")			

		-- check if assessor1 is present
		GetInsideRoom("assessor1","Room")
		if (GetID("assessor1")==-1) or (GetID("Room")~=GetID("judgeroom")) then  
			if AliasExists("assessor1") and GetID("assessor1")>0 then
				CityAddPenalty("settlement","assessor1",PENALTY_MONEY,1000)
				CreditMoney("settlement",1000,"CostAdministration")
				feedback_MessagePolitics("assessor1","@L_LAWSUIT_3_INTRO_PERSON_NOT_PRESENT_RICHTER_MESSAGES_+0",
						"@L_LAWSUIT_3_INTRO_PERSON_NOT_PRESENT_RICHTER_MESSAGES_+1",GetID("assessor1"),1000) 
			end
			BuildingFindSimByProperty("courtbuilding","BUILDING_NPC", 2,"assessor1")
		end

		-- check if assessor1 is present
		GetInsideRoom("assessor2","Room")
		if (GetID("assessor2")==-1) or (GetID("Room")~=GetID("judgeroom")) then
			if AliasExists("assessor2") and GetID("assessor2")>0 then
				CityAddPenalty("settlement","assessor2",PENALTY_MONEY,1000)
				CreditMoney("settlement",1000,"CostAdministration")
				feedback_MessagePolitics("assessor2","@L_LAWSUIT_3_INTRO_PERSON_NOT_PRESENT_RICHTER_MESSAGES_+0",
						"@L_LAWSUIT_3_INTRO_PERSON_NOT_PRESENT_RICHTER_MESSAGES_+1",GetID("assessor2"),1000) 
			end
			BuildingFindSimByProperty("courtbuilding","BUILDING_NPC", 3,"assessor2")
		end

	-- This message lets a player know that a trial begins. It was only supposed to be called if the sim was not present however it used OoS code to accomplish this. its not a big deal so I set it up so that the player receives it regardless of whether they showed up or not but in a way that it will only be shown once no matter how many of the players characters are involved!!
		if DynastyIsPlayer("accuser") then
			feedback_MessagePolitics("accuser","@L_LAWSUIT_2_MESSAGES_2C_REMEMBER_+1",
				"@L_LAWSUIT_2_MESSAGES_2C_REMEMBER_+2",GetID("settlement")) 
		elseif DynastyIsPlayer("accused") then 
			feedback_MessagePolitics("accused","@L_LAWSUIT_2_MESSAGES_2C_REMEMBER_+1",
				"@L_LAWSUIT_2_MESSAGES_2C_REMEMBER_+2",GetID("settlement")) 
		elseif DynastyIsPlayer("judge") then 
			feedback_MessagePolitics("judge","@L_LAWSUIT_2_MESSAGES_2C_REMEMBER_+1",
				"@L_LAWSUIT_2_MESSAGES_2C_REMEMBER_+2",GetID("settlement")) 
			
		elseif DynastyIsPlayer("assessor1") then 
			feedback_MessagePolitics("assessor1","@L_LAWSUIT_2_MESSAGES_2C_REMEMBER_+1",
				"@L_LAWSUIT_2_MESSAGES_2C_REMEMBER_+2",GetID("settlement")) 
		elseif DynastyIsPlayer("assessor2") then
			feedback_MessagePolitics("assessor2","@L_LAWSUIT_2_MESSAGES_2C_REMEMBER_+1",
				"@L_LAWSUIT_2_MESSAGES_2C_REMEMBER_+2",GetID("settlement")) 
		end
		
	-- find the townhall executioner
		local execfound = false
		if BuildingFindSimByProperty("courtbuilding","BUILDING_NPC",4, "executioner") then
			execfound = true
		end

		trial_BeamIfNPCNotInside("assessor2","LeftAssessorChairPos")
		trial_BeamIfNPCNotInside("assessor1","RightAssessorChairPos")
		trial_BeamIfNPCNotInside("judge",	 "JudgeChairPos")
		trial_BeamIfNPCNotInside("accuser","AccuserStandPos")
		trial_BeamIfNPCNotInside("accused","AccusedStandPos")

	-- Gebäude und darinstehende Sims locken
		trial_StopAllMeasures()
		RoomLockForCutscene("judgeroom","") 
		-- PATCH TODO
		-- judge and assessors cannot start measure, but can receive them
		if SimIsInside("judge") then
			SetStateImpact("no_hire")
			SetStateImpact("no_control")
			SetStateImpact("no_measure_start")
			SetStateImpact("no_attackable")
			SetStateImpact("no_action")
			ForbidMeasure("judge","StartDialog",EN_BOTH)
		end
		if SimIsInside("assessor1") then
			SetStateImpact("no_hire")
			SetStateImpact("no_control")
			SetStateImpact("no_measure_start")
			SetStateImpact("no_attackable")
			SetStateImpact("no_action")
			ForbidMeasure("assessor1","MultiplayerSay",EN_BOTH)
		end
		if SimIsInside("assessor2") then
			SetStateImpact("no_hire")
			SetStateImpact("no_control")
			SetStateImpact("no_measure_start")
			SetStateImpact("no_attackable")
			SetStateImpact("no_action")
			ForbidMeasure("assessor2","MultiplayerSay",EN_BOTH)
		end				
		-- accuser and accused can use measures
		if SimIsInside("accuser") then
			SetStateImpact("no_hire")
			SetStateImpact("no_control")
			SetStateImpact("no_attackable")
			SetStateImpact("no_action")
			ForbidMeasure("accuser","MultiplayerSay",EN_BOTH)
		end
		
		if SimIsInside("accused") then
			SetStateImpact("no_hire")
			SetStateImpact("no_control")
			SetStateImpact("no_attackable")
			SetStateImpact("no_action")
			ForbidMeasure("accused","MultiplayerSay",EN_BOTH)
		end
		
		

	-- Besucher liste erstellen
		RoomGetInsideSimList("judgeroom","visitor_list")
		ListRemove("visitor_list","judge")
		ListRemove("visitor_list","accuser")
		ListRemove("visitor_list","accused")
		ListRemove("visitor_list","assessor1")
		ListRemove("visitor_list","assessor2")
		if execfound then
			ListRemove("visitor_list","executioner")
		end
		BuildingFindSimByProperty("courtbuilding","BUILDING_NPC", 1,"usher")
		if GetID("usher")~=-1 then
			ListRemove("visitor_list","usher")
		end

	-- Add Main Characters to Cutscene
		--if trial_SimIsPresent("judge")==1 then
		--	CutsceneAddSim("","judge")
		--end
		--if trial_SimIsPresent("accuser")==1 then
			--CutsceneAddSim("","accuser")
		--end			
		--if trial_SimIsPresent("accused")==1 then
			--CutsceneAddSim("","accused")
		--end
		--if trial_SimIsPresent("assessor1")==1 then
			--CutsceneAddSim("","assessor1")
		--end
		--if trial_SimIsPresent("assessor2")==1 then
		--		CutsceneAddSim("","assessor2")
		--	end
		--	if trial_SimIsPresent("executioner")==1 then
		--		CutsceneAddSim("","executioner")
		--		end

	-- sit down
		local wait_cnt = 0
		wait_cnt = wait_cnt + trial_SitAt("assessor2","LeftAssessorChairPos")
		wait_cnt = wait_cnt + trial_SitAt("assessor1","RightAssessorChairPos")
		wait_cnt = wait_cnt + trial_SitAt("judge", "JudgeChairPos")
		wait_cnt = wait_cnt + trial_StandAt("accuser","AccuserStandPos")
		wait_cnt = wait_cnt + trial_StandAt("accused","AccusedStandPos")
		if execfound then
			wait_cnt = wait_cnt + trial_StandAt("executioner","ExecutionerTrialPos")
		end

		local visitor_cnt = ListSize("visitor_list")
		
		-- PATCH TODO
		-- prevents cutscene from freezing
		if (visitor_cnt == nil) then
			visitor_cnt = ListSize("visitor_list")
		end
		local visitors = visitor_cnt - 1	
		
		--PATCH TODO
		for i=0,visitors do
			ListGetElement("visitor_list",i,"visitor")
			if HasProperty("visitor","BUILDING_NPC")==false then
				wait_cnt = wait_cnt + trial_LeaveBuilding("visitor")
			end
		end
		ListClear("visitor_list")		

	-- set next event
		CutsceneAddTriggerEvent("","Go", "Reached", wait_cnt,160)
end

function ProduceEvidence(EvidenceType,VictimID,EvidenceStrength,EvidenceValue,GenderType,accused,EvidenceTime)
	--anklaeger
	trial_Cam("TrialMainCam")
	AlignTo("accuser","accused")
	AlignTo("accused","accuser")


	trial_Cam("Accuserback")
	CutsceneCameraBlend("",10,2)
	trial_Cam("TrailCenter")

	PlayAnimationNoWait("accuser", "point_at")
	PlayAnimationNoWait("accused", "shake_head")
	if EvidenceType==1	then
		-- 1: Sabotage
		MsgSay("accuser","@L_LAWSUIT_4_ACCUSAL_C_CHARGES_SABOTAGE"..GenderType,GetID("accused"),VictimID,EvidenceTime)
	elseif EvidenceType==4 then
		-- 4: bribery
		MsgSay("accuser","@L_LAWSUIT_4_ACCUSAL_C_CHARGES_BRIBERY"..GenderType,GetID("accused"),VictimID,EvidenceTime)
	elseif EvidenceType==6 then
		-- 6: blackmail
		MsgSay("accuser","@L_LAWSUIT_4_ACCUSAL_C_CHARGES_BLACKMAIL"..GenderType,GetID("accused"),VictimID,EvidenceTime)
	elseif EvidenceType==7 then
		-- 7: slugging
		MsgSay("accuser","@L_LAWSUIT_4_ACCUSAL_C_CHARGES_SLUGGING"..GenderType,GetID("accused"),VictimID,EvidenceTime)
	elseif EvidenceType==10 then
		-- 10: calumny
		MsgSay("accuser","@L_LAWSUIT_4_ACCUSAL_C_CHARGES_CALUMNY"..GenderType,GetID("accused"),VictimID,EvidenceTime)
	elseif EvidenceType==11 then
		-- 11: poison
		MsgSay("accuser","@L_LAWSUIT_4_ACCUSAL_C_CHARGES_POISON"..GenderType,GetID("accused"),VictimID,EvidenceTime)
	elseif EvidenceType==12 then
		-- 12: raiding
		MsgSay("accuser","@L_LAWSUIT_4_ACCUSAL_C_CHARGES_RAIDING"..GenderType,GetID("accused"),VictimID,EvidenceTime)
	elseif EvidenceType==13 then
		-- 13: revolt
		MsgSay("accuser","@L_LAWSUIT_4_ACCUSAL_C_CHARGES_REVOLT"..GenderType,GetID("accused"),VictimID,EvidenceTime)
	elseif EvidenceType==14 then
		-- 14: marauding
		MsgSay("accuser","@L_LAWSUIT_4_ACCUSAL_C_CHARGES_MARAUDING"..GenderType,GetID("accused"),VictimID,EvidenceTime)
	elseif EvidenceType==15 then
		-- 15: abduction
		MsgSay("accuser","@L_LAWSUIT_4_ACCUSAL_C_CHARGES_ABDUCTION"..GenderType,GetID("accused"),VictimID,EvidenceTime)
	elseif EvidenceType==16 then
		-- 16: murder
		MsgSay("accuser","@L_LAWSUIT_4_ACCUSAL_C_CHARGES_MURDER"..GenderType,GetID("accused"),VictimID,EvidenceTime)
	elseif EvidenceType==17 then
		-- 17: collected evidence
		MsgSay("accuser","@L_LAWSUIT_4_ACCUSAL_C_CHARGES_SHARED"..GenderType,GetID("accused"),VictimID,EvidenceTime)
	elseif EvidenceType==18 then
		-- 18: Attack civilian
		MsgSay("accuser","@L_LAWSUIT_4_ACCUSAL_C_CHARGES_SLUGGING"..GenderType,GetID("accused"),VictimID,EvidenceTime)
	elseif EvidenceType==19 then
		-- 19 : attack cart
		MsgSay("accuser","@L_NEWSTUFF_CARTATTACK"..GenderType,GetID("accused"),VictimID,EvidenceTime)
	elseif EvidenceType==20 then
		-- 20 : theft
		MsgSay("accuser","@L_LAWSUIT_4_ACCUSAL_C_CHARGES_THEFT"..GenderType,GetID("accused"),VictimID,EvidenceTime)
	else
		-- DEBUG: invalid case
		MsgSay("accuser","@L_LAWSUIT_4_ACCUSAL_C_CHARGES_INVALID")
	end

	AlignTo("accuser","judge")
	AlignTo("accused","judge")

	local QualityType

--###########################[More Important Skills]###########################
	local AccuserAtt = (GetSkillValue("accuser",RHETORIC))
	local AccusedAtt = (GetSkillValue("accused",RHETORIC))
	local AccuserDef = (GetSkillValue("accuser",EMPATHY))
	local AccusedDef = (GetSkillValue("accused",EMPATHY))
	if AccuserAtt > AccusedDef then
		EvidenceStrength = EvidenceStrength + 15
	end

	if AccusedAtt > AccuserDef then
		EvidenceStrength = EvidenceStrength - 15
	end	

--#############################[Modify EvidenceStrength]#######################
	local x = (EvidenceValue*EvidenceStrength/100)*-1
	if EvidenceStrength<51 then
		QualityType = "_25QUALITY"
		trial_ModifyTotalEvidenceValue(x)
	elseif EvidenceStrength<76 then
		QualityType = "_50QUALITY"
		trial_ModifyTotalEvidenceValue(x)
	elseif EvidenceStrength<100 then
		QualityType = "_75QUALITY"
		trial_ModifyTotalEvidenceValue(x)
	else
		QualityType = "_100QUALITY"
	end
	CutsceneCameraBlend("",0.01,0)
	trial_Cam("TrialMainCam")
	trial_RandomVisitorComment("@L_LAWSUIT_4_ACCUSAL_F_AUDIENCE_STANDARD")
	trial_Cam("JudgeFromBelowCam")

	trial_ModifyTotalEvidenceValue(EvidenceValue)
	trial_PlayRelevantJuryAni("judge",EvidenceStrength)
	MsgSay("judge","@L_LAWSUIT_4_ACCUSAL_D_JUDGE_COMMENTS"..QualityType)

end

function GetSubjectiveSentence(Sim)
	local TotalEV = GetData("TotalEvidenceValue")
	if TotalEV == nil or TotalEV < 0 then
		TotalEV = 0
	end	
	local Sentence = TotalEV + trial_GetFavorModifier(Sim)

	if (Sentence<0) then
		Sentence = 0
	elseif (Sentence>24) then
		Sentence = 24
	end

	return Sentence
end

function UpdatePanel()
	trial_UpdatePanelTrial(1)
end

function UpdatePanelTrial(time)
	local TotalEV = GetData("TotalEvidenceValue")
	local JudgePos = trial_GetSubjectiveSentence("judge")
	local Assessor1Pos = trial_GetSubjectiveSentence("assessor1")
	local Assessor2Pos = trial_GetSubjectiveSentence("assessor2")
	local AccuserSentence = GetData("AccuserSentence")

	if AccuserSentence==nil then
		AccuserSentence = 0
	elseif AccuserSentence>0 then
		AccuserSentence = AccuserSentence*3+1
	end

	TrialHUDSetStatus("",TotalEV,JudgePos,Assessor1Pos,Assessor2Pos,AccuserSentence,time)
end

function OnCameraEnable() 
	BuildingGetRoom("courtbuilding", "Judge", "judgeroom")
	CutsceneHUDShow("","LetterBoxPanel")
	CutsceneHUDShow("","TrialPanel")
	TrialHUDSetSims("",GetID("accuser"),GetID("accused"),GetID("judge"),GetID("assessor1"),GetID("assessor2"))
	trial_UpdatePanelTrial(0)
	
	local sim
	local SimCount = ScenarioGetObjects("cl_Sim", 99999, "SimList")
	for sim=0,SimCount-1 do
		local SimAlias = "SimList"..sim
		if DynastyIsPlayer(SimAlias) then
			GetInsideRoom(SimAlias, "PlayerRoom")
			if GetID("PlayerRoom") == GetID("judgeroom") then
				HudClearSelection()
			end
			if GetDynastyID(SimAlias)==GetDynastyID("accuser") then
				GetInsideRoom("accuser", "Room")
				if GetID("Room")==GetID("judgeroom") then
					HudAddToSelection("accuser")
				end
			end
			if GetDynastyID(SimAlias)==GetDynastyID("accused") then
				GetInsideRoom("accused", "Room")
				if GetID("Room")==GetID("judgeroom") then
					HudAddToSelection("accused")
				end
			end
		end
	end
end

function OnCameraDisable()
	CutsceneHUDShow("","TrialPanel",false)
	CutsceneHUDShow("","LetterBoxPanel",false)
	HudCancelUserSelection()
	HudClearSelection()
	HudAddToSelection("courtbuilding") 
end

function GetFavorModifier(Sim)
	local v = (GetFavorToSim(Sim,"accuser") - GetFavorToSim(Sim,"accused"))/10
	v = math.floor(v)
	if (v<-5) then
		v = -5
	end
	if (v>5) then
		v = 5
	end
	return v
end

-- Eröffnung, Beweisaufnahme
function Go()
	BuildingGetRoom("courtbuilding", "Judge", "judgeroom")
	
	-- Cutscenes can only be attached to the _main_ room of a building or to a position (or a simobject) - NOT to a room!
	GetLocatorByName("courtbuilding", "TableChair0", "CameraCreatePos")
	CutsceneCameraCreate("","CameraCreatePos") 
	trial_Cam("TrialMainCam")

	if DynastyIsPlayer("accused") then 
		gameplayformulas_StartHighPriorMusic(MUSIC_NEGATIVE_EVENT)
	end
	
	SetData("TotalEvidenceValue",0)
	SetData("AccuserSentence",-1) 



	if trial_SimIsPresent("judge")==1 then
		local time = PlayAnimationNoWait("judge", "sit_judge_hammer")
		Sleep(1.5)
		CarryObject("judge","Handheld_Device/Anim_judge_hammer.nif",false)
		Sleep(0.6)
		for i=0,12 do
			PlaySound3DVariation("judge","Locations/hammer")
			Sleep(0.3)
		end
		Sleep(time - 7)
		CarryObject("judge","",false)
		Sleep(1)
		PlayAnimationNoWait("judge", "talk_sit_short")
		MsgSay("judge","@L_LAWSUIT_3_INTRO_START")
	else
		MsgSay("assessor1","@L_LAWSUIT_3_INTRO_START")
	end
	--the fine, judge has to pay when he forgets the court
	local fine = 1000 + GetMoney("judge")/25
	local lNumCrimes = CutsceneCollectEvidences("","accuser","accused")
	local RawPenalty = 0
	for iC = 0,lNumCrimes-1 do
		RawPenalty = RawPenalty + GetData("evidence"..iC.."value")
	end
	local FugitiveYears = math.floor(RawPenalty/6 + 1)
	if FugitiveYears > 6 then 
		FugitiveYears = 6
	end

	local Options = FindNode("\\Settings\\Options")
	local YearsPerRound = Options:GetValueInt("YearsPerRound")
	local FugitiveHours = FugitiveYears * 24 / YearsPerRound

	--judge is dead
	if trial_SimIsPresent("judge")==2 then
		MsgSay("assessor1","@L_LAWSUIT_3_INTRO_PERSON_NOT_PRESENT_DEAD_JUDGE_+0")
		feedback_MessagePolitics("accuser","@L_LAWSUIT_3_INTRO_PERSON_NOT_PRESENT_DEAD_JUDGE_MSG_HEAD",
							"@L_LAWSUIT_3_INTRO_PERSON_NOT_PRESENT_DEAD_JUDGE_MSG_BODY")
		feedback_MessagePolitics("accused","@L_LAWSUIT_3_INTRO_PERSON_NOT_PRESENT_DEAD_JUDGE_MSG_HEAD",
							"@L_LAWSUIT_3_INTRO_PERSON_NOT_PRESENT_DEAD_JUDGE_MSG_BODY")
		feedback_MessagePolitics("assessor1","@L_LAWSUIT_3_INTRO_PERSON_NOT_PRESENT_DEAD_JUDGE_MSG_HEAD",
							"@L_LAWSUIT_3_INTRO_PERSON_NOT_PRESENT_DEAD_JUDGE_MSG_BODY")
		feedback_MessagePolitics("assessor2","@L_LAWSUIT_3_INTRO_PERSON_NOT_PRESENT_DEAD_JUDGE_MSG_HEAD",
							"@L_LAWSUIT_3_INTRO_PERSON_NOT_PRESENT_DEAD_JUDGE_MSG_BODY")
		if GetImpactValue("accused","IsCharged")==1 then
		    RemoveImpact("accused","IsCharged")
		end
		if GetImpactValue("accuser","HasCharged")==1 then
			RemoveImpact("accuser","HasCharged")
		end	
		EndCutscene("")
	end

	--accuser is dead
	if trial_SimIsPresent("accuser")==2 then
		PlayAnimationNoWait("judge", "sit_talk")
		MsgSay("judge","@L_LAWSUIT_3_INTRO_PERSON_NOT_PRESENT_DEAD_ACCUSER_+0")
		feedback_MessagePolitics("judge","@L_LAWSUIT_3_INTRO_PERSON_NOT_PRESENT_DEAD_ACCUSER_MSG_HEAD",
							"@L_LAWSUIT_3_INTRO_PERSON_NOT_PRESENT_DEAD_ACCUSER_MSG_BODY")
		feedback_MessagePolitics("accused","@L_LAWSUIT_3_INTRO_PERSON_NOT_PRESENT_DEAD_ACCUSER_MSG_HEAD",
							"@L_LAWSUIT_3_INTRO_PERSON_NOT_PRESENT_DEAD_ACCUSER_MSG_BODY")
		feedback_MessagePolitics("assessor1","@L_LAWSUIT_3_INTRO_PERSON_NOT_PRESENT_DEAD_ACCUSER_MSG_HEAD",
							"@L_LAWSUIT_3_INTRO_PERSON_NOT_PRESENT_DEAD_ACCUSER_MSG_BODY")
		feedback_MessagePolitics("assessor2","@L_LAWSUIT_3_INTRO_PERSON_NOT_PRESENT_DEAD_ACCUSER_MSG_HEAD",
							"@L_LAWSUIT_3_INTRO_PERSON_NOT_PRESENT_DEAD_ACCUSER_MSG_BODY")
		if GetImpactValue("accused","IsCharged")==1 then
		    RemoveImpact("accused","IsCharged")
		end
        EndCutscene("")
	end

	--accused dead
	if trial_SimIsPresent("accused")==2 then
		PlayAnimationNoWait("judge", "sit_talk")
		MsgSay("judge","@L_LAWSUIT_3_INTRO_PERSON_NOT_PRESENT_DEAD_ACCUSED_+0")
		feedback_MessagePolitics("judge","@L_LAWSUIT_3_INTRO_PERSON_NOT_PRESENT_DEAD_ACCUSED_MSG_HEAD",
							"@L_LAWSUIT_3_INTRO_PERSON_NOT_PRESENT_DEAD_ACCUSED_MSG_BODY")
		feedback_MessagePolitics("accuser","@L_LAWSUIT_3_INTRO_PERSON_NOT_PRESENT_DEAD_ACCUSED_MSG_HEAD",
							"@L_LAWSUIT_3_INTRO_PERSON_NOT_PRESENT_DEAD_ACCUSED_MSG_BODY")
		feedback_MessagePolitics("assessor1","@L_LAWSUIT_3_INTRO_PERSON_NOT_PRESENT_DEAD_ACCUSED_MSG_HEAD",
							"@L_LAWSUIT_3_INTRO_PERSON_NOT_PRESENT_DEAD_ACCUSED_MSG_BODY")
		feedback_MessagePolitics("assessor2","@L_LAWSUIT_3_INTRO_PERSON_NOT_PRESENT_DEAD_ACCUSED_MSG_HEAD",
							"@L_LAWSUIT_3_INTRO_PERSON_NOT_PRESENT_DEAD_ACCUSED_MSG_BODY")
		if GetImpactValue("accuser","HasCharged")==1 then
			RemoveImpact("accuser","HasCharged")
		end	
		EndCutscene("")
	end
	
	--judge is lost and jailed somewhere or knocked unconscious by the accused's henchmen
	if trial_SimIsPresent("judge")==0 and GetState("judge",STATE_HIJACKED) or GetState("judge",STATE_UNCONSCIOUS) then
		MsgSay("assessor1","@L_LAWSUIT_3_INTRO_PERSON_NOT_PRESENT_ENTFUEHRT_RICHTER")
		feedback_MessagePolitics("judge","@L_LAWSUIT_3_INTRO_PERSON_NOT_PRESENT_ENTFUEHRT_RICHTER_MESSAGES_+0",
						"@L_LAWSUIT_3_INTRO_PERSON_NOT_PRESENT_ENTFUEHRT_RICHTER_MESSAGES_+1",GetID("judge"))
		feedback_MessagePolitics("accuser","@L_LAWSUIT_3_INTRO_PERSON_NOT_PRESENT_ENTFUEHRT_RICHTER_MESSAGES_+2",
						"@L_LAWSUIT_3_INTRO_PERSON_NOT_PRESENT_ENTFUEHRT_RICHTER_MESSAGES_+3",GetID("accuser"))
		feedback_MessagePolitics("accused","@L_LAWSUIT_3_INTRO_PERSON_NOT_PRESENT_ENTFUEHRT_RICHTER_MESSAGES_+2",
						"@L_LAWSUIT_3_INTRO_PERSON_NOT_PRESENT_ENTFUEHRT_RICHTER_MESSAGES_+3",GetID("accused"))
		feedback_MessagePolitics("assessor1","@L_LAWSUIT_3_INTRO_PERSON_NOT_PRESENT_ENTFUEHRT_RICHTER_MESSAGES_+2",
						"@L_LAWSUIT_3_INTRO_PERSON_NOT_PRESENT_ENTFUEHRT_RICHTER_MESSAGES_+3",GetID("assessor1"))
		feedback_MessagePolitics("assessor2","@L_LAWSUIT_3_INTRO_PERSON_NOT_PRESENT_ENTFUEHRT_RICHTER_MESSAGES_+2",
						"@L_LAWSUIT_3_INTRO_PERSON_NOT_PRESENT_ENTFUEHRT_RICHTER_MESSAGES_+3",GetID("assessor2"))
		if GetImpactValue("accused","IsCharged")==1 then
		    RemoveImpact("accused","IsCharged")
		end
		if GetImpactValue("accuser","HasCharged")==1 then
			RemoveImpact("accuser","HasCharged")
		end
		EndCutscene("")
	end

	--accused has immunity
	if GetImpactValue("accused","HaveImmunity")==1 and GetImpactValue("accused","HasRepealedImmunity") < 1 then
		feedback_MessagePolitics("accuser","@L_LAWSUIT_3_INTRO_PERSON_NOT_PRESENT_ENTFUEHRT_RICHTER_MESSAGES_+0","@L_NEWSTUFF_TRIALCANCELLED_IMMUNITY_+0",GetID("accused"))
		feedback_MessagePolitics("accused","@L_LAWSUIT_3_INTRO_PERSON_NOT_PRESENT_ENTFUEHRT_RICHTER_MESSAGES_+0","@L_NEWSTUFF_TRIALCANCELLED_IMMUNITY_+0",GetID("accused"))
		feedback_MessagePolitics("judge","@L_LAWSUIT_3_INTRO_PERSON_NOT_PRESENT_ENTFUEHRT_RICHTER_MESSAGES_+0","@L_NEWSTUFF_TRIALCANCELLED_IMMUNITY_+0",GetID("accused"))
		feedback_MessagePolitics("assessor1","@L_LAWSUIT_3_INTRO_PERSON_NOT_PRESENT_ENTFUEHRT_RICHTER_MESSAGES_+0","@L_NEWSTUFF_TRIALCANCELLED_IMMUNITY_+0",GetID("accused"))
		feedback_MessagePolitics("assessor2","@L_LAWSUIT_3_INTRO_PERSON_NOT_PRESENT_ENTFUEHRT_RICHTER_MESSAGES_+0","@L_NEWSTUFF_TRIALCANCELLED_IMMUNITY_+0",GetID("accused"))
		BuildingFindSimByProperty("courtbuilding","BUILDING_NPC", 1,"usher")
		MsgSay("usher","@L_LAWSUIT_1_INSTALL_USHER_IMMUNITY_+0",GetID("accused"))
		MsgSay("judge","@L_LAWSUIT_6_DECISION_C_JUDGEMENT_CLOSE_+0")
		if GetImpactValue("accused","IsCharged")==1 then
		    RemoveImpact("accused","IsCharged")
		end
		if GetImpactValue("accuser","HasCharged")==1 then
			RemoveImpact("accuser","HasCharged")
		end	
		EndCutscene("")
	end
	--accuser is lost and jailed somewhere or knock unconscious by the accused's henchmen
	if trial_SimIsPresent("accuser")==0 and GetState("accuser",STATE_HIJACKED) or GetState("accuser",STATE_UNCONSCIOUS) then --State pregnant is fix for dumb npcs that dont time having children properly allowing human players to get off easy
		PlayAnimationNoWait("judge", "sit_talk")
		MsgSay("judge","@L_LAWSUIT_3_INTRO_PERSON_NOT_PRESENT_ENTFUEHRT_KLAEGER")
		feedback_MessagePolitics("accuser","@L_LAWSUIT_3_INTRO_PERSON_NOT_PRESENT_ENTFUEHRT_KLAEGER_MESSAGES_+0",
						"@L_LAWSUIT_3_INTRO_PERSON_NOT_PRESENT_ENTFUEHRT_KLAEGER_MESSAGES_+1",GetID("accuser"),GetID("accused"))
		feedback_MessagePolitics("judge","@L_LAWSUIT_3_INTRO_PERSON_NOT_PRESENT_ENTFUEHRT_KLAEGER_MESSAGES_+2",
						"@L_LAWSUIT_3_INTRO_PERSON_NOT_PRESENT_ENTFUEHRT_KLAEGER_MESSAGES_+3",GetID("judge"),GetID("accuser"),GetID("accused"))
		feedback_MessagePolitics("accused","@L_LAWSUIT_3_INTRO_PERSON_NOT_PRESENT_ENTFUEHRT_KLAEGER_MESSAGES_+2",
						"@L_LAWSUIT_3_INTRO_PERSON_NOT_PRESENT_ENTFUEHRT_KLAEGER_MESSAGES_+3",GetID("accused"),GetID("accuser"),GetID("accused"))
		feedback_MessagePolitics("assessor1","@L_LAWSUIT_3_INTRO_PERSON_NOT_PRESENT_ENTFUEHRT_KLAEGER_MESSAGES_+2",
						"@L_LAWSUIT_3_INTRO_PERSON_NOT_PRESENT_ENTFUEHRT_KLAEGER_MESSAGES_+3",GetID("assessor1"),GetID("accuser"),GetID("accused"))
		feedback_MessagePolitics("assessor2","@L_LAWSUIT_3_INTRO_PERSON_NOT_PRESENT_ENTFUEHRT_KLAEGER_MESSAGES_+2",
						"@L_LAWSUIT_3_INTRO_PERSON_NOT_PRESENT_ENTFUEHRT_KLAEGER_MESSAGES_+3",GetID("assessor2"),GetID("accuser"),GetID("accused"))
		if GetImpactValue("accused","IsCharged")==1 then
		    RemoveImpact("accused","IsCharged")
		end
		if GetImpactValue("accuser","HasCharged")==1 then
			RemoveImpact("accuser","HasCharged")
		end
		EndCutscene("")
	end

	--accused is lost and jailed somewhere
	if trial_SimIsPresent("accused")==0 and GetState("accused",STATE_HIJACKED) then
		PlayAnimationNoWait("judge", "sit_talk")
		MsgSay("judge","@L_LAWSUIT_3_INTRO_PERSON_NOT_PRESENT_ENTFUEHRT_ANGEKLAGTER")
		feedback_MessagePolitics("accused","@L_LAWSUIT_3_INTRO_PERSON_NOT_PRESENT_ENTFUEHRT_ANGEKLAGTER_MESSAGES_+0",
						"@L_LAWSUIT_3_INTRO_PERSON_NOT_PRESENT_ENTFUEHRT_ANGEKLAGTER_MESSAGES_+1",GetID("accused"))
		feedback_MessagePolitics("judge","@L_LAWSUIT_3_INTRO_PERSON_NOT_PRESENT_ENTFUEHRT_ANGEKLAGTER_MESSAGES_+2",
						"@L_LAWSUIT_3_INTRO_PERSON_NOT_PRESENT_ENTFUEHRT_ANGEKLAGTER_MESSAGES_+3",GetID("accused"))
		feedback_MessagePolitics("accuser","@L_LAWSUIT_3_INTRO_PERSON_NOT_PRESENT_ENTFUEHRT_ANGEKLAGTER_MESSAGES_+2",
						"@L_LAWSUIT_3_INTRO_PERSON_NOT_PRESENT_ENTFUEHRT_ANGEKLAGTER_MESSAGES_+3",GetID("accused"))
		feedback_MessagePolitics("assessor1","@L_LAWSUIT_3_INTRO_PERSON_NOT_PRESENT_ENTFUEHRT_ANGEKLAGTER_MESSAGES_+2",
						"@L_LAWSUIT_3_INTRO_PERSON_NOT_PRESENT_ENTFUEHRT_ANGEKLAGTER_MESSAGES_+3",GetID("accused"))
		feedback_MessagePolitics("assessor2","@L_LAWSUIT_3_INTRO_PERSON_NOT_PRESENT_ENTFUEHRT_ANGEKLAGTER_MESSAGES_+2",
						"@L_LAWSUIT_3_INTRO_PERSON_NOT_PRESENT_ENTFUEHRT_ANGEKLAGTER_MESSAGES_+3",GetID("accused"))
		if GetImpactValue("accused","IsCharged")==1 then
		    RemoveImpact("accused","IsCharged")
		end
		if GetImpactValue("accuser","HasCharged")==1 then
			RemoveImpact("accuser","HasCharged")
		end
		EndCutscene("")
	end

	--judge is not in here
	if trial_SimIsPresent("judge")==0 then
		MsgSay("assessor1","@L_LAWSUIT_3_INTRO_PERSON_NOT_PRESENT_RICHTER",GetID("judge"),fine)
		feedback_MessagePolitics("judge","@L_LAWSUIT_3_INTRO_PERSON_NOT_PRESENT_RICHTER_MESSAGES_+0",
						"@L_LAWSUIT_3_INTRO_PERSON_NOT_PRESENT_RICHTER_MESSAGES_+1",GetID("judge"),fine)
		CityAddPenalty("settlement","judge",PENALTY_MONEY,2500)
		CreditMoney("settlement",2500,"CostAdministration")
		feedback_MessagePolitics("accuser","@L_LAWSUIT_3_INTRO_PERSON_NOT_PRESENT_RICHTER_MESSAGES_+2",
						"@L_LAWSUIT_3_INTRO_PERSON_NOT_PRESENT_RICHTER_MESSAGES_+3",GetID("judge"))
		feedback_MessagePolitics("accused","@L_LAWSUIT_3_INTRO_PERSON_NOT_PRESENT_RICHTER_MESSAGES_+2",
						"@L_LAWSUIT_3_INTRO_PERSON_NOT_PRESENT_RICHTER_MESSAGES_+3",GetID("judge"))
		feedback_MessagePolitics("assessor1","@L_LAWSUIT_3_INTRO_PERSON_NOT_PRESENT_RICHTER_MESSAGES_+2",
						"@L_LAWSUIT_3_INTRO_PERSON_NOT_PRESENT_RICHTER_MESSAGES_+3",GetID("judge"))
		feedback_MessagePolitics("assessor2","@L_LAWSUIT_3_INTRO_PERSON_NOT_PRESENT_RICHTER_MESSAGES_+2",
						"@L_LAWSUIT_3_INTRO_PERSON_NOT_PRESENT_RICHTER_MESSAGES_+3",GetID("judge"))
		if GetImpactValue("accused","IsCharged")==1 then
		    RemoveImpact("accused","IsCharged")
		end
		if GetImpactValue("accuser","HasCharged")==1 then
			RemoveImpact("accuser","HasCharged")
		end
		EndCutscene("")
	end

	--accuser is not in here
	if trial_SimIsPresent("accuser")==0 then --This is a fix for dumb npc's that allow human player to get off easy because they don't time their children right
		PlayAnimationNoWait("judge", "sit_talk")
		MsgSay("judge","@L_LAWSUIT_3_INTRO_PERSON_NOT_PRESENT_KLAEGER",GetID("accuser"),GetID("accused"))
		CutsceneCollectEvidences("","accuser","accused",true)		-- mark collected evidences as used		
		feedback_MessagePolitics("accuser","@L_LAWSUIT_3_INTRO_PERSON_NOT_PRESENT_KLAEGER_MESSAGES_+0",
						"@L_LAWSUIT_3_INTRO_PERSON_NOT_PRESENT_KLAEGER_MESSAGES_+1",GetID("accuser"),GetID("accused"))
		feedback_MessagePolitics("accused","@L_LAWSUIT_3_INTRO_PERSON_NOT_PRESENT_KLAEGER_MESSAGES_+2",
						"@L_LAWSUIT_3_INTRO_PERSON_NOT_PRESENT_KLAEGER_MESSAGES_+3",GetID("accuser"),GetID("accused"))
		feedback_MessagePolitics("judge","@L_LAWSUIT_3_INTRO_PERSON_NOT_PRESENT_KLAEGER_MESSAGES_+2",
						"@L_LAWSUIT_3_INTRO_PERSON_NOT_PRESENT_KLAEGER_MESSAGES_+3",GetID("accuser"),GetID("accused"))
		feedback_MessagePolitics("assessor1","@L_LAWSUIT_3_INTRO_PERSON_NOT_PRESENT_KLAEGER_MESSAGES_+2",
						"@L_LAWSUIT_3_INTRO_PERSON_NOT_PRESENT_KLAEGER_MESSAGES_+3",GetID("accuser"),GetID("accused"))
		feedback_MessagePolitics("assessor2","@L_LAWSUIT_3_INTRO_PERSON_NOT_PRESENT_KLAEGER_MESSAGES_+2",
						"@L_LAWSUIT_3_INTRO_PERSON_NOT_PRESENT_KLAEGER_MESSAGES_+3",GetID("accuser"),GetID("accused"))
		if GetImpactValue("accused","IsCharged")==1 then
		    RemoveImpact("accused","IsCharged")
		end
		if GetImpactValue("accuser","HasCharged")==1 then
			RemoveImpact("accuser","HasCharged")
		end	
		EndCutscene("")
	end
	--accused is not in here
	if trial_SimIsPresent("accused")==0 then
		PlayAnimationNoWait("judge", "sit_talk")
		MsgSay("judge","@L_LAWSUIT_3_INTRO_PERSON_NOT_PRESENT_ANGEKLAGTER",GetID("accused"),FugitiveYears)
		

		if (RawPenalty<16) then
			-- give the accused a chance to surrender himself or pay a fee
			CreateCutscene("queries","myquery")
			CopyAliasToCutscene("accused","myquery","Sim")
			CopyAliasToCutscene("accuser","myquery","Accuser")
			CopyAliasToCutscene("assessor1","myquery","Assessor1")
			CopyAliasToCutscene("assessor2","myquery","Assessor2")
			CopyAliasToCutscene("judge","myquery","Judge")
			CopyAliasToCutscene("settlement","myquery","settlement")
			SetData("RawPenalty",RawPenalty)
			SetData("FugitiveYears",FugitiveYears)
			CutsceneSetData("myquery","RawPenalty")
			CutsceneSetData("myquery","FugitiveYears")
			CutsceneCallScheduled("myquery","DecideFugitive")
		else 
			-- punish him
			CityAddPenalty("settlement","accused",PENALTY_FUGITIVE,FugitiveYears)
			AddImpact("accused","REVOLT",1,FugitiveYears)
			local outlawed = 1
			if HasProperty("accused", "Outlawed") then
				outlawed = outlawed + GetProperty("accused", "Outlawed")
			end
			SetProperty("accused", "Outlawed", outlawed)
			SetProperty("accused", GetName("Settlement").."Start", GetRound())
			SetProperty("accused", GetName("Settlement").."FugitiveHours", FugitiveYears)
			CreateScriptcall("Fugitive_End",FugitiveYears,"Cutscenes/Trial.lua","FugitiveExpires","accused","accused","settlement")
			feedback_MessagePolitics("accused","@L_LAWSUIT_3_INTRO_PERSON_NOT_PRESENT_ANGEKLAGTER_MESSAGES_+0",
							"@L_LAWSUIT_3_INTRO_PERSON_NOT_PRESENT_ANGEKLAGTER_MESSAGES_+1",GetID("accused"),FugitiveYears)
			feedback_MessagePolitics("accuser","@L_LAWSUIT_3_INTRO_PERSON_NOT_PRESENT_ANGEKLAGTER_MESSAGES_+2",
							"@L_LAWSUIT_3_INTRO_PERSON_NOT_PRESENT_ANGEKLAGTER_MESSAGES_+3",GetID("accused"),FugitiveYears)
			feedback_MessagePolitics("judge","@L_LAWSUIT_3_INTRO_PERSON_NOT_PRESENT_ANGEKLAGTER_MESSAGES_+2",
							"@L_LAWSUIT_3_INTRO_PERSON_NOT_PRESENT_ANGEKLAGTER_MESSAGES_+3",GetID("accused"),FugitiveYears)
			feedback_MessagePolitics("assessor1","@L_LAWSUIT_3_INTRO_PERSON_NOT_PRESENT_ANGEKLAGTER_MESSAGES_+2",
							"@L_LAWSUIT_3_INTRO_PERSON_NOT_PRESENT_ANGEKLAGTER_MESSAGES_+3",GetID("accused"),FugitiveYears)
			feedback_MessagePolitics("assessor2","@L_LAWSUIT_3_INTRO_PERSON_NOT_PRESENT_ANGEKLAGTER_MESSAGES_+2",
							"@L_LAWSUIT_3_INTRO_PERSON_NOT_PRESENT_ANGEKLAGTER_MESSAGES_+3",GetID("accused"),FugitiveYears)
		end
		SetNobilityTitle("accused", 2, true)
		GetNearestSettlement("judge","TrialCity")
		CityRemoveFromOffice("accused","TrialCity")
		if GetImpactValue("accused","IsCharged")==1 then
			RemoveImpact("accused","IsCharged")
		end
		if GetImpactValue("accuser","HasCharged")==1 then
			RemoveImpact("accuser","HasCharged")
		end	
		EndCutscene("")
	end

	--get rhetoric and gender from accuser and accused
	local AccuserRhetoric = (GetSkillValue("accuser",RHETORIC))
	local AccusedRhetoric = (GetSkillValue("accused",RHETORIC))
	local AccuserGender = (SimGetGender("accuser"))
	local AccusedGender = (SimGetGender("accused"))


	Sleep(1)

	trial_Cam("JudgeFromBelowCam")
	PlayAnimationNoWait("judge", "sit_talk")
	MsgSay("judge","@L_LAWSUIT_3_INTRO_EVERYONE_ABORD_1")
	PlayAnimationNoWait("judge", "sit_talk")
	MsgSay("judge","@L_LAWSUIT_3_INTRO_EVERYONE_ABORD_2",GetID("accuser"),GetID("accused"))
	StopAnimation("judge")

	-- MsgSay("judge", "@LTRIAL_GO@THiermit erkläre ich den Prozeß %1SN gegen %2SN für eröffnet.",GetID("accuser"),GetID("accused"))
	-- MsgSay("judge", "@LTRIAL_GO@TKläger, was habt ihr gegen %1SN vorzubringen?",GetID("accused"))

	local NumEvidences = 0+CutsceneCollectEvidences("","accuser","accused")

	--trial_Cam("TrialMainCam")

	--combine textlabel by checking rhetoric skill and gender for text
	local RhethoricType
	if AccuserRhetoric < 4 then
		RhethoricReplace = "_DUMB"
	elseif AccuserRhetoric < 7 then
		RhethoricReplace = "_AVERAGE"
	else
		RhethoricReplace = "_SMART"
	end

	local GenderType
	if AccusedGender == 0 then
		GenderType = "_TOFEMALE"
	else
		GenderType = "_TOMALE"
	end

	local AlignmentReplace
	local Alignment = SimGetAlignment("accuser")
	if Alignment < 50 then
		AlignmentReplace = "_GOOD"
	elseif Alignment < 75 then
		AlignmentReplace = "_NORMAL"
	else
		AlignmentReplace = "_EVIL"
	end

	camera_CutsceneDialogCam("","accuser",0,0)
	trial_PlayRelevantTalkAni("accuser")
	MsgSay("accuser"," @L_LAWSUIT_4_ACCUSAL_A_HELLO"..RhethoricReplace..AlignmentReplace)

	if AccuserRhetoric < 5 then
		RhethoricReplace = "_DUMB"
	else
		RhethoricReplace = "_SMART"
	end

	local EvidenceReplace
	if NumEvidences < 4 then
		EvidenceReplace = "_LOWEVIDENCE"
	else
		EvidenceReplace = "_HIGHEVIDENCE"
	end

	if NumEvidences==0 then
		trial_Cam("TrialMainCam")
		local TrialFee = 1000
		PlayAnimationNoWait("accuser", "cogitate")
		MsgSay("accuser","@L_LAWSUIT_4_ACCUSAL_NOEVIDENCE_ACCUSER")
		PlayAnimationNoWait("judge", "sit_no")
		MsgSay("judge","@L_LAWSUIT_4_ACCUSAL_NOEVIDENCE_JUDGE",TrialFee)
		PlayAnimationNoWait("judge", "sit_talk")
		MsgSay("judge","@L_LAWSUIT_6_DECISION_C_JUDGEMENT_CLOSE_+0")
		CreditMoney("accuser",-TrialFee,"CostAdministration")
		CreditMoney("settlement",TrialFee,"CostAdministration")
	else
		MsgSay("accuser"," @L_LAWSUIT_4_ACCUSAL_B_INTRO"..RhethoricReplace..EvidenceReplace..GenderType)

		local EvidenceType		= GetData("evidence0type")
		local VictimID			= GetData("evidence0victim")
		local EvidenceStrength  = GetData("evidence0quality")
		local EvidenceValue		= GetData("evidence0value")
		local EvidenceTime		= GetData("evidence0time") --???

		if GetImpactValue("accused","EvidenceSuppression")==1 then		-- Impact: Heiligenschein
			EvidenceStrength = 0
		end

		trial_ProduceEvidence(EvidenceType,VictimID,EvidenceStrength,EvidenceValue,GenderType,accused,EvidenceTime)

		if GetImpactValue("accused","EvidenceSuppression")==1 then		-- Impact: Heiligenschein
			camera_CutsceneDialogCam("","accused",0,0)
			EvidenceStrength = 0
			GetPosition("accused", "ParticleSpawnPos")
			StartSingleShotParticle("particles/absolvesinner.nif", "ParticleSpawnPos",1.4,4)
			MsgSay("accused","@L_LAWSUIT_4_ACCUSAL_G_ACCUSED_HALO")
		end

		if NumEvidences>1 then
			local QualityType
			if EvidenceStrength<34 then
				QualityType = "_LOWQUALITY"
			elseif EvidenceStrength<67 then
				QualityType = "_MEDIUMQUALITY"
			else
				QualityType = "_HIGHQUALITY"
			end

			trial_Cam("TrialMainCam")
			MsgSay("judge","@L_LAWSUIT_4_ACCUSAL_D_JUDGE_CONTINUE"..QualityType)

			EvidenceType     = GetData("evidence1type")
			VictimID	 = GetData("evidence1victim")
			EvidenceStrength = GetData("evidence1quality")
			EvidenceValue    = GetData("evidence1value")
			EvidenceTime	 = GetData("evidence1time") --???
			trial_ProduceEvidence(EvidenceType,VictimID,EvidenceStrength,EvidenceValue,GenderType,accused,EvidenceTime)

			if (NumEvidences>=3) then
				EvidenceType     = GetData("evidence2type")
				VictimID	 = GetData("evidence2victim")
				EvidenceStrength = GetData("evidence2quality")
				EvidenceValue    = GetData("evidence2value")
				EvidenceTime	 = GetData("evidence2time") --???
			end
			
			if NumEvidences==3 then
				trial_ProduceEvidence(EvidenceType,VictimID,EvidenceStrength,EvidenceValue,GenderType,accused,EvidenceTime)
			else
				local NumRest = 0+ NumEvidences - 2
				local NumReplace
				if NumRest < 3 then
					NumReplace = "_TWOEVIDENCES"
				elseif NumRest < 6 then
					NumReplace = "_SOMEEVIDENCES"
				else
					NumReplace = "_MANYEVIDENCES"
				end

				trial_Cam("TrialMainCam")
				MsgSay("accuser","@L_LAWSUIT_4_ACCUSAL_E_THEREST"..NumReplace..GenderType)

				local QualityType
				if EvidenceStrength<51 then
					QualityType = "_25QUALITY"
				elseif EvidenceStrength<76 then
					QualityType = "_50QUALITY"
				elseif EvidenceStrength<100 then
					QualityType = "_75QUALITY"
				else
					QualityType = "_100QUALITY"
				end
				trial_Cam("JudgeFromBelowCam")
				trial_PlayRelevantJuryAni("judge",EvidenceStrength)
				MsgSay("judge","@L_LAWSUIT_4_ACCUSAL_D_JUDGE_COMMENTS"..QualityType)
			end
		end
		trial_Cam("TrialMainCam")
		trial_RandomVisitorComment("@L_LAWSUIT_4_ACCUSAL_F_AUDIENCE_STANDARD")
		
		local AcusdTitle = GetNobilityTitle("accused")
		local AcusrTitle = GetNobilityTitle("accuser")
		GetDynasty("accused","accuseddynasty")
		GetDynasty("accuser","accuserdynasty")
		if GetImpactValue("accuseddynasty","BeFromNobleBlood")~=0 then
			if AcusdTitle > AcusrTitle then
				PlayAnimationNoWait("judge", "sit_yes")
				MsgSay("judge","@L_PRIVILEGES_130_BEFROMNOBLEBLOOD_LAWSUIT_JUDGE",GetID("accused"))
				if GetImpactValue("accuserdynasty","BeFromNobleBlood")~=0 then
					trial_ModifyTotalEvidenceValue(-3)
				else
					trial_ModifyTotalEvidenceValue(-5)
				end
			elseif AcusedTitle == AcusrTitle then
				PlayAnimationNoWait("judge", "sit_talk")
				MsgSay("judge","@L_LAWSUIT_5_DEFENSE_A_NOBLEFROMBLOOD_EQUALTITLE_+0",GetID("accused"),GetID("accuser"))
			else
				PlayAnimationNoWait("judge", "sit_yes")
				MsgSay("judge","@L_LAWSUIT_5_DEFENSE_A_NOBLEFROMBLOOD_GREATERTITLE_+0",GetID("accused"),GetID("accuser"))
				trial_ModifyTotalEvidenceValue(3)
			end
		elseif GetImpactValue("accuserdynasty","BeFromNobleBlood")~=0 then
			PlayAnimationNoWait("judge", "sit_yes")
			MsgSay("judge","@L_LAWSUIT_5_DEFENSE_A_NOBLEFROMBLOOD_ACCUSERTITLE_+0",GetID("accuser"),GetID("accused"))
			trial_ModifyTotalEvidenceValue(5)
		end
		
		if GetImpactValue("accuser","AimForInquisitionalProceeding")~=0 then
			trial_ModifyTotalEvidenceValue(3)
			PlayAnimationNoWait("judge", "sit_talk")
			MsgSay("judge","@L_PRIVILEGES_113_AIMFORINQUISITIONALPROCEEDING_LAWSUIT_JUDGE",GetID("accused"))
		end


		local TEV = GetData("TotalEvidenceValue")

		-- Der Richter kommentiert die angewendete Härte der Rechtssprechung und ändert den TEV entsprechend
		local SeverityOfLaw = GetProperty("settlement","SeverityOfLaw")
		local LawReplace
		if SeverityOfLaw==0 then
			LawReplace = "_LIBERAL"
			trial_ModifyTotalEvidenceValue(-5)
		elseif SeverityOfLaw==1 then
			LawReplace = "_NORMAL"
		else
			LawReplace = "_HARD"
			trial_ModifyTotalEvidenceValue(8)
		end

		PlayAnimationNoWait("judge", "sit_talk")
		MsgSay("judge","@L_LAWSUIT_5_DEFENSE_A_LAW"..LawReplace)

		-- Kläger darf Strafmaß wählen
		trial_Cam("JudgeFromBelowCam")
		PlayAnimationNoWait("judge", "talk_sit_short")
		MsgSay("judge","@L_LAWSUIT_5_DEFENSE_A_TO_ACCUSER")


		trial_Cam("TrialMainCam")
		local AccuserSentence = MsgSayInteraction("accuser","accuser",0,
			-- PanelParam
			"@B[1,@L_LAWSUIT_5_DEFENSE_A_SCREENPLAYER_ACCUSER_+1]"..
			"@B[2,@L_LAWSUIT_5_DEFENSE_A_SCREENPLAYER_ACCUSER_+2]"..
			"@B[3,@L_LAWSUIT_5_DEFENSE_A_SCREENPLAYER_ACCUSER_+3]"..
			"@B[4,@L_LAWSUIT_5_DEFENSE_A_SCREENPLAYER_ACCUSER_+4]"..
			"@B[5,@L_LAWSUIT_5_DEFENSE_A_SCREENPLAYER_ACCUSER_+5]"..
			"@B[6,@L_LAWSUIT_5_DEFENSE_A_SCREENPLAYER_ACCUSER_+6]",
			trial_AccuserDecideSentence, --AIFunc
			"@L_LAWSUIT_5_DEFENSE_A_SCREENPLAYER_ACCUSER_+0",GetID("accused")) --Message Text

		-- Berechne default-Strafmaß
		local SentenceLevel = GetData("TotalEvidenceValue") / 3
		SetData("DefaultSentence",math.floor(SentenceLevel))	-- for judge AI func
		camera_CutsceneDialogCam("","accuser",0,0)
		local SentenceAnnouncer = "accuser"
		
		if AccuserSentence=="C" then	
			trial_PlayRelevantTalkAni("accuser")
			MsgSay("accuser","@L_LAWSUIT_5_DEFENSE_A_SPEAK_ACCUSER_NOCOMMENT_+0")

			SentenceLevel = MsgSayInteraction("judge","judge",0,
			-- PanelParam
			"@B[1,@L_LAWSUIT_5_DEFENSE_A_SCREENPLAYER_ACCUSER_+1]"..
			"@B[2,@L_LAWSUIT_5_DEFENSE_A_SCREENPLAYER_ACCUSER_+2]"..
			"@B[3,@L_LAWSUIT_5_DEFENSE_A_SCREENPLAYER_ACCUSER_+3]"..
			"@B[4,@L_LAWSUIT_5_DEFENSE_A_SCREENPLAYER_ACCUSER_+4]"..
			"@B[5,@L_LAWSUIT_5_DEFENSE_A_SCREENPLAYER_ACCUSER_+5]"..
			"@B[6,@L_LAWSUIT_5_DEFENSE_A_SCREENPLAYER_ACCUSER_+6]",
			trial_JudgeDecideSentence, --AIFunc
			"@L_LAWSUIT_5_DEFENSE_A_SCREENPLAYER_ACCUSER_+0",GetID("accused")) --Message Text
			if not (SentenceLevel>=1 and SentenceLevel<=6) then
				SentenceLevel = trial_GetSubjectiveSentence("judge")/6+1
			end
		else
			SentenceLevel = AccuserSentence
		end

		if (SentenceLevel<1) then
			SentenceLevel = 1
		elseif (SentenceLevel>6) then
			SentenceLevel = 6
		end
			
		PlayAnimationNoWait(SentenceAnnouncer, "talk")
		if AccuserSentence==1 then
			MsgSay(SentenceAnnouncer,"@L_LAWSUIT_5_DEFENSE_A_SPEAK_ACCUSER_MONEY"..GenderType)
			SentenceLevel = 1
		elseif AccuserSentence==2 then
			MsgSay(SentenceAnnouncer,"@L_LAWSUIT_5_DEFENSE_A_SPEAK_ACCUSER_PILLORY"..GenderType)
			SentenceLevel = 2
		elseif AccuserSentence==3 then
			MsgSay(SentenceAnnouncer,"@L_LAWSUIT_5_DEFENSE_A_SPEAK_ACCUSER_MOREMONEY"..GenderType)
			SentenceLevel = 3
		elseif AccuserSentence==4 then
			MsgSay(SentenceAnnouncer,"@L_LAWSUIT_5_DEFENSE_A_SPEAK_ACCUSER_TITLE"..GenderType)
			SentenceLevel = 4
		elseif AccuserSentence==5 then
			MsgSay(SentenceAnnouncer,"@L_LAWSUIT_5_DEFENSE_A_SPEAK_ACCUSER_PRISON"..GenderType)
			SentenceLevel = 5
		elseif AccuserSentence==6 then
			MsgSay(SentenceAnnouncer,"@L_LAWSUIT_5_DEFENSE_A_SPEAK_ACCUSER_DEATH"..GenderType)
			SentenceLevel = 6
		end
		SetData("AccuserSentence",SentenceLevel)

		-- Angeklagter soll Stellung nehmen
		local confession = 1

		trial_UpdatePanelTrial(0)

		trial_Cam("TrialMainCam")
		PlayAnimationNoWait("judge", "talk_sit_short")
		MsgSay("judge","@L_LAWSUIT_5_DEFENSE_A_TO_DEFENDER"..GenderType,GetID("accused"))

		local AccusedStatement = MsgSayInteraction("accused","accused",0,
			"@B[1,@L_LAWSUIT_5_DEFENSE_B_DEFENDER_SCREENPLAYER_+1]"..
			"@B[2,@L_LAWSUIT_5_DEFENSE_B_DEFENDER_SCREENPLAYER_+2]"..
			"@B[3,@L_LAWSUIT_5_DEFENSE_B_DEFENDER_SCREENPLAYER_+3]",
			trial_AccusedDecideConfess,
			"@L_LAWSUIT_5_DEFENSE_B_DEFENDER_SCREENPLAYER_+0",GetID("accused"))
		local DecisionReplacement
		
		if AccusedStatement==1 then -- unschuldig
			DecisionReplacement = "_NOTGUILTY"
			confession = 0
			if GetSkillValue("accused",RHETORIC) > GetSkillValue("judge",EMPATHY) then --Bug fixed!
				trial_ModifyTotalEvidenceValue(-5) 
				PlayAnimationNoWait("judge", "nod")
			else
				trial_ModifyTotalEvidenceValue(5) 
			end
			
		elseif AccusedStatement==2 then -- nichts sagen
			DecisionReplacement = "_STAYQUIET"
			confession = 1
		elseif AccusedStatement==3 then --schuldig
			DecisionReplacement = "_GUILTY"
			trial_ModifyTotalEvidenceValue(-3)
			confession = 2
		else
			DecisionReplacement = "_STAYQUIET" -- default (?)
			confession = 1
		end
		camera_CutsceneDialogCam("","accused",0,0)
		if (confession == 0) then
			PlayAnimationNoWait("accused", "shake_head")
		elseif (confession == 1) then
			PlayAnimationNoWait("accused", "cogitate")
		elseif (confession == 2) then
			PlayAnimationNoWait("accused", "nod")
		end
		MsgSay("accused","@L_LAWSUIT_5_DEFENSE_B_DEFENDER_SPEAKS"..DecisionReplacement)

		trial_Cam("JudgeFromBelowCam")
		PlayAnimationNoWait("judge", "sit_talk_short")
		MsgSay("judge", "@L_SESSION_3_ELECT_THINKBREAK")
		trial_Cam("TrialMainCam")
		CarryObject("judge","Handheld_Device/Anim_ink_feather.nif",false)
		PlayAnimation("judge", "sit_write_in")
		LoopAnimation("judge","sit_write_loop",-1)

		--accused und accuser dürfen bestechen

		local SleepTime = 30
		local Actions = 5

		local TargetArray = {"judge","accuser","accused","assessor1","assessor2"}
		local TargetCount = 5
		local AITargetArray = {"accuser","accused"}
		local AITargetCount = 5
		
		for AISim = 1, TargetCount do
			if HasProperty(TargetArray[AISim],"BUILDING_NPC") then
				if GetState(TargetArray[AISim],STATE_TOWNNPC) then
					SetState(TargetArray[AISim],STATE_TOWNNPC,false)
					SetProperty(TargetArray[AISim],"townnpc","townnpc")
				end
			end
		end

		if trial_HumanPlayerWantsInteraction() then
			CutsceneSetTimeBar("",SleepTime)
		else
			SleepTime = 1
		end	

		trial_MeasureBar(true)

		for i=1,Actions do
			for AISim = 1, AITargetCount do
				trial_RunAIPlan(AITargetArray[AISim])
			end
			Sleep(SleepTime/Actions)
		end
		trial_MeasureBar(false)
		
		if CutsceneLocalPlayerIsWatching("") then
			HudCancelUserSelection()
		end
		
		PlayAnimation("judge", "sit_write_out")
		CarryObject("judge","",false)
		StopAnimation("judge")
		for AISim = 1, TargetCount do
			if HasProperty(TargetArray[AISim],"EX_BUILDING_NPC") then
				if HasProperty(TargetArray[AISim],"townnpc") then
					SetState(TargetArray[AISim],STATE_TOWNNPC,true)
					RemoveProperty(TargetArray[AISim],"townnpc")
				end
			end
		end		

		Sleep(0.5)
		RemoveAllObjectDependendImpacts("accuser", "")  

		trial_Cam("TrialMainCam")

		-- Urteilsfindung
		local DecisionTextLabel, AnnouncementLabel

		trial_UpdatePanelTrial(0)

		if confession==2 then
			-- "Das gericht wird jetzt entscheiden, ob das vom Kläger geforderte Strafmaß angemessen ist."
			trial_PlayRelevantJuryAni("judge",60)
			MsgSay("judge","@L_LAWSUIT_6_DECISION_A_APPROPRIATEQ_INTRO")
			DecisionTextLabel = "@L_LAWSUIT_6_DECISION_A_APPROPRIATEQ_SCREENPLAYER_"
			AnnouncementLabel = "@L_LAWSUIT_6_DECISION_A_APPROPRIATEQ_ANNOUNCEMENTS_"
		else
			trial_PlayRelevantJuryAni("judge",60)
			MsgSay("judge","@L_LAWSUIT_6_DECISION_A_GUILTYQ_INTRO")
			DecisionTextLabel = "@L_LAWSUIT_6_DECISION_A_GUILTYQ_SCREENPLAYER_"
			AnnouncementLabel = "@L_LAWSUIT_6_DECISION_A_GUILTYQ_ANNOUNCEMENTS_"
		end

		-- Entscheidungen Jury
		local conviction_cnt = 0
		--richter und beisitzer dürfen sich entscheiden, wenn sie spieler sind
		SetData("DecisionParam","judge")
		SetData("JudgeDecision",-1)
		
		local JudgeDecision = MsgSayInteraction("judge","judge",0,
			"@B[1,"..DecisionTextLabel.."+1]"..
			"@B[2,"..DecisionTextLabel.."+2]",
			trial_ConvictionDecision,
			""..DecisionTextLabel.."+0",GetID("judge"))

		if JudgeDecision == "C" then
			JudgeDecision = trial_ConvictionDecision()
		end
		if JudgeDecision == 1 then
			conviction_cnt = conviction_cnt+1
			trial_PlayRelevantJuryAni("judge",100)
			MsgSay("judge",""..AnnouncementLabel.."+0")
		else
			trial_PlayRelevantJuryAni("judge",0)
			MsgSay("judge",""..AnnouncementLabel.."+1")
		end
		
		SetData("JudgeDecision",JudgeDecision)

		--assessor1
		SetData("DecisionParam","assessor1")
		local Assessor1Decision = MsgSayInteraction("assessor1","assessor1",0,
			"@B[1,"..DecisionTextLabel.."+1]"..
			"@B[2,"..DecisionTextLabel.."+2]",
			trial_ConvictionDecision,
			""..DecisionTextLabel.."+0",GetID("assessor1"))

		if Assessor1Decision == "C" then
			Assessor1Decision = trial_ConvictionDecision()
		end
		if Assessor1Decision == 1 then
			conviction_cnt = conviction_cnt+1
			trial_PlayRelevantJuryAni("assessor1",100)
			MsgSay("assessor1",""..AnnouncementLabel.."+0")
		else
			trial_PlayRelevantJuryAni("assessor1",0)
			MsgSay("assessor1",""..AnnouncementLabel.."+1")
		end

		--assessor2
		SetData("DecisionParam","assessor2")
		local Assessor2Decision = MsgSayInteraction("assessor2","assessor2",0,
			"@B[1,"..DecisionTextLabel.."+1]"..
			"@B[2,"..DecisionTextLabel.."+2]",
			trial_ConvictionDecision,
			""..DecisionTextLabel.."+0",GetID("assessor2"))

		if Assessor2Decision == "C" then
			Assessor2Decision = trial_ConvictionDecision()
		end
		if Assessor2Decision == 1 then
			conviction_cnt = conviction_cnt+1
			trial_PlayRelevantJuryAni("assessor2",100)
			MsgSay("assessor2",""..AnnouncementLabel.."+0")
		else
			trial_PlayRelevantJuryAni("assessor2",0)
			MsgSay("assessor2",""..AnnouncementLabel.."+1")
		end

		SetData("judgedecision",-1)
		SetData("assessor1decision",-1)
		SetData("assessor2decision",-1)

		local TrialCosts = 250 + GetNobilityTitle("accused") * 250
		local DecisionForFinalComment = 0
		trial_Cam("JudgeFromBelowCam")
		-- Urteilsverkündung--------------------------------------------

--		MsgSay("judge","@L_LAWSUIT_6_DECISION_B_JUDGE_DECISION_+0") -- Rausgenommen weil keine Speech aufnahme..
		if confession==2 or conviction_cnt>=2 then
			if confession==2 and conviction_cnt<2 then
				PlayAnimationNoWait("judge", "sit_talk")
				MsgSay("judge","@L_LAWSUIT_6_DECISION_B_JUDGE_DECISION_GUILTY_BUT_MILD"..GenderType)
				PlayAnimationNoWait("judge", "sit_talk")
				MsgSay("judge","@L_LAWSUIT_6_DECISION_B_JUDGE_DECISION_GUILTY_BUT_MILD_TOBOTH_+0")
				PlayAnimationNoWait("judge", "sit_talk")
				MsgSay("judge","@L_LAWSUIT_6_DECISION_B_JUDGE_DECISION_GUILTY_BUT_MILD_TOBOTH_+1")
				SentenceLevel = SentenceLevel - 1
			else
				PlayAnimationNoWait("judge", "sit_talk")
				MsgSay("judge","@L_LAWSUIT_6_DECISION_B_JUDGE_DECISION_GUILTY"..GenderType,GetID("accused"))
				if conviction_cnt==2 then
					PlayAnimationNoWait("judge", "sit_talk")
					MsgSay("judge","@L_LAWSUIT_6_DECISION_B_JUDGE_DECISION_GUILTY_HALF")
					SentenceLevel = SentenceLevel - 1;
				else
					PlayAnimationNoWait("judge", "sit_talk")
					MsgSay("judge","@L_LAWSUIT_6_DECISION_B_JUDGE_DECISION_GUILTY_FULL")
				end
			end

			local PenaltyType = -1
			local PenaltyValue = 0

			PlayAnimationNoWait("judge", "sit_talk")
			if SentenceLevel<1 then
				MsgSay("judge","@L_LAWSUIT_6_DECISION_C_JUDGEMENT_ANNOUNCEMENT_+0",GetID("accused"),PenaltyValue)
			elseif SentenceLevel==1 then
				PenaltyValue = SimGetWealth("accused")/12
				if PenaltyValue <= 0 then
					PenaltyValue = 250
				end
				MsgSay("judge","@L_LAWSUIT_6_DECISION_C_JUDGEMENT_ANNOUNCEMENT_+1",GetID("accused"),PenaltyValue)
				PenaltyType = PENALTY_MONEY
			elseif SentenceLevel==2 then
				PenaltyValue = 8
				MsgSay("judge","@L_LAWSUIT_6_DECISION_C_JUDGEMENT_ANNOUNCEMENT_+2",GetID("accused"),PenaltyValue)
				PenaltyType = PENALTY_PILLORY
			elseif SentenceLevel==3 then
				PenaltyValue = SimGetWealth("accused")/5
				if PenaltyValue <= 0 then
					PenaltyValue = 1500
				end
				MsgSay("judge","@L_LAWSUIT_6_DECISION_C_JUDGEMENT_ANNOUNCEMENT_+4",GetID("accused"),PenaltyValue)
				PenaltyType = PENALTY_MONEY
			elseif SentenceLevel==4 then
				PenaltyType = PENALTY_TITLE
				if (SimGetOfficeID("accused")~=-1) then
					MsgSay("judge","@L_LAWSUIT_6_DECISION_C_JUDGEMENT_ANNOUNCEMENT_+3",GetID("accused"))
					RemoveAllObjectDependendImpacts( "accused", "Office" )
					GetHomeBuilding("accused","home")
					BuildingGetCity("home","homecity")				
					CityRemoveFromOffice("homecity","accused")
					CityRemoveApplicant("homecity","accused") --löscht auch eine Bewerbung
				elseif (GetNobilityTitle("accused")>1) then
					MsgSay("judge","@L_LAWSUIT_6_DECISION_C_JUDGEMENT_ANNOUNCEMENT_+5",GetID("accused"))
				else
					MsgSay("judge","@L_NEWSTUFF_NOTITLEPENALTY_+0")
					PlayAnimationNoWait("judge", "sit_talk")
					MsgSay("judge","@L_LAWSUIT_6_DECISION_C_JUDGEMENT_ANNOUNCEMENT_+6",GetID("accused"))
					PenaltyType = PENALTY_PRISON
					PenaltyValue = 96 / YearsPerRound
				end
			elseif SentenceLevel==5 then
				PlayAnimationNoWait("judge", "sit_talk")
				MsgSay("judge","@L_LAWSUIT_6_DECISION_C_JUDGEMENT_ANNOUNCEMENT_+6",GetID("accused"),PenaltyValue)
				PenaltyType = PENALTY_PRISON
				PenaltyValue = 96 / YearsPerRound
			elseif SentenceLevel==6 then
				PlayAnimationNoWait("judge", "sit_talk")
				MsgSay("judge","@L_LAWSUIT_6_DECISION_C_JUDGEMENT_ANNOUNCEMENT_+7",GetID("accused"),PenaltyValue)
				PenaltyType = PENALTY_DEATH
				SetProperty("accused","ExecutedBy",GetID("accuser"))
				--mission_ScoreAccuse("accuser")
			end

			DecisionForFinalComment = 1
			PlayAnimationNoWait("judge", "talk_sit_short")
			MsgSay("judge","@L_LAWSUIT_6_DECISION_C_JUDGEMENT_EXECUTE_+0")

			if PenaltyType>-1 then
				CityAddPenalty("settlement","accused",PenaltyType,PenaltyValue)
				xp_ChargeCharacter("accuser", SentenceLevel)
			end

		else -- gerichtskosten trägt die anklage
			trial_PlayRelevantJuryAni("judge",0)
			MsgSay("judge","@L_LAWSUIT_6_DECISION_B_JUDGE_DECISION_NOTGUILTY"..GenderType,GetID("accused"))
			MsgSay("judge","@L_LAWSUIT_6_DECISION_B_JUDGE_DECISION_NOTGUILTY_TOBOTH",TrialCosts)
			if conviction_cnt==0 then
				TrialCosts = GetMoney("accuser")/5 --20%
				if TrialCosts<1000 then TrialCosts=1000 end
			elseif conviction_cnt==1 then
				TrialCosts = GetMoney("accuser")/40 --2.5 %
				if TrialCosts<500 then TrialCosts=500
				elseif TrialCosts>5000 then TrialCosts=5000 end
			else
				TrialCosts = 0 --darf nicht passieren
			end				
			CreditMoney("settlement",TrialCosts,"CostAdministration")
			CreditMoney("accuser",-TrialCosts,"CostAdministration")
			DecisionForFinalComment = 0
			xp_ChargeCharacter("accused", SentenceLevel)
		end
		trial_Cam("TrialMainCam")
		local time = PlayAnimationNoWait("judge", "sit_judge_hammer")
		Sleep(1.5)
		CarryObject("judge","Handheld_Device/Anim_judge_hammer.nif",false)
		Sleep(0.6)
		for i=0,12 do
			PlaySound3DVariation("judge","Locations/hammer")
			Sleep(0.3)
		end
		Sleep(time - 7)
		CarryObject("judge","",false)
		Sleep(1)
		PlayAnimationNoWait("judge", "talk_sit_short")
		MsgSay("judge","@L_LAWSUIT_6_DECISION_C_JUDGEMENT_CLOSE_+0")

		--Reactions
		if DecisionForFinalComment == 1 then
			camera_CutsceneDialogCam("","accused",0,0)
			PlayAnimationNoWait("accused", "shake_head")
			MsgSay("accused","@L_LAWSUIT_6_DECISION_D_REACTIONS_GUILTY")
			if DynastyIsPlayer("accused") then
				gameplayformulas_StartHighPriorMusic(MUSIC_NEGATIVE_EVENT)
			elseif DynastyIsPlayer("accuser") then
				gameplayformulas_StartHighPriorMusic(MUSIC_POSITIVE_EVENT)
			end
		else
			camera_CutsceneDialogCam("","accuser",0,0)
			PlayAnimationNoWait("accuser", "shake_head")
			MsgSay("accuser","@L_LAWSUIT_6_DECISION_D_REACTIONS_NOTGUILTY")
			if DynastyIsPlayer("accused") then
				gameplayformulas_StartHighPriorMusic(MUSIC_POSITIVE_EVENT)
			elseif DynastyIsPlayer("accuser") then
				gameplayformulas_StartHighPriorMusic(MUSIC_NEGATIVE_EVENT)
			end			
		end
	end

	--Fertig
	CutsceneCollectEvidences("","accuser","accused",true)		-- mark collected evidences as used
	--BuildingLockForCutscene("courtbuilding",0)
	SimResetBehavior("executioner")
	if GetImpactValue("accused","IsCharged")==1 then
	    RemoveImpact("accused","IsCharged")
	end
	if GetImpactValue("accuser","HasCharged")==1 then
		RemoveImpact("accuser","HasCharged")
	end	
	EndCutscene("")
end

-- Ende

function StopAllMeasures()
	BuildingGetRoom("courtbuilding", "Judge", "judgeroom")
	RoomGetInsideSimList("judgeroom","visitor_list")
	local i
	local num = ListSize("visitor_list")
	for i=0,num-1 do
		ListGetElement("visitor_list",i,"visitor")
		if (HasProperty("visitor","BUILDING_NPC") == false) then
			if (DynastyIsAI("visitor")) then
				SimSetBehavior("visitor","Idle")
			end
			SimStopMeasure("visitor")
		end
	end
end


----------------------------------------------------------------------------------
--- Helper functions
----------------------------------------------------------------------------------
function RandomVisitorComment(comment)
	lsize = ListSize("visitor_list")
	if lsize>=1 then
		local index = Rand(lsize)
		ListGetElement("visitor_list",index,"random_visitor")
		PlayAnimationNoWait("random_visitor", "talk")
		MsgSay("random_visitor",comment)
	end
end

function ConvictionDecision()

	local x = GetData("DecisionParam")
	local AccuserSentence = GetData("AccuserSentence") * 3 + 1
	local JudgeDecision = GetData("JudgeDecision")
	
	if (JudgeDecision ~= -1) then
		local DipState = DynastyGetDiplomacyState("judge",x)
		if (DipState == DIP_FOE) then
			if (JudgeDecision == 1) then
				return 2
			else
				return 1
			end
		end
		
		if (DipState == DIP_ALLIANCE) then
			if (JudgeDecision == 1) then
				return 1
			else
				return 2
			end
		end		
	end
	if trial_GetSubjectiveSentence(x) >= AccuserSentence then
		return 1
	else
		return 2
	end
end

function SimIsPresent(SimAlias)
	BuildingGetRoom("courtbuilding", "Judge", "judgeroom")
	if GetID(SimAlias)>0 then
		if GetState(SimAlias,STATE_DEAD) then
			return 2 -->sim is dead
		end

		if not GetInsideRoom(SimAlias,"currentroom") then
			return 0 -->sim is not in building
		end
		if GetID("currentroom")==GetID("judgeroom") then
			return 1 -->sim is in building
		end
		return 0	-- sim is not in building
	end
	return 2 -->sim does not exists -> sim is dead
end


function CreateSim(SimAlias,LocatorName,templateID)
	if GetLocatorByName("courtbuilding",LocatorName,"DestPos") then
		SimCreate(templateID,"courtbuilding","DestPos",SimAlias)
		SimSetLastname(SimAlias,SimAlias)
		SimSetFirstname(SimAlias,SimAlias)
	end
end

function SitAt(SimAlias, LocatorName)
	if trial_SimIsPresent(SimAlias)==1 then
		CutsceneCallThread("", "SimSitDown", SimAlias, LocatorName)
		return 1
	end
	return 0
end

function StandAt(SimAlias, LocatorName)
	if trial_SimIsPresent(SimAlias)==1 then
		CutsceneCallThread("", "SimStandAt", SimAlias, LocatorName)
		return 1
	end
	return 0
end

function LeaveBuilding(SimAlias)
	if trial_SimIsPresent(SimAlias)==1 then
		feedback_MessagePolitics(SimAlias,"@L_TOWNHALL_CLOSED_HEADER_+0","@L_TOWNHALL_CLOSED_TEXT_+0",GetID(SimAlias))
		CutsceneCallThread("", "SimExitBuilding", SimAlias)
		return 1
	end
	return 0
end

function ModifyTotalEvidenceValue(x)
	local lx = GetData("TotalEvidenceValue")
	lx = lx + x
	SetData("TotalEvidenceValue",lx)
	trial_UpdatePanelTrial(2)
end

function AccusedDecideConfess()
	local Sentence = GetData("AccuserSentence")
	local SentenceValue = Sentence * 3 + 1
	local jury_tendency = (trial_GetSubjectiveSentence("judge") + trial_GetSubjectiveSentence("assessor1") + trial_GetSubjectiveSentence("assessor2"))/3

	if Sentence==6 then
		if jury_tendency>21 then 
			return 1	-- hier hilft nur noch alles abstreiten und beten
		else 
			return 3	-- gestehen und auf milderung hoffen
		end
	else
		if jury_tendency-SentenceValue>3 then
			return 1		-- gestehen
		elseif jury_tendency-SentenceValue<-3 then
			return 2		-- nix sagen
		else
			return Rand(2)+1 -- unschuldig oder nichts sagen
		end
	end		

	return (Rand(3)+1)	-- sollte nicht eintreten
end

function JudgeDecideSentence()
	return GetData("DefaultSentence")
end

function AccuserDecideSentence()
	local maxmod = 0
	if GetFavorToSim("accuser","accused")<30 then 
		maxmod = 1+Rand(2)
	end

	local av = (trial_GetSubjectiveSentence("judge")+maxmod)/3
	local bv = (trial_GetSubjectiveSentence("assessor1")+maxmod)/3
	local cv = (trial_GetSubjectiveSentence("assessor2")+maxmod)/3
	local majority = 1 
	for i=1,6 do
		if (av>=i and bv>=i) or (av>=i and cv>=i) or (bv>=i and cv>=i) then
			majority = i
		end
	end

	return majority
end

function GetLocalPlayerRepresentative(alias)
	if DynastyIsPlayer("accuser") then
		CopyAlias("accuser",alias)
		return true
	elseif DynastyIsPlayer("accused") then
		CopyAlias("accused",alias)
		return true
	elseif DynastyIsPlayer("judge") then
		CopyAlias("judge",alias)
		return true
	elseif DynastyIsPlayer("assessor1") then
		CopyAlias("assessor1",alias)
		return true
	elseif DynastyIsPlayer("assessor2") then
		CopyAlias("assessor2",alias)
		return true
	end
	return false
end

function Cam(LocatorName)
	GetLocatorByName("courtbuilding",LocatorName,"DestPos")
	CutsceneCameraSetAbsolutePosition("","DestPos")
end

function BeamIfNPCNotInside(SimAlias, LocatorName)
	BuildingGetRoom("courtbuilding", "Judge", "judgeroom")
	--feststellen ob der sim im gerichtsgebäude ist
	local IsPresent = false
	local IsPresentButInWrongRoom = false
	if GetInsideRoom(SimAlias,"currentroom") then
		if GetID("currentroom")==GetID("judgeroom") then
			IsPresent = true
		end
	end
	
	if GetInsideBuildingID(SimAlias) == GetID("courtbuilding") and not IsPresent then
		IsPresentButInWrongRoom = true
	end

	-- konsequenzen:
	if IsPresentButInWrongRoom then 
		if GetLocatorByName("courtbuilding",LocatorName,LocatorName) then
			StopAllAnimations(SimAlias)
			SimBeamMeUp(SimAlias,LocatorName)
		end
	elseif DynastyIsPlayer(SimAlias) then
		MsgNewsNoWait(SimAlias,"courtbuilding", MB_OK, "politics", 0,
			"@L_LAWSUIT_DIARY_MISSED_+0",
			"@L_LAWSUIT_DIARY_MISSED_+1", GetID(SimAlias))
	else
		if not GetState(SimAlias,STATE_CRUSADE) then
			if not GetState(SimAlias,STATE_DEAD) then
				if not GetState(SimAlias,STATE_DYING) then
					if not GetState(SimAlias,STATE_DUEL) then
						if not GetState(SimAlias,STATE_FIGHTING) then
							if not GetState(SimAlias,STATE_FEAST) then
								if not GetState(SimAlias,STATE_HIJACKED) then
									if not GetState(SimAlias,STATE_LOCKED) then
										if not GetState(SimAlias,STATE_LOCKEDALT) then
											if not GetState(SimAlias,STATE_PILLORY) then
											--	if not GetState(SimAlias,STATE_PREGNANT) then
													if not GetState(SimAlias,STATE_UNCONSCIOUS) then
														if not GetState(SimAlias,STATE_CHILD) then
															if not GetState(SimAlias,STATE_CAPTURED) then
																if not GetState(SimAlias,STATE_HPFZ_TRAUMLAND) then
																	if not GetState(SimAlias,STATE_HPFZ_HYPNOSE) then
																		if not GetState(SimAlias,STATE_IMPRISONED) then
																			if not GetState(SimAlias,STATE_GUARDING) then
																				if not GetState(SimAlias,STATE_HPFZ_BETTLER) then
																					if not GetState(SimAlias,STATE_ROBBERGUARD) then
																						if GetState(SimAlias,STATE_EXPEL) then
																							SetState(SimAlias,STATE_EXPEL,false)
																						elseif GetState(SimAlias,STATE_HPFZ_BAUARBEITER) then
																							SetState(SimAlias,STATE_HPFZ_BAUARBEITER,false)
																						elseif GetState(SimAlias,STATE_LITTLEDRUNK) then
																							SetState(SimAlias,STATE_LITTLEDRUNK,false)
																						elseif GetState(SimAlias,STATE_SITAROUND) then
																							SetState(SimAlias,STATE_SITAROUND,false)
																						elseif GetState(SimAlias,STATE_SLEEPING) then
																							SetState(SimAlias,STATE_SLEEPING,false)
																						elseif GetState(SimAlias,STATE_TOTALLYDRUNK) then
																							SetState(SimAlias,STATE_TOTALLYDRUNK,false)
																						elseif GetState(SimAlias,STATE_WORKING) then
																							SetState(SimAlias,STATE_WORKING,false)
																						end
																						if GetLocatorByName("courtbuilding",LocatorName,LocatorName) then
																							StopAllAnimations(SimAlias)
																							SimStopMeasure(SimAlias)
																							SimBeamMeUp(SimAlias,LocatorName,true)
																						end
																					end
																				end
																			end
																		end
																	end
																end
															end
														end
													end
											--	end
											end
										end
									end
								end
							end
						end
					end
				end
			end
		end
	end
end


----------------------------------------------------------------------------------
--- Measures
----------------------------------------------------------------------------------
function SimSitDown(LocatorName)
	if GetLocatorByName("courtbuilding", LocatorName, LocatorName) then
		--f_MoveTo("",LocatorName)
		if GetName("")=="Lena Oscroft" then
			OutputDebugString("f_BeginUseLocator"..GetName("").."loc: "..LocatorName..".\n")
		end
		--SimBeamMeUp("",LocatorName)
		f_BeginUseLocator("",LocatorName, GL_STANCE_SIT, true)
		--MoveSetStance("",GL_STANCE_SIT)   -- to be checked
	end
	CutsceneSendEventTrigger("owner", "Reached")
end

function SimStandAt(LocatorName)
	if(GetLocatorByName("courtbuilding", LocatorName, LocatorName)) then
		f_MoveTo("",LocatorName)
	end
	CutsceneSendEventTrigger("owner", "Reached")
end

function SimExitBuilding()
	f_ExitCurrentBuilding("")
	f_Stroll("",250.0,1.0)
	CutsceneRemoveSim("owner","")
	CutsceneSendEventTrigger("owner", "Reached")
end

function RunAIPlan(SimAlias)
	local SimExists = GetAliasByID(GetID(SimAlias),"ExisitingSim")
	if(SimExists == true) then
		if DynastyIsAI(SimAlias) then
			if GetInsideRoom(SimAlias,"currentroom") then
				if trial_IsIndoor(SimAlias) then
					AIExecutePlan(SimAlias, "Trial", "SIM",SimAlias)
					Sleep(0.01)
				end
			end
		end
	end
end

-- TrialMainCam, AccusedCam, AccuserCam, Judge2AccusedCam,
--
function CleanUp()
	BuildingGetRoom("courtbuilding", "Judge", "judgeroom")
	RoomGetInsideSimList("judgeroom","visitor_list")
	for i=0,ListSize("visitor_list")-1 do
		ListGetElement("visitor_list",i,"Sim")
		if not HasProperty("Sim","BUILDING_NPC") then
			AllowMeasure("Sim","StartDialog",EN_BOTH)
			ReleaseLocator("Sim")
		end
	end
	
	GetSettlement("courtbuilding", "CityAlias")
	if HasProperty("CityAlias","TrialBooked") then
		RemoveProperty("CityAlias","TrialBooked")
	end
	RemoveProperty("judgeroom","NextCutsceneID")
	BuildingLockForCutscene("courtbuilding",0)
	RoomLockForCutscene("judgeroom",0)
	local TargetArray = {"judge","accuser","accused","assessor1","assessor2"}
	local TargetCount = 5
	for Voter = 1, TargetCount do
		if AliasExists(TargetArray[Voter]) and (HasProperty(TargetArray[Voter],"trial_destination_ID") == true) then
			RemoveProperty(TargetArray[Voter],"trial_destination_ID")
		end
	end	
	
	-- PATCH TODO
	-- unlocks all the participants
		if SimIsInside("judge") then
			ClearStateImpact("no_hire")
			ClearStateImpact("no_control")
			ClearStateImpact("no_measure_start")
			ClearStateImpact("no_attackable")
			ClearStateImpact("no_action")
		end
		
		if SimIsInside("assessor1") then
			ClearStateImpact("no_hire")
			ClearStateImpact("no_control")
			ClearStateImpact("no_measure_start")
			ClearStateImpact("no_attackable")
			ClearStateImpact("no_action")
		end
		if SimIsInside("assessor2") then
			ClearStateImpact("no_hire")
			ClearStateImpact("no_control")
			ClearStateImpact("no_measure_start")
			ClearStateImpact("no_attackable")
			ClearStateImpact("no_action")
		end		
		if SimIsInside("accuser") then
			ClearStateImpact("no_hire")
			ClearStateImpact("no_control")
			ClearStateImpact("no_attackable")
			ClearStateImpact("no_action")
		end		
		if SimIsInside("accused") then
			ClearStateImpact("no_hire")
			ClearStateImpact("no_control")
			ClearStateImpact("no_attackable")
			ClearStateImpact("no_action")
		end
	EndCutscene("")
	DestroyCutscene("")
end

function IsIndoor(SimAlias)
	BuildingGetRoom("courtbuilding", "Judge", "judgeroom")
	--check if sim exist and is in the building. then run the function "FuncName" for the SIM @ SimAlias
	if GetID(SimAlias)>0 then
		if GetInsideRoom(SimAlias,"currentroom") then
			if GetID("currentroom")==GetID("judgeroom") then
				return 1
			else
				-- sim is not in the building
				return 0
			end
		else
			return 0
		end
	end
	return 0
end

function MeasureBar(state)
	local TargetArray = {"accuser","accused"}
	local TargetCount = 2
	for Voter = 1, TargetCount do
		local VoterAlias = TargetArray[Voter]
		if (trial_IsIndoor(VoterAlias) == 1) then
			if (state == true) then
				trial_ActivateSessionMeasures(VoterAlias)
			elseif (state == false) then
				trial_RemoveAllSessionMeasures(VoterAlias)
			end
		end
	end
	CutsceneShowCharacterPanel("",state)
end
 
function PlayRelevantTalkAni(sim)
	if (SimGetGender(sim) == GL_GENDER_FEMALE) then
		PlayAnimationNoWait(sim,"talk_female_"..(Rand(2)+1))
	else
		if (Rand(2) == 0) then
			PlayAnimationNoWait(sim, "talk")
		else
			PlayAnimationNoWait(sim, "talk_2")
		end
	end
end

function PlayRelevantJuryAni(sim,quality)
	local AniToPlay
	if quality<51 then
		AniToPlay = "sit_no"
	elseif quality<76 then
		AniToPlay = "talk_sit_short"
	elseif quality<100 then
		AniToPlay = "sit_talk"
	else
		AniToPlay = "sit_yes"
	end
	PlayAnimationNoWait(sim,AniToPlay)
end

function ActivateSessionMeasures(Sim)
	BuildingGetRoom("courtbuilding", "Judge", "judgeroom")
	SetProperty(Sim,"trial_destination_ID",GetID("judgeroom"))

	SetProperty(Sim,"CutsceneBribeCharacter",1)
	SetProperty(Sim,"CutsceneFragranceOfHoliness",1) -- JUST TRIAL
	SetProperty(Sim,"CutsceneLetterFromRome",1)
	SetProperty(Sim,"CutsceneAboutTalents1",1)
	SetProperty(Sim,"CutsceneAboutTalents2",1)
	SetProperty(Sim,"CutsceneFlowerOfDiscord",1)
	SetProperty(Sim,"CutscenePerfume",1)
	SetProperty(Sim,"CutscenePoem",1)
	SetProperty(Sim,"CutsceneThesisPaper",1)
	SetProperty(Sim,"CutsceneCurryFavor",1)
	SetProperty(Sim,"CutsceneDeliverTheFalseGauntlet",1)
	SetProperty(Sim,"CutsceneHaveAStabbingGaze",1)
	SetProperty(Sim,"CutsceneMakeACompliment",1)
	SetProperty(Sim,"CutsceneFlirt",1)
	--SetProperty(Sim,"CutsceneThreatCharacter",1)
end


function RemoveAllSessionMeasures(Sim)
	RemoveProperty(Sim,"CutsceneBribeCharacter")
	RemoveProperty(Sim,"CutsceneFragranceOfHoliness") -- JUST TRIAL
	RemoveProperty(Sim,"CutsceneLetterFromRome")
	RemoveProperty(Sim,"CutsceneAboutTalents1")
	RemoveProperty(Sim,"CutsceneAboutTalents2")
	RemoveProperty(Sim,"CutsceneFlowerOfDiscord")
	RemoveProperty(Sim,"CutscenePerfume")
	RemoveProperty(Sim,"CutscenePoem")
	RemoveProperty(Sim,"CutsceneThesisPaper")
	RemoveProperty(Sim,"CutsceneCurryFavor")
	RemoveProperty(Sim,"CutsceneDeliverTheFalseGauntlet")
	RemoveProperty(Sim,"CutsceneHaveAStabbingGaze")
	RemoveProperty(Sim,"CutsceneMakeACompliment")
	RemoveProperty(Sim,"CutsceneFlirt")
	--RemoveProperty(Sim,"CutsceneThreatCharacter")
end

-- abfrage: es gibt einen Spieler, der entweder kläger oder angeklagten kontrolliert
function HumanPlayerWantsInteraction()
	if DynastyIsPlayer("accuser") then
		return true
	end

	if DynastyIsPlayer("accused") then
		return true
	end

	return false
end

function EvidenceIntToString(EvidenceType)
		if EvidenceType==1	then
			return "@L_TRIAL_START_QUESTION_TO_JUDGE_EVIDENCETYPE_SABOTAGE_+0"
	elseif EvidenceType==4 then
			return "@L_TRIAL_START_QUESTION_TO_JUDGE_EVIDENCETYPE_PRIBE_+0"
	elseif EvidenceType==6 then
			return "@L_TRIAL_START_QUESTION_TO_JUDGE_EVIDENCETYPEB_LACKMAIL_+0"
	elseif EvidenceType==7 then
			return "@L_TRIAL_START_QUESTION_TO_JUDGE_EVIDENCETYPE_SLUGGING_+0"
	elseif EvidenceType==10 then
			return "@L_TRIAL_START_QUESTION_TO_JUDGE_EVIDENCETYPE_CALUMNY_+0"
	elseif EvidenceType==11 then
			return "@L_TRIAL_START_QUESTION_TO_JUDGE_EVIDENCETYPE_POISON_+0"
	elseif EvidenceType==12 then
			return "@L_TRIAL_START_QUESTION_TO_JUDGE_EVIDENCETYPE_ASSAULT_+0"
	elseif EvidenceType==13 then
			return "@L_TRIAL_START_QUESTION_TO_JUDGE_EVIDENCETYPE_REVOLT_+0"
	elseif EvidenceType==14 then
			return "@L_TRIAL_START_QUESTION_TO_JUDGE_EVIDENCETYPE_MARAUDER_+0"
	elseif EvidenceType==15 then
			return "@L_TRIAL_START_QUESTION_TO_JUDGE_EVIDENCETYPE_ABDUCTION_+0"
	elseif EvidenceType==16 then
			return "@L_TRIAL_START_QUESTION_TO_JUDGE_EVIDENCETYPE_MURDER_+0"
	elseif EvidenceType==17 then
			return "@L_TRIAL_START_QUESTION_TO_JUDGE_EVIDENCETYPE_ESPIONAGE_+0"
	elseif EvidenceType==18 then
			return "@L_TRIAL_START_QUESTION_TO_JUDGE_EVIDENCETYPE_PERSONASSAULT_+0"
	elseif EvidenceType==19 then
			return "@L_TRIAL_START_QUESTION_TO_JUDGE_EVIDENCETYPE_CARTASSAULT_+0"
	elseif EvidenceType==20 then
			return "@L_TRIAL_START_QUESTION_TO_JUDGE_EVIDENCETYPE_THEFT_+0"
	else
		-- DEBUG: invalid case
			return "@L_TRIAL_START_QUESTION_TO_JUDGE_THEFT_+0"
	end
end

function FugitiveExpires()
   if CityGetPenalty("settlement","Destination",PENALTY_DEATH,true,"Penalty") then
        --PenaltyFinish("Penalty") -- Maybe to unsecure
		PenaltyReset("Penalty", 0)
   end
end
