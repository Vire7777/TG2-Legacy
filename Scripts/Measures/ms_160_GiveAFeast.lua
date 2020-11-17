function AIFunc()
	return Rand(4) 
end

function AISecondFunc()
	return Rand(3) 
end

function AIThirdFunc()
	local Choice = Rand(10) 
	if Choice < 4 then
		return 1
	else
		return 0
	end
end

function Run()
	if not GetHomeBuilding("","MyHome") then
		StopMeasure()
	end
	
	local FoodValue = 0
	local MusicValue = 0
	-- Essen & trinken bestellen
	local Res1 = MsgNews("","",
		"@B[0, @L_FEAST_1_PLAN_A_ORDERMENUE_+2]"..
		"@B[1, @L_FEAST_1_PLAN_A_ORDERMENUE_+3]"..
		"@B[2, @L_FEAST_1_PLAN_A_ORDERMENUE_+4]"..
		"@B[3, @L_FEAST_1_PLAN_A_ORDERMENUE_+5]"..
		"@B[4, @L_FEAST_1_PLAN_A_ORDERMENUE_+6]@P",
		ms_160_giveafeast_AIFunc,
		"politics",
		25,
		"@L_FEAST_1_PLAN_A_ORDERMENUE_+0",
		"@L_FEAST_1_PLAN_A_ORDERMENUE_+1", 
		10000,
		5000,
		2500,
		1750,
		500
		)

	local FoodLevel = 0 
	if Res1==0 then
		FoodLevel = 5		
		FoodValue = 10000
	elseif Res1==1 then
		FoodLevel = 4		
		FoodValue = 5000
	elseif Res1==2 then
		FoodLevel = 3		
		FoodValue = 2500
	elseif Res1==3 then
		FoodLevel = 2		
		FoodValue = 1750
	elseif Res1==4 then
		FoodLevel = 1		
		FoodValue = 500
	else
		return
	end		

	-- musiker bestellen
	local Res2 = MsgNews("","",
		"@B[0, @L_FEAST_1_PLAN_B_ORDERMUSICIANS_+1]"..
		"@B[1, @L_FEAST_1_PLAN_B_ORDERMUSICIANS_+2]"..
		"@B[2, @L_FEAST_1_PLAN_B_ORDERMUSICIANS_+3]"..
		"@B[3, @L_FEAST_1_PLAN_B_ORDERMUSICIANS_+4]@P",
		ms_160_giveafeast_AISecondFunc,
		"politics",
		25,
		"@L_FEAST_1_PLAN_A_ORDERMENUE_+0",
		"@L_FEAST_1_PLAN_B_ORDERMUSICIANS_+0",
		5000,
		2500,
		1750,
		500
		)

	local MusicLevel = 0 
	if Res2==0 then			--Die berühmten >Mittelländer Troubadoure<
		MusicLevel = 4		
		MusicValue = 5000
	elseif Res2==1 then		--Den bekannten Barden >Willem Hamshakes<
		MusicLevel = 3		
		MusicValue = 2500
	elseif Res2==2 then		--Eine Truppe Flötisten aus den Anden
		MusicLevel = 2		
		MusicValue = 1750
	elseif Res2==3 then		--Die berüchtigten >Fürchterlichen Volksmusikanten<
		MusicLevel = 1		
		MusicValue = 500
	else
		return
	end		
	local PriceForInvite = 250
	local PriceForFeast = MusicValue + FoodValue
	-- zusammenfassung: und ja/nein
	local Res3 = MsgNews("","",
		"@B[0, @L_FEAST_1_PLAN_BTN_+0]@B[1, @L_FEAST_1_PLAN_BTN_+1]@P",
		ms_160_giveafeast_AIThirdFunc,
		"politics",
		25,
		"@L_FEAST_1_PLAN_A_ORDERMENUE_+0",
		"_FEAST_1_PLAN_C_DATE_+0",
		PriceForFeast,
		PriceForInvite
		)
	
	if Res3 == 1 then
		StopMeasure()
	end
	
	if DynastyIsPlayer("") then
		if not SpendMoney("", PriceForFeast ,"CostSocial") then
			StopMeasure()
		end
	end
	
	SetState("MyHome",STATE_FEAST,true)
	SetProperty("","Host")
	SetProperty("MyHome","InvitationsLeft",6)
	SetProperty("MyHome","CanInvite",1)
	SetProperty("MyHome","MusicLevel",MusicLevel)
	SetProperty("MyHome","FoodLevel",FoodLevel)
	SetProperty("MyHome","BaseMoney",PriceForFeast)
	SetProperty("MyHome","PriceForInvite",PriceForInvite)
	
	StopMeasure()
end

function CallToFeast()
	if not GetHomeBuilding("","PartyLocation") then
		StopMeasure()
	end
	if not BuildingHasUpgrade("PartyLocation",531) then	--salon
		StopMeasure()
	end
	if not MeasureRun("","PartyLocation","AttendFestivity") then
		StopMeasure()
	end
end

function CleanUp()
end

