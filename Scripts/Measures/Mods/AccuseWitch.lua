-- it would have been nice to only accuse those with low faith but the AI attend church regularly regardless of class so this balancing tool has been omitted :(

function Run()
	
	if not GetInsideBuilding("","Church") then	-- returns current building 
		StopMeasure()
	end	
	GetHomeBuilding("","Home")
	BuildingGetCity("Home","MyCity")
	BuildingGetCity("Church","City") -- Gets current buildings city
	GetNearestSettlement("Destination","WitchCity") -- returns the city the target is currently visiting or in (not to be confused with home city)
	--AliasChecks
	if not AliasExists("Home") then
		StopMeasure()
	end
	if not AliasExists("MyCity") then
		StopMeasure()
	end
	if not AliasExists("City") then
		StopMeasure()
	end
	
	if not GetID("MyCity")==GetID("City") then
		MsgQuick("","@L_ACCUSEWITCH_ERROR")
		StopMeasure()
	end
	if SimGetFaith("") < 60 then
		MsgQuick("","@L_ACCUSEWITCH_ERROR_TWO")
		StopMeasure()
	end
	if not GetID("MyCity")==GetID("WitchCity") then
		MsgQuick("","@L_ACCUSEWITCH_ERROR_THREE") --otherwise it takes too long for measure to finish
		StopMeasure()
	end
	
	local Gender = SimGetGender("Destination")
	
	if SimGetFaith("Destination") > 75 then
		if (Gender == GL_GENDER_FEMALE) then
			MsgQuick("","@L_ACCUSEWITCH_ERROR_FOUR")
		else
			MsgQuick("","@L_ACCUSEWITCH_ERROR_FIVE")
		end
		StopMeasure()
	end
	
	local Hour = math.mod(GetGametime(), 24)
	if Hour > 4 then
		MsgQuick("","@L_ACCUSEWITCH_ERROR_SIX")
		StopMeasure()
	end
	
	local X = SimGetOfficeLevel("Destination")
	local Title = GetNobilityTitle("Destination")
	local TitleCost = Title * 500
	local Level = {}
		Level[-1] = 0
		Level[1] = 10000
		Level[2] = 25000
		Level[3] = 35000
		Level[4] = 35000
		Level[5] = 50000
		Level[6] = 75000
		Level[7] = 100000
		
	local OfficeCost = Level[X]
	local Cost = 10000 + TitleCost + OfficeCost			
	local Difficulty = ScenarioGetDifficulty()
	if SimGetFaith("Destination") < 25 then
		Cost = Cost * 0.1
	elseif Difficulty < 2 then
		Cost = Cost * 0.1
	elseif Difficulty == 2 then
		Cost = Cost * 0.5
	end	
	local MyMoney = GetMoney("")
	if DynastyIsPlayer("") then
		if MyMoney < Cost then
			if (Gender == GL_GENDER_FEMALE) then
				MsgQuick("","@L_ACCUSEWITCH_ERROR_SEVEN")
			else
				MsgQuick("","@L_ACCUSEWITCH_ERROR_EIGHT")
			end
			StopMeasure()
		end
	end	

	local Result = MsgNews("","","@P"..
		"@B[1,@L_REPLACEMENTS_BUTTONS_JA_+0]"..
		"@B[2,@L_REPLACEMENTS_BUTTONS_NEIN_+0]",
		accusewitch_AIDecision,  --AIFunc
		"intrigue", --Message Class
		2, --TimeOut
		"@L_INTRIGUE_ACCUSEWITCH_SCREENPLAY_ACTOR_HEAD_+0",
		"@L_INTRIGUE_ACCUSEWITCH_SCREENPLAY_ACTOR_BODY_+0",
		GetID("Destination"),Cost)
	
	if Result ~= 1 then
		StopMeasure()
	else	
		if (GetState("Destination",STATE_WORKING)==true) then
			SetState("Destination",STATE_WORKING,false)
		end	
		SimStopMeasure("Destination")
		MoveStop("Destination")
		SetState("Destination",STATE_LOCKEDALT,true)
		SetState("",STATE_LOCKEDALT,true)
		GetPosition("","Spawn")
		f_MoveToNoWait("","Home")
		Sleep(2)
		MoveStop("")
		Sleep(1)
		SimCreate(20, "Church", "Spawn", "Priest")
		SetState("Priest",STATE_LOCKEDALT,true)
		AlignTo("","Priest")
		AlignTo("Priest","")
		Sleep(1)
		if SimIsInside("Destination") then
			f_ExitCurrentBuilding("Destination")
		end	
			
		if (Gender == GL_GENDER_FEMALE) then
			MsgSay("","@L_ACCUSEWITCH_FEMALE")
			MsgSay("Priest","@L_ACCUSEWITCH_PRIEST_FEMALE")
		else
			MsgSay("","@L_ACCUSEWITCH_MALE")
			MsgSay("Priest","@L_ACCUSEWITCH_PRIEST_MALE")
		end	
		
		if DynastyIsPlayer("") then
			SpendMoney("",Cost,"CostIndulgence")
		end	
		SetProperty("","WitchBurner",1)
		SetProperty("Church","PriestChurch",1)
		SetFavorToSim("","Destination",0)
		BuildingGetOwner("Church","Inquisitor")
		if AliasExists("Inquisitor") then
			Income = Cost * 0.1
			chr_RecieveMoney("Inquisitor",Income,"IncomeOther")
		end	

		MeasureRun("Priest","Destination","WitchKill",false)
		SetState("", STATE_LOCKEDALT, false)
		SetState("Priest", STATE_LOCKEDALT, false)
		SetState("Destination",STATE_LOCKEDALT,false)
		local MeasureID = GetCurrentMeasureID("")
		local TimeOut = mdata_GetTimeOut(MeasureID)
		SetRepeatTimer("", GetMeasureRepeatName(), TimeOut)
	end	
end

function CleanUp()
end

function AIDecision()
	return 1
end

function GetOSHData(MeasureID)
	--can be used again in:
	OSHSetMeasureRepeat("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+2",Gametime2Total(mdata_GetTimeOut(MeasureID)))
end
