-------------------------------------------------------------------------------
----
----	OVERVIEW "ms_068_PickpocketPeople"
----
----	with this measure, the player can send a thief, to pickpocket people
---- impact HaveBeenPickpocketed
-------------------------------------------------------------------------------

-- changes: added about 50 base gold to all successful pickpocketings

function Run()
	if GetHP("") <= 0 or GetState("",STATE_UNCONSCIOUS) then--i am dead.. i should stop this.
		StopMeasure("")
		return
	end
	
	f_MoveTo("","Destination", GL_MOVESPEED_RUN)
	--the time, a thief must wait to rob the same person again
	local TimeToWait = 8
	local Value
	local	TimeOut
	TimeOut = GetData("TimeOut")
	if TimeOut then
		TimeOut = GetGametime() + TimeOut
	end
	
	if not SimGetWorkingPlace("","MyHome") then
		if IsPartyMember("") then
			local NextBuilding = ai_GetNearestDynastyBuilding("",GL_BUILDING_CLASS_WORKSHOP,GL_BUILDING_TYPE_THIEF)
			if not NextBuilding then
				StopMeasure()
			end
			CopyAlias(NextBuilding,"MyHome")
		else
			StopMeasure()
		end
	end
	while true do
		if GetHP("") <= 0 or GetState("",STATE_UNCONSCIOUS) then--i am dead.. i should stop this.
			StopMeasure("")
			return
		end
		if TimeOut then
			if TimeOut < GetGametime() then
				break
			end
		end
		local NumOfObjects = Find("Owner","__F( (Object.GetObjectsByRadius(Sim)==1000) AND NOT(Object.BelongsToMe()) AND NOT(Object.HasImpact(HaveBeenPickpocketed)) AND NOT(Object.GetState(cutscene))AND NOT(Object.GetProfession() == 21)AND NOT(Object.GetProfession() == 25)AND NOT(Object.GetState(townnpc))AND(Object.MinAge(16)))","Sims",-1)
		if NumOfObjects>0 then
			local DestAlias = "Sims"..Rand(NumOfObjects-1)
			local DoIt = 1
			if GetCurrentMeasureName(DestAlias)=="AttendMass" then 
				DoIt = 0	
			end
			if IsPartyMember(DestAlias) then
				DoIt = 0
			end
			local VictimSkill		
			if IsDynastySim(DestAlias) then 
				VictimSkill = GetSkillValue(DestAlias,EMPATHY)
			else
				VictimSkill = Rand(6) + 1
			end
			if DoIt==1 then
				if SendCommandNoWait(DestAlias, "BlockMe") then 
					if CheckSkill("",2,VictimSkill) then
						SetData("Blocked", 1)
						
						--hide the thief
						--bad idea. all people at the market are shouting TF
						--SetState("",STATE_HIDDEN,true)
							
						f_MoveTo("", DestAlias, GL_MOVESPEED_WALK, 140)
						AlignTo("Owner", DestAlias)
						Sleep(0.7)
						PlayAnimation("Owner", "pickpocket")
						AddImpact(DestAlias,"HaveBeenPickpocketed",1,TimeToWait)
						
						local		ThiefLevel				= SimGetLevel("")
						local		VictimSpendValue	= Rand(40) + ThiefLevel * 20 + 25
						
						if Rand(100 ) > (100-ThiefLevel*2) then
							VictimSpendValue = VictimSpendValue*3
						end
						
						IncrementXPQuiet("Owner",15)
						chr_RecieveMoney("Owner", VictimSpendValue, "IncomeThiefs")
						--for the mission
						mission_ScoreCrime("",VictimSpendValue)
						-- Play a coin sound for the local player
						if DynastyIsPlayer("") then
							PlaySound3D("","Effects/coins_to_moneybag+0.wav", 1.0)
						end
						
						if IsPartyMember(DestAlias) then
						
							local Value = GetMoney(DestAlias) * 0.05
							if VictimSpendValue > Value then
								VictimSpendValue = Value
							end
							SpendMoney(DestAlias, VictimSpendValue, "theft")
							
							if VictimSpendValue>25 then
								feedback_MessageCharacter(DestAlias,
									"@L_THIEF_068_PICKPOCKETPEOPLE_MSG_VICTIM_HEAD_+0",
									"@L_THIEF_068_PICKPOCKETPEOPLE_MSG_VICTIM_BODY_+0",GetID(DestAlias), VictimSpendValue)
							end
						end
	
						Sleep(0.75)
						SetData("Blocked", 0)
					else
						--hide the thief
						--bad idea. all people at the market are shouting TF
						--SetState("",STATE_HIDDEN,true)
					
						SetData("Blocked", 1)
						f_MoveTo("", DestAlias, GL_MOVESPEED_WALK, 140)
						AlignTo("Owner", DestAlias)
						AddImpact(DestAlias,"HaveBeenPickpocketed",1,TimeToWait)
						PlayAnimationNoWait("","pickpocket")
						Sleep(3)
						StopAnimation("")
						SetData("Blocked", 0)
						if chr_GetTitle(DestAlias) > 3 then
							chr_ModifyFavor(DestAlias,"",-5)
							CommitAction("pickpocket", "", "", DestAlias)
							feedback_OverheadComment(DestAlias,
								"@L_THIEF_068_PICKPOCKETPEOPLE_SCREAM_+0", false, true)
							if BuildingHasUpgrade("MyHome",543) then
							    if GetState("", STATE_FIGHTING) == false then
								    ms_068_pickpocketpeople_FastHide()
								end
							else
							    f_MoveTo("","MyHome",GL_MOVESPEED_RUN,0)
							    StopAction("pickpocket","")
							    Sleep(50)
							end
							f_MoveTo("","Destination",GL_MOVESPEED_WALK,50)
						end
					end
				end
			end	
		else
			f_MoveTo("","Destination",GL_MOVESPEED_WALK,50)	
		end
		Sleep(3)
	end
end

function BlockMe()
	while GetData("Blocked")==1 do
		Sleep(Rand(10)*0.1+0.5)
		if GetHP("") <= 0 or GetState("",STATE_UNCONSCIOUS) then--i am dead.. i should stop this.
			StopMeasure("")
			return
		end
	end
end

function FastHide()

    StopAction("pickpocket","")
    GetPosition("","standPos")
	PlayAnimationNoWait("","crouch_down")
	Sleep(1)
	local filter ="__F((Object.GetObjectsByRadius(Building)==1000))"
	local k = Find("",filter,"Umgebung",15)
	if k > 0 then
	    GfxAttachObject("tarn","Handheld_Device/barrel_new.nif")
	else
	    GfxAttachObject("tarn","Outdoor/Bushes/bush_08_big.nif")
	end
	GfxSetPositionTo("tarn","standPos")
	SetState("", STATE_INVISIBLE, true)
	Sleep(10)

	SimBeamMeUp("","standPos",false)
	GfxDetachAllObjects()
    SetState("", STATE_INVISIBLE, false)
	PlayAnimationNoWait("","crouch_up")

end

function CleanUp()
	--stop hiding
	--SetState("",STATE_HIDDEN,false)

	StopAnimation("")
	StopAction("pickpocket","")
end

