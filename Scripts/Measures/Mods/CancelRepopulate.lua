function Run()

	local TownHall = Find("", "__F((Object.GetObjectsOfWorld(Building))AND(Object.IsType(23)))","CityCenter", -1)
	local idx
	for idx=0, TownHall-1 do
		local CityH = "CityCenter"..idx
		RemoveProperty(CityH, "CancelRun")
	end
	RemoveScriptcall("RepeatRepopulate")
end	

function CleanUp()
end
