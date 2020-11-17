function Run()

	local MeasureID = GetCurrentMeasureID("")
	local duration = mdata_GetDuration(MeasureID)
	local TimeOut = mdata_GetTimeOut(MeasureID)
	local OriginalDuration = duration
	MeasureSetStopMode(STOP_NOMOVE)

	-- for the ai
	if IsPartyMember("") then
		if not GetInsideBuilding("","CurrentBuilding") then
			StopMeasure()
		end
		if BuildingGetType("CurrentBuilding")==GL_BUILDING_TYPE_CHURCH_CATH or BuildingGetType("CurrentBuilding")==GL_BUILDING_TYPE_CHURCH_EV then
			CopyAlias("CurrentBuilding","church")
		else
			StopMeasure()
		end
	elseif not SimGetWorkingPlace("","church") then
		StopMeasure()
	end

	-- for the ai
	if GetInsideBuildingID("") ~= GetID("church") then
		if not f_MoveTo("", "church", GL_MOVESPEED_RUN) then
			return
		end
	end

	local MassInProgress = GetProperty("church", "MassInProgress")
	if MassInProgress and MassInProgress~=GetID("") then
		return
	end
	SetProperty("church", "MassInProgress", GetID(""))

	-- mass setup first-time or re-enter after sub-measure (WorshipPraise or WorshipScold)
	--local duration = 8
	local TimerLeft = GetRepeatTimerLeft("church",GetMeasureRepeatName())
	if (TimerLeft>0) then
		duration = duration - (TimeOut-TimerLeft)
	else
		if IsPartyMember("") then
			SetRepeatTimer("", GetMeasureRepeatName(), TimeOut)
		else
			SetRepeatTimer("church", GetMeasureRepeatName(), TimeOut)
		end
	end

	if duration<0 then
		StopMeasure()
	end

	local Level = BuildingGetLevel("church")
	if Level < 3 then
		PlaySound3D("church","Locations/bell_stroke_minster_loop+0.wav",1)
	else
		PlaySound3D("church","Locations/bell_stroke_cathedral_loop+0.wav",1)
	end

	if GetImpactValue("church","MassInProgress")==0 then
		AddImpact("church","MassInProgress",1,duration)
	end
	if GetImpactValue("","MassInProgress")==0 then
		AddImpact("","MassInProgress",1,duration)
	end

	-- worship loop
	GetLocatorByName("church","Priest1","PriestPos")
	f_MoveTo("","PriestPos")
	Sleep(1)
	SetData("WorshipInProgress",1)
	local Replacement
	local Religion = BuildingGetReligion("church")
	if Religion == RELIGION_CATHOLIC then
		Replacement = "_CATHOLIC"
	else
		Replacement = "_PROTESTANT"
	end
	SetProcessMaxProgress("",40)
	local TimeLeft = ImpactGetMaxTimeleft("","MassInProgress") * 10
	--SetProcessProgress("",TimeLeft)
	MsgSay("","@L_CHURCH_091_PREPAREWORSHIP_WORSHIPPING_WELCOME")
	while (GetImpactValue("","MassInProgress")==1) do
		TimeLeft = ImpactGetMaxTimeleft("","MassInProgress") * 10
		TimeLeft = (OriginalDuration*10) - TimeLeft
		SetProcessProgress("",TimeLeft)
		PlayAnimationNoWait("","preach")
		MsgSay("","@L_CHURCH_091_PREPAREWORSHIP_WORSHIPPING_PREACHING")
		Sleep(6)
		TimeLeft = ImpactGetMaxTimeleft("","MassInProgress") * 10
		TimeLeft = (OriginalDuration*10) - TimeLeft
		SetProcessProgress("",TimeLeft)
		PlayAnimationNoWait("","preach")
		MsgSay("","@L_CHURCH_091_PREPAREWORSHIP_WORSHIPPING_BLESSING"..Replacement)
		Sleep(6)
		-- do worship activities here

	end
	SetData("WorshipInProgress",0)
	ResetProcessProgress("")
	-- Fajeth: def 90
	IncrementXP("",100)
	-- eigener Glauben steigt by LordProtektor
	SimSetFaith("",SimGetFaith("")+10)
end

function CleanUp()
	StopAnimation("")
	if GetID("church")~=-1 then

		local MassInProgress = GetProperty("church", "MassInProgress")
		if MassInProgress and MassInProgress==GetID("") then
			RemoveProperty("church", "MassInProgress")
			RemoveImpact("church","MassInProgress")
			RemoveImpact("","MassInProgress")
		end
	end

	if GetImpactValue("","MassInProgress")==0 then
		ResetProcessProgress("")
	end

	if not SimIsWorkingTime("") then
		ResetProcessProgress("")
	end


end

function GetOSHData(MeasureID)
	--can be used again in:
	OSHSetMeasureRepeat("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+2",Gametime2Total(mdata_GetTimeOut(MeasureID)))
	--active time:
	OSHSetMeasureRuntime("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+0",Gametime2Total(mdata_GetDuration(MeasureID)))
end

