function AIInit()
	local Chance = Rand(2)
	if Chance == 0 then
		return "L"
	elseif Chance == 1 then
		return "M"
	end
	return "H"
end

function Run()

	if not AliasExists("Destination") then
		StopMeasure()
	end
	
	local MeasureID = GetCurrentMeasureID("")
	--local TimeOut = mdata_GetTimeOut(MeasureID)
	local TimeOut = 24
	
	local BardFilter = "__F((Object.GetObjectsByRadius(Sim)==1000)AND(Object.GetState(townnpc))AND(Object.Property.IsBard == 1)AND(Object.Property.BardIsFree == 1))"
	local NumBards = Find("",BardFilter,"Bard",-1)
	
	if NumBards < 1 then
		StopMeasure()
	end
	
	MoveStop("Bard")
	MeasureSetNotRestartable()
	SetProperty("Bard","BardIsFree",0)
	BlockChar("Bard")
	
	AlignTo("","Bard")
	AlignTo("Bard","")
	Sleep(1)
	
	local DestCharisma = GetSkillValue("Destination","CHARISMA") --1..10
	local DestTitle = GetNobilityTitle("Destination",false) --1..10
	
	local LowPrice = 200 * DestCharisma * DestTitle
	local MidPrice = LowPrice * 2
	local HighPrice = LowPrice * 4
	
	local result = MsgNews("","destination","@P"..
			"@B[L,@L_MESSAGES_SLANDER_MSG_BUTTONS_+0]"..
			"@B[M,@L_MESSAGES_SLANDER_MSG_BUTTONS_+1]"..
			"@B[H,@L_MESSAGES_SLANDER_MSG_BUTTONS_+2]",
			ms_slander_AIInit(),"intrigue",1,
			"@L_MESSAGES_SLANDER_MSG_HEAD_+0",
			"@L_MESSAGES_SLANDER_MSG_BODY_+0",
			LowPrice,MidPrice,HighPrice)
	
	if result == "C" then
		StopMeasure()
	end
	
	local Evidence = 0
	local EvidenceLabel = "INTRO"
	local Costs = 0
	local Choice = 0
	
	--low crimes
	if result == "L" then
		Costs = LowPrice
		Choice = Rand(4)
		if Choice == 0 then
			Evidence = 1	--sabotage		5
			EvidenceLabel = "SABOTAGE"
		elseif Choice == 1 then
			Evidence = 6	--blackmail		5
			EvidenceLabel = "BLACKMAIL"
		elseif Choice == 2 then
			Evidence = 10	--calumny		4
			EvidenceLabel = "CALUMNY"
		else
			Evidence = 12	--raiding		5
			EvidenceLabel = "RAIDING"
		end
	--mid crimes
	elseif result == "M" then
		Costs = MidPrice
		Choice = Rand(6)
		if Choice == 0 then
			Evidence = 7	--slugging		6
			EvidenceLabel = "SLUGGING"
		elseif Choice == 1 then
			Evidence = 11	--poison		6
			EvidenceLabel = "POISON"
		elseif Choice == 2 then
			Evidence = 7	--slugging		6
			EvidenceLabel = "SLUGGING"
		elseif Choice == 3 then
			Evidence = 14	--marauding		7
			EvidenceLabel = "MARAUDING"
		elseif Choice == 4 then
			Evidence = 19	--attackcart		6
			EvidenceLabel = "ATTACKCART"
		else
			Evidence = 20	--theft			6
			EvidenceLabel = "THEFT"
		end		
	--high crimes
	elseif result == "H" then
		Costs = HighPrice
		Choice = Rand(3)
		if Choice == 0 then
			Evidence = 15	--abduction		8
			EvidenceLabel = "ABDUCTION"
		elseif Choice == 1 then
			Evidence = 16	--murder		15
			EvidenceLabel = "MURDER"
		else
			Evidence = 18	--attackcivilian	8
			EvidenceLabel = "ATTACKCIVILIAN"
		end
	end
	
	if not SpendMoney("",Costs,"CostBribes") then
		MsgSay("Bard","@L_MESSAGES_SLANDER_SPEECH_NOMONEY_+0")
		StopMeasure()
	end	
	
	SetMeasureRepeat(TimeOut)
	
	local SimFilter = "__F((Object.GetObjectsByRadius(Sim)==1800)AND NOT(Object.GetState(townnpc)))"
	local NumSims = Find("",SimFilter,"Sim",-1)
	MsgSay("Bard","@L_MESSAGES_SLANDER_SPEECH_INTRO_+0")
	while true do
		ScenarioGetRandomObject("cl_Sim","CurrentRandomSim")
		if not GetDynasty("CurrentRandomSim","CDynasty") then
			CopyAlias("CurrentRandomSim","EvidenceVictim")
			break
		end
		Sleep(2)
	end
	AddEvidence("","Destination","EvidenceVictim",Evidence,"Sim0","Sim1","Sim2","Sim3","Sim4","Sim5","Sim6","Sim7","Sim8","Sim9")
	MsgSay("Bard","@L_MESSAGES_SLANDER_SPEECH_"..EvidenceLabel.."_+0",GetID("Destination"))
	SetProperty("Bard","BardIsFree",1)
	StopMeasure()	
	
end

function CleanUp()
	if AliasExists("Bard") then
		SetProperty("Bard","BardIsFree",1)
	end


end

function GetOSHData(MeasureID)
	--can be used again in:
	OSHSetMeasureRepeat("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+2",Gametime2Total(mdata_GetTimeOut(MeasureID)))
end

