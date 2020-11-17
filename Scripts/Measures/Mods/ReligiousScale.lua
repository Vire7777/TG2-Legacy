function Run()
	local Faith = SimGetFaith("")
	feedback_MessageCharacter("",
                  "@L_RELIGIOUSSCALE_LOOSE_HEAD",
                  "@L_RELIGIOUSSCALE_LOOSE_BODY",GetID(""), Faith)
end	

function CleanUp()
end
