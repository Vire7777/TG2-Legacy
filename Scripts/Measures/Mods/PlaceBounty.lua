function Run()
  AddImpact("","BountyHunt",3,12)
  SetState("",STATE_CONTAMINATED,true)
end

function toto()
	-- calculate how much money we have (the beginning is a bug fix, surely from McCoy)
  local MyMoney = 0
  if HasProperty("","BugFix") and not DynastyIsPlayer("") then
    GetDynasty("", "Madynasty")
    DynastyGetFamilyMember("Madynasty",0,"DaBoss")
    MyMoney = GetMoney("DaBoss")
  else
    MyMoney = GetMoney("")
  end
  
  -- Calculate how much the target is worth
  local targetWealth = SimGetWealth("Destination") 
  local targetTitle = GetNobilityTitle("Destination")
  local TitleCost = targetTitle * 100
  
  -- Take office in consideration
  local Level = {}
    Level[-1] = 0
    Level[1] = 500
    Level[2] = 1000
    Level[3] = 1500
    Level[4] = 2000
    Level[5] = 2500
    Level[6] = 3000
    Level[7] = 5000
    
  local targetOffice = SimGetOfficeLevel("Destination")
  local OfficeCost = Level[targetOffice]
  
  -- Sum everything together
  local PowerCost = TitleCost + OfficeCost + targetWealth  
  
  -- Calculation depends on difficulty level
  local Difficulty = ScenarioGetDifficulty()
  local Choice = {}
  Choice[1] = PowerCost * 0.25 * (Difficulty+1)
  Choice[2] = PowerCost * 0.5 * (Difficulty+1)
  Choice[3] = PowerCost * 1 * (Difficulty+1)
  
  -- if not enough money even for a small bounty
  if MyMoney < Choice[1] then
    MsgQuick("","@L_MEASURE_PLACEBOUNTY_FAILURES_+0")
    StopMeasure()
  end
  
  -- show the bounty choices
  local panel
  if MyMoney >= Choice[3] then
        panel = ("@P"..
        "@B[1,@L_INTRIGUE_041_BRIBECHARACTER_SCREENPLAY_ACTOR_CHOICE_+0,@L_INTRIGUE_041_BRIBECHARACTER_SCREENPLAY_ACTOR_CHOICE_+0,Hud/Buttons/btn_Money_Small.tga]"..
    "@B[2,@L_INTRIGUE_041_BRIBECHARACTER_SCREENPLAY_ACTOR_CHOICE_+1,@L_INTRIGUE_041_BRIBECHARACTER_SCREENPLAY_ACTOR_CHOICE_+1,Hud/Buttons/btn_Money_Medium.tga]"..
    "@B[3,@L_INTRIGUE_041_BRIBECHARACTER_SCREENPLAY_ACTOR_CHOICE_+2,@L_INTRIGUE_041_BRIBECHARACTER_SCREENPLAY_ACTOR_CHOICE_+2,Hud/Buttons/btn_Money_Large.tga]")
  elseif MyMoney >= Choice[2] then
        panel = ("@P"..
        "@B[1,@L_INTRIGUE_041_BRIBECHARACTER_SCREENPLAY_ACTOR_CHOICE_+0,@L_INTRIGUE_041_BRIBECHARACTER_SCREENPLAY_ACTOR_CHOICE_+0,Hud/Buttons/btn_Money_Small.tga]"..
    "@B[2,@L_INTRIGUE_041_BRIBECHARACTER_SCREENPLAY_ACTOR_CHOICE_+1,@L_INTRIGUE_041_BRIBECHARACTER_SCREENPLAY_ACTOR_CHOICE_+1,Hud/Buttons/btn_Money_Medium.tga]")
  else
    panel = ("@P"..
        "@B[1,@L_INTRIGUE_041_BRIBECHARACTER_SCREENPLAY_ACTOR_CHOICE_+0,@L_INTRIGUE_041_BRIBECHARACTER_SCREENPLAY_ACTOR_CHOICE_+0,Hud/Buttons/btn_Money_Small.tga]")
  end
  
  MsgMeasure("","")
  
  -- Make the choice
  local BountyPower = InitData(panel,
  PlaceBounty_AIInitPlaceBounty,
  "@L_MEASURE_PLACEBOUNTY_SCREENPLAY_ACTOR_HEAD_+0",
  "@L_MEASURE_PLACEBOUNTY_SCREENPLAY_ACTOR_BODY_+0",
  GetID("Destination"),Choice[1],Choice[2],Choice[3])

  -- calculate the time of the bounty hunt
  local MeasureID = GetCurrentMeasureID("") 
  local duration = mdata_GetDuration(MeasureID)
  if BountyPower == 1 then
    duration = duration*0.5
  elseif BountyPower == 2 then
    duration = duration*1
  elseif BountyPower == 3 then
    duration = duration*1.5
  else
    StopMeasure()
  end
  
  SpendMoney("",Choice[BountyPower],"CostBounty")
  
  -- Finally create the impact on the target
  AddImpact("Destination","BountyHunt",BountyPower,duration)
  SetState("Destination",STATE_CONTAMINATED,true)
  
  -- You did it
  feedback_MessageCharacter("",
    "@L_MEASURE_PLACEBOUNTY_SUCCESS_HEAD_+0",
    "@L_MEASURE_PLACEBOUNTY_SUCCESS_BODY_+0",GetID("Destination"))
    
  StopMeasure()
end	

function AIInitPlaceBounty()
  --AI decides how much money to spend
  local Favor = GetFavorToSim("","Destination")
  local SpendFactor = 1
  
  -- depends how much they hate you
  if Favor < 25 then
    SpendFactor = SpendFactor + 2
  elseif Favor < 50 then
    SpendFactor = SpendFactor + 1
  end
  
  return SpendFactor
end

function CleanUp()
end
