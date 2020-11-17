--pay very close attention to the disposition of your target or you could wind up with a hefty fine, in the pillory or even in prison!!!!

function Run()
	find_Captain("","Captain")
	if not AliasExists("Captain") then
		MsgQuick("","@L_INTRIGUE_BRIBEGUARD_FAILURES_+0")
		StopMeasure()
	end
	
	local Hour = math.mod(GetGametime(), 24)
	if Hour > 11 then  --Prevents officeholder from missing/being interupted from office meeting
		MsgQuick("","@L_INTRIGUE_BRIBEGUARD_FAILURES_+1")
		StopMeasure()
	end	
	
	find_HomeCity("", "City")
	--AliasCheck
	if not AliasExists("City") then
		StopMeasure()
	end
	local Difficulty = ScenarioGetDifficulty()
	local MyMoney = GetMoney("")
	local Time
	local Title = GetNobilityTitle("Captain")
	local TitleCost = Title * 100
	local X = SimGetOfficeLevel("Captain")
	local Level = {}
		Level[1] = 750
		Level[2] = 1000
		Level[3] = 1500
		Level[4] = 2500
		Level[5] = 5000
		Level[6] = 7500
	local PowerCost = Level[X] + TitleCost	
	local Choice = {}
		Choice[1] = 500 + PowerCost
		Choice[2] = 1000 + PowerCost
		Choice[3] = 2000 + PowerCost
	local Duration = {}
		Duration[1] = 3
		Duration[2] = 6
		Duration[3] = 12
	
	if Difficulty < 2 then
		Choice[1] = 500
		Choice[2] = 750
	    Choice[3] = 1000
		Duration[1] = Duration[1] * 2
	    Duration[2] = Duration[2] * 2
	    Duration[3] = Duration[3] * 2
	elseif Difficulty == 2 then
		Choice[1] =	Choice[1] * 0.5
	    Choice[2] = Choice[2] * 0.5
	    Choice[3] = Choice[3] * 0.5
		Duration[1] = Duration[1] * 2
	    Duration[2] = Duration[2] * 2
	    Duration[3] = Duration[3] * 2
	end
	
	local Alignment = SimGetAlignment("Captain")
	local panel
	if MyMoney >= Choice[3] then
        panel = ("@P"..
        "@B["..Choice[1]..",@L_BRIBEGUARD_BUTTONS_+1]"..
		"@B["..Choice[2]..",@L_BRIBEGUARD_BUTTONS_+2]"..
		"@B["..Choice[3]..",@L_BRIBEGUARD_BUTTONS_+3]"..
		"@B[0,@L_REPLACEMENTS_BUTTONS_CANCEL_+0]")
	elseif MyMoney >= Choice[2] and MyMoney < Choice[3] then
        panel = ("@P"..
        "@B["..Choice[1]..",@L_BRIBEGUARD_BUTTONS_+1]"..
		"@B["..Choice[2]..",@L_BRIBEGUARD_BUTTONS_+2]"..
		"@B[0,@L_REPLACEMENTS_BUTTONS_CANCEL_+0]")
	elseif MyMoney >= Choice[1] and MyMoney < Choice[2] then
		panel = ("@P"..
        "@B["..Choice[1]..",@L_BRIBEGUARD_BUTTONS_+1]"..
        "@B[0,@L_REPLACEMENTS_BUTTONS_CANCEL_+0]")
	else
		MsgQuick("","@L_INTRIGUE_BRIBEGUARD_FAILURES_+3")
		StopMeasure()
	end
	
	local Result = MsgNews ("","",panel,
	bribeguard_AIDecision,  --AIFunc 
	"intrigue", --Message Class
	2, --TimeOut
	"@L_INTRIGUE_BRIBEGUARD_SCREENPLAY_ACTOR_HEAD_+0",
	"@L_INTRIGUE_BRIBEGUARD_SCREENPLAY_ACTOR_BODY_+0",
	GetID(""),Choice[1],Choice[2],Choice[3])

	if Result == Choice[1] then
		if Alignment > 50 then
			if Rand(100)<75 then	
				local Fine = Choice[1] * 0.75
				CityAddPenalty("City","",PENALTY_PRISON,3)
				CityAddPenalty("City","",PENALTY_MONEY,Fine)
				MsgNewsNoWait("","Captain","","intrigue",-1,
					"@L_INTRIGUE_BRIBEGUARD_MSG_FAILURE_HEAD_+0",
					"@L_INTRIGUE_BRIBEGUARD_MSG_FAILURE_BODY_+0",GetID("Captain"),Fine)
				StopMeasure()
			else
				Time = Duration[1]
			end
		else
			Time = Duration[1]
		end
	elseif Result == Choice[2] then
		if Alignment > 75 then
			if Rand(100)<75 then
				local Fine = Choice[2] * 0.5 
				CityAddPenalty("City","",PENALTY_PILLORY,2)
				CityAddPenalty("City","",PENALTY_MONEY,Fine)
				MsgNewsNoWait("","Captain","","intrigue",-1,
					"@L_INTRIGUE_BRIBEGUARD_MSG_FAILURE_HEAD_+1",
					"@L_INTRIGUE_BRIBEGUARD_MSG_FAILURE_BODY_+1",GetID("Captain"),Fine)
				StopMeasure()
			else
				Time = Duration[2]
			end	
		else
			Time = Duration[2]
		end
	elseif Result == Choice[3] then
		if Alignment > 95 then
			if Rand(100)<75 then	
				local Fine = Choice[3] * 0.25 
				CityAddPenalty("City","",PENALTY_PILLORY,1)
				CityAddPenalty("City","",PENALTY_MONEY,Fine)
				MsgNewsNoWait("","Captain","","intrigue",-1,
					"@L_INTRIGUE_BRIBEGUARD_MSG_FAILURE_HEAD_+2",
					"@L_INTRIGUE_BRIBEGUARD_MSG_FAILURE_BODY_+2",GetID("Captain"),Fine)
				StopMeasure()
			else
				Time = Duration[3]
			end
		else
			Time = Duration[3]
		end
	else
		StopMeasure()
	end
	
	MoveStop("Captain")
	f_MoveTo("","Captain",GL_MOVESPEED_RUN)
	AlignTo("","Captain")
	AlignTo("Captain","")
	--do visual stuff
	PlayAnimation("", "watch_for_guard")
	local time1
	local time2
	time1 = PlayAnimationNoWait("Owner", "use_object_standing")
	time2 = PlayAnimationNoWait("Captain","cogitate")
	Sleep(1)
	PlaySound3D("","Locations/wear_clothes/wear_clothes+1.wav", 1.0)
	CarryObject("","Handheld_Device/ANIM_Smallsack.nif",false)
	Sleep(1)
	CarryObject("","",false)
	CarryObject("Captain","Handheld_Device/ANIM_Smallsack.nif",false)
	time2 = PlayAnimationNoWait("Captain","fetch_store_obj_R")
	Sleep(1)
	StopAnimation("")
	PlaySound3D("Captain","Locations/wear_clothes/wear_clothes+1.wav", 1.0)
	CarryObject("Captain","",false)	
	
	CommitAction("bribe","","","Captain")
	SpendMoney("",Result,"CostBribes")
	Sleep(1)
	chr_RecieveMoney("Captain", Result, "IncomeBribes")
	AddImpact("","BribeGuard",1,Time)
	chr_GainXP("",GetData("BaseXP"))
	--show message
	local MeasureID = GetCurrentMeasureID("")
	local TimeOut = mdata_GetTimeOut(MeasureID)
	SetRepeatTimer("", GetMeasureRepeatName(), TimeOut)
	MsgNewsNoWait("","Captain","","intrigue",-1,
		"@L_INTRIGUE_BRIBEGUARD_MSG_SUCCESS_HEAD_+0",
		"@L_INTRIGUE_BRIBEGUARD_MSG_SUCCESS_BODY_+0",GetID("Captain"))
end

function CleanUp()
end

function AIDecision()
	return "..Choice[1].."
end

function GetOSHData(MeasureID)
	--can be used again in:
	OSHSetMeasureRepeat("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+2",Gametime2Total(mdata_GetTimeOut(MeasureID)))
end
