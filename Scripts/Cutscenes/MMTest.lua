function Go()

	GetInsideBuilding("protagonist","building")
	CutsceneAddSim("","protagonist")
	CutsceneAddSim("","antagonist")

	BuildingLockForCutscene("building","")
	--CutsceneCameraCreate("","building")
	
	CutsceneCameraCreate("","building")
	CutsceneCameraSetRelativePosition("","CameraPortrait","protagonist")

--	if not GetSettlement("protagonist", "my_settlement") then
--		return	
--	end
--	CityScheduleCutsceneEvent("my_settlement","duel_date","","Event1",6,6,"@L_DUELL_6_TIMEPLANNERENTRY_DATEBOOK_+0",GetID("protagonist"),GetID("protagonist"))	-- hourofday=7,mintimeinfuture=2
--	CityScheduleCutsceneEvent("my_settlement","duel_date","","Event2",6,6,"@L_DUELL_6_TIMEPLANNERENTRY_DATEBOOK_+0",GetID("protagonist"),GetID("protagonist"))	-- hourofday=7,mintimeinfuture=2
	
	Sleep(5.0)
	SetProperty("protagonist","CutsceneBribe",1)
	Sleep(5.0)
	RemoveProperty("protagonist","CutsceneBribe")
	Sleep(5.0)

--	TrialHUDSetStatus(0,0,0,0,-1,0)
--	Sleep(5.0)
--	TrialHUDSetStatus(0,0,0,0,5,1)
--	Sleep(5.0)

--	TrialHUDSetStatus(24,24,24,24,5,1)
--	Sleep(5.0)

--	TrialHUDSetStatus(24,23,24,24,5,1)
--	Sleep(3.0)
--	TrialHUDSetStatus(24,23,24,23,5,1)
--	Sleep(3.0)
--	TrialHUDSetStatus(24,24,24,23,5,1)
--	Sleep(3.0)

--	local i
--	local v = 2
--	for i=0,24 do
---		v = i
--		TrialHUDSetStatus(i,v+Rand(11)-5,v+Rand(11)-5,v+Rand(11)-5,5,5)
--		Sleep(2.0)
--	end
--	Sleep(5)

	EndCutscene("")
end

function Event1()
	OutputDebugString("Event1\n")
end

function Event2()
	OutputDebugString("Event2\n")
end

function UpdatePanel()
	OfficeApplicationHUDSetCandidates("",-1,GetID("protagonist"),GetID("antagonist"),-1,-1)
	OfficeApplicationHUDAddVoter("",GetID("protagonist"),GetID("protagonist"))
	OfficeApplicationHUDAddVoter("",GetID("antagonist"),GetID("antagonist"))
end

function CleanUp()
	BuildingLockForCutscene("building",0)
	DestroyCutscene("")
--	OutputDebugString("END\n")
end

function OnCameraEnable()
	CutsceneHUDShow("","LetterBoxPanel")
	CutsceneHUDShow("","OfficeApplicationPanel")
	mmtest_UpdatePanel()
end

function OnCameraDisable()
	CutsceneHUDShow("","LetterBoxPanel",false)
	CutsceneHUDShow("","OfficeApplicationPanel",false)
end
