-------------------------------------------------------------------------------
----
----	OVERVIEW "state_pregnant.lua"
----
----	This state is set while a sim is pregnant
----
-------------------------------------------------------------------------------

-- -----------------------
-- Init
-- -----------------------
function Init()
end

-- -----------------------
-- Run
-- -----------------------
function Run()

	if not IsType("", "Sim") then
		SetState("", STATE_PREGNANT, false)
		return
	end

	-- Block the locator
	if not GetInsideBuilding("", "Residence") then
		SetState("", STATE_PREGNANT, false)
		return
	end

	StopAllAnimations("")

	if not GetLocatorByName("Residence", "Cohabit2", "CohabitPos2") then
		return false
	end

	f_BeginUseLocator("", "CohabitPos2", GL_STANCE_LAY)
	PlayAnimation("","sickinbed_idle_in")
	LoopAnimation("","sickinbed_idle_01",-1)
	local Options = FindNode("\\Settings\\Options")
	local X = Options:GetValueInt("YearsPerRound")
	local MaxProgress = {}
		MaxProgress[1] = 1080
		MaxProgress[2] = 540
		MaxProgress[3] = 360
		MaxProgress[4] = 270
	
	SetProcessMaxProgress("",MaxProgress[X])
	SetProcessProgress("",0)
	local SleepTime = 0
	--Sleep(SleepTime)
	Sleep(3)
	PlayAnimation("","sickinbed_idle_out")
	StopAllAnimations("")
	f_EndUseLocator("", "CohabitPos2", GL_STANCE_STAND)
	while SleepTime < MaxProgress[X] do
		Sleep(5)
		SleepTime = SleepTime + 5
		SetProcessProgress("",SleepTime)
	end
	ResetProcessProgress("")
	SimGetSpouse("", "Father")

	MeasureCreate("Measure")

	if( HasProperty("","ForceChildGender") )then
		chr_CreateChild("Residence", "", "Father", 0, "NewBorn", GetProperty("","ForceChildGender"))
		RemoveProperty("","ForceChildGender")
		SimSetFirstname("NewBorn", GetProperty("","ForceChildName"))
		RemoveProperty("","ForceChildName")
		MeasureAddAlias("Measure","SetName","",false)
	else
		chr_CreateChild("Residence", "", "Father", 0, "NewBorn")
		-- start set child name measure
--		MeasureRun("NewBorn","","SetChildName")		
	end
	
	MeasureStart("Measure","NewBorn","","SetChildName")	
	SetData("GetUp",1)
	gameplayformulas_StartHighPriorMusic(MUSIC_BIRTH)
	

end

-- -----------------------
-- CleanUp
-- -----------------------
function CleanUp()
	ResetProcessProgress("")
end

