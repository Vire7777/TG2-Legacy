function Run()
	Distance = GetData("Distance")
	if not Distance then
		Distance = 200
	end
	
	SetState("Owner", STATE_BLACKDEATH, true)
	
	if GetFleePosition("Owner", "Actor", Distance + Rand(Distance/10), "Away") then
		f_MoveTo("Owner", "Away", GL_MOVESPEED_RUN)
		AlignTo("Owner", "Actor")
	end
	Sleep(1)
end

function CleanUp()
end
