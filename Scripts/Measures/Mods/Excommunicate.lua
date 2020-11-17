function Run()
	MeasureSetNotRestartable()
	if HasProperty("destination","Emperor") then
		if SimGetFaith("destination") > 25 then
			MsgQuick("","@L_EXCOMMUNICATE_ERROR_ONE")
			StopMeasure()
		end
	end
	if HasProperty("destination","King") then
		if SimGetFaith("destination") > 40 then
			MsgQuick("","@L_EXCOMMUNICATE_ERROR_TWO")
			StopMeasure()
		end
	end
	if SimGetFaith("destination") > 80 then
		MsgQuick("","@L_EXCOMMUNICATE_ERROR_THREE")
		StopMeasure()
	end
	
	if SimGetOfficeID("destination") ~= -1 then
		SimSetOffice("destination",0)
	end	
	SetNobilityTitle("destination",3,true)
	SimSetFaith("destination",0)
	HisMoney = GetMoney("destination")
	Cut = HisMoney * 0.75
	SpendMoney("destination",Cut,"CostAdministration")
	CreditMoney("",Cut,"IncomeOther")
	local sim
	local SimCount = ScenarioGetObjects("cl_Sim", 9999, "SimList")
	for sim=0,SimCount-1 do
		local SimAlias = "SimList"..sim
		SetFavorToSim("destination",SimAlias,0)
	end	
	AddImpact("destination","Excommed",1,240)
	feedback_MessageCharacter("All",
		"@L_EXCOMMUNICATED_ACTOR_SUCCESS_HEAD_+0",
		"@L_EXCOMMUNICATED_ACTOR_SUCCESS_BODY_+0",GetID("destination"),GetID(""),Cut)
	feedback_MessageCharacter("destination",
		"@L_EXCOMMUNICATED_ACTOR_SUCCESS_HEAD_+1",
		"@L_EXCOMMUNICATED_ACTOR_SUCCESS_BODY_+1",GetID(""),Cut)	
	local MeasureID = GetCurrentMeasureID("")
	local TimeOut = mdata_GetTimeOut(MeasureID)
	SetRepeatTimer("", GetMeasureRepeatName(), TimeOut)
end

function GetOSHData(MeasureID)
	--can be used again in:
	OSHSetMeasureRepeat("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+2",Gametime2Total(mdata_GetTimeOut(MeasureID)))
end

function CleanUp()
	StopMeasure()
end
