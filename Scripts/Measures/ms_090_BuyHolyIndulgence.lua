function AIDecideBuy()
	return 1
end

function Run()

	local MeasureID = GetCurrentMeasureID("")
	local TimeOut = mdata_GetTimeOut(MeasureID)

	local TextPrefix = "@L_CHURCH_090_BUYHOLYINDULGENCE"
	
	if GetItemCount("",166,INVENTORY_STD) <= 0 then		--lettofindulgence
		MsgQuick("","@L_REPLACEMENTS_FAILURE_MSG_NOITEM_+0")
		StopMeasure()
	end

	SimGetCrimeList("","CrimeList")
	if ListSize("CrimeList")==0 then
		MsgQuick("", "@L_CHURCH_090_BUYHOLYINDULGENCE_FAILURES_+0", GetID(""))
		return
	elseif GetInsideBuilding("","church") then
		local Cost = 0
		local NumEvidences = ListSize("CrimeList")
		for i=0,NumEvidences-1,1 do
			ListGetElement("CrimeList",i,"tmp")
			Cost = Cost + CrimeGetEvidenceValue("tmp")
		end

		Cost = Cost*200
		
		local Decision = MsgNews("","","@P"..
			"@B[1,"..TextPrefix.."_BTN_+0]"..
			"@B[2,"..TextPrefix.."_BTN_+1]",
			ms_087_changefaith_AIDecide,
			"politics",0,
			"@L_CHURCH_090_BUYHOLYINDULGENCE_HEAD_+0",
			""..TextPrefix.."_DESCRIPTION", Cost)

		if Decision==2 or Decision=="C" then
			return
		end
		
		
		local money = GetMoney("")
		if (money<Cost) then
			MsgQuick("", "@L_CHURCH_090_BUYHOLYINDULGENCE_FAILURES_+1", Cost)
		else
			RemoveItems("",166,1,INVENTORY_STD)
			if GetFreeLocatorByName("church","HolyIndulgence",-1,-1,"HolyIndulgencePos") then
				f_BeginUseLocator("","HolyIndulgencePos",GL_STANCE_KNEEL,true)
				SetData("Blocked",1)
				PlayAnimation("","knee_pray")
				GetPosition("", "ParticleSpawnPos")
				StartSingleShotParticle("particles/absolvesinner.nif", "ParticleSpawnPos",1.4,4)
				Sleep(3)
				f_EndUseLocator("","HolyIndulgencePos",GL_STANCE_STAND)
				SetData("Blocked",0)
			end
			SpendMoney("", Cost,"CostIndulgence")
			CreditMoney("church",Cost,"IncomeIndulgence")
			SetMeasureRepeat(TimeOut)
			for i=0,ListSize("CrimeList")-1,1 do
				ListGetElement("CrimeList",i,"tmp")
				CrimeForfeit("tmp",2)		
			end
			local baseXP = GetData("BaseXP")
			baseXP = baseXP * NumEvidences
			chr_GainXP("",baseXP)
			feedback_MessagePolitics("",
				""..TextPrefix.."_SUCCESS_MSG_HEAD",
				""..TextPrefix.."_SUCCESS_MSG_BODY",GetID(""),GetID("church"),Cost)
		end
	end
	StopMeasure()
end

function CleanUp()
	StopAnimation("")
	if GetData("Blocked")==1 then
		f_EndUseLocator("","HolyIndulgencePos",GL_STANCE_STAND)
	end

end

function GetOSHData(MeasureID)
	--can be used again in:
	OSHSetMeasureRepeat("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+2",Gametime2Total(mdata_GetTimeOut(MeasureID)))
end

