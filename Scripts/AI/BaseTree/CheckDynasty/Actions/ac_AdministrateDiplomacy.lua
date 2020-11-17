function Weight()
	if not ReadyToRepeat("dynasty", "ai_AdministrateDiplomacy") then
		return 0
	end
	
	local NumDynasties = ScenarioGetObjects("cl_Dynasty",99,"OutPutDyn")
	local CurrentStatus
	local FavorToVictim
	local MinStatusFavor
	local MaxStatusFavor
	local FavorDifference
	local RaiseDiplomacyState = false
	local LargestDifference = 0
	local MySettlementID = GetSettlementID("SIM")
	local Count
	local VictimNo
	local Change
	
	for i=0,NumDynasties-1 do
		--LogMessage("Checking Dynasty"..GetName("OutPutDyn"..i))
		Count = DynastyGetMemberCount("OutPutDyn"..i)
		VictimNo = Rand(Count)
		if (DynastyGetMember("OutPutDyn"..i, VictimNo, "Victim")) then
			if GetSettlementID("Victim")==MySettlementID then	
				CurrentStatus = DynastyGetDiplomacyState("dynasty","OutPutDyn"..i)
				FavorToVictim = GetFavorToDynasty("dynasty","OutPutDyn"..i)
				if CurrentStatus == nil then
					return 0
				end
				if CurrentStatus == 0 then
					MinStatusFavor = 0
					MaxStatusFavor = 40
				elseif CurrentStatus == 1 then
					MinStatusFavor = 35
					MaxStatusFavor = 65
				elseif CurrentStatus == 2 then
					MinStatusFavor = 60
					MaxStatusFavor = 81
				elseif CurrentStatus == 3 then
					MinStatusFavor = 75
					MaxStatusFavor = 100
				end
				Change = false
				if FavorToVictim > MaxStatusFavor then

					local MaxState = DynastyGetMaxDiplomacyState("dynasty", "OutPutDyn"..i)
					if CurrentStatus < MaxState then
						FavorDifference = FavorToVictim - MaxStatusFavor
						RaiseDiplomacyState = true
						Change = true
					end
				elseif FavorToVictim < MinStatusFavor then

					local MinState = DynastyGetMinDiplomacyState("dynasty", "OutPutDyn"..i)
					if CurrentStatus>MinState then
						FavorDifference = MinStatusFavor - FavorToVictim
						RaiseDiplomacyState = false
						Change = true
					end
				end
				
				if Change then
					if FavorDifference > LargestDifference then
						RemoveData("SetStatusTo")
						LargestDifference = FavorDifference
						CopyAlias("OutPutDyn"..i,"VictimDynasty")
						if RaiseDiplomacyState then
							if CurrentStatus < 3  then
								SetData("SetStatusTo",CurrentStatus+1)
							end
						else
							if CurrentStatus > 0 then
								SetData("SetStatusTo",CurrentStatus-1)
							end
						end
					end
				end
			end
		end
	end
	
	if CurrentStatus == nil then
		return 0
	end
	
	if not AliasExists("VictimDynasty") then
		return 0
	end
	
	if not HasData("SetStatusTo") then
		return 0
	end

	local Count = DynastyGetMemberCount("VictimDynasty")
	local VictimNo = Rand(Count)
	if not (DynastyGetMember("VictimDynasty", VictimNo, "Victim")) then
		return 0
	end		

	return 100
end

function Execute()
	if SimGetAge("Victim") < 16 or SimGetAge("SIM") < 16 then
		return
	end
	SetRepeatTimer("dynasty", "ai_AdministrateDiplomacy", 8)
	MeasureCreate("measure")
	MeasureAddData("Measure", "InitResult", GetData("SetStatusTo"), false)
	MeasureStart("Measure", "SIM", "Victim", "AdministrateDiplomacy")
end

function CleanUp()
end
