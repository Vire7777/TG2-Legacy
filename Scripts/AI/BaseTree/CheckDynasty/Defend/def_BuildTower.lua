function Weight()
	if not AliasExists("Dynasty") then
		return 0
	end
	
	if GetMoney("Dynasty")<3000 then
		return 0
	end

	local Difficulty = ScenarioGetDifficulty()
	if Difficulty < 2 then
		return 0
	elseif Difficulty == 2 then
		return 5
	else
		return 10
	end
	return 0
end

function Execute()
	local Proto = ScenarioFindBuildingProto(7,40, 1+Rand(2), -1)
--	LogMessage("Proto = "..Proto)
	if Proto ~= -1 then
		if DynastyGetRandomBuilding("Dynasty", -1, -1, "ProtectMe") then
			if BuildingGetCity("ProtectMe", "ProCity") then
				if BuildingGetOwner("ProtectMe", "DaOwner") then
					if GetDynasty("DaOwner","MaiDynasty") then
						if ImpactGetMaxTimeleft("MaiDynasty","AITowerTimer") > 0 then
							return
						else
							ScenarioFindPosition("ProtectMe", 5000, EN_POSTYPE_GROUND, 300, 10000, EN_POSTYPE_GROUND, 100, "PosGround1", "PosGround2")
--							local a,b,c = PositionGetVector("PosGround1")
--							local x,y,z = PositionGetVector("PosGround2")
--							LogMessage("PosGround1:  a = "..a.." b = "..b.." c = "..c.." PosGround2: x = "..x.." y = "..y.." z = "..z)
							AddImpact("MaiDynasty","AITowerTimer",1,48)
							if not CityBuildNewBuilding("ProCity", Proto, "DaOwner", "Tower", "PosGround1") then
								if not CityBuildNewBuilding("ProCity", Proto, "DaOwner", "Tower", "PosGround2") then
--									LogMessage("Building Failed")
									return
								end
							end
						end
					end
				end
			end
		end
	end
	return
end

function CleanUp()
end
