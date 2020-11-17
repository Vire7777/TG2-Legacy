function Run()
	SetState("", STATE_LOCKED, true)
	SetState("Destination",STATE_LOCKED,true)
	Find("", "__F((Object.GetObjectsOfWorld(Sim))AND(Object.MinAge(16))AND(Object.HasProperty(WitchBurner)))","Dude", 1)
	if not AliasExists("Dude") then
		InternalDie("")
		InternalRemove("")
		StopMeasure()
	end
	if not BuildingGetCity("Church","City") then
		InternalDie("")
		InternalRemove("")
		StopMeasure()
	end
	RemoveProperty("Dude","WitchBurner")
	GetHomeBuilding("Destination","HomeB") --No check required on this Alias because if there is an error the Alias is very unique and easy to find
	Find("HomeB", "__F((Object.GetObjectsOfWorld(Building))AND(Object.HasProperty(PriestChurch)))","Church", 1)
	RemoveProperty("Church","PriestChurch")
	CarryObject("","Handheld_Device/ANIM_Pitchfork.nif",false)
	f_MoveTo("","Destination",GL_MOVESPEED_RUN)
	f_MoveToNoWait("","Church")
	Sleep(2.5)
	MoveStop("")
	f_MoveToNoWait("","Destination")
	Sleep(0.5)
	MoveStop("")
	AlignTo("Destination","")
	Sleep(1)
	PlayAnimationNoWait("","threat")
	PlayAnimation("Destination","shake_head")
	
	if (Gender == GL_GENDER_FEMALE) then
		MsgSay("","@L_WITCHKILL_FEMALE")
	else
		MsgSay("","@L_WITCHKILL_MALE")
	end
	
	CityGetRandomBuilding("City", -1, GL_BUILDING_TYPE_EXECUTIONS_PLACE, -1, -1, FILTER_IGNORE, "ExecutionPlace")
	GetLocatorByName("ExecutionPlace","executionPlace","ExecPos")
	MoveSetActivity("Destination","arrested")
	Sleep(2)
	f_MoveToNoWait("","ExecPos")
	f_MoveTo("Destination","ExecPos")
	f_MoveToNoWait("","Church")
	Sleep(4)
	MoveStop("")
	f_MoveToNoWait("","Destination")
	Sleep(1)
	MoveStop("")
	CarryObject("", "Handheld_Device/ANIM_torchparticles.nif", false)
	MsgSay("","@L_WITCHKILL_PRIEST")
	Sleep(1)
	MsgSay("Destination","@L_WITCHKILL_VICTIM")
	PlayAnimationNoWait("", "throw")
	Sleep(2.03)
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
	if AliasExists("Dude") then
		feedback_MessageCharacter("Dude",
			"@L_GENERAL_MEASURES_AccuseWitch_HEAD_+0",
			"@L_GENERAL_MEASURES_AccuseWitch_BODY_+0",GetID("Destination"))
	end
	
	feedback_MessageCharacter("Destination",
		"@L_GENERAL_MEASURES_AccuseWitch_HEAD_+0",
		"@L_GENERAL_MEASURES_AccuseWitch_BODY_+1",GetID(""))
	SetState("", STATE_LOCKED, false)
	SetState("Destination",STATE_LOCKED,false)
	CarryObject("", "" ,true)
	CreateScriptcall("KillPriest",1,"Measures/Mods/WitchKill.lua","RemovePriest","",nil)
    f_MoveToNoWait("","Church")
	Kill("Destination")
end

function CleanUp()
end

function RemovePriest()
	InternalDie("")
	InternalRemove("")
end	
