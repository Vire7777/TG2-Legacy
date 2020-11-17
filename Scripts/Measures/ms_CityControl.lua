function Run()
----------------------------------------------------------------------------------------------------
----	Set GodModule 'true' for city events and desasters					----
----												----
	local GodModule = true									----
----												----
----												----
----------------------------------------------------------------------------------------------------
	if GodModule == false then
		StopMeasure()
	end
	
	GetScenario("World")
	if HasProperty("World", "static") then
		StopMeasure()
	end
	
	local CityID = GetProperty("","CityID")
	if not GetAliasByID(CityID,"MyCity") then
		StopMeasure()
	end

	if CityIsKontor("MyCity") then
		StopMeasure()
	end

	while true do
		Sleep(Rand(500)+500)
		local Choice = Rand(150)+1
		if ScenarioGetDifficulty()<3 then 
			if Choice ==1 then
				ms_citycontrol_Inferno()
			elseif Choice == 2 and Weather_GetSeason()~=3 then
				ms_citycontrol_Heuschrecken()
			else
				ms_citycontrol_InfectPartyMember()
			end
		elseif ScenarioGetDifficulty()==3 then
			if Choice <3 then
				ms_citycontrol_Inferno()
			elseif Choice >2 and Choice <5 and Weather_GetSeason()~=3 then
				ms_citycontrol_Heuschrecken()
			elseif Choice == 5 then
				if GetRound() > (3+Rand(5)) then
					ms_citycontrol_RatBoy()
				end
			elseif Choice == 6 then
				if GetRound() > (5+Rand(5)) then
					ms_citycontrol_TheBlackDeath()
				end
			else
			ms_citycontrol_InfectPartyMember()
			end
		elseif ScenarioGetDifficulty()==4 then
			if Choice <4 then
				ms_citycontrol_Inferno()
			elseif Choice >3 and Choice <6 and Weather_GetSeason()~=3 then
				ms_citycontrol_Heuschrecken()
			elseif Choice == 6 or Choice == 7 then
				if GetRound() > (3+Rand(5)) then
					ms_citycontrol_RatBoy()
				end
			elseif Choice == 8 or Choice == 9 then
				if GetRound() > (5+Rand(5)) then
					ms_citycontrol_TheBlackDeath()
				end
			else
			ms_citycontrol_InfectPartyMember()
			end
		end
	end
end

function InfectPartyMember()
	
	ScenarioGetRandomObject("cl_Dynasty","CurrentDyn")
	if not AliasExists("CurrentDyn") then
		return
	end
	
	local MemberCount = DynastyGetMemberCount("CurrentDyn")
	if MemberCount > 0 then
		 for i=0,MemberCount-1 do
		 	 if DynastyGetMember("CurrentDyn",i,"CurrentMember") then
		 	 	if IsPartyMember("CurrentMember") then 
		 	 		if GetID("CurrentMember") then
		 	 			if GetState("CurrentMember",STATE_SICK) then 
		 	 				return
		 	 			end
		 	 		end
		 	 	end
		 	 end
		 end
	end
	
	if AliasExists("CurrentMember") then
		if GetImpactValue("CurrentMember","Resist")>0 then
			return 
		end
		GetHomeBuilding("CurrentMember","ZuHause")
		local healLuck = Rand(10)
		if CityGetRandomBuilding("MyCity",2,37,-1,-1,FILTER_IGNORE,"CurrentBuilding") then
			local SickChoice = Rand(10)
			local krankH
			if BuildingGetLevel("CurrentBuilding") == 1 then
				if SickChoice>4 then
					diseases_Sprain("CurrentMember",true,true)
					krankH = 1
				else
				    if GetItemCount("ZuHause", "Blanket", INVENTORY_STD)>0 and healLuck >= 4 then
					    RemoveItems("ZuHause", "Blanket", 1, INVENTORY_STD)
						return
					else
					    diseases_Cold("CurrentMember",true,true)
					    krankH = 2
					end
				end
			elseif BuildingGetLevel("CurrentBuilding") == 2 then
				if SickChoice>4 then
					diseases_Influenza("CurrentMember",true,true)
					krankH = 3
				else
				    if GetItemCount("ZuHause", "Soap", INVENTORY_STD)>0 and healLuck >= 7 then
					    RemoveItems("ZuHause", "Soap", 1, INVENTORY_STD)
						return
					else
					    diseases_Pox("CurrentMember",true,true)
					    krankH = 4
					end
				end
			else
				if SickChoice>4 then
					diseases_Fracture("CurrentMember",true,true)
					krankH = 5
				else
				    if GetItemCount("ZuHause", "HerbTea", INVENTORY_STD)>0 and healLuck > 5 then
					    RemoveItems("ZuHause", "HerbTea", 1, INVENTORY_STD)
						return
					else
					    diseases_Caries("CurrentMember",true,true)
					    krankH = 6
					end
				end
			end
			ms_citycontrol_Warnung(1,"CurrentMember",krankH)
		end
	
	RemoveAlias("CurrentMember")	
	end
	
end

function RatBoy()
	if not CityGetRandomBuilding("MyCity",3,23,-1,-1,FILTER_IGNORE,"RatBoyHomeBuilding") then
		return
	end
	GetPosition("RatBoyHomeBuilding","RatBoySpawnPos")
	if not SimCreate(904,"RatBoyHomeBuilding","RatBoySpawnPos","RatBoy") then
		return
	end
	SimSetBehavior("RatBoy","RatBoy")
	ms_citycontrol_Warnung(2,"MyCity")
end

function Inferno()
	local NumBuildings = CityGetBuildingCount("MyCity",1,-1,-1,-1,FILTER_IGNORE)
	CityGetBuildings("MyCity",1,-1,-1,-1,FILTER_IGNORE,"Building")
	for i=0,NumBuildings-1 do
		SetState("Building"..i,STATE_BURNING,true)
		Sleep(5)
	end
	ms_citycontrol_Warnung(3,"MyCity")
end

function Heuschrecken()
	if not CityGetRandomBuilding("MyCity",6,33,0,-1,FILTER_IGNORE,"Feld") then
	    return
	end
  if not HasProperty("Feld","Heuschrecken") then
	    SetProperty("Feld","Heuschrecken",1)
	else
	    return
	end
	MeasureRun("Feld","","HeuPlage",true)
	ms_citycontrol_Warnung(4,"MyCity")
end

function TheBlackDeath()
  local opfer = Rand(2)+1
	if CityGetRandomBuilding("MyCity",opfer,-1,-1,-1,FILTER_IGNORE,"Ausbruch") then
		if BuildingGetSim("Ausbruch",1,"ErstOpfer") then
			diseases_Blackdeath("ErstOpfer",true,true)
			ms_citycontrol_Warnung(5,"MyCity","Ausbruch")	
		end
	end
	
end

function Warnung(danger,opfer,zusatz)

    local krankNam = { "@L_HPFZ_KATASTR_KRANK_NAM_+0", "@L_HPFZ_KATASTR_KRANK_NAM_+1", "@L_HPFZ_KATASTR_KRANK_NAM_+2", "@L_HPFZ_KATASTR_KRANK_NAM_+3", "@L_HPFZ_KATASTR_KRANK_NAM_+4", "@L_HPFZ_KATASTR_KRANK_NAM_+5" }
    if danger == 1 then
	    MsgNewsNoWait(opfer,opfer,"","intrigue",-1,"@L_HPFZ_KATASTR_KRANK_KOPF",
	                    "@L_HPFZ_KATASTR_KRANK_RUMPF_+0"..krankNam[zusatz].."@L_HPFZ_KATASTR_KRANK_RUMPF_+1",GetID(opfer),krankNam[zusatz])
	elseif danger == 2 then
	    MsgNewsNoWait("All",opfer,"","intrigue",-1,"@L_HPFZ_KATASTR_RATTE_KOPF",
	                    "@L_HPFZ_KATASTR_RATTE_RUMPF")
	elseif danger == 3 then
	    MsgNewsNoWait("All",opfer,"","intrigue",-1,"@L_HPFZ_KATASTR_FEUER_KOPF",
	                    "@L_HPFZ_KATASTR_FEUER_RUMPF",GetID(opfer))
	elseif danger == 4 then
	    MsgNewsNoWait("All",opfer,"","intrigue",-1,"@L_HPFZ_KATASTR_GRILLEN_KOPF",
	                    "@L_HPFZ_KATASTR_GRILLEN_RUMPF",GetID(opfer))
	elseif danger == 5 then
	    MsgNewsNoWait("All",opfer,"","intrigue",-1,"@L_HPFZ_KATASTR_STOD_KOPF",
	                    "@L_HPFZ_KATASTR_STOD_RUMPF",GetID(opfer),zusatz)
	end

end

function CleanUp()
	if HasProperty("","CityID") then
		RemoveProperty("","CityID")
	end
end
