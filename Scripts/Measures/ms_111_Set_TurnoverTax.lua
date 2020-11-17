function Run()
	if GetData("Cancel")=="Cancel" then
		StopMeasure()
	end

	local MeasureID = GetCurrentMeasureID("")
	local TimeOut = mdata_GetTimeOut(MeasureID)

	if not ai_GoInsideBuilding("", "",-1, GL_BUILDING_TYPE_TOWNHALL) then
		StopMeasure()
	end
	if not GetInsideBuilding("","building") then
		StopMeasure()
	end

	BuildingGetCity("building","city")
	local Percent = 0+ GetProperty("city","TurnoverTax")
	SetData("Oldpercent",Percent)
	local Tax
	local Favor
	local Corruption = 0
	local result = InitData("@P"..
	"@B[0,0,@L_PRIVILEGES_111_SETTURNOVERTAX_ACTION_BTN_+0,Hud/Buttons/btn_Money_Small.tga]"..
	"@B[1,10,@L_PRIVILEGES_111_SETTURNOVERTAX_ACTION_BTN_+1,Hud/Buttons/btn_Money_SmallLarge.tga]"..
	"@B[2,15,@L_PRIVILEGES_111_SETTURNOVERTAX_ACTION_BTN_+2,Hud/Buttons/btn_Money_Medium.tga]"..
	"@B[3,20,@L_PRIVILEGES_111_SETTURNOVERTAX_ACTION_BTN_+3,Hud/Buttons/btn_Money_MediumLarge.tga]"..
	"@B[4,30,@L_PRIVILEGES_111_SETTURNOVERTAX_ACTION_BTN_+4,Hud/Buttons/btn_Money_Large.tga]",
	ms_111_set_turnovertax_AIFunction,
	"@L_PRIVILEGES_111_SETTURNOVERTAX_ACTION_TEXT_+1",
	"@L_PRIVILEGES_111_SETTURNOVERTAX_ACTION_TEXT_+0",Percent)

	if result==0 then
		SetProperty("city","TurnoverTax",0)
		Tax = 0
		Favor = 45
	elseif result==1 then
		SetProperty("city","TurnoverTax",10)
		Tax = 0.02
		Favor = -5
		Corruption = 0.02
	elseif result==2 then
		SetProperty("city","TurnoverTax",15)
		Tax = 0.03
		Favor = -10
		Corruption = 0.03
	elseif result==3 then
		SetProperty("city","TurnoverTax",20)
		Tax = 0.04
		Favor = -20
		Corruption = 0.04
	elseif result==4 then
		SetProperty("city","TurnoverTax",30)
		Tax = 0.05
		Favor = -30
		Corruption = 0.05
	else
		SetData("Cancel","Cancel")
	end
	
	if IsGUIDriven() then
		SetMeasureRepeat(TimeOut)
	else
		SetMeasureRepeat(50)
	end
	BuildingGetCity("building","city")
	CityGetDynastyCharList("city","dyn_chars")
	local TaxValue = 0+ GetProperty("city","TurnoverTax")
	local Oldpercent = GetData("Oldpercent")
	if Oldpercent ~= TaxValue then
		MsgNewsNoWait("All","","","politics",-1,
		"@L_PRIVILEGES_111_SETTURNOVERTAX_MSG_HEADLINE_+0",
		"@L_PRIVILEGES_111_SETTURNOVERTAX_MSG_BODY",GetID(""),GetID("city"),TaxValue)
	end
	
	local Wealth = 0
	local Total = 0
	local Stolen = 0
	local CityCoffers = 0
	local CofferMoney = 0
	local StolenMoney = 0
	if GetProperty("city","TurnoverTax") ~= 0 then
		for i=0,ListSize("dyn_chars")-1 do 
			ListGetElement("dyn_chars",i,"char")  
			GetDynasty("char","DynCheck")
			DynastyGetFamilyMember("DynCheck",0,"PayUp")
			if not HasProperty("PayUp","OnceIsEnough") then
				SetProperty("PayUp","OnceIsEnough",1)
				if SimGetOfficeLevel("PayUp") == -1 then	
					Wealth = GetMoney("PayUp")
					Total = Wealth*Tax
					Stolen = Total*Corruption
					CityCoffers = Total - Stolen
					if not HasProperty("city", "IncomeTax") then
						SetProperty("city", "IncomeTax", CityCoffers)
					else
						CofferMoney = GetProperty("city", "IncomeTax") + CityCoffers
						SetProperty("city", "IncomeTax", CofferMoney)
					end
				
					if not HasProperty("", "IncomeTax") then
						SetProperty("", "IncomeTax", Stolen)
					else
						StolenMoney = GetProperty("", "IncomeTax") + Stolen
						SetProperty("", "IncomeTax", StolenMoney)
					end
					
					CreditMoney("PayUp",-Total,"SalesTax")
					ModifyFavorToSim("PayUp","",Favor)
					MsgNewsNoWait("PayUp","","","politics",-1,
					"@L_PRIVILEGES_111_HIDDENTAX_MSG_HEADLINE_+0",
					"@L_PRIVILEGES_111_HIDDENTAX_MSG_BODY_+0",GetID(""),Total)
				end
			end
		end
		for i=0,ListSize("dyn_char")-1 do 
			ListGetElement("dyn_char",i,"dude")  
			GetDynasty("dude","DynCheck")
			DynastyGetFamilyMember("DynCheck",0,"DynMem")
			if HasProperty("DynMem","OnceIsEnough") then
				RemoveProperty("DynMem","OnceIsEnough")
			end
		end
		
		local PayBoss = GetProperty("","IncomeTax")
		local PayCity = GetProperty("city","IncomeTax")
		if PayBoss ~= nil and PayBoss > 0 then
			if HasProperty("","BugFix") and not DynastyIsPlayer("") then
				DynastyGetFamilyMember("",0,"PayDaddy")
				CreditMoney("PayDaddy",PayBoss,"IncomeThiefs")
			else
				CreditMoney("",PayBoss,"IncomeThiefs")
			end
			MsgNewsNoWait("","","","politics",-1,
			"@L_PRIVILEGES_111_CORRUPTION_HEADLINE_+0",
			"@L_PRIVILEGES_111_CORRUPTION_BODY_+0",GetID(""),PayBoss)
		end
		
		if PayCity ~= nil and PayCity > 0 then
			CreditMoney("city",PayCity,"IncomeOther")
		end
		RemoveProperty("","IncomeTax")
		RemoveProperty("city","IncomeTax")
	else
		for i=0,ListSize("dyn_chars")-1 do 
			ListGetElement("dyn_chars",i,"char")  
			GetDynasty("char","DynCheck")
			DynastyGetFamilyMember("DynCheck",0,"Friend")
			if SimGetOfficeLevel("Friend") == -1 then
				if not HasProperty("Friend","OnceIsEnough") then
					SetProperty("Friend","OnceIsEnough",1)
					ModifyFavorToSim("Friend","",Favor)
					MsgNewsNoWait("Friend","","","politics",-1,
					"@L_PRIVILEGES_111_NOTAX_MSG_HEADLINE_+0",
					"@L_PRIVILEGES_111_NOTAX_MSG_BODY_+0",GetID(""))
				end
			end
		end
		for i=0,ListSize("dyn_char")-1 do 
			ListGetElement("dyn_char",i,"dude")  
			GetDynasty("dude","DynCheck")
			DynastyGetFamilyMember("DynCheck",0,"DynMem")
			if HasProperty("DynMem","OnceIsEnough") then
				RemoveProperty("DynMem","OnceIsEnough")
			end
		end
	end
	StopMeasure()
end


function AIFunction()
    if GetProperty("","Class") == 1 then --Patrons need friends it is in their best interest to set taxes low
		return Rand(1)
	end
	
	if GetProperty("","Class") == 3 then --Scholars also need friends but not quite to the same extent...they can be a bit snobby :D 
	    return Rand(2)
	end
	
	local Personality = SimGetAlignment("")
	if Personality < 25 then
		return Rand(1)
	elseif Personality < 50 then
		return Rand(2)
	elseif Personality < 75 then
		return (Rand(3)+1)
	else
		return (Rand(2)+2)
	end
	
	return Rand(4) --This is just a failsafe. It should not be needed
end

function GetOSHData(MeasureID)
	--can be used again in:
	OSHSetMeasureRepeat("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+2",Gametime2Total(mdata_GetTimeOut(MeasureID)))
end

