-- Get council of cardinals property and multiply by 1000, then add the faith to get one number so that the correct person is at the top of the list. For the list itself put the Name, Council of Cardinal Level, And faith percentage :)

function Run()	
	find_Pope("Pope")
	find_Emperor("Emperor")
	find_King("King")
	local PopeID = -1
	local KingID = -1
	local EmpID = -1 
	if AliasExists("Pope") then
		PopeID = GetID("Pope")
	end
	if AliasExists("Emperor") then
		EmpID = GetID("Emperor") 
	end
	if AliasExists("King") then
		EmpID = GetID("King") 
	end
	local sim
	local candidates = {nil,nil,nil,nil,nil}
	local SimCount = ScenarioGetObjects("cl_Sim", 9999, "SimList")
	for sim=0,SimCount-1 do
		local SimAlias = "SimList"..sim
		if AliasExists(SimAlias) then
			find_HomeCity(SimAlias,"HomeCity")
			if AliasExists("HomeCity") then
				if CityGetLevel("HomeCity") == 6 then
					if IsDynastySim(SimAlias) then
						if SimGetAge(SimAlias) >= GL_AGE_FOR_GROWNUP then
							local Check = GetID(SimAlias)
							if Check ~= EmpID and  Check ~= PopeID and  Check ~= KingID then
								x = 1
								while x < 6 do
									if candidates[x]~=nil and GetAliasByID(candidates[x],"candidate") then
										if find_CardinalPoints(SimAlias) > find_CardinalPoints("candidate") then
											
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

	local NameArray  = {"","","","",""}
	local CPointsArray   = {0,0,0,0,0}
	local FPointsArray = {0,0,0,0,0}
	local HeadText = "@L_PAPALCANDIDATE_MASTERLIST_HEAD_+0"
	local BodyText = "@L_PAPALCANDIDATE_MASTERLIST_BODY_+0"
	
	for z=1,5 do
		if GetAliasByID(candidates[z],"TheChosen") then
			NameArray[z-1]   = GetName("TheChosen")
			if HasProperty("TheChosen","Cardinal") then
				CPointsArray[z-1] = GetProperty("TheChosen","Cardinal")
			else
				CPointsArray[z-1] = "0"
			end
			FPointsArray[z-1] = SimGetFaith("TheChosen")
		else
			NameArray[z-1] = "@L_IMPERIALCANDIDATE_MASTERLIST_TEXT_+0"
			CPointsArray[z-1] = "0"
			FPointsArray[z-1] = "0"
		end
	end
	
	MsgBoxNoWait("All",false,HeadText,BodyText,
		NameArray[0], CPointsArray[0], FPointsArray[0], NameArray[1], CPointsArray[1], FPointsArray[1], NameArray[2], CPointsArray[2], FPointsArray[2], NameArray[3], CPointsArray[3], FPointsArray[3], NameArray[4], CPointsArray[4], FPointsArray[4])
end