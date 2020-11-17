function Weight()	
	local time = math.mod(GetGametime(),24)
	if time < 18 then
		return 0
	end
	local MyID = math.mod(GetID("SIM"),10)
	
	if MyID == nil then
		return 0
	end
	
	if MyID == 0 then
		return 30
	end
	
	if SimGetAge("SIM")<21 then
		return 0
	end
	return 1
end

function Execute()
	MeasureRun("SIM", "", "RPGSitAround")
	return
end

function CleanUp()
end
