-------------------------------------------------------------------------------
----
----	OVERVIEW "ms_010_GoToSleep"
----
----	with this measure the character can go to Sleep in his home building
----
-------------------------------------------------------------------------------

function Run()

	local MeasureID = GetCurrentMeasureID("")
	local duration = mdata_GetDuration(MeasureID)

	BuildingFound = 1
	if SimGetProfession("")==GL_PROFESSION_MYRMIDON then
		if not SimGetWorkingPlace("","HomeBuilding") then
			MsgQuick("","@L_GENERAL_MEASURES_010_GOTOSLEEP_FAILURES_+0", GetID(""))
			StopMeasure()
		end
	elseif not(GetHomeBuilding("", "HomeBuilding")) then
		MsgDebugMeasure("GoToSleep - No homebuilding found for sleeping")
		if IsDynastySim("Owner") then
			MsgQuick("","@L_GENERAL_MEASURES_010_GOTOSLEEP_FAILURES_+0", GetID(""))
			StopMeasure()
		end
		StopMeasure()
	end

	if not GetInsideBuilding("", "Inside") or GetID("Inside")~=GetID("HomeBuilding") then
		if GetImpactValue("","Sickness")>0 then
			if not f_MoveTo("", "HomeBuilding", GL_MOVESPEED_WALK) then
				StopMeasure()
			end
		else
			if not f_MoveTo("", "HomeBuilding", GL_MOVESPEED_RUN) then
				StopMeasure()
			end
		end
	end
	if GetImpactValue("","SleepRecoverBonus")>0 then
		duration = duration - ((GetImpactValue("","SleepRecoverBonus")*0.01)*duration)
	end
	local CurrentHP = GetHP("")
	local MaxHP = GetMaxHP("")
	local ToHeal = MaxHP - CurrentHP
	local HealPerTic = ToHeal / (duration * 12)
	local UseLocator = false

	if not AliasExists("HomeBuilding") then
		StopMeasure()
	end

	if GetFreeLocatorByName("HomeBuilding", "Bed",1,3, "SleepPosition") then
		if not f_BeginUseLocator("", "SleepPosition", GL_STANCE_LAY, true) then
			MsgQuick("","@L_GENERAL_MEASURES_010_GOTOSLEEP_FAILURES_+1",GetID(""))
			StopMeasure()
		end
	else
		if SimGetProfession("")==GL_PROFESSION_MYRMIDON then
			MsgQuick("","@L_GENERAL_MEASURES_010_GOTOSLEEP_FAILURES_+1",GetID(""))
			StopMeasure()
		end
		if GetDynastyID("")~=-1 and IsDynastySim("Owner") then
			-- member from a dynasty must sleep in the right way
			MsgQuick("","@L_GENERAL_MEASURES_010_GOTOSLEEP_FAILURES_+1",GetID(""))
			return
		end
		RemoveAlias("SleepPosition")
	end

	local CurrentTime = GetGametime()
	local WasSick = false
	if GetImpactValue("","Sickness")>0 then
		duration = duration * 1.5
		WasSick = true
	end
	local EndTime = CurrentTime + duration

	while GetGametime()<EndTime do
		Sleep(5)
		-- increase the hp due to the recover factor for the residence
		if GetHP("") < MaxHP then
			ModifyHP("", HealPerTic,false)
			PlaySound3DVariation("","measures/gotosleep",1)
		end
	end

	if IsDynastySim("Owner") then
		if WasSick == true then
			diseases_Cold("",false)
			diseases_Influenza("",false)
			diseases_Pneumonia("",false)
		end
		-- adding a bonus for sleeping by Fajeth
		AddImpact("","constitution",1,16)
		AddImpact("","craftsmanship",2,8)

		feedback_MessageCharacter("",
			"@L_GENERAL_MEASURES_010_GOTOSLEEP_WAKEUP_HEAD",
			"@L_GENERAL_MEASURES_010_GOTOSLEEP_WAKEUP_BODY", GetID(""))
	end
end

-- -----------------------
-- CleanUp
-- -----------------------
function CleanUp()

	if AliasExists("SleepPosition") then
		f_EndUseLocator("", "SleepPosition", GL_STANCE_STAND)
	end
end

function GetOSHData(MeasureID)

	--active time:
	OSHSetMeasureRuntime("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+0",Gametime2Total(mdata_GetDuration(MeasureID)))
end

