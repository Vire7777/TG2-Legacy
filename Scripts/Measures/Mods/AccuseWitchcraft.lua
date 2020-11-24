-- it would have been nice to only accuse those with low faith but the AI attend church regularly regardless of class so this balancing tool has been omitted :(

function Run()
	
	if not GetInsideBuilding("","Church") then	-- returns current building 
		StopMeasure()
	end	
	
	-- Get important infos
	GetSettlement("","MyCity") -- Gets your own city
	BuildingGetCity("Church","ChurchCity") -- Gets current visited church city
	GetSettlement("Destination", "WitchCity") -- Gets the city the target is currently visiting or in (not to be confused with home city)
	BuildingGetOwner("Church","ChurchPriest") -- Gets church priest
	
	-- AliasChecks (should never happen)
	if not AliasExists("ChurchCity") then
		StopMeasure()
	end
	if not AliasExists("MyCity") then
		StopMeasure()
	end
	if not AliasExists("WitchCity") then
		StopMeasure()
	end
	
	-- Verify you are from the religion
	if SimGetReligion("")~=SimGetReligion("ChurchPriest") then
    MsgQuick("","@L_ACCUSEWITCHCRAFT_FAILURE_NOT_SAME_RELIGION")
    StopMeasure()
  end
  if SimGetReligion("")~=SimGetReligion("Destination") then
    MsgQuick("","@L_ACCUSEWITCHCRAFT_FAILURE_VICTIM_NOT_SAME_RELIGION")
    StopMeasure()
  end
  
	-- Verify everyone is from the same city
	if GetID("MyCity")~=GetID("ChurchCity") then
		MsgQuick("","@L_ACCUSEWITCHCRAFT_FAILURE_PRIEST_NOT_KNOW_YOU")
		StopMeasure()
	end
  if GetID("MyCity")~=GetID("WitchCity") then
    MsgQuick("","@L_ACCUSEWITCHCRAFT_FAILURE_VICTIM_NOT_FROM_CITY") --otherwise it takes too long for measure to finish
    StopMeasure()
  end
	
	-- Verify your faith and victim one (has to be really high)
	local yourFaith = SimGetFaith("")
	local victimFaith = SimGetFaith("Destination")
	local yourCharisma = GetSkillValue("", "CHARISMA")
	local yourRhetoric = GetSkillValue("", "RHETORIC")
  local victimCharisma = GetSkillValue("Destination", "CHARISMA")
	local priestEmpathy = GetSkillValue("ChurchPriest", "EMPATHY")
	local yourPriestFavor = GetFavorToSim("ChurchPriest", "")
  local victimPriestFavor = GetFavorToSim("ChurchPriest", "Destination")
  
  -- evidences of witchcraft
  -- local NumEvidences = 0+CutsceneCollectEvidences("","accuser","accused")
  -- local EvidenceType   = GetData("evidence0type")
  -- local EvidenceStrength  = GetData("evidence0quality")
  -- local EvidenceValue   = GetData("evidence0value")
	
	local combatOfFaith = yourFaith + yourPriestFavor + yourCharisma * 0.33 * 10 + yourRhetoric * 0.66 * 10 - victimFaith - victimPriestFavor - priestEmpathy * 0.66 * 10 - victimCharisma * 0.33 * 10
	--MsgQuick("",combatOfFaith)
	accusewitchcraft_BurnYou()
end

function ChoiceIsYours()
  if (combatOfFaith < -30) then
    feedback_MessageCharacter("",
        "@L_ACCUSEWITCHCRAFT_FAILURE_HEAD_+0",
        "@L_ACCUSEWITCHCRAFT_FAILURE_BODY_+0",GetID(""))
    AccuseWitchcraft_BurnYou()
  elseif (combatOfFaith > -30 and combatOfFaith < 30) then
    feedback_MessageCharacter("",
        "@L_ACCUSEWITCHCRAFT_FAILURE_HEAD_+0",
        "@L_ACCUSEWITCHCRAFT_FAILURE_BODY_+1",GetID(""))
    ModifyFavorToSim("Priest","",-Rand(20)-10)
    ModifyFavorToSim("Destination","",-Rand(20)-10)
    
    local MeasureID = GetCurrentMeasureID("")
    local duration = mdata_GetDuration(MeasureID)
    AddImpact("","perfume",1,duration)
    SetState("",STATE_CONTAMINATED,true)
    SetProperty("","perfume",6)
    
    StopMeasure()
  elseif (combatOfFaith > 30) then
    feedback_MessageCharacter("",
        "@L_ACCUSEWITCHCRAFT_SUCCESS_HEAD_+0",
        "@L_ACCUSEWITCHCRAFT_SUCCESS_BODY_+0",GetID(""),GetID("Destination"))
    accusewitchcraft_BurnWitch()
  end
end 

function BurnYou()
  if (GetState("",STATE_WORKING)==true) then
    SetState("",STATE_WORKING,false)
  end 
  
  MoveStop("")
  SetState("",STATE_LOCKED,true)
  Sleep(1)
  SimCreate(20, "Church", "Church", "Priest")
  
  SetState("Priest",STATE_LOCKED,true)
  f_MoveTo("Priest","",GL_MOVESPEED_WALK,10)
  AlignTo("","Priest")
  AlignTo("Priest","")
  Sleep(1) 
  
  if (SimGetGender("") == GL_GENDER_FEMALE) then
    MsgSay("Priest","@L_ACCUSEWITCHCRAFT_PRIEST_FEMALE")
  else
    MsgSay("Priest","@L_ACCUSEWITCHCRAFT_PRIEST_FEMALE")
  end 
  
  SetProperty("Church","PriestChurch",1)
  SetFavorToSim("ChurchPriest","",0)

  MeasureRun("Priest","","WitchKill",true)
  SetState("", STATE_LOCKED, false)
  SetState("Priest", STATE_LOCKED, false)
  local MeasureID = GetCurrentMeasureID("")
  local TimeOut = mdata_GetTimeOut(MeasureID)
  SetRepeatTimer("", GetMeasureRepeatName(), TimeOut)
end

function BurnWitch()
	if (GetState("Destination",STATE_WORKING)==true) then
		SetState("Destination",STATE_WORKING,false)
	end	
	SimStopMeasure("Destination")
	MoveStop("Destination")
	SetState("Destination",STATE_LOCKED,true)
	SetState("",STATE_LOCKED,true)
	GetPosition("","Spawn")
	f_MoveToNoWait("","Home")
	Sleep(2)
	MoveStop("")
	Sleep(1)
	SimCreate(20, "Church", "Spawn", "Priest")
	SetState("Priest",STATE_LOCKED,true)
	AlignTo("","Priest")
	AlignTo("Priest","")
	Sleep(1)
	if SimIsInside("Destination") then
		f_ExitCurrentBuilding("Destination")
	end	
		
	if (SimGetGender("Destination") == GL_GENDER_FEMALE) then
		MsgSay("","@L_ACCUSEWITCHCRAFT_FEMALE")
		MsgSay("Priest","@L_ACCUSEWITCHCRAFT_PRIEST_FEMALE")
	else
		MsgSay("","@L_ACCUSEWITCH_MALE")
		MsgSay("Priest","@L_ACCUSEWITCHCRAFT_PRIEST_MALE")
	end	
	
	--if DynastyIsPlayer("") then
		--SpendMoney("",Cost,"CostIndulgence")
	--end	
	SetProperty("","WitchBurner",1)
	SetProperty("Church","PriestChurch",1)
	SetFavorToSim("","Destination",0)
	--BuildingGetOwner("Church","Inquisitor")
	--if AliasExists("Inquisitor") then
		--Income = Cost * 0.1
		--chr_RecieveMoney("Inquisitor",Income,"IncomeOther")
	--end	

	MeasureRun("Priest","Destination","WitchKill",false)
	SetState("", STATE_LOCKED, false)
	SetState("Priest", STATE_LOCKED, false)
	SetState("Destination",STATE_LOCKED,false)
	local MeasureID = GetCurrentMeasureID("")
	local TimeOut = mdata_GetTimeOut(MeasureID)
	SetRepeatTimer("", GetMeasureRepeatName(), TimeOut)
end

-- not used at the moment
function PayToBurn()
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
        MsgQuick("","@L_ACCUSEWITCHCRAFT_ERROR_SEVEN")
      else
        MsgQuick("","@L_ACCUSEWITCHCRAFT_ERROR_EIGHT")
      end
      StopMeasure()
    end
  end 

  local Result = MsgNews("","","@P"..
    "@B[1,@L_REPLACEMENTS_BUTTONS_JA_+0]"..
    "@B[2,@L_REPLACEMENTS_BUTTONS_NEIN_+0]",
    accusewitchcraft_AIDecision,  --AIFunc
    "intrigue", --Message Class
    2, --TimeOut
    "@L_INTRIGUE_ACCUSEWITCHCRAFT_SCREENPLAY_ACTOR_HEAD_+0",
    "@L_INTRIGUE_ACCUSEWITCHCRAFT_SCREENPLAY_ACTOR_BODY_+0",
    GetID("Destination"),Cost)
  
  if Result ~= 1 then
    StopMeasure()
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
