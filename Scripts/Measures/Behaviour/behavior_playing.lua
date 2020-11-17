function Run()
	
	local Action = Rand(3)
	
	if Action == 0 then	
		GetLocatorByName("Residence", "Cohabit1", "PlayPos")	
	elseif Action == 1 then	
		GetLocatorByName("Residence", "Training1", "PlayPos")	
	elseif Action == 2 then
		GetLocatorByName("Residence", "Bed1", "PlayPos")
	end
		
	if AliasExists("PlayPos") then
		f_MoveTo("Owner", "PlayPos")
		PlayAnimation("Owner", "sit_laugh")
	end
	
	Sleep(1)
	
end

function CleanUp()
end
