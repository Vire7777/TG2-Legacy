-- it would have been nice to only accuse those with low faith but the AI attend church regularly regardless of class so this balancing tool has been omitted :(

function Run()
	if not GetInsideBuilding("","Church") then	-- returns current building 
		StopMeasure()
	end	
	
	-- Get important infos
	GetSettlement("","MyCity") -- Gets your own city
	BuildingGetCity("Church","ChurchCity") -- Gets current visited church city
	GetSettlement("Destination", "WitchCity") -- Gets the city the target is currently visiting or in (not to be confused with home city)
	BuildingGetOwner("Church","ChurchOwner") -- Gets church priest
	
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
	if SimGetReligion("")~=SimGetReligion("ChurchOwner") then
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
	local priestEmpathy = GetSkillValue("ChurchOwner", "EMPATHY")
	local yourPriestFavor = GetFavorToSim("ChurchOwner", "")
  local victimPriestFavor = GetFavorToSim("ChurchOwner", "Destination")
  
  -- Not implemented yet. Need to find a way to rework the evidence system
  -- evidences of witchcraft
  -- local NumEvidences = 0+CutsceneCollectEvidences("","accuser","accused")
  -- local EvidenceType   = GetData("evidence0type")
  -- local EvidenceStrength  = GetData("evidence0quality")
  -- local EvidenceValue   = GetData("evidence0value")
	
	-- Calculate the amount of the different parameters
	local combatOfFaith = yourFaith + yourPriestFavor + yourCharisma * 0.33 * 10 + yourRhetoric * 0.66 * 10 - victimFaith - victimPriestFavor - priestEmpathy * 0.66 * 10 - victimCharisma * 0.33 * 10
	combatOfFaith = combatOfFaith / 4
	
  -- let s see who won
  local MeasureID = GetCurrentMeasureID("") 
  if (combatOfFaith < -30) then
    -- you lost and you will burn
    accusewitchcraft_AccuserBurn()
  elseif (combatOfFaith > 30) then
    -- you won and the victim would burn in hell
    accusewitchcraft_AccusedBurn()
  elseif (combatOfFaith > -30 and combatOfFaith < 0) then
    -- you lost and the priest is angry
    accusewitchcraft_BecomeABlackSheep()
  else
    -- you lost and the priest is not too angry
    accusewitchcraft_PriestNotConvinced()
  end
    
  local TimeOut = mdata_GetTimeOut(MeasureID)
  SetRepeatTimer("", GetMeasureRepeatName(), TimeOut)
end 

function AccuserBurn()
  feedback_MessageCharacter("",
    "@L_ACCUSEWITCHCRAFT_FAILURE_HEAD_+0",
    "@L_ACCUSEWITCHCRAFT_FAILURE_BODY_+0",GetID(""))
  ModifyFavorToSim("Destination","",-Rand(20)-20)
  SimCreate(20, "Church", "Church", "Priest")
  MeasureRun("Priest","","WitchKill",true)
end

function AccusedBurn()
  feedback_MessageCharacter("",
    "@L_ACCUSEWITCHCRAFT_SUCCESS_HEAD_+0",
    "@L_ACCUSEWITCHCRAFT_SUCCESS_BODY_+0",GetID(""),GetID("Destination"))
  ModifyFavorToSim("Destination","",-Rand(20)-20)
  SimCreate(20, "Church", "Church", "Priest")
  MeasureRun("Priest","Destination","WitchKill",true)
end

function BecomeABlackSheep()
  feedback_MessageCharacter("",
    "@L_ACCUSEWITCHCRAFT_FAILURE_HEAD_+0",
    "@L_ACCUSEWITCHCRAFT_FAILURE_BODY_+1",GetID(""))
  ModifyFavorToSim("Priest","",-Rand(10)-5)
  ModifyFavorToSim("Destination","",-Rand(10)-10)
  
  local duration = mdata_GetDuration(MeasureID)
  AddImpact("","BlackSheep",1,duration)
  SetState("",STATE_CONTAMINATED,true)
end

function PriestNotConvinced()
  feedback_MessageCharacter("",
    "@L_ACCUSEWITCHCRAFT_FAILURE_HEAD_+0",
    "@L_ACCUSEWITCHCRAFT_FAILURE_BODY_+1",GetID(""))
  ModifyFavorToSim("Priest","",-Rand(5)-5)
  ModifyFavorToSim("Destination","",-Rand(10)-5)
end
function GetOSHData(MeasureID)
	--can be used again in:
	OSHSetMeasureRepeat("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+2",Gametime2Total(mdata_GetTimeOut(MeasureID)))
end

function CleanUp()
end
