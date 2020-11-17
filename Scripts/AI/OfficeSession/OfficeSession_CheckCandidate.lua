function Weight()
	GetSettlement("SIM","OSCC_Settlement")
	CityGetRandomBuilding("OSCC_Settlement", -1, 23, -1, -1, FILTER_IGNORE, "OfficeSession_Destination")
--	CopyAlias("OfficeSession_Destination_tmp0","OfficeSession_Destination")
--	GetAliasByID(GetProperty("SIM","destination_ID"),"OfficeSession_Destination")
	local CutsceneID = GetProperty("OfficeSession_Destination","sessioncutszene")
	GetAliasByID(CutsceneID,"CutsceneAlias")
	
	local WhoAmI = officesession_checkcandidate_GetCutscenePossition()
	
	if GetInsideBuilding("SIM","InsideBuilding") then
		if (GetID("OfficeSession_Destination") == GetID("InsideBuilding")) then

--			Check who the Sim is in the Session, in fact that he can be in the jury and/or run for an office and/or be deselected. 1/2/4 System

--			if you are an applicant do this
			if ((WhoAmI >= 4) or (WhoAmI == 2) or (WhoAmI == 3) or (WhoAmI == 6) or (WhoAmI == 7)) then
				return 100
			end
	
		end
	end
	return 0
end

function GetCutscenePossition()
	GetSettlement("SIM","OSCC_Settlement")
	local NumOfVotes = CityPrepareOfficesToVote("OSCC_Settlement","OfficeList",false)
	
	if NumOfVotes == nil then
		return 0
	end

	local Iam = 0
	
	
--	Check if the SIM is in the Jury to Vote
	local Found = false
	
	for i=0,NumOfVotes - 1 do
		ListGetElement("OfficeList",i,"OfficeToCheck")

	    local VoterCnt = officesession_GetVoters("OfficeToCheck","Voter")
	    if(VoterCnt > 0) then
	    	for j=0,VoterCnt - 1 do
	    		local VoterAlias = "Voter"..j
				if GetID(VoterAlias) == GetID("") then
					Found = true
					Iam = Iam + 1
					break
				end
	    	end
	    end
	    if Found then break end
	end

--	Check if the SIM is an Applicant for the Office that he allready own
	local Found = false
	
	for i=0,NumOfVotes - 1 do
		ListGetElement("OfficeList",i,"OfficeToCheck")

	    local ApplicantCntCnt = officesession_OfficeGetApplicants("OfficeToCheck","Applicant")
	    if(ApplicantCntCnt > 0) then
	    	for j=0,ApplicantCntCnt - 1 do
	    		local ApplicantAlias = "Applicant"..j
				if GetID(ApplicantAlias) == GetID("") then
					if SimGetOfficeID("") == GetID("OfficeToCheck") then
						Found = true
						Iam = Iam + 2
						break
					end
				end
	    	end
	    end
	    if Found then break end
	end
	
--	Check if the SIM is an Applicant for an Office
	local Found = false
	
	for i=0,NumOfVotes - 1 do
		ListGetElement("OfficeList",i,"OfficeToCheck")

	    local ApplicantCntCnt = officesession_OfficeGetApplicants("OfficeToCheck","Applicant")
	    if(ApplicantCntCnt > 0) then
	    	for j=0,ApplicantCntCnt - 1 do
	    		local ApplicantAlias = "Applicant"..j
				if GetID(ApplicantAlias) == GetID("") then
					if SimGetOfficeID("") ~= GetID("OfficeToCheck") then
						Found = true
						Iam = Iam + 4
						break
					end
				end
	    	end
	    end
	    if Found then break end
	end	
	
	return 	Iam
end


function Execute()
end

function CleanUp()
end
