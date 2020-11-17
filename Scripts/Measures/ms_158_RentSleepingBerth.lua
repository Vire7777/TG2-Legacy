-- -----------------------
-- Run
-- -----------------------
function Run()

	-- get the tavern
	if not GetInsideBuilding("", "Tavern") then
		return
	end

	local MyDynastyID = GetDynastyID("")
	local Money = GetMoney("")
	-- hier muss noch der Preis anhand der Preisangabe des Wirtes errechnen
	local Price = 75
	
--	local Result = MsgNews("","","@P"..
--				"@B[1,@L_REPLACEMENTS_BUTTONS_JA_+0]"..
--				"@B[C,@L_REPLACEMENTS_BUTTONS_NEIN_+0]",
--				ms_158_rentsleepingberth_AIDecision,  --AIFunc
--				"building", --MessageClass
--				2, --TimeOut
--				"@L_MEASURE_RentSleepingBerth_NAME_+0",
--				"@L_GENERAL_MEASURES_158_RENTSLEEPINGBERTH_MSG_BODY_+0",
--				Price)
--	if Result == "C" then
--		StopMeasure()
--	end
	
	-- check both sleeping berths
	if not GetFreeLocatorByName("Tavern", "Berth", 1, 2, "SleepingBerth") then	
		MsgQuick("","@L_TAVERN_158_RENTSLEEPINGBERTH_FAILURES_+1", GetID("Tavern"))
		return
	end
	
	if not SpendMoney("", Price, "CostSocial") then
		MsgQuick("","@L_TAVERN_158_RENTSLEEPINGBERTH_FAILURES_+0",Price)
		StopMeasure()
	end
	
	CreditMoney("Tavern", Price, "RentABerth")

	-- go to the berth
	f_BeginUseLocator("", "SleepingBerth", GL_STANCE_LAY, true)
		
	-- sleep
	
	local	RecoverTime	= Gametime2Realtime(EN_RECOVERFACTOR_TAVERN/60)
	local SleepTime
	local	HasToSleep = ((GetMaxHP("") - GetHP("") )*EN_RECOVERFACTOR_TAVERN) / 60
	if HasToSleep > 8 then
		HasToSleep = 8
	else
		HasToSleep = math.max(1, HasToSleep)
	end
	local TotalTime 	= Gametime2Realtime(HasToSleep)
		
	
	
	local Time = GetGametime()
	-- increase the hp due to the recover factor for the tavern
	while TotalTime>0 or Time<7 or Time>23 do
		
		Sleep(RecoverTime)
		TotalTime = TotalTime - RecoverTime
		
		if (GetHPRelative("")<1) then
			ModifyHP("", 1)
		end
		Time = GetGametime()
		
	end
	
	-- end sleeping

	f_EndUseLocator("", "SleepingBerth", GL_STANCE_STAND)

	-- sleeping heals diseases even in tavern by Fajeth
	local WasSick = false
	if GetImpactValue("","Sickness")>0 then
		--duration = duration * 2
		WasSick = true
	end
	if WasSick == true then
			diseases_Cold("",false)
			diseases_Influenza("",false)
			diseases_Pneumonia("",false)
		end
	-- adding bonus for sleeping by Fajeth
	-- Wer schläft, erhält einen Konstitutionsbonus von +1 für den Tag! mod by Fajeth
	-- Fürs Schlafen im Fremden Bett gibts außerdem 50 XP gratis
	chr_GainXP("",50)
	AddImpact("","constitution",1,16)
	AddImpact("","craftsmanship",2,8)
	feedback_MessageCharacter("",
		"@L_GENERAL_MEASURES_010_GOTOSLEEP_WAKEUP_HEAD",
		"@L_GENERAL_MEASURES_010_GOTOSLEEP_WAKEUP_BODY", GetID("Owner"))
end

function AIDecision()
	return "O"
end

-- -----------------------
-- CleanUp
-- -----------------------
function CleanUp()
	if AliasExists("SleepingBerth") then
		f_EndUseLocator("", "SleepingBerth", GL_STANCE_STAND)
	end
	feedback_OverheadComment("Owner")
end

function GetOSHData(MeasureID)
	
	OSHSetMeasureCost("@L_INTERFACE_HEADER_+6",75)
end

