function Run()
	MeasureSetNotRestartable()
	
	-- Verify we are not at max favor already
	if GetProperty("","CardinalFavor") == 5 then
		MsgQuick("","@L_INTRIGUE_DONATECARDINAL_FAILURES_ONE")
		StopMeasure()
	end	
	
	-- Initialize properties
	local MyMoney = GetMoney("")
  local Amount = {10000,50000,100000,500000,1000000}
  local CardinalFavor = 0
  if (HasProperty("","CardinalFavor") and GetProperty("","CardinalFavor")) then
    CardinalFavor = GetProperty("","CardinalFavor")
  end
   
  -- Calculate the amount of money you will need to pay
  if MyMoney < Amount[CardinalFavor+1] then
		MsgQuick("","@L_INTRIGUE_DONATECARDINAL_FAILURES_+0") 
    StopMeasure() 
  end
    
  -- Show the question panel
  local panel = ("@P".. 
        "@B[5,@L_DONATECARDINAL_BUTTONS_+1]"..
        "@B[0,@L_REPLACEMENTS_BUTTONS_CANCEL_+0]")
        
  local Result = MsgNews("","",panel,
          CouncilOfCardinals_AIDecision,  --AIFunc 
          "intrigue", --Message Class 
          2, --TimeOut 
          "@L_INTRIGUE_COUNCILOFCARDINALS_SCREENPLAY_ACTOR_HEAD_+0", 
          "@L_INTRIGUE_COUNCILOFCARDINALS_SCREENPLAY_ACTOR_BODY_+0", 
          GetID(""),Amount[CardinalFavor+1]) 
	
	 -- Pay your money
  SpendMoney("",Amount[CardinalFavor+1],"CostAdministration")
  
  -- Add more favor
	SetProperty("","CardinalFavor", CardinalFavor + 1)
	
	-- Give a percentage to the church owner
	GetInsideBuilding("","Church")
  BuildingGetOwner("Church","COwner")
  if AliasExists("COwner") then
    CreditMoney("COwner",Amount[CardinalFavor+1]/10,"IncomeOther")
  end 
	
	-- Send feedback for the donation
	feedback_MessageCharacter("",
        "@L_CARDINALDONATION_ACTOR_SUCCESS_HEAD_+0",
        "@L_CARDINALDONATION_ACTOR_SUCCESS_BODY_+0",GetID(""),Amount[CardinalFavor+1])
        
  -- Send feeback to the church owner for the donation
	feedback_MessageCharacter("COwner",
        "@L_CARDINALDONATION_COWNER_SUCCESS_HEAD_+0",
        "@L_CARDINALDONATION_COWNER_SUCCESS_BODY_+0",GetID(""),Amount[CardinalFavor+1]/10,GetID(""))
	Sleep(1)
	StopMeasure()
end

function AIDecision()
	Rand(5)
end	

function CleanUp()
	StopMeasure()
end
