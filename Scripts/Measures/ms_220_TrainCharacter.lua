function Run()
	
	local MeasureID = GetCurrentMeasureID("")
	local duration = mdata_GetDuration(MeasureID)
	local TimeOut = mdata_GetTimeOut(MeasureID)
	
	if not GetInsideBuilding("", "HomeBuilding") then
		return
	end
	--chr_GainXP("",10000) -- this will add 10.000 XP edit this to your liking (best set to 5000)
	--SetNobilityTitle("",14,true) -- this will give you the highest title (14), edit this if you want a lower title
	--CreditMoney("",1000000,"IncomeOther")
  
	local TimeToStudy = duration
	SetData("TimeToStudy",TimeToStudy)
	SetData("StartTime", GetGametime())
	SendCommandNoWait("","Progress")
	local i
	local Found
	SetMeasureRepeat(TimeOut)
	SetData("Learning",1)
	while (GetData("Learning")==1) do
		Found = 0
		if GetLocatorByName("HomeBuilding","TakeBook","TakeBookPos") then
			if f_BeginUseLocator("","TakeBookPos",GL_STANCE_STAND,true) then
				Found = 1
				local Time = PlayAnimationNoWait("","manipulate_middle_up_r")
				Sleep(2.5)
				CarryObject("","Handheld_Device/ANIM_Closedbook.nif", false)
				Sleep(Time-2.5)
				if GetLocatorByName("HomeBuilding","ReadBook","ReadBookPos") then
					f_BeginUseLocator("","ReadBookPos",GL_STANCE_STAND,true)
					Sleep(1)
				elseif GetFreeLocatorByName("HomeBuilding","Stroll",1,3,"ReadBookPos") then
					f_BeginUseLocator("","ReadBookPos",GL_STANCE_STAND,true)
				end
				for i=0,3 do
					Time = PlayAnimationNoWait("","use_book_standing")
					Sleep(1)
					CarryObject("","Handheld_Device/ANIM_book.nif", false)
					Sleep(Time-2)
					CarryObject("","Handheld_Device/ANIM_Closedbook.nif", false)
					Sleep(1.8)
				end
				Sleep(1)
				f_EndUseLocator("","ReadBookPos")
				f_BeginUseLocator("","TakeBookPos",GL_STANCE_STAND,true)
				Time = PlayAnimationNoWait("","manipulate_middle_up_r")
				Sleep(2.5)
				CarryObject("","", false)
				Sleep(Time-2.5)
				Sleep(2)
				f_EndUseLocator("","TakeBookPos")
			end
		end
		if (GetData("Learning"))==0 then
			break
		end
		if GetLocatorByName("HomeBuilding","manipulate_middle_twohand_pos_012","TablePos") then
			if f_BeginUseLocator("","TablePos",GL_STANCE_STAND,true) then
				Found = 1
				for i=0,3 do
					PlayAnimation("", "cogitate")
					PlayAnimation("", "manipulate_middle_twohand")
				end
				f_EndUseLocator("","TablePos")
			end
		end
		
		if Found == 0 then
			MsgQuick("", "@L_GENERAL_MEASURES_220_TRAINCHARACTER_FAILURES_+0", GetID("Owner"))
			StopMeasure()
		end
	PlayAnimation("", "cogitate")
	end

	StopMeasure()
end

function Progress()
	local TimeToStudy = GetData("TimeToStudy")
	local MaxProgress = TimeToStudy * 10
	SetProcessMaxProgress("",MaxProgress)
	local ProgressStartTime = GetGametime()
	local ProgressEndTime = GetGametime() + TimeToStudy
	while (GetGametime() < ProgressEndTime) do
		SetProcessProgress("",(GetGametime()-ProgressStartTime)*10)
		Sleep(1)
	end
	SetData("Learning",0)
	
end

function CleanUp()
	local Options = FindNode("\\Settings\\Options")
	local YearsPerRound = Options:GetValueInt("YearsPerRound")
	local MeasureID = GetCurrentMeasureID("")
	local	Time = GetGametime()
	local	Start = GetData("StartTime")
	local duration = mdata_GetDuration(MeasureID)
	
	local	Factor = (Time - Start) / duration
	if Factor>1 then
		Factor = 1
	end
    local BaseXP = GetData("BaseXP")
    local AddXP = BaseXP * YearsPerRound
    chr_GainXP("", (AddXP)*Factor)
    
    ResetProcessProgress("")
	StopAnimation("")
	CarryObject("","",false)
	if AliasExists("TablePos") then
		f_EndUseLocator("","TablePos")
	end
	if AliasExists("TakeBookPos") then
		f_EndUseLocator("","TakeBookPos")
	end
	if AliasExists("ReadBookPos") then
		f_EndUseLocator("","ReadBookPos")
	end
	
end

function GetOSHData(MeasureID)
	--can be used again in:
	OSHSetMeasureRepeat("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+2",Gametime2Total(mdata_GetTimeOut(MeasureID)))
	--active time:
	OSHSetMeasureRuntime("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+0",Gametime2Total(mdata_GetDuration(MeasureID)))
end

