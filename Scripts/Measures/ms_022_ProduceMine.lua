function GetLocator()

	local LocatorArray = {
		"Work_01", ms_022_producemine_UseLocator, "",
		"Work_02", ms_022_producemine_UseLocator, "",
		"Work_03", ms_022_producemine_UseLocator, "",
		"Work_04", ms_022_producemine_UseLocator, "",
		"Work_05", ms_022_producemine_UseLocator, "",
		"Work_06", ms_022_producemine_UseLocator, "",
		"Work_07", ms_022_producemine_UseLocator, "",
		"Work_08", ms_022_producemine_UseLocator, "",
	}
	local	LocatorCount = 8
	IncrementXPQuiet("",5)
	local Position = (Rand(LocatorCount))*3+1
	return	LocatorArray[Position], LocatorArray[Position+1], LocatorArray[Position+2]
end


function UseLocator()
	PlayAnimation("", "hammer_in")
	LoopAnimation("", "hammer_loop")
	Sleep(10.0)
	PlayAnimation("", "hammer_out")
end

function CleanUp()
end
