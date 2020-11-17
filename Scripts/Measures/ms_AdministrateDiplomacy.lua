function Init()
	local CState = DynastyGetDiplomacyState("Destination","")
	local Buttons = ""
	
	local MinState = DynastyGetMinDiplomacyState("", "Destination")
	local MaxState = DynastyGetMaxDiplomacyState("", "Destination")
	
	if MinState<0 or MaxState<0 then
		return false
	end
	
	local	Count = 0
	
	for i=0,3 do
		if i>=MinState and i<=MaxState and i~= CState then
		
			if i==0 then
				Buttons	= Buttons .. "@B[0,,@LHostility,Hud/Buttons/btn_034_ArmCharacter.tga]"
			elseif i==1 then
				Buttons	= Buttons .. "@B[1,,@LNeutral,Hud/Buttons/btn_030_GuardObject.tga]"			
			elseif i==2 then
				Buttons	= Buttons .. "@B[2,,@LNAP,Hud/Buttons/btn_015_ReclaimField.tga]"
			elseif i==3 then
				Buttons	= Buttons .. "@B[3,,@LAlliance,Hud/Buttons/btn_047_Administrate_Diplomacy.tga]"
			end
			
			Count = Count + 1
			
		end
	end
	
	if Count<2 then
		-- error und raus
		return false
	end

	local result = InitData("@P"..Buttons,
		ms_administratediplomacy_AIInitDipl,
		"@LAdministrateDiplomacySheet",
		"")
	SetData("InitResult",result)
end

function AIInitDipl()
	local CurrentFavor = GetFavorToDynasty("Destination","")
	if CurrentFavor > 79 then
		return 3
	elseif CurrentFavor > 62 then
		return 2
	elseif CurrentFavor > 37 then
		return 1
	else
		return 0
	end
end

function AIDecision()
	local Indicator = 0
	local Factor = 1
	
	--check for religion -2 .. 2
	if SimGetFaith("Destination") > 50 then
		Factor = 2
	end
	if SimGetReligion("") == SimGetReligion("Destination") then
		Indicator = Indicator + Factor
	else
		Indicator = Indicator - Factor
	end
	
	--check if rogue -3 .. 2
	if SimGetClass("")==4 then
		if SimGetClass("Destination")==4 then
			Indicator = Indicator + 2
		else
			Indicator = Indicator - 2
		end
	else
		Indicator = Indicator + 1
	end
	
	--check for nobility title
	if GetNobilityTitle("Destination") > GetNobilityTitle("") then
		Indicator = Indicator - (GetNobilityTitle("Destination")-GetNobilityTitle(""))
	else
		Indicator = Indicator + 2
	end
	
	--check for money 
	if SimGetWealth("Destination") > SimGetWealth("") then
		Indicator = Indicator - 2
	else
		Indicator = Indicator + 2
	end
	
	--check current state
	local CurrentDIPState = DynastyGetDiplomacyState("Destination","")
	local PropState = GetData("InitResult")
	
	if PropState > (CurrentDIPState+1) then
		Indicator = Indicator - 2
	end
	
	if CurrentDIPState == 1 then
		Indicator = Indicator + 1
	end
	
	--check charisma and rhetoric
	local RhetoricSkill = GetSkillValue("",RHETORIC)
	local CharismaSkill = GetSkillValue("",CHARISMA)
	if RhetoricSkill > 4 then
		Indicator = Indicator + 1
	else
		Indicator = Indicator - 1
	end
	
	if CharismaSkill > 4 then
		Indicator = Indicator + 1
	else
		Indicator = Indicator - 1
	end
	
	--check currentfavor
	local CurrentFavor = GetFavorToDynasty("Destination","")
	if CurrentFavor > 79 then
		Indicator = Indicator + 4
	elseif CurrentFavor > 62 then
		Indicator = Indicator + 2
	elseif CurrentFavor > 37 then
		Indicator = Indicator - 2
	else
		Indicator = Indicator - 4
	end
	
	--check the end result
	if Indicator > 0 then
		return "A"
	else
		return "C"
	end
	
end

function Run()
	if not HasData("InitResult") then
		StopMeasure()
	end
	if not AliasExists("Destination") then
		StopMeasure()
	end
	
	local InitResult = GetData("InitResult")
	if InitResult == "C" then
		StopMeasure()
	end
	
	local StatusLabel = "@LHostility"
	local Favor = 0
	local Status = DIP_FOE
	if InitResult == 1 then
		StatusLabel = "@LNeutral"
		Favor = 50
		Status = DIP_NEUTRAL
	elseif InitResult == 2 then
		StatusLabel = "@LNAP"
		Favor = 70
		Status = DIP_NAP
	elseif InitResult == 3 then
		StatusLabel = "@LAlliance"
		Favor = 100
		Status = DIP_ALLIANCE
	end
	
	if DynastyGetTeam("") == DynastyGetTeam("Destination") and DynastyGetTeam("") > 0 then
		MsgQuick("", "@L_MEASURE_AdministrateDiplomacy_FAILURE_TEAM_+0")
		StopMeasure()
	end
	
	local CurrentState = DynastyGetDiplomacyState("Destination","")
	local CurrentLabel = "@LHostility"
	if CurrentState == InitResult then
		StopMeasure()
	elseif InitResult < CurrentState then
		if CurrentState == 1 then
			CurrentLabel = "@LNeutral"
		elseif CurrentState == 2 then
			CurrentLabel = "@LNAP"
		elseif CurrentState == 3 then	
			CurrentLabel = "@LAlliance"
		end
		
		DynastySetDiplomacyState("Destination","",Status)
		DynastyForceCalcDiplomacy("")
		SetFavorToDynasty("Destination","",Favor)
		MsgNewsNoWait("","Destination","","politics",-1,
			"@LDIPLOMATIC_STATE_CHANGED_HEAD",
			"@LDIPLOMATIC_STATE_CHANGED",GetID("Destination"),StatusLabel,CurrentLabel)
		MsgNewsNoWait("Destination","","","politics",-1,
			"@LDIPLOMATIC_STATE_CHANGED_HEAD",
			"@LDIPLOMATIC_STATE_CHANGED",GetID(""),StatusLabel,CurrentLabel)
		
		SetRepeatTimer("Dynasty", GetMeasureRepeatName(), 8)
		StopMeasure()
	end
	
	
	local MsgTimeOut = 0.5 --30sek
	local DestResult = MsgNews("Destination","",
				"@B[A,@L_FAMILY_2_COHABITATION_BIRTH_BAPTISM_BTN_+1]"..
				"@B[C,@L_ROBBER_134_PRESSPROTECTIONMONEY_ACTION_MSG_VICTIM_BTN_+1]",
				ms_administratediplomacy_AIDecision,  --AIFunc
				"politics", --MessageClass
				MsgTimeOut, --TimeOut
				"@LAdministrateDiplomacySheet",
				"@LDIPLOMATIC_REQUEST_QUESTION",
				GetID(""),StatusLabel)
				
	SetRepeatTimer("Dynasty", GetMeasureRepeatName(), 8)
	
	if DestResult == "C" then
		--decline
		ModifyFavorToDynasty("Destination","",-15)
		MsgNewsNoWait("","Destination","","politics",-1,
				"@LAdministrateDiplomacySheet",
				"%4l %2l$N$N%1DN: %>%3l%<",GetID("Destination"),StatusLabel,"@L_CHURCH_087_CHANGEFAITH_CATHOLIC_BTN_+1","@LStatus:")
		StopMeasure()
	end
	
	--accepted
	MsgNewsNoWait("","Destination","","politics",-1,
			"@LAdministrateDiplomacySheet",
			"@LDIPLOMATIC_REQUEST_ACCEPT",GetID("Destination"),StatusLabel)
	
	--SetFavorToDynasty("Destination","",Favor)
	DynastySetDiplomacyState("Destination","",Status)
	DynastyForceCalcDiplomacy("")

	if GetFavorToDynasty("Destination","")<Favor then
		SetFavorToDynasty("Destination","",Favor)
	end

	Sleep(1)
	StopMeasure()
	
end

function CleanUp()

end

