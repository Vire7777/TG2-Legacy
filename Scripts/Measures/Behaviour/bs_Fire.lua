function Run()
	if SimGetAge("") <= 16 then
		return "Flee"
	end

	if GetImpactValue("","spying") == 1 then 
		return ""
	end
	
	if SimGetProfession("")==GL_PROFESSION_CITYGUARD then
		return "PutoutFire"
	end
	
	if SimGetWorkingPlaceID("Owner")==GetID("Actor") then
		if BuildingGetOwner("Actor", "BuildingOwner") then
			if GetFavorToSim("Owner", "BuildingOwner") > 35 then
				return "PutoutFire"
			end
		end
	end
	
	if GetState("",STATE_WORKING) then
		return "PutoutFire"
	end
	
	if GetHomeBuildingId("")==GetID("Actor") then
		return "PutoutFire"
	end
	local DynID = GetDynastyID("")
	if SimGetProfession("")==GL_PROFESSION_MYRMIDON then
		if GetImpactValue("Actor","buildingbombedby")==DynID then
			return ""
		end
	end
	
	if GetState("",STATE_ROBBERGUARD) then
		return ""
	end
	
	local State
	State = DynastyGetDiplomacyState("", "Actor")

	if State >= DIP_ALLIANCE then
		-- alliierter oder von der selber dynasty
		return "PutoutFire"
	end
	
	if State < DIP_NEUTRAL then
		SetData("Distance", 1000)
		return "Gape"
	end
	
	if SimGetAlignment("Owner")<50 then
		return "PutoutFire"
	end
	
	SetData("Distance", 1500)
	return "Flee"
end

function CleanUp()
end
