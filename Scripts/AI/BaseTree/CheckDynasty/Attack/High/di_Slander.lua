function Weight()
	
	if GetMeasureRepeat("SIM", "Slander")>0 then
		return 0
	end
	
	if GetNobilityTitle("SIM")<5 then
		return 0
	end
	
	GetHomeBuilding("SIM","MyHouse")
	if not AliasExists("MyHouse") then
		return 0
	end
	BuildingGetCity("MyHouse","MyCity") 
    CityGetDynastyCharList("MyCity","EnemyList") 
	for i=0,ListSize("EnemyList") do
		ListGetElement("EnemyList",i,"Friends")
		if DynastyGetDiplomacyState("SIM","Friends") ~= DIP_FOE then
			ListRemove("EnemyList","Friends")
		end
	end
	local Foes = ListSize("EnemyList")
	ListGetElement("EnemyList",Rand(Foes),"Target")
	if not AliasExists("Target") then
		return 0
	end
	
	local BardFilter = "__F((Object.GetObjectsByRadius(Sim)==15000)AND(Object.GetState(townnpc))AND(Object.Property.IsBard == 1)AND(Object.Property.BardIsFree == 1))"
	local NumBards = Find("SIM",BardFilter,"Bard",1)
	
	if NumBards < 1 then
		return 0
	end

	if not f_MoveTo("SIM","Bard") then
		return 0
	end
	
	return 100
end

function Execute()
	MeasureRun("SIM","Target","Slander")
end

function CleanUp()
end