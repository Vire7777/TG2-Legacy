function Run()
  GetInsideBuilding("","Church")
  
  -- lock both people
  SetState("", STATE_LOCKED, true)
  SetState("Destination", STATE_LOCKED, true)
  
  -- Priest go to "Destination"
  MoveStop("Destination")
  f_MoveTo("","Destination",GL_MOVESPEED_RUN,10)
  
  AlignTo("","Destination")
  AlignTo("Destination","")
  Sleep(1) 
  
  -- accuse "Destination" of witchcraft
  if (SimGetGender("Destination") == GL_GENDER_FEMALE) then
    MsgSay("","@L_ACCUSEWITCHCRAFT_PRIEST_FEMALE")
  else
    MsgSay("","@L_ACCUSEWITCHCRAFT_PRIEST_FEMALE")
  end 
  
  -- Sort the fork
  CarryObject("","Handheld_Device/ANIM_Pitchfork.nif",false)
  Sleep(1)
  
  -- Threat the "Destination"
  PlayAnimationNoWait("","threat")
  PlayAnimation("Destination","shake_head")
  
  if (SimGetGender("Destination") == GL_GENDER_FEMALE) then
    MsgSay("","@L_ACCUSEWITCHCRAFT_FEMALE")
  else
    MsgSay("","@L_ACCUSEWITCHCRAFT_MALE")
  end
  
  MoveSetActivity("Destination","arrested")
  Sleep(2)
  
  -- Move to execution place
  BuildingGetCity("Church","ChurchCity")
  CityGetRandomBuilding("ChurchCity",GL_BUILDING_CLASS_PUBLICBUILDING,GL_BUILDING_TYPE_EXECUTIONS_PLACE,-1,-1,FILTER_IGNORE,"DestExecPlace")
  
  f_FollowNoWait("", "Destination", GL_MOVESPEED_WALK,10)
  f_MoveTo("Destination","DestExecPlace",GL_MOVESPEED_WALK)

  -- take the torch out and throw
  AlignTo("Destination","")
  Sleep(5)
  
  CarryObject("", "Handheld_Device/ANIM_torchparticles.nif", false)
  MsgSay("","@L_ACCUSEWITCHCRAFT_PRIEST")
  MsgSay("Destination","@L_ACCUSEWITCHCRAFT_VICTIM")
  PlayAnimationNoWait("", "throw")
  Sleep(2.03)
  
  -- launch the torches
  local tDuration = ThrowObject("", "Destination", "Handheld_Device/ANIM_torchparticles.nif",0.1,"torch",30,150,0)
  Sleep(0.13)
  
  CarryObject("", "" ,false)
  Sleep(tDuration)
  
  GetPosition("Destination","Position")
  StartSingleShotParticle("particles/bonfire.nif","Position",2,5)
  Sleep(2)
  
  MsgSayNoWait("","@L_ACCUSEWITCHCRAFT_PRIEST_TWO")
  PlayAnimationNoWait("","threat")
  StartSingleShotParticle("particles/bonfire.nif","Position",5,7)
  
  -- Victim message
  feedback_MessageCharacter("Destination",
    "@L_GENERAL_MEASURES_ACCUSEWITCHCRAFT_HEAD_+0",
    "@L_GENERAL_MEASURES_ACCUSEWITCHCRAFT_BODY_+1",GetID("Destination"))
    
  -- unlock of characters
  SetState("", STATE_LOCKED, false)
  SetState("Destination",STATE_LOCKED,false)
  
  -- Make Priest Disappear
  CreateScriptcall("KillPriest",1,"Measures/Mods/WitchKill.lua","RemovePriest","",nil)
  
  -- Kill "Destination"
  Kill("Destination")
end

function RemovePriest()
  InternalDie("")
  InternalRemove("")
end 

function CleanUp()
end
