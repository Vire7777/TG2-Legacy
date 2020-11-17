function Run()
	if not GetInsideBuilding("", "Base") then
		StopMeasure()
		return
	end
	
	if not BuildingGetPrisoner("Base", "Victim") then
		StopMeasure()
		return
	end
	
	if not find_HomeCity("","City") then
		StopMeasure()
	end
	
	MeasureSetNotRestartable()
	
	if (GetState("Victim", STATE_UNCONSCIOUS)) then
		SetState("Victim", STATE_UNCONSCIOUS, false)
	end
	SetState("Victim",STATE_LOCKED,true)
	BlockChar("Victim")
	
	local VictimLevel = SimGetLevel("Victim")
	local baseXP = GetData("BaseXP")
	
	--go to the prisoner and open cell
	GetLocatorByName("Base", "EntryPrisonPos", "EntryPrisonPos")
	CarryObject("", "weapons/shortsword_01.nif", false)
	
	f_MoveTo("", "EntryPrisonPos", GL_MOVESPEED_WALK, 0)
	Sleep(0.5)
	
	SetRoomAnimationTime("Base", "", "U_PrisonDoor", 0)
	StartRoomAnimation("Base", "", "U_PrisonDoor")
	Sleep(1)
	StopRoomAnimation("Base", "", "U_PrisonDoor")
	
	AlignTo("", "Victim")
	AlignTo("Victim", "")
	
	GetPosition("Victim", "VictimPos")
	
	SimSetBehavior("Victim", "")
	feedback_OverheadActionName("")
	
	
	MsgSay("", "@L_KILLHIJACKED_AGGRESSOR")
	MsgSay("Victim", "@L_KILLHIJACKED_VICTIM")
	Sleep(1)
	StopAnimation("")
	
	local MeasureID = GetCurrentMeasureID("")
	local TimeOut = mdata_GetTimeOut(MeasureID)
	SetRepeatTimer("Base", GetMeasureRepeatName(), TimeOut)
	
	--bye now, you are dead!
	
	local Bounty = 0
	if GetImpactValue("Victim","REVOLT")==0 then
		CommitAction("murder","","Victim","Victim")
	else
		Bounty = Rand(125) + VictimLevel * 750
	end
	
	PlayAnimationNoWait("", "finishing_move_01")
	Sleep(0.6)
	StartSingleShotParticle("particles/bloodsplash.nif", "VictimPos", 1, 4)
	PlaySound3DVariation("Victim", "Effects/combat_strike_mace", 1)
	Sleep(2)
	CarryObject("", "", false)
	
	StopAction("murder", "")
	
	if Bounty == 0 then 	--- Mord!
	
		feedback_MessageCharacter("","@L_BATTLE_FIGHTKILL_MSG_SUCCESS_OWNER_HEAD_+0",
			"@L_HijackedKILL_MSG_SUCCESS_OWNER_BODY_+0",GetID("Victim"))
		
		if not HasProperty("Victim","MessageRecieved") then
			SetProperty("Victim","MessageRecieved",1)
			MsgNewsNoWait("Victim","","","intrigue",-1,
				"@L_BATTLE_FIGHTKILL_MSG_SUCCESS_VICTIM_HEAD_+0",
				"@L_HijackedKILL_MSG_SUCCESS_VICTIM_BODY_+0",GetID("Victim"),GetID(""),Bounty)
		end
			
	else --- kein Mord!
		
		feedback_MessageCharacter("","@L_BATTLE_FIGHTKILL_MSG_SUCCESS_OWNER_HEAD_+0",
			"@L_HijackedKILL_MSG_SUCCESS_OWNER_BODY_+1",GetID("Victim"))
			
		if not HasProperty("Victim","MessageRecieved") then
			SetProperty("Victim","MessageRecieved",1)
			MsgNewsNoWait("Victim","","","intrigue",-1,
				"@L_BATTLE_FIGHTKILL_MSG_SUCCESS_VICTIM_HEAD_+0",
				"@L_HijackedKILL_MSG_SUCCESS_VICTIM_BODY_+1",GetID(""))
		end
	end
			
	if Bounty > 0 then
		MsgSay("", "@L_KILLHIJACKED_AGGRESSOR_ALT")
		wait(0.35)
		chr_RecieveMoney("", Bounty, "IncomeOther")
	else
		MsgSay("", "@L_KILLHIJACKED_AGGRESSOR_TWO")
	end
			
	baseXP = baseXP * VictimLevel
	chr_GainXP("",baseXP)
	SetFavorToSim("","Victim",0)
	SetProperty("Victim","UnconsciousKill",1)
	Kill("Victim")
end
		
function CleanUp()
end
		
function GetOSHData(MeasureID)
	--can be used again in:
	OSHSetMeasureRepeat("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+2",Gametime2Total(mdata_GetTimeOut(MeasureID)))
end