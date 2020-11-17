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
	
	if IsGUIDriven() then
		SetMeasureRepeat(TimeOut)
	else
		SetMeasureRepeat(60)
	end
	BuildingGetCity("building","city")
	
	local Percent = 0+ GetProperty("city","ChurchTithe")
	SetData("Oldpercent",Percent)
	local result = InitData("@P"..
	"@B[0,0,@L_PRIVILEGES_110_SETCHURCHTITHE_ACTION_BTN_+0,Hud/Buttons/btn_Money_Small.tga]"..
	"@B[1,2,@L_PRIVILEGES_110_SETCHURCHTITHE_ACTION_BTN_+1,Hud/Buttons/btn_Money_SmallLarge.tga]"..
	"@B[2,4,@L_PRIVILEGES_110_SETCHURCHTITHE_ACTION_BTN_+2,Hud/Buttons/btn_Money_Medium.tga]"..
	"@B[3,6,@L_PRIVILEGES_110_SETCHURCHTITHE_ACTION_BTN_+3,Hud/Buttons/btn_Money_MediumLarge.tga]"..
	"@B[4,8,@L_PRIVILEGES_110_SETCHURCHTITHE_ACTION_BTN_+4,Hud/Buttons/btn_Money_Large.tga]"..
	"@B[5,10,@L_PRIVILEGES_110_SETCHURCHTITHE_ACTION_BTN_+5,Hud/Buttons/btn_Money_VeryLarge.tga]",
	ms_110_set_churchtithe_AIFunction,
	"@L_PRIVILEGES_110_SETCHURCHTITHE_ACTION_TEXT_+1",
	"@L_PRIVILEGES_110_SETCHURCHTITHE_ACTION_TEXT_+0",Percent)
	
	local Tax = 0
	local Favor = 0
	local Corruption = 0
	if result==0 then
		SetProperty("city","ChurchTithe",0)
		Favor = 20
	elseif result==1 then
		SetProperty("city","ChurchTithe",4)
		Tax = 0.04
		Corruption = 0.01
	elseif result==2 then
		SetProperty("city","ChurchTithe",6)
		Tax = 0.06
		Corruption = 0.03
	elseif result==3 then
		SetProperty("city","ChurchTithe",8)
		Tax = 0.08
		Corruption = 0.05
	elseif result==4 then
		SetProperty("city","ChurchTithe",10)
		Tax = 0.1
		Corruption = 0.08
	elseif result==5 then
		SetProperty("city","ChurchTithe",15)
		Tax = 0.15
		Corruption = 0.12
	else
		SetData("Cancel","Cancel")
	end
	
	local TaxValue = 0+ GetProperty("city","ChurchTithe")
	local Oldpercent = GetData("Oldpercent")
	if Oldpercent ~= TaxValue then

		MsgNewsNoWait("All","","","politics",-1,
			"@L_PRIVILEGES_110_SETCHURCHTITHE_MSG_HEADLINE_+0",
			"@L_PRIVILEGES_110_SETCHURCHTITHE_MSG_BODY",GetID(""),TaxValue)	
	end
	local SimCount = Find("", "__F((Object.GetObjectsOfWorld(Sim))AND NOT(Object.BelongsToMe())AND(Object.IsDynastySim())AND(Object.MinAge(16)))","SimList", -1)
	for sim=0,SimCount-1 do
		local SimAlias = "SimList"..sim
		if GetProperty("city","ChurchTithe") ~= 0 then
			local Wealth = GetMoney(SimAlias)
			local Total = Wealth*Tax
			local Stolen = Wealth*Corruption
			SpendMoney(SimAlias,Total,"Taxes")
			ModifyFavorToSim(SimAlias,"",Favor)
			MsgNewsNoWait(SimAlias,"","","politics",-1,
				"@L_PRIVILEGES_110_TITHETAX_MSG_HEADLINE_+0",
				"@L_PRIVILEGES_110_TITHETAX_MSG_BODY_+0",GetID(""),Total)
			if not HasProperty("","OnceIsEnough") then
				SetProperty("","OnceIsEnough",1)
				if HasProperty("","BugFix") and not DynastyIsPlayer("") then
					DynastyGetFamilyMember("",0,"PayDaddy")
					CreditMoney("PayDaddy",Stolen,"Taxes")
				else
					CreditMoney("",Stolen,"Taxes")
				end
				MsgNewsNoWait("","","","politics",-1,
					"@L_PRIVILEGES_110_CORRUPTION_HEADLINE_+0",
					"@L_PRIVILEGES_110_CORRUPTION_BODY_+0",GetID(""),Stolen)
			end
		else
			ModifyFavorToSim(SimAlias,"",Favor)
			MsgNewsNoWait(SimAlias,"","","politics",-1,
				"@L_PRIVILEGES_110_TITHETAX_MSG_HEADLINE_+1",
				"@L_PRIVILEGES_110_TITHETAX_MSG_BODY_+1",GetID(""))
		end
	end	
	if HasProperty("","OnceIsEnough") then
		RemoveProperty("","OnceIsEnough")
	end	
	StopMeasure()
end
	


function CleanUp()

end

function AIFunction()
    if GetProperty("","Profession") == 11 then
	    return 5
	end

    if GetProperty("","Profession") == 9 then
	    return 0
	end	

    if GetProperty("","Class") == 4 then
	    return Rand(3)
	end
	
	return Rand(6)
end

function GetOSHData(MeasureID)
	--can be used again in:
	OSHSetMeasureRepeat("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+2",Gametime2Total(mdata_GetTimeOut(MeasureID)))
end
