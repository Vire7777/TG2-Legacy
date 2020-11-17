function Run()
	--how far the Destination can be to start this action
	local MaxDistance = 1000
	--how far from the destination, the owner should stand while reading the letter from rome
	local ActionDistance = 80

	--StartGameTimer(8)
	MeasureSetStopMode(STOP_NOMOVE)
	
	f_ExitCurrentBuilding("Owner")
	
	if not AliasExists("Destination") then
		CopyAlias("", "Destination")
	end
	MeasureSetNotRestartable() 
	f_MoveTo("","Destination")
	
	if not SimGetWorkingPlace("Owner","WorkBuilding") then
		return
	end
	local IsMonitor = false
	if not BuildingGetOwner("WorkBuilding","BuildingOwner") then
		if SimGetProfession("")==GL_PROFESSION_MONITOR then
			SimGetServantDynasty("","BuildingOwner")
			IsMonitor = true
		--sim is monitor
		else
			return
		end
	end

	MsgMeasure("","@L_GENERAL_MEASURES_211_ORDERCOLLECTEVIDENCE_ACTION_+0")

	local	Total = 0
	
	SetData("IsProductionMeasure", 0)
	SimSetProduceItemID("", -GetCurrentMeasureID(""), -1)
	SetData("IsProductionMeasure", 1)
	
	while true do
		
		local NumOfObjects = Find("Owner","__F( (Object.GetObjectsByRadius(Sim)==3000) AND NOT(Object.BelongsToMe())AND(Object.CanBeInterrupted(OrderCollectEvidence))AND NOT(Object.GetState(cutscene))AND NOT(Object.HasImpact(HasBeenTalked))AND NOT(Object.GetProfession() == 25)AND NOT(Object.GetProfession() == 21)AND NOT(Object.GetProfession() == 22))","Sims",-1)
		if NumOfObjects>0 then
			local DestAlias = "Sims"..Rand(NumOfObjects)
			
			local Check = true
			if IsDynastySim(DestAlias) and DynastyIsPlayer(DestAlias) then
				Check = false
			end
			
			if HasProperty(DestAlias,"QuestActive") then
				Check = false
			end
		
			if Check then
			
				SetData("Blocked", 0)
				if ai_StartInteraction("", DestAlias, MaxDistance, ActionDistance, "BlockMe") then
					AddImpact(DestAlias,"HasBeenTalked",1,6)
					AlignTo(DestAlias,"")
					Sleep(0.7)
					PlayAnimationNoWait("Owner", "talk")
					if SimGetGender("")==GL_GENDER_MALE then
						PlaySound3DVariation("","CharacterFX/male_neutral",1)
					else
						PlaySound3DVariation("","CharacterFX/female_neutral",1)
					end
					Sleep(0.75)
					PlayAnimation(DestAlias, "talk")
					local Cnt = Talk("", DestAlias, true)
					if Cnt>0 then
						if SimGetGender("")==GL_GENDER_MALE then
							PlaySound3DVariation("","CharacterFX/male_amazed",1)
						else
							PlaySound3DVariation("","CharacterFX/female_amazed",1)
						end
						if IsMonitor then
							feedback_MessageCharacter("BuildingOwner",
								"@L_GENERAL_MEASURES_211_ORDERCOLLECTEVIDENCE_MSG_SUCCESS_HEAD_+0",
								"@L_GENERAL_MEASURES_211_ORDERCOLLECTEVIDENCE_MSG_SUCCESS_BODY_+0",GetID(""))
							Total = Total + Cnt
						else
							feedback_MessageCharacter("",
								"@L_GENERAL_MEASURES_211_ORDERCOLLECTEVIDENCE_MSG_SUCCESS_HEAD_+0",
								"@L_GENERAL_MEASURES_211_ORDERCOLLECTEVIDENCE_MSG_SUCCESS_BODY_+0",GetID(""))
							Total = Total + Cnt
						end
					end
				else
					f_MoveTo("","Destination",GL_MOVESPEED_RUN)
					Sleep(1)
				end
				SetData("Blocked", 1)
			end
		else
			f_MoveTo("","Destination")
		end
		Sleep(2)
	end
		
	if Total == 0 then
		if IsMonitor then
			feedback_MessageCharacter("BuildingOwner",
				"@L_GENERAL_MEASURES_211_ORDERCOLLECTEVIDENCE_MSG_FAILED_HEAD_+0",
				"@L_GENERAL_MEASURES_211_ORDERCOLLECTEVIDENCE_MSG_FAILED_BODY_+0",GetID(""))
		else
			feedback_MessageCharacter("",
				"@L_GENERAL_MEASURES_211_ORDERCOLLECTEVIDENCE_MSG_FAILED_HEAD_+0",
				"@L_GENERAL_MEASURES_211_ORDERCOLLECTEVIDENCE_MSG_FAILED_BODY_+0",GetID(""))
		end
	end
	
	MeasureRun("","Destination",2110)
	
	--f_MoveTo("","Workbuilding")
end

function BlockMe()
	while GetData("Blocked")~=1 do
		Sleep(1)
	end
end

function CleanUp()
	StopAnimation("Owner")
end

