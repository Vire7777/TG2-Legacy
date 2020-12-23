-- The tax system is only for you as a player
function Run()
	HudGetActiveCharacter("Sim")
	GetDynasty("Sim", "Dyn")
	local dueTaxes = taxes_CalculateDynTaxes()
	
	local options = "@P"
	if ((GetProperty("Dyn", "CIVILTAXES_ISPAID") ~= 1)) then	
		options = options.."@B[0,@L_CIVILTAXES_PAYMENT_PAY]"
		options = options.."@B[1,@L_CIVILTAXES_PAYMENT_NOTPAY]"
	else
		options = options.."@B[0,@L_CIVILTAXES_PAYMENT_WASPAID]"
	end
	
	local result = MsgNews("Dyn",-1,
		options, --options
		-1,  --AIFunc
		"politics", --MessageClass
		-1, --TimeOut
		"@L_CIVILTAXES_INFORMATION_HEAD",
		"@L_CIVILTAXES_INFORMATION_BODY",
		GetID("Sim"),dueTaxes)
			
	if (result == 0 and GetProperty("Dyn", "CIVILTAXES_ISPAID") ~= 1) then
		if (GetMoney("Sim") > dueTaxes) then
    		taxes_PaymentSuccesful(dueTaxes)
    		SetProperty("Dyn", "CIVILTAXES_ISPAID", 1)
    	else
    		feedback_MessagePolitics("Dyn","@L_CIVILTAXES_NOTPAID_HEAD_+0",
    			"@L_CIVILTAXES_NOTPAID_BODY_+0", dueTaxes)
		end
	end
end	

function PaymentSuccesful(dueTaxes)
	SpendMoney("Dyn", dueTaxes, "Civil taxes")
	feedback_MessagePolitics("Dyn","@L_CIVILTAXES_PAID_HEAD_+0",
		"@L_CIVILTAXES_PAID_BODY_+0", dueTaxes)
end

function CivilTaxCollection()
	-- Check all player dynasties 
	GetDynasty("Sim","Dyn")
	
    if (GetProperty("Dyn", "CIVILTAXES_ISPAID") ~= 1) then
    	-- calculate taxes
    	local dueTaxes = taxes_CalculateDynTaxes()
    
    	--  does the dynasty has enough money to pay
		taxes_PayTaxes(dueTaxes)
	else
		-- your cursor for the next turn tax is put to is not paid
		SetProperty("Dyn", "CIVILTAXES_ISPAID", 0)
	end 
    	
	-- call the script for next taxes
	CreateScriptcall("CivilTaxCollection",24,"Measures/Mods/Taxes.lua","CivilTaxCollection","Sim","Sim",0)
end

function PayTaxes(dueTaxes)
	-- pay the fine
	if (GetMoney("Dyn") > dueTaxes) then
		taxes_PaymentSuccesful(dueTaxes)
		return
	end
	
	-- else we launch the seize procedure
	feedback_MessagePolitics("Dyn","@L_CIVILTAXES_PAID_HEAD_+0",
		"@L_LAWSUIT_6_DECISION_C_JUDGEMENT_ANNOUNCEMENT_+8",dueTaxes)
	CreateScriptcall("TakeFineOrSeize",6,"Measures/Mods/Taxes.lua","TakeFineOrSeize","Sim","Sim",dueTaxes)
end

function TakeFineOrSeize(dueTaxes)
	if (GetProperty("Dyn", "CIVILTAXES_ISPAID") == 1) then
        -- your cursor for the next turn tax is put to is not paid
        SetProperty("Dyn", "CIVILTAXES_ISPAID", 0)
        return
	end

	HudGetActiveCharacter("Sim")
	-- pay the finelocal 
	local simMoney = GetMoney("Sim")
	dueTaxes = 1 + dueTaxes - 1
	
	if (dueTaxes < simMoney) then
		-- as you paid, you are not going to jail anymore
		taxes_PaymentSuccesful(dueTaxes)
		return
	end
	
	-- Can t pay, then seize of properties
	SpendMoney("Dyn", simMoney, "Civil taxes")
	dueTaxes = dueTaxes - simMoney
	
	GetSettlement("Sim", "City")			
	local seizeMoney = taxes_SeizeProperties(dueTaxes)
	dueTaxes = dueTaxes - seizeMoney

    if (dueTaxes <= 0) then
    	-- seize resolves the debt
    	CreditMoney("Dyn",-dueTaxes,"Seize rest")
    	feedback_MessagePolitics("Dyn","@L_LAWSUIT_7_BUILDINGSEIZE_HEAD_+0",
					"@L_LAWSUIT_7_BUILDINGSEIZE_BODY_+0")
    elseif (GetImpactValue("Sim", "TaxPunishment") > 0) then
    	-- seize didn t resolve the debt => sentenced to death
    	taxes_DeathSentence()
    else
    	-- seize didn t resolve the debt => sentenced to jail
    	taxes_JailSentence(dueTaxes)
    end
end

function JailSentence(dueTaxes)
	-- in case can t pay, you go to death
	feedback_MessagePolitics("Dyn","@L_LAWSUIT_7_BUILDINGSEIZE_HEAD_+2",
		"@L_LAWSUIT_7_BUILDINGSEIZE_BODY_+2", dueTaxes)
	CreateScriptcall("TakeFineOrSeize",12,"Measures/Mods/Taxes.lua","TakeFineOrSeize","Sim","Sim",dueTaxes)
	CityAddPenalty("City","Sim",PENALTY_PRISON,1)
end

function DeathSentence()
	-- in case can t pay, you go to death
	feedback_MessagePolitics("Dyn","@L_LAWSUIT_7_BUILDINGSEIZE_HEAD_+1",
		"@L_LAWSUIT_7_BUILDINGSEIZE_BODY_+1")
	CityAddPenalty("City","Sim",PENALTY_DEATH,96)
end

function SeizeProperties(dueTaxes)
	-- look for each building
	GetDynasty("Sim", "Dyn")
	local bldCount = DynastyGetBuildingCount2("Dyn")
    local seizeMoney = 0
    local HomeId = GetHomeBuildingId("Sim")
    
	for i=0, bldCount - 1 do
    	if DynastyGetBuilding2("Dyn", i, "Check") then
    		
    		-- we seize the building
    		if (GetID("Check") ~= HomeId) then
    			
        		local buildingPrice = BuildingGetBuyPrice("Check")
    			SetState("Check",STATE_DEAD,true)
        		
        		seizeMoney = seizeMoney + buildingPrice / 2
    		end
    		
    		-- enough building were seized
    		if (dueTaxes <= seizeMoney) then
    			return seizeMoney
    		end
    	end
    end
        
    return seizeMoney
end

function CalculateDynTaxes()
	-- find number of building owned
	local sumBuildingPrices = 0
	local BldCount = DynastyGetBuildingCount("Dyn")
	
	for i=0, BldCount - 1 do
    	if DynastyGetBuilding2("Dyn", i, "building") then
    		
    		-- we add the price to the sum
    		sumBuildingPrices = sumBuildingPrices + BuildingGetBuyPrice("building")
    	end
	end
	
	-- find th title of dynasty
	local titleLevel = GetNobilityTitle("Sim")
	
	-- we calculate the taxes
	local dueTaxes = sumBuildingPrices * (titleLevel * 2 + 20) / 100
	return dueTaxes
end

function CleanUp()
end
