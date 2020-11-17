function Init()

	if not SimGetWorkingPlace("", "Base") then
		return
	end

	if not BuildingGetPrisoner("Base", "Victim") then
		return
	end
	
	if not GetDynasty("Victim", "VictimDyn") then
		return
	end
	
	local iRanking = GetNobilityTitle("VictimDyn")
	local fMoney = math.floor(iRanking * (GetMoney("VictimDyn")/50))
	if fMoney<100 then
		fMoney=100
	end
	
	local Sum1 = math.floor(fMoney * 0.5)
	local Sum2 = math.floor(fMoney * 0.75)
	local Sum3 = fMoney
	local Sum4 = math.floor(fMoney * 1.25)
	local Sum5 = math.floor(fMoney * 1.5)
	local OutTime = GetProperty("Victim","HijackedEndTime")
	OutTime = Gametime2Total(OutTime)

	local result = InitData("@P"..
	"@B[1,,@L_THIEF_069_DEMANDRANSOM_ACTION_BTN_+0,Hud/Buttons/btn_Money_Small.tga]"..
	"@B[2,,@L_THIEF_069_DEMANDRANSOM_ACTION_BTN_+1,Hud/Buttons/btn_Money_SmallLarge.tga]"..
	"@B[3,,@L_THIEF_069_DEMANDRANSOM_ACTION_BTN_+2,Hud/Buttons/btn_Money_Medium.tga]"..
	"@B[4,,@L_THIEF_069_DEMANDRANSOM_ACTION_BTN_+3,Hud/Buttons/btn_Money_MediumLarge.tga]"..
	"@B[5,,@L_THIEF_069_DEMANDRANSOM_ACTION_BTN_+4,Hud/Buttons/btn_Money_Large.tga]",
	ms_069_demandransom_AIInitDemandRansom,
	"@L_THIEF_069_DEMANDRANSOM_RANSOMDEMAND_VICTIM_HEAD_+0",
	"@L_THIEF_069_DEMANDRANSOM_ACTION_TEXT_+0",
	Sum1,Sum2,Sum3,Sum4,Sum5,GetID("Victim"),OutTime)


	if result==1 then
		fMoney = Sum1
	elseif result==2 then
		fMoney = Sum2
	elseif result==3 then
		fMoney = Sum3
	elseif result==4 then
		fMoney = Sum4
	elseif result==5 then
		fMoney = Sum5
	elseif result=="C" then
		return
	end
	SetData("TFRansom", fMoney)
end 

function AIInitDemandRansom()
	return (Rand(5)+1)
end

function AIInitDemandRansomAnswer()
	local Difficulty = ScenarioGetDifficulty()
	if Difficulty > 2 then
		if Rand(100) > 10 then
			return "O"
		else
			return "Z"
		end
	else
		return "O"
	end
end



function Run()
	
--	local MeasureID = GetCurrentMeasureID("")
--	local TimeOut = mdata_GetTimeOut(MeasureID)
	SetRepeatTimer("Base", GetMeasureRepeatName2("DemandRansom"), 6)
	
	local fMoney = GetData("TFRansom")

	if not fMoney then
		if not DynastyIsAI("") or not AliasExists("Victim") then
			return
		end

		local iRanking = GetNobilityTitle("Victim")
		local fMoney = math.floor(iRanking * (GetMoney("Victim")/50))
		if fMoney<100 then
			fMoney=100
		end
		fMoney = math.floor(fMoney * 0.75)
	end
	
	if not SimGetWorkingPlace("", "Base") then
		return
	end	
	
	if not GetHomeBuilding("Victim", "VictimHome") then
		return
	end

	if not GetOutdoorMovePosition("", "VictimHome", "DoorPos") then
		return
	end
	f_MoveTo("", "DoorPos", GL_MOVESPEED_RUN)

	CarryObject("", "Handheld_Device/ANIM_flag.nif",false)	
	f_Stroll("", 300,3)
	PlayAnimation("", "talk")
	CarryObject("","",false)
	
	--ask again for prisoner to avoid exploit
	if not BuildingGetPrisoner("Base", "Victim") then
		StopMeasure()
	end
	
	local result = MsgNews("Victim","","@P"..
				"@B[O,@L_THIEF_069_DEMANDRANSOM_RANSOMDEMAND_VICTIM_BTN_+0]"..
				"@B[C,@L_THIEF_069_DEMANDRANSOM_RANSOMDEMAND_VICTIM_BTN_+1]"..
				"@B[Z,@L_THIEF_069_DEMANDRANSOM_RANSOMDEMAND_VICTIM_BTN_+2]",
				ms_069_demandransom_AIInitDemandRansomAnswer,"default",8,
				"@L_THIEF_069_DEMANDRANSOM_RANSOMDEMAND_VICTIM_HEAD_+0",
				"@L_THIEF_069_DEMANDRANSOM_RANSOMDEMAND_VICTIM_BODY_+0",
				 GetID("Victim"),fMoney)
				 
	if result=="O" then
		--wants to pay
		if SpendMoney("Victim", fMoney, "CostRobbers") then
			chr_RecieveMoney("", fMoney, "IncomeRobbers")
			--for the mission
			mission_ScoreCrime("",fMoney)
			feedback_MessageCharacter("",
				"@L_THIEF_069_DEMANDRANSOM_RANSOMDEMAND_ACTOR_SUCCESS_HEAD_+0",
				"@L_THIEF_069_DEMANDRANSOM_RANSOMDEMAND_ACTOR_SUCCESS_BODY_+0",GetID("Victim"), fMoney)
			if not MeasureRun("Base", NIL, "LetAbducteeFree",false) then
				SetProperty("Victim","ForceFree",1)
			end
		else
			--can't pay
			feedback_MessageCharacter("",
				"@L_THIEF_069_DEMANDRANSOM_RANSOMDEMAND_ACTOR_TIMEOUT_HEAD_+0",
				"@L_THIEF_069_DEMANDRANSOM_RANSOMDEMAND_ACTOR_TIMEOUT_BODY_+0",GetID("Victim"),GetID("Victim"))		
		end
	elseif result=="Z" then
        GetDynasty("")
		GetSettlement("","CityAlias")
        CityAddPenalty("CityAlias","",PENALTY_PILLORY,12)
        if not DynastyIsPlayer("") then
			BuildingGetPrisoner("Base", "Victim")
			SetProperty("Victim","UnconsciousKill",1)
			feedback_MessageCharacter("",
				"@L_THIEF_069_DEMANDRANSOM_RANSOMDEMAND_ACTOR_TIMEOUT_HEAD_+0",
				"@L_THIEF_069_DEMANDRANSOM_RANSOMDEMAND_ACTOR_TIMEOUT_BODY_+1",GetID("Victim"),GetID("Victim"))
			Kill("Victim")	 -- must be the last command in this measure, because the kill of a measure object restarts the measure
		end
	else
		--doesnt wanna pay
		feedback_MessageCharacter("",
			"@L_THIEF_069_DEMANDRANSOM_RANSOMDEMAND_ACTOR_TIMEOUT_HEAD_+0",
			"@L_THIEF_069_DEMANDRANSOM_RANSOMDEMAND_ACTOR_TIMEOUT_BODY_+0",GetID("Victim"),GetID("Victim"))		
	end
 
	f_MoveTo("", "Base", GL_MOVESPEED_RUN)
end

function CleanUp()

end

function GetOSHData(MeasureID)
	--can be used again in:
	OSHSetMeasureRepeat("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+2",Gametime2Total(mdata_GetTimeOut(MeasureID)))
end

