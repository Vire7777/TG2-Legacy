-------------------------------------------------------------------------------
----
----	OVERVIEW "ms_RoyalGuard"
----
----	With this measure the player can send out the royal guard
----  
----  1. Die Garde radiert alle Gauner im Zielgebiet über eine gewisse Zeitspanne aus
----  2. Jede Dynastie erhält eine Nachricht über die bevorstehende "Razzia"
----  3. Nach einer Zeit spawnt die Garde (sehr starte Kampfeinheiten) im Zielgebiet
----  4. Danach verschwindet die Garde wieder
-------------------------------------------------------------------------------

-- -----------------------
-- Run
-- -----------------------
function Run()
		
	local MeasureID = GetCurrentMeasureID("")
	local TimeOut = mdata_GetTimeOut(MeasureID)
	
	-- Get the residence of the king
	if not GetHomeBuilding("", "HomeBuilding") then
		StopMeasure()
	end
	
	local CurMeasID = GetCurrentMeasureID("")
	
	-- Spawn the guards at the home building
	GetPosition("", "GuardSpawnPos")
	
	local DynAlias = "Guards"..GetID("")


	SetProperty("","CalledGuards",1)
	for i=0, 1 do
		if not SimCreate(50, "HomeBuilding", "GuardSpawnPos", "Guard"..i) then
			StopMeasure()
		else				
			SetProperty("Guard"..i, "DynMember", GetID(""))
			SetProperty("Guard"..i, "CurMeasID", CurMeasID)

			SimSetBehavior("Guard"..i, "PapalGuardDuty")
		end
	end	
	SetMeasureRepeat(TimeOut)
end

-- -----------------------
-- GetOSHData
-- -----------------------
function GetOSHData(MeasureID)
	--can be used again in:
	OSHSetMeasureRepeat("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+2", Gametime2Total(mdata_GetTimeOut(MeasureID)))
end

-- -----------------------
-- CleanUp
-- -----------------------
function CleanUp()
end

