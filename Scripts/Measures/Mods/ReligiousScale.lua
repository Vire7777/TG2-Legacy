function Run()
	local Faith = SimGetFaith("")
	local result = MsgNewsNoWait("",-1,"@P@B[O,@L_GENERAL_BUTTONS_CLOSE_+0]","politics",
	-1,
	"@L_RELIGIOUSSCALE_LOOSE_HEAD",
    "@L_RELIGIOUSSCALE_LOOSE_BODY",GetID(""), Faith)
end	

function CleanUp()
end
