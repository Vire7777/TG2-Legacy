--This measure allows you to raise your disposition by donating a user selected amount to every dynasty member in your city. The more you pay the more your disposition will rise

function Run()    
    if not GetSettlement("","city") then
	    StopMeasure()
    end
    CityGetDynastyCharList("city","dyn_chars") 

    for i=0,ListSize("dyn_chars") do
        ListGetElement("dyn_chars",i,"TheChar") 
         if DynastyIsPlayer("TheChar") then
            ListRemove("dyn_chars","TheChar")
        end
    end
    
    local Citizens = ListSize("dyn_chars")
    local MyMoney = GetMoney("")
    local AmountArr = {}
        AmountArr[1] = 250
        AmountArr[2] = 500
        AmountArr[3] = 750
        AmountArr[4] = 1000
    local DonationArr = {}
        DonationArr[1] = (Citizens) * AmountArr[1]
        DonationArr[2] = (Citizens) * AmountArr[2]
        DonationArr[3] = (Citizens) * AmountArr[3]
        DonationArr[4] = (Citizens) * AmountArr[4]
    
    local panel
    if MyMoney >= DonationArr[4] then
        panel = ("@P"..
        "@B["..AmountArr[1]..",@L_DONATEMONEY_BUTTONS_+1]"..
        "@B["..AmountArr[2]..",@L_DONATEMONEY_BUTTONS_+2]"..
        "@B["..AmountArr[3]..",@L_DONATEMONEY_BUTTONS_+3]"..
        "@B["..AmountArr[4]..",@L_DONATEMONEY_BUTTONS_+4]"..
        "@B[0,@L_REPLACEMENTS_BUTTONS_CANCEL_+0]")
    elseif MyMoney >= DonationArr[3] then
        panel = ("@P"..
        "@B["..AmountArr[1]..",@L_DONATEMONEY_BUTTONS_+1]"..
        "@B["..AmountArr[2]..",@L_DONATEMONEY_BUTTONS_+2]"..
        "@B["..AmountArr[3]..",@L_DONATEMONEY_BUTTONS_+3]"..
        "@B[0,@L_REPLACEMENTS_BUTTONS_CANCEL_+0]")
    elseif MyMoney >= DonationArr[2] then
        panel = ("@P".. 
        "@B["..AmountArr[1]..",@L_DONATEMONEY_BUTTONS_+1]"..
        "@B["..AmountArr[2]..",@L_DONATEMONEY_BUTTONS_+2]"..
        "@B[0,@L_REPLACEMENTS_BUTTONS_CANCEL_+0]")
    elseif MyMoney >= DonationArr[1] then
        panel = ("@P".. 
        "@B["..AmountArr[1]..",@L_DONATEMONEY_BUTTONS_+1]"..
        "@B[0,@L_REPLACEMENTS_BUTTONS_CANCEL_+0]")
    else
        MsgQuick("","@L_INTRIGUE_DONATEMONEY_FAILURES_+0") 
        StopMeasure() 
    end
    
    local Result = MsgNews("","",panel,
            ms_raisedisposition_AIDecision,  --AIFunc 
            "intrigue", --Message Class 
            2, --TimeOut 
            "@L_INTRIGUE_RAISEDISPOSITION_SCREENPLAY_ACTOR_HEAD_+0", 
            "@L_INTRIGUE_RAISEDISPOSITION_SCREENPLAY_ACTOR_BODY_+0", 
            GetID(""),AmountArr[1],DonationArr[1],AmountArr[2],DonationArr[2],AmountArr[3],DonationArr[3],AmountArr[4],DonationArr[4]) 

    if Result ~= 0 then
        for i=0,ListSize("dyn_chars")-1 do 
            ListGetElement("dyn_chars",i,"char")  
            if IsPartyMember("char") == false then            
                chr_RecieveMoney("char", Result, "IncomeBribes")
                feedback_MessageCharacter("char",
                  "@L_RECEIVEDONATION_ACTOR_SUCCESS_HEAD_+0",
                  "@L_RECEIVEDONATION_ACTOR_SUCCESS_BODY_+0",GetID(""), Result)
            end
        end
      
        local Donation = Citizens * Result
        SpendMoney("",Donation,"CostBribes")
        for i=Result,AmountArr[1],-AmountArr[1]  do
            CommitAction("charity","","","")
        end
		local MeasureID = GetCurrentMeasureID("")
		local TimeOut = mdata_GetTimeOut(MeasureID)
		SetRepeatTimer("", GetMeasureRepeatName(), TimeOut)
    end
end  

function CleanUp()
end

function AIDecision()
	return AmountArr[1]
end

function GetOSHData(MeasureID)
	--can be used again in:
	OSHSetMeasureRepeat("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+2",Gametime2Total(mdata_GetTimeOut(MeasureID)))
end
