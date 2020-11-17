function Run()
	if GetState("",STATE_SICK) then
		return
	end
	local Profession = SimGetProfession("")
	if Profession then
		--cityguard, prisonguard, inspector, monitor, eliteguard
		if (Profession > 20) and (Profession < 26) then
			return
		end
		--iquisitor
		if Profession == 28 then
			return
		end
	end
	if GetImpactValue("","Resist")>0 then
		return
	else
		AddImpact("","Resist",1,2)
	end
	
	if GetInsideBuilding("","CurrentBuilding") then
		if BuildingGetType("CurrentBuilding")==GL_BUILDING_TYPE_HOSPITAL then
			return
		end
	end
	if GetImpactValue("Actor","Blackdeath")==0 then
		if IsDynastySim("") then
			return
		end
	end
	
	local Constitution = 10 + GetSkillValue("",1) * 10
	if Constitution < 10 then
		Constitution = (Rand(7)+1)*10
	end
	local SimAge = SimGetAge("") / 2
	if SimAge < 8 then
		return
	end
	local Immunity = Constitution - SimAge
	if Immunity <= 0 then
		Immunity = 0
	else
		Immunity = Rand(Immunity) + (Immunity/(2 - Constitution/100))
	end
	local CurrentRound = GetRound()
	
	-- ShowOverheadSymbol("",false,true,0,"Immunität: %1n",Immunity)
	local Hazard = 0
	if GetImpactValue("Actor","Cold")==1 then
		Hazard = 20
		if Rand(Hazard) > Immunity then
			diseases_Cold("",true)
		end
	elseif GetImpactValue("Actor","Influenza")==1 then
		Hazard = 30
		if Rand(Hazard) > Immunity then
			diseases_Influenza("",true)
		end
	elseif GetImpactValue("Actor","Pox")==1 then
		Hazard = 40
		if CurrentRound < 5 then
			Hazard = 30
		end
		if Rand(Hazard) > Immunity then
			diseases_Pox("",true)
		end
	elseif GetImpactValue("Actor","Blackdeath")==1 then
		Hazard = 50
		if CurrentRound < 5 then
			Hazard = 20
		elseif CurrentRound < 7 then
			Hazard = 30
		end		
		if Rand(Hazard) > Immunity then
			if GetSettlement("","City") then
				local InfectableSims = CityGetCitizenCount("City") / 4
				local CurrentInfected = GetProperty("City","InfectedSims")
				if CurrentInfected < InfectableSims then
					diseases_Blackdeath("",true,true)
				end
			end
		end
		return "flee"
	end
end

function CleanUp()
end