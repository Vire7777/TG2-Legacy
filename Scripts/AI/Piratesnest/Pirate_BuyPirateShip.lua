function Weight()
	if not SimGetWorkingPlace("SIM","PiratesNest") then
		return 0
	end
	
	local Found = false
	for i=0,BuildingGetCartCount("PiratesNest")-1 do
		if BuildingGetCart("PiratesNest",i,"Cart") then
			if CartGetType("Cart")==EN_CT_CORSAIR then
				Found = true
			end
		end
	end
	
	if Found then
		return 0
	end
	
	return 100
end

function Execute()
	BuildingBuyCart("PiratesNest",EN_CT_CORSAIR,true,"pirateship")
end

function CleanUp()
end
