function Weight()
	if GetHomeBuilding("SIM","Home") then
		if BuildingHasUpgrade("Home", "Saloon") then
			return 100
		end
	end
	return 0
end


function Execute()
	if GetHomeBuilding("SIM","Home") then
		if BuildingHasUpgrade("Home", "Saloon") then
			if GetState("Home",STATE_FEAST) then
				if GetProperty("Home","InvitationsLeft") > 0 then
					CityGetDynastyCharList("city","dyn_chars")
					for i=0,ListSize("dyn_chars")-1 do
						if ListGetElement("dyn_chars",i,"TheChar") then 
							if HasProperty("TheChar","InvitedBy") or GetFavorToSim("TheChar","SIM") > 80 then
								ListRemove("dyn_chars","TheChar")
							end
						end
					end
					local Size = ListSize("dyn_chars")
					if ListGetElement("dyn_chars",Rand(Size),"Invitee") then 
						MeasureRun("SIM", "Invitee", "InviteToFeast")
					end
				end
			else
				MeasureRun("SIM", nil, "GiveAFeast")
			end
		end
	end
end

function CleanUp()
end
