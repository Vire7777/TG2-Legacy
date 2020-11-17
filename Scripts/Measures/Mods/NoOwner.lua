function Run()
	
	local Class = BuildingGetCharacterClass("")
	local Level
	if BuildingGetLevel("") == 1 then
		Level = 1
	elseif BuildingGetLevel("") == 2 then
		Level = 3
	else
		Level = 5
	end
	
	if Class ~= -1 then
		local sim
		local SimCount = ScenarioGetObjects("cl_Sim", 9999, "SimList")
		ListNew("Bums")
		for sim=0,SimCount-1 do
			local SimAlias = "SimList"..sim
			if DynastyIsShadow(SimAlias) then
				if SimGetAge(SimAlias) >= GL_AGE_FOR_GROWNUP then
					if GetNobilityTitle(SimAlias) > 1 then
						if SimGetClass(SimAlias) == Class then -- <--- Ensure the Sim will be able to use the building by making sure only sims with the buildings class make it on the list
							if SimGetLevel(SimAlias) >= Level then -- <-- The Shadow dynasty needs to have the right to own the buiding or an error pops up (level 3 building requires the sim to be at level 5..ect)
								if IsDynastySim(SimAlias) then
									if BuildingCanBeOwnedBy("",SimAlias) then
										ListAdd("Bums",SimAlias)
									end
								end
							end
						end
					end
				end
			end
		end
		local LotteryTicket = ListSize("Bums")
		ListGetElement("Bums",Rand(LotteryTicket),"LotteryWinner") -- <---this makes sure a random person on the list gets the buiding...it may sort alphabetically meaning 4 people from the same class would be getting all the buildings...this ensures that possibility does not happen :)
		if AliasExists("LotteryWinner") then
			if GetState("",STATE_SELLFLAG) then
				SetState("", STATE_SELLFLAG, false)
			end
			BuildingSetForSale("", false)
			CreateScriptcall("AIAcquireBuilding",0.05,"Measures/Mods/NoOwner.lua","AIBuy","","LotteryWinner")
		else --if no Shadow dynasty owner is acceptable then AI dynasty is better then no one :)
			for sim=0,SimCount-1 do
				local SimAlias = "SimList"..sim
				if DynastyIsAI(SimAlias) then
					if not DynastyIsShadow(SimAlias) then
						if not HasProperty(SimAlias,"BugFix") then
							if SimGetAge(SimAlias) >= GL_AGE_FOR_GROWNUP then
								if GetNobilityTitle(SimAlias) > 1 then
									if SimGetClass(SimAlias) == Class then -- <--- Ensure the Sim will be able to use the building by making sure only sims with the buildings class make it on the list
										if SimGetLevel(SimAlias) >= Level then -- <-- The Shadow dynasty needs to have the right to own the buiding or an error pops up (level 3 building requires the sim to be at level 5..ect)
											if BuildingCanBeOwnedBy("",SimAlias) then
												if IsDynastySim(SimAlias) then
													ListAdd("Bums",SimAlias)
												end
											end
										end
									end
								end
							end
						end
					end
				end
			end
			local SecondLottery = ListSize("Bums")
			ListGetElement("Bums",Rand(SecondLottery),"NewLotteryWinner")
			if AliasExists("NewLotteryWinner") then
				if GetState("",STATE_SELLFLAG) then
					SetState("", STATE_SELLFLAG, false)
				end
				BuildingSetForSale("", false)
				CreateScriptcall("AIAcquireBuilding",0.05,"Measures/Mods/NoOwner.lua","AIBuy","","NewLotteryWinner")
			else
				MsgQuick("All","@L_NOOWNER_ERROR_ONE")
			end
		end
	end
end

function CleanUp()
end

function AIBuy()
	CreditMoney("Destination",10000,"IncomeOther")
	BuildingBuy("","Destination",BM_CAPTURE)
end	

function AISell() --This function is for repopulate scriptcall and was placed here since the repopulate mod uses AIBuy() function. Reduces clutter in the repopulate mod
	BuildingSetForSale("", true)
	SetState("", STATE_SELLFLAG, true)
end