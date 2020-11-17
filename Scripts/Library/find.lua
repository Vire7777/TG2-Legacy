-----Must always start library files with Init as it is needed for caching -----
function Init()
 --needed for caching
end

--Functions that allow dev to quickly find a specific Alias 
function Emperor(Alias) --Alias is the output alias when you use this in an actual mod file you put whatever name you like there and that will be the output alias of the mayor
    local Cities = ScenarioGetObjects("Settlement", 10, "Cities")
	for i=0,Cities-1 do
		local CityList = "Cities"..i
		if CityGetLevel(CityList) == 6 then
			GetOfficeTypeHolder(CityList,13,"Emperor")
			if AliasExists("Emperor") then -- this is should be self-explanatory
				CopyAlias("Emperor", Alias) -- this is crucial for creating this type of function as it sets our chosen output alias (in this case the mayor)
				return true --this is also very important because it sets this boolean function to true...if this line is not added this function does not work
			end
		end
	end
    return false -- If "Leader" does not exist this returns this boolean function false which is important to define
end

function King(Alias) --Alias is the output alias when you use this in an actual mod file you put whatever name you like there and that will be the output alias of the mayor
    local Cities = ScenarioGetObjects("Settlement", 10, "Cities")
	for i=0,Cities-1 do
		local CityList = "Cities"..i
		if CityGetLevel(CityList) == 6 then
			GetOfficeTypeHolder(CityList,12,"King")
			if AliasExists("King") then -- this is should be self-explanatory
				CopyAlias("King", Alias) -- this is crucial for creating this type of function as it sets our chosen output alias (in this case the mayor)
				return true --this is also very important because it sets this boolean function to true...if this line is not added this function does not work
			end
		end
	end
	return false -- If "Leader" does not exist this returns this boolean function false which is important to define
end

function Pope(Alias) --Alias is the output alias when you use this in an actual mod file you put whatever name you like there and that will be the output alias of the mayor
    local Cities = ScenarioGetObjects("Settlement", 10, "Cities")
	for i=0,Cities-1 do
		local CityList = "Cities"..i
		if CityGetLevel(CityList) == 6 then
			GetOfficeTypeHolder(CityList,11,"Pope")
			if AliasExists("Pope") then -- this is should be self-explanatory
				CopyAlias("Pope", Alias) -- this is crucial for creating this type of function as it sets our chosen output alias (in this case the mayor)
				return true --this is also very important because it sets this boolean function to true...if this line is not added this function does not work
			end
		end
	end
	return false -- If "Leader" does not exist this returns this boolean function false which is important to define
end

function Mayor(ObjectAlias, Alias) --ObjectAlias is the input alias its what the code will use to find the mayor...Alias is the output alias when you use this in an actual mod file you put whatever name you like there and that will be the output alias of the mayor
    GetSettlement(ObjectAlias,"TheCity") --this returns the city of the input alias
    GetOfficeTypeHolder("TheCity",1,"Mayor")
    if AliasExists("Mayor") then -- this is should be self-explanatory
        CopyAlias("Mayor", Alias) -- this is crucial for creating this type of function as it sets our chosen output alias (in this case the mayor)
        return true --this is also very important because it sets this boolean function to true...if this line is not added this function does not work
    end
    return false -- If "Leader" does not exist this returns this boolean function false which is important to define
end

function Captain(ObjectAlias, Alias) --ObjectAlias is the input alias its what the code will use to find the mayor...Alias is the output alias when you use this in an actual mod file you put whatever name you like there and that will be the output alias of the mayor
    GetSettlement(ObjectAlias,"TheCity") --this returns the city of the input alias
    GetOfficeTypeHolder("TheCity",2,"Captain")
    if AliasExists("Captain") then -- this is should be self-explanatory
        CopyAlias("Captain", Alias) -- this is crucial for creating this type of function as it sets our chosen output alias (in this case the mayor)
        return true --this is also very important because it sets this boolean function to true...if this line is not added this function does not work
    end
    return false -- If "Leader" does not exist this returns this boolean function false which is important to define
end

function Judge(ObjectAlias, Alias) --ObjectAlias is the input alias its what the code will use to find the mayor...Alias is the output alias when you use this in an actual mod file you put whatever name you like there and that will be the output alias of the mayor
    GetSettlement(ObjectAlias,"TheCity") --this returns the city of the input alias
    GetOfficeTypeHolder("TheCity",3,"Judge")
    if AliasExists("Judge") then -- this is should be self-explanatory
        CopyAlias("Judge", Alias) -- this is crucial for creating this type of function as it sets our chosen output alias (in this case the mayor)
        return true --this is also very important because it sets this boolean function to true...if this line is not added this function does not work
    end
    return false -- If "Leader" does not exist this returns this boolean function false which is important to define
end

function HomeCity(ObjectAlias, Alias)
	GetHomeBuilding(ObjectAlias, "MyHome")
	GetNearestSettlement("MyHome","MyCity")
	if AliasExists("MyCity") then
		CopyAlias("MyCity", Alias) -- this is crucial for creating this type of function as it sets our chosen output alias (in this case the city)
        return true --this is also very important because it sets this boolean function to true...if this line is not added this function does not work
    end
    return false -- If "Leader" does not exist this returns this boolean function false which is important to define
end
	
function TrueWealthSim(ObjectAlias) -- To return the full Asset amount we see in-game we have to add the value of our nobility title into our wealth funcion.
	if not AliasExists(ObjectAlias) then
		return -1
	else
		local Wealth = GetMoney(ObjectAlias) -- Finds the money + Real Estate value of the Sim
		local Title = {} -- This array sets shows the value of each title level
			Title[-1] = 0
			Title[1] = 0
			Title[2] = 250
			Title[3] = 500
			Title[4] = 2000
			Title[5] = 6000
			Title[6] = 15000
			Title[7] = 30000
			Title[8] = 80000
			Title[9] = 150000
			Title[10] = 300000
			Title[11] = 600000
			Title[12] = 1000000
			Title[13] = 1500000
			Title[14] = 2000000
		local X = GetNobilityTitle(ObjectAlias) -- return the nobility level for the sim. You can see how it is used 2 lines below
		
		local Count = DynastyGetBuildingCount2(ObjectAlias,-1,-1)
		for i=0, Count-1 do
			if DynastyGetBuilding2(ObjectAlias,i,"DynBuilding") then
				if BuildingGetOwner("DynBuilding", "BuildingOwner") then
					if GetID(ObjectAlias) == GetID("BuildingOwner") then
						local BuildingValue = BuildingGetBuyPrice("DynBuilding") 
						if not HasProperty(ObjectAlias,"TlBdVa") then
							SetProperty(ObjectAlias,"TlBdVa",BuildingValue)
						else
							Current = GetProperty(ObjectAlias,"TlBdVa")
							SetProperty(ObjectAlias,"TlBdVa",Current+BuildingValue)
						end
					end
				end
			end
		end
		local Land = 0
		if GetProperty(ObjectAlias,"TlBdVa") ~= nil then -- This check is needed because aritmetic cannot be performed on a nil value (Land)
			Land = GetProperty(ObjectAlias,"TlBdVa")
		end
		Wealth = Wealth + Title[X] + Land --Adds money + Real estate + Nobility title value = ALL ASSETS
		if HasProperty(ObjectAlias,"TlBdVa") then
			RemoveProperty(ObjectAlias,"TlBdVa")
		end
		return Wealth --Returns the true wealth of the character so we can find out who truly has the most assets :)
	end
	return -1
end

function TrueWealthDynasty(ObjectAlias) -- To return the full Asset amount we see in-game we have to add the value of our nobility title into our wealth funcion.
	if not AliasExists(ObjectAlias) then
		return -1
	else
		local Wealth = GetMoney(ObjectAlias) -- Finds the money + Real Estate value of the Sim
		local Title = {} -- This array sets shows the value of each title level
			Title[-1] = 0
			Title[1] = 0
			Title[2] = 250
			Title[3] = 500
			Title[4] = 2000
			Title[5] = 6000
			Title[6] = 15000
			Title[7] = 30000
			Title[8] = 80000
			Title[9] = 150000
			Title[10] = 450000
			Title[11] = 900000
			Title[12] = 1500000
			Title[13] = 2250000
			Title[14] = 3000000
		local X = GetNobilityTitle(ObjectAlias) -- return the nobility level for the sim. You can see how it is used 2 lines below
		
		local Count = DynastyGetBuildingCount2(ObjectAlias,-1,-1)
		for i=0, Count-1 do
			if DynastyGetBuilding2(ObjectAlias,i,"DynBuilding") then
				local BuildingValue = BuildingGetBuyPrice("DynBuilding") 
				if not HasProperty(ObjectAlias,"TlBdVa") then
					SetProperty(ObjectAlias,"TlBdVa",BuildingValue)
				else
					Current = GetProperty(ObjectAlias,"TlBdVa")
					SetProperty(ObjectAlias,"TlBdVa",Current+BuildingValue)
				end
			end
		end
		local Land = 0
		if GetProperty(ObjectAlias,"TlBdVa") ~= nil then -- This check is needed because aritmetic cannot be performed on a nil value (Land)
			Land = GetProperty(ObjectAlias,"TlBdVa")
		end
		Wealth = Wealth + Title[X] + Land --Adds money + Real estate + Nobility title value = ALL ASSETS
		if HasProperty(ObjectAlias,"TlBdVa") then
			RemoveProperty(ObjectAlias,"TlBdVa")
		end
		return Wealth --Returns the true wealth of the character so we can find out who truly has the most assets :)
	end
	return -1
end

function CardinalPoints(ObjectAlias)
	if not AliasExists(ObjectAlias) then
		return -1 --Returns -1 if ObjectAlias does not exist (dying/dead)
	else
		local Total = SimGetFaith(ObjectAlias)
		if HasProperty(ObjectAlias,"Cardinal") then
			local Cardinal = GetProperty(ObjectAlias,"Cardinal")
			local CardinalTotal = Cardinal * 1000
			Total = Total + CardinalTotal
		end
		return Total
	end
	return -1 --Returns -1 if error occurs
end

function CleanUp()
end
