function Run()	
	find_Pope("Pope")
	find_Emperor("Emperor")
	local PopeID = -1
	local EmperorID = -1
	if AliasExists("Pope") then
		PopeID = GetID("Pope")
	end
	if AliasExists("Emperor") then
		EmperorID = GetID("Emperor")
	end
	local candidates = {nil,nil,nil,nil,nil}
	local SimCount = ScenarioGetObjects("cl_Sim", 9999, "SimList")
	for sim=0,SimCount-1 do
		local SimAlias = "SimList"..sim
		if AliasExists(SimAlias) then
			if SimGetAge(SimAlias) >= GL_AGE_FOR_GROWNUP then
				if IsDynastySim(SimAlias) then
					find_HomeCity(SimAlias,"HomeCity")
					if AliasExists("HomeCity") then
						if GetNobilityTitle(SimAlias) > 7  then
							if CityGetLevel("HomeCity") == 6 then
								local Check = GetID(SimAlias)
								if Check ~= PopeID and Check ~= EmperorID then
									x = 1
									while x < 6 do
										if candidates[x]~=nil and GetAliasByID(candidates[x],"candidate") then
											if find_TrueWealthSim(SimAlias) > find_TrueWealthSim("candidate") then
												
												y = 5
												while y>x do
													candidates[y] = candidates[y-1]
													y = y - 1
												end
		
												candidates[x] = GetID(SimAlias)
												break
											end
										else
											candidates[x] = GetID(SimAlias)
											break
										end
										x = x + 1
									end
								end	
							end
						end
					end
				end
			end
		end
	end

	local TitleArray  = {"","","","",""}
	local NameArray   = {"","","","",""}
	local WealthArray = {0,0,0,0,0}
	local HeadText = "@L_IMPERIALCANDIDATE_MASTERLIST_HEAD_+0"
	
	for z=1,5 do
		if GetAliasByID(candidates[z],"TheChosen") then
			local Title = GetNobilityTitle("TheChosen")
			if SimGetGender("TheChosen") == GL_GENDER_FEMALE then
				Title = Title*2-2
			else
				Title = Title*2-1
			end
			TitleArray[z-1]  = "_CHARACTERS_3_TITLES_NAME_+"..Title
			NameArray[z-1]   = GetName("TheChosen")
			WealthArray[z-1] = find_TrueWealthSim("TheChosen")
		else
			TitleArray[z-1] = ""
			NameArray[z-1] = "@L_IMPERIALCANDIDATE_MASTERLIST_TEXT_+0"
			WealthArray[z-1] = "0"
		end
	end
	
	MsgBoxNoWait("All",false,HeadText,
		"@L$L1. %1l %2l %3t$N$N$L2. %4l %5l %6t$N$N$L3. %7l %8l %9t$N$N$L4. %10l %11l %12t$N$N$L5. %13l %14l %15t",
		TitleArray[0], NameArray[0], WealthArray[0], TitleArray[1], NameArray[1], WealthArray[1], TitleArray[2], NameArray[2], WealthArray[2], TitleArray[3], NameArray[3], WealthArray[3], TitleArray[4], NameArray[4], WealthArray[4])
end