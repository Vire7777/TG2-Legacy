-----Must always start library files with Init as it is needed for caching -----
function Init()
 --needed for caching
end

function AIOfficeCheck()
	local SimCount = ScenarioGetObjects("cl_Sim", 99999, "Politicians")
	for i=0, SimCount-1 do
		local SimAlias = "Politicians"..i
		if not DynastyIsPlayer(SimAlias) then
			-- search through all offices and check if I am allready an applicant
			if SimGetOfficeID(SimAlias) ~= -1 then
			--	LogMessage("LastName="..SimGetLastname(SimAlias).." 0 <---Already running for office. Smart AI")
				if SimIsAppliedForOffice(SimAlias) then
					if SimGetOffice(SimAlias,"CurrentOffice") then
			--			LogMessage("Office Index="..SimGetOfficeIndex(SimAlias).." OfficeLevel="..SimGetOfficeLevel(SimAlias).." OfficeID="..SimGetOfficeID(SimAlias).." OfficeName="..OfficeGetTextLabel("CurrentOffice"))
						if GetOfficeByApplicant(SimAlias,"AppliedOffice") then
							local X = SimGetOfficeIndex(SimAlias)
							local OfficeIdx = {}
								OfficeIdx[0] = 1
								OfficeIdx[1] = 0
							if OfficeGetLevel("AppliedOffice") == OfficeGetLevel("CurrentOffice") and OfficeGetIdx("AppliedOffice") == X  then --If this returns false it means that the AI has already applied for an office and no help is required
								local OffLevel = SimGetOfficeLevel(SimAlias)
								if OffLevel < 5 then
									if SimGetCityOfOffice(SimAlias,"OffCity") then
										if CityGetOffice("OffCity", OffLevel+1, X, "Seat") then
											if not OfficeGetHolder("Seat", "SeatHolder") then
												MeasureRun(SimAlias,"Seat","RunForAnOffice",true)
											elseif CityGetOffice("OffCity", OffLevel+1, OfficeIdx[X], "SeatTwo") then
												if not OfficeGetHolder("SeatTwo", "SeatHolderTwo") then
													MeasureRun(SimAlias,"SeatTwo","RunForAnOffice",true)
												end
											end
										elseif CityGetOffice("OffCity", OffLevel+1, OfficeIdx[X], "SeatThree") then
											if not OfficeGetHolder("SeatThree", "SeatHolderThree") then
												MeasureRun(SimAlias,"SeatThree","RunForAnOffice",true)
											end
										end
									end
								end
							end
						end
					end
				else
					local OffLevel = SimGetOfficeLevel(SimAlias)
					if OffLevel < 5 then
						if SimGetOffice(SimAlias,"CurrentOffice") then
			--				LogMessage("Office Index="..SimGetOfficeIndex(SimAlias).." OfficeLevel="..SimGetOfficeLevel(SimAlias).." OfficeName="..OfficeGetTextLabel("CurrentOffice"))
							local X = SimGetOfficeIndex(SimAlias)
							local OfficeIdx = {}
								OfficeIdx[0] = 1
								OfficeIdx[1] = 0
							if SimGetCityOfOffice(SimAlias,"OffCity") then
			--					LogMessage("LastName="..SimGetLastname(SimAlias).." 1")
								if CityGetOffice("OffCity", OffLevel+1, X, "Seat") then
									LogMessage("LastName="..SimGetLastname(SimAlias).." 2")
									if not OfficeGetHolder("Seat", "SeatHolder") then
			--							LogMessage("LastName="..SimGetLastname(SimAlias).." 3")
										MeasureRun(SimAlias,"Seat","RunForAnOffice",true)
									elseif CityGetOffice("OffCity", OffLevel+1, OfficeIdx[X], "SeatTwo") then
			--							LogMessage("LastName="..SimGetLastname(SimAlias).." 4")
										if not OfficeGetHolder("SeatTwo", "SeatHolderTwo") then
			--								LogMessage("LastName="..SimGetLastname(SimAlias).." 5")
											MeasureRun(SimAlias,"SeatTwo","RunForAnOffice",true)
										end
									end
								elseif CityGetOffice("OffCity", OffLevel+1, OfficeIdx[X], "SeatThree") then
			--						LogMessage("LastName="..SimGetLastname(SimAlias).." 6")
									if not OfficeGetHolder("SeatThree", "SeatHolderThree") then
			--							LogMessage("LastName="..SimGetLastname(SimAlias).." 7")
										MeasureRun(SimAlias,"SeatThree","RunForAnOffice",true)
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

function CleanUp()

end
