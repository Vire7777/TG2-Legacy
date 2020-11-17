-------------------------------------------------------------------------------
----
----	OVERVIEW "behavior_RoyalGuard.lua"
----
-------------------------------------------------------------------------------

-- -----------------------
-- Run
-- -----------------------
function Run()
	
	-- Avert the guard from anything else but his duty !
	SetState("", STATE_LOCKED, true)
	SetProperty("", "NotAffectable", 1)

	GetAliasByID(GetProperty("", "DynID"), "Dynasty")
	
	-- Get the guard a weapon
	if not HasProperty("", "Equiped") then
		AddItems("", "Platemail", 1, INVENTORY_EQUIPMENT)
		AddItems("", "FullHelmet", 1, INVENTORY_EQUIPMENT)
		AddItems("", "IronBrachelet", 1, INVENTORY_EQUIPMENT)
		AddItems("", "Longsword", 1, INVENTORY_EQUIPMENT)
		AddImpact("", "Elite", 5, 0)
		SetProperty("", "Equiped", 1)
	end

	CarryObject("", "Handheld_Device/ANIM_Shield2.nif", true)
	
	-- Get the destination position
	if not ScenarioCreatePosition(GetProperty("", "DestX"), GetProperty("", "DestZ"), "DestPos") then
		StopMeasure()
	end

	f_MoveTo("", "DestPos", GL_MOVESPEED_RUN)
	GfxRotateToAngle("", 0, Rand(360), 0, 1, true)
	
	-- Check if the guard is here the first time
	if not HasProperty("", "EndTime") then
		local duration = 12
		local CurrentTime = GetGametime()
		local EndTime = CurrentTime + duration
		SetProperty("", "EndTime", EndTime)
	end
	
	-- SetData("Time", duration)
	-- SetData("EndTime", EndTime)	
	-- SetProcessMaxProgress("", duration*10)
	-- SendCommandNoWait("", "Progress")

	local Range = 1500
	if HasData("CurMeasID") then
		local MeasureID = GetProperty("", "CurMeasID")
		Range = GetDatabaseValue("Measures", MeasureID, "rangeradius") * 100
	end
	
	Find("", "__F((Object.GetObjectsOfWorld(Sim))AND(Object.IsDynastySim())AND(Object.Property.CalledGuards==1))","TheBossMan", -1)
	-- Do the timer loop
	local EndTime = GetProperty("", "EndTime")
	while GetGametime() < EndTime do
		
		local Enemy = Find("", "__F((Object.GetObjectsOfWorld(Sim))AND(Object.GetState(fighting))AND NOT(Object.Property.CalledGuards==1))", "Enemy", -1)
		for i=0, Enemy-1 do
			LogMessage("Log Message: EnemyID == "..GetID("Enemy"..i))
			local Distance = GetDistance("","Enemy"..i)
			if Distance < 5000 then
				f_Fight("", "Enemy"..i, "subdue")
			end
			while GetState("", STATE_FIGHTING) do
				Sleep(3)
			end
		end
		-- Fight until the fight is over even if the measure is over
		
		f_MoveToNoWait("","TheBossMan", GL_MOVESPEED_RUN, 100)
		Sleep(1)
	end
	
	-- Move out
	RemoveProperty("TheBossMan","CalledGuards")
	GetHomeBuilding("", "HomeBuilding")
	f_MoveTo("", "HomeBuilding")
	StopMeasure()
	
end

-- -----------------------
-- Progress
-- -----------------------
function Progress()

	while true do
		local Time = GetData("Time")
		local EndTime = GetData("EndTime") 
		local CurrentTime = GetGametime() 
		CurrentTime = EndTime - CurrentTime 
		CurrentTime = Time - CurrentTime 
		SetProcessProgress("", CurrentTime*10)
		Sleep(3)
	end

end

-- -----------------------
-- CleanUp
-- -----------------------
function CleanUp()

	local EndTime = GetProperty("", "EndTime")
	if not (GetState("", STATE_FIGHTING)) and (GetGametime() > EndTime) then	
		ResetProcessProgress("")
		CarryObject("", "", true)
		InternalDie("")
		InternalRemove("")		
	end
	
end

