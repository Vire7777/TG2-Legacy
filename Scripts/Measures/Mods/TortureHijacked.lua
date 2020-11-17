function Run()  
 	if not GetInsideBuilding("", "Base") then
        MsgQuick("", "@L_TORTUREHIJACKED_ERROR_ONE")
		StopMeasure()
  	end

	if not BuildingGetPrisoner("Base", "Victim") then
		StopMeasure()
  	end

	if (GetState("Victim", STATE_UNCONSCIOUS)) then
    	MsgQuick("", "@L_TORTUREHIJACKED_ERROR_TWO")
		StopMeasure()
    end
    
   	--go to the prisoner and open cell
	GetLocatorByName("Base", "EntryPrisonPos", "EntryPrisonPos")
    CarryObject("", "weapons/club_01.nif", false)

	f_MoveTo("", "EntryPrisonPos", GL_MOVESPEED_WALK, 0)
	Sleep(0.5)
	
	SetRoomAnimationTime("Base", "", "U_PrisonDoor", 0)
	StartRoomAnimation("Base", "", "U_PrisonDoor")
	Sleep(1)
	StopRoomAnimation("Base", "", "U_PrisonDoor")

	AlignTo("", "Victim")
	AlignTo("Victim", "")
	
    feedback_OverheadActionName("")
	
	Sleep(1)
	PlayAnimationNoWait("","propel")
	SetProperty("Victim","GettingTortured",1)
	SimSetBehavior("Victim","")
	Sleep(1)
	StopAnimation("Victim")
	
 	BlockChar("Victim")
	
    if Rand (2) == 1 then 
	MsgSay("","@L_TORTUREHIJACKED_SPEECH_THREE")
	else
	MsgSay("","@L_TORTUREHIJACKED_SPEECH_FOUR")
	end
	
   	local MeasureID = GetCurrentMeasureID("")
	local TimeOut = mdata_GetTimeOut(MeasureID)
	SetRepeatTimer("Base", GetMeasureRepeatName(), TimeOut)
	   
	if GetLocatorByName("Base", "", "TorturePosition") then
		if not f_MoveTo("","TorturePosition") then
			StopMeasure()
		end
	end
	
	SetData("FinallyReached",1)
	SetData("PositionModified",1)
	PositionModify("TorturePosition",0,70,0)

	for i=1,4 do
		PlayAnimationNoWait("Victim","torture_victim")
		PlayAnimation("","torture")
     end
	
	CarryObject("","",false)
	PositionModify("TorturePosition",0, -70,0)	
	SetData("PositionModified",0)
	
	local Random = Rand(11)
	if Random == 0 then
		Evidence = 1
	elseif Random == 1 then
		Evidence = 4
	elseif Random == 2 then
		Evidence = 7
	elseif Random == 3 then
		Evidence = 10
	elseif Random == 4 then
		Evidence = 11
	elseif Random == 5 then
		Evidence = 12
	elseif Random == 6 then
		Evidence = 13
	elseif Random == 7 then
		Evidence = 14
	elseif Random == 8 then
		Evidence = 15
 	else
		Evidence = 18
	end
	
	local ActualHP = GetHP("Victim")
	ModifyHP("Victim",-(ActualHP/3),true)
	Sleep(0.5)
	
	chr_ModifyFavor("Victim","",-15)
	
	if CheckSkill("Victim",1,5) then
		chr_GainXP("",GetData("BaseXP"))
		
		while true do
		ScenarioGetRandomObject("cl_Sim","CurrentRandomSim")
		if not GetDynasty("CurrentRandomSim","CDynasty") then
		CopyAlias("CurrentRandomSim","EvidenceVictim")
		break
		end
		end
			
		if Rand (100) > 50
		then
		AddEvidence("","Victim","",Evidence)
		local ich = 1
        else
		AddEvidence("","Victim","EvidenceVictim",Evidence)
		local ich = 0
		end

		if Rand (2) == 1
		then
		MsgSay("Victim","@L_TORTUREHIJACKED_SPEECH_FIVE")
        Sleep(0.3)
		MsgSay("","@L_TORTUREHIJACKED_SPEECH_SIX")
		else
		MsgSay("Victim","@L_TORTUREHIJACKED_SPEECH_SEVEN")
        Sleep(0.3)
		MsgSay("","@L_TORTUREHIJACKED_SPEECH_EIGHT")
		end

 		if ich == 1 then
        MsgNewsNoWait("Victim","","","intrigue",-1,
						"@L_PRIVILEGES_105_TORTURECHARACTER_MESSAGES_VICTIM_SUCCESS_HEAD_+0",
						"@L_TORTUREHIJACKED_MESSAGES_VICTIM_SUCCESS_BODY_+0",GetID(""))
		MsgNewsNoWait("","Victim","","intrigue",-1,
						"@L_PRIVILEGES_105_TORTURECHARACTER_MESSAGES_OWNER_SUCCESS_HEAD_+0",
						"@L_TORTUREHIJACKED_MESSAGES_OWNER_SUCCESS_BODY_+0",GetID("Victim"))
	    else

		MsgNewsNoWait("Victim","","","intrigue",-1,
						"@L_PRIVILEGES_105_TORTURECHARACTER_MESSAGES_VICTIM_SUCCESS_HEAD_+0",
						"@L_TORTUREHIJACKED_MESSAGES_VICTIM_SUCCESS_BODY_+1",GetID(""))
		MsgNewsNoWait("","Victim","","intrigue",-1,
						"@L_PRIVILEGES_105_TORTURECHARACTER_MESSAGES_OWNER_SUCCESS_HEAD_+0",
						"@L_TORTUREHIJACKED_MESSAGES_OWNER_SUCCESS_BODY_+1",GetID("Victim"))
		end

	else
        
		if Rand (2) == 1
		then
		MsgSay("Victim","@L_TORTUREHIJACKED_SPEECH_NINE")
        Sleep(0.3)
		MsgSay("","@L_TORTUREHIJACKED_SPEECH_TEN")
		else
		MsgSay("Victim","@L_TORTUREHIJACKED_SPEECH_ELEVEN")
        Sleep(0.3)
		MsgSay("","@L_TORTUREHIJACKED_SPEECH_TWELVE")
		end

		MsgNewsNoWait("Victim","","","intrigue",-1,
						"@L_PRIVILEGES_105_TORTURECHARACTER_MESSAGES_VICTIM_FAILED_HEAD_+0",
						"@L_TORTUREHIJACKED_MESSAGES_VICTIM_FAILED_BODY_+0",GetID(""))
		MsgNewsNoWait("","Victim","","intrigue",-1,
						"@L_PRIVILEGES_105_TORTURECHARACTER_MESSAGES_OWNER_FAILED_HEAD_+0",
						"@L_TORTUREHIJACKED_MESSAGES_OWNER_FAILED_BODY_+0",GetID("Victim"))
		
	end
   
    StartRoomAnimation("Base","","U_PrisonDoor")
	Sleep(1.3)
	StopRoomAnimation("Base","","U_PrisonDoor")
	SetRoomAnimationTime("Base","","U_PrisonDoor",0)
	  
	StopMeasure()
 
end	  
function CleanUp()
	StopAnimation("")
	if AliasExists("Victim") then
        StopAnimation("Victim")
        MeasureRun("", "", "Hijack")
	end
end

function GetOSHData(MeasureID)
	--can be used again in:
	OSHSetMeasureRepeat("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+2",Gametime2Total(mdata_GetTimeOut(MeasureID)))
end

