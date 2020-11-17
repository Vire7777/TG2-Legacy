function Run()
	MeasureSetNotRestartable()
	if GetProperty("","CardinalFavor") == 5 then
		MsgQuick("","@L_INTRIGUE_DONATECARDINAL_FAILURES_ONE")
		StopMeasure()
	end	
	
	local MyMoney = GetMoney("")
    local Amount = 0
   
	local panel
    if MyMoney >= 10000 and not HasProperty("","CardinalFavor") then
        panel = ("@P"..
        "@B[1,@L_DONATECARDINAL_BUTTONS_+1]"..
        "@B[0,@L_REPLACEMENTS_BUTTONS_CANCEL_+0]")
		Amount = 10000
	elseif MyMoney >= 50000 and GetProperty("","CardinalFavor") == 1 then
        panel = ("@P"..
        "@B[2,@L_DONATECARDINAL_BUTTONS_+1]"..
        "@B[0,@L_REPLACEMENTS_BUTTONS_CANCEL_+0]")
		Amount = 50000
	elseif MyMoney >= 100000 and GetProperty("","CardinalFavor") == 2 then 
        panel = ("@P"..
        "@B[3,@L_DONATECARDINAL_BUTTONS_+1]"..
        "@B[0,@L_REPLACEMENTS_BUTTONS_CANCEL_+0]")
		Amount = 100000
	elseif MyMoney >= 500000 and GetProperty("","CardinalFavor") == 3 then
        panel = ("@P".. 
        "@B[4,@L_DONATECARDINAL_BUTTONS_+1]"..
        "@B[0,@L_REPLACEMENTS_BUTTONS_CANCEL_+0]")
		Amount = 500000
	elseif MyMoney >= 1000000 and GetProperty("","CardinalFavor") == 4 then
        panel = ("@P".. 
        "@B[5,@L_DONATECARDINAL_BUTTONS_+1]"..
        "@B[0,@L_REPLACEMENTS_BUTTONS_CANCEL_+0]")
		Amount = 1000000
	else
		MsgQuick("","@L_INTRIGUE_DONATECARDINAL_FAILURES_+0") 
        StopMeasure() 
    end
    
    local Result = MsgNews("","",panel,
            CouncilOfCardinals_AIDecision,  --AIFunc 
            "intrigue", --Message Class 
            2, --TimeOut 
            "@L_INTRIGUE_COUNCILOFCARDINALS_SCREENPLAY_ACTOR_HEAD_+0", 
            "@L_INTRIGUE_COUNCILOFCARDINALS_SCREENPLAY_ACTOR_BODY_+0", 
            GetID(""),Amount) 
			
	GetInsideBuilding("","Church")
	if Result == 1 then
		SetProperty("","CardinalFavor",1)
		BuildingGetOwner("Church","COwner")
		if AliasExists("COwner") then
			CreditMoney("COwner",1000,"IncomeOther")
		end	
	elseif Result == 2 then
		SetProperty("","CardinalFavor",2)
		BuildingGetOwner("Church","COwner")
		if AliasExists("COwner") then
			CreditMoney("COwner",5000,"IncomeOther")
		end	
	elseif Result == 3 then
		SetProperty("","CardinalFavor",3)
		BuildingGetOwner("Church","COwner")
		if AliasExists("COwner") then
			CreditMoney("COwner",10000,"IncomeOther")
		end	
	elseif Result == 4 then
		SetProperty("","CardinalFavor",4)	
		BuildingGetOwner("Church","COwner")
		if AliasExists("COwner") then
			CreditMoney("COwner",50000,"IncomeOther")
		end	
	elseif Result == 5 then
		SetProperty("","CardinalFavor",5)
		BuildingGetOwner("Church","COwner")
		if AliasExists("COwner") then
			CreditMoney("COwner",100000,"IncomeOther")
		end	
	else
		StopMeasure()
	end
	SpendMoney("",Amount,"CostAdministration")
	feedback_MessageCharacter("",
        "@L_CARDINALDONATION_ACTOR_SUCCESS_HEAD_+0",
        "@L_CARDINALDONATION_ACTOR_SUCCESS_BODY_+0",GetID(""),Amount)
	feedback_MessageCharacter("COwner",
        "@L_CARDINALDONATION_COWNER_SUCCESS_HEAD_+0",
        "@L_CARDINALDONATION_COWNER_SUCCESS_BODY_+0",Amount,GetID(""))
	Sleep(1)
	StopMeasure()
end

function AIDecision()
	Rand(5)
end	

function CleanUp()
	StopMeasure()
end
