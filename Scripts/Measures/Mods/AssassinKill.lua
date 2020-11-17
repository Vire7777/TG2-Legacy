function Run()
	SetState("", STATE_LOCKED, true)
	Find("Destination", "__F((Object.GetObjectsOfWorld(Sim))AND(Object.HasProperty(Ident1)))","Player", 1)
	RemoveProperty("Player","Ident1")
	f_Follow("","Destination", GL_MOVESPEED_RUN, 20, true)	
	GetHomeBuilding("Destination","Home")
	f_MoveToNoWait("", "Home")
	if SimGetGender("Destination")==GL_GENDER_MALE then
		feedback_MessageCharacter("Player",
			"@L_GENERAL_MEASURES_Assassin_HEAD_+0",
			"@L_GENERAL_MEASURES_Assassin_BODY_+0",GetID("Destination"))
		feedback_MessageCharacter("Destination",
			"@L_GENERAL_MEASURES_Assassin_HEAD_+2",
			"@L_GENERAL_MEASURES_Assassin_BODY_+2",GetID("Destination"))
	else
		feedback_MessageCharacter("Player",
			"@L_GENERAL_MEASURES_Assassin_HEAD_+1",
			"@L_GENERAL_MEASURES_Assassin_BODY_+1",GetID("Destination"))
		feedback_MessageCharacter("Destination",
			"@L_GENERAL_MEASURES_Assassin_HEAD_+2",
			"@L_GENERAL_MEASURES_Assassin_BODY_+2",GetID("Destination"))
	end
	Sleep(5.5)
	SetState("Destination", STATE_DYING, true)
	Sleep(3)
	MoveStop("")
	GetPosition("","Position")
	StartSingleShotParticle("particles/big_crash.nif", "Position",5,3)
	Sleep(2)
	InternalDie("")
	InternalRemove("")
end	

function CleanUp()
end
