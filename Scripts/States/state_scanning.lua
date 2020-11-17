function Run()
	-- dont remove this line since it sets the owners dynasty that is needed for later filter
	GetDynasty("", "Dynasty")
	
	while not GetState("", STATE_DEAD) do
	
		if IsType("","Sim") then
			state_scanning_ArrestLoop()
		elseif IsType("","Building")then
			state_scanning_WatchtowerLoop() 
		end
		Sleep(4)
	end
end


function ArrestLoop()
	if not GetState("", STATE_FIGHTING) then
		if CityGuardScan("", "Penalty") then  -- find a fugitive (and with no impact "no_arrestable")
			if PenaltyGetOffender("Penalty", "Wanted") then -- wanted found -> arrest him
				if (GetCurrentMeasureName("") ~=  "Arrest") and (GetCurrentMeasureName("Wanted") ~=  "Arrest") then
					if GetImpactValue("Wanted","REVOLT") > 0 then
						if GetState("Wanted", STATE_UNCONSCIOUS) then
							feedback_OverheadActionName("Wanted")
							GetPosition("Wanted", "ParticleSpawnPos")
							BattleWeaponPresent("")
							Sleep(2)
							PlayAnimationNoWait("","finishing_move_01")
							Sleep(0.6)	
							StartSingleShotParticle("particles/bloodsplash.nif", "ParticleSpawnPos", 1,4)
							PlaySound3DVariation("Wanted","Effects/combat_strike_mace",1)
							Sleep(2)
							BattleWeaponStore("")	
							if AliasExists("Wanted") then
								SetProperty("Wanted","UnconsciousKill",1)
								Kill("Wanted")
							end
						else
							gameplayformulas_SimAttackWithRangeWeapon("", "Wanted")
							BattleJoin("", "Wanted", true)
						end
					else
						MeasureRun("", "Wanted", "Arrest")
					end
				end
			end
		end
	end
end

function WatchtowerLoop()
	if not GetState("", STATE_FIGHTING) then
		-- Detect enemy ships
		local ShipFilter = "__F((Object.GetObjectsByRadius(Ship)==4000)AND(Object.IsHostile())AND(Object.GetState(fighting))AND(Object.IsShipWithCannons))"
		local NumOfShips = Find("", ShipFilter,"HostileShip", -1)
		if NumOfShips > 0 then
			local iBattleID = BattleJoin("","HostileShip", false)
			return
		end
		
		-- Detect enemy watchtower
		local BuildingFilter = "__F((Object.GetObjectsByRadius(Building)==4000)AND(Object.IsHostile())AND(Object.GetState(fighting))AND(Object.IsType(40)))"
		local NumOfBuildings = Find("", BuildingFilter,"HostileBuilding", -1)
		if NumOfBuildings > 0 then
			local iBattleID = BattleJoin("","HostileBuilding", false)
			return
		end
		
		--Detect enemy and fighting Sims
		BuildingGetOwner("","WatchOwner")
		if AliasExists("WatchOwner") then
			local TowerID = GetDynastyID("WatchOwner")
			local SimFilter = "__F((Object.GetObjectsByRadius(Sim)==4000)AND(Object.HasImpact(NotFriends))AND(((Object.IsHostile())AND(Object.GetState(fighting)))OR(Object.IsClass(4))))"
			local NumOfSims = Find("",SimFilter,"Dumbass",-1) 
			if NumOfSims > 0 then
				for i=0,NumOfSims-1 do
					local Jerk = "Dumbass"..i
					if TowerID == GetImpactValue(Jerk,"NotFriends") then
						BattleJoin("",Jerk,false)
						return
					end
				end
			end
		end
	end
	Sleep(1)
end

function CleanUp()
end
