function Run()
  
	SetState("", STATE_LOCKED, true)
	SetState("Destination",STATE_LOCKED,true)
	
	GetInsideBuilding("","Church")
	RemoveProperty("Church","PriestChurch")
	
	-- Sort the fork
	CarryObject("","Handheld_Device/ANIM_Pitchfork.nif",false)
	
	AlignTo("Destination","")
  AlignTo("","Destination")
  Sleep(1)
  
  -- Threat the victim
	PlayAnimationNoWait("","threat")
	PlayAnimation("Destination","shake_head")
  
	if (SimGetGender("Destination") == GL_GENDER_FEMALE) then
		MsgSay("","@L_WITCHKILL_FEMALE")
	else
		MsgSay("","@L_WITCHKILL_MALE")
	end
	
	MoveSetActivity("Destination","arrested")
  Sleep(2)
  
  -- Move to execution place
	BuildingGetCity("Church","City")
	CityGetRandomBuilding("City",GL_BUILDING_CLASS_PUBLICBUILDING,GL_BUILDING_TYPE_EXECUTIONS_PLACE,-1,-1,FILTER_IGNORE,"DestExecPlace")
	GetOutdoorMovePosition("","DestExecPlace","ExecPos")

	f_FollowNoWait("", "Destination", GL_MOVESPEED_WALK,10)
	f_MoveTo("Destination","ExecPos")
	Sleep(1)
	
	-- take the torch out
	AlignTo("","Destination")
  AlignTo("Destination","")
  
	CarryObject("", "Handheld_Device/ANIM_torchparticles.nif", false)
	MsgSay("","@L_WITCHKILL_PRIEST")
	Sleep(1)
	
	-- victim screams
	MsgSay("Destination","@L_WITCHKILL_VICTIM")
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
	
	MsgSayNoWait("","@L_WITCHKILL_PRIEST_TWO")
	PlayAnimationNoWait("","threat")
	StartSingleShotParticle("particles/bonfire.nif","Position",5,7)
	
	-- Victim finally burns
	feedback_MessageCharacter("Destination",
		"@L_GENERAL_MEASURES_ACCUSEWITCHCRAFT_HEAD_+0",
		"@L_GENERAL_MEASURES_ACCUSEWITCHCRAFT_BODY_+1",GetID(""))
	SetState("", STATE_LOCKED, false)
	SetState("Destination",STATE_LOCKED,false)
	CarryObject("", "" ,true)
	CreateScriptcall("KillPriest",1,"Measures/Mods/WitchKill.lua","RemovePriest","",nil)
	Kill("Destination")
end

function CleanUp()
end

function RemovePriest()
	InternalDie("")
	InternalRemove("")
end	
