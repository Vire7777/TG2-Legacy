function Run()
	MeasureSetNotRestartable()
	local panel
    panel = ("@P"..
	"@B[1,@L_IMPERIALREMOVE_BUTTONS_+1]"..
    "@B[0,@L_REPLACEMENTS_BUTTONS_CANCEL_+0]")
	
	local Result = MsgNews("","",panel,
			imperialremove_AIDecision,  --AIFunc 
            "intrigue", --Message Class 
            2, --TimeOut 
            "@L_INTRIGUE_IMPERIALREMOVE_SCREENPLAY_ACTOR_HEAD_+0", 
            "@L_INTRIGUE_IMPERIALREMOVE_SCREENPLAY_ACTOR_BODY_+0", 
            GetID("destination")) 
			
	if Result == 0 then
		StopMeasure()
	else
		SetFavorToSim("","destination",0)
		SimSetOffice("destination",0)
		feedback_MessageCharacter("",
			"@L_IMPERIALREMOVE_ACTOR_SUCCESS_HEAD_+0",
			"@L_IMPERIALREMOVE_ACTOR_SUCCESS_BODY_+0",GetID("destination"))
		feedback_MessageCharacter("destination",
			"@L_IMPERIALREMOVE_ACTOR_SUCCESS_HEAD_+1",
			"@L_IMPERIALREMOVE_ACTOR_SUCCESS_BODY_+1",GetID(""))
	end
end

function AIDecision()
	return 1
end

function CleanUp()
	StopMeasure()
end
