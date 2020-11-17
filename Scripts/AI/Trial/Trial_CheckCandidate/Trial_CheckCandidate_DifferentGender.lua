function Weight()
	GetAliasByID(GetProperty("SIM","trial_destination_ID"),"CutsceneAlias")
	GetAliasByID(GetProperty("SIM","trial_destination_ID"),"trial_destination_ID")

	local CutsceneID = GetProperty("CutsceneAlias","NextCutsceneID")
	GetAliasByID(CutsceneID,"CutsceneAlias")

	local judge = trial_checkcandidate_differentgender_GetDataFromCutscene("CutsceneAlias","judge")
	local accuser = trial_checkcandidate_differentgender_GetDataFromCutscene("CutsceneAlias","accuser")
	local accused = trial_checkcandidate_differentgender_GetDataFromCutscene("CutsceneAlias","accused")
	local assessor1 = trial_checkcandidate_differentgender_GetDataFromCutscene("CutsceneAlias","assessor1")
	local assessor2 = trial_checkcandidate_differentgender_GetDataFromCutscene("CutsceneAlias","assessor2")

	local TargetArray = {judge,accuser,accused,assessor1,assessor2}
	local TargetCount = 5

	local MaxFavor = 51
	local MinFavor = 0
	local ModifyFavorJury = -1
	local CountDiffGender = 0
	local CountDiffGenderTotal = 0
	local ModifyRhetoric = 0

	local CurrentJury
	for UseTarget = 1, TargetCount do
		CurrentJury = TargetArray[UseTarget]
		if (CurrentJury ~= GetID("SIM")) then
			if (GetAliasByID(CurrentJury,"TA_CurrentJury") == true) then
				if (DynastyIsPlayer("TA_CurrentJury") == false) then
					GetInsideBuilding("","InsideBuilding")
					if (GetID("trial_destination_ID") == GetID("InsideBuilding")) then			
						local Favor	= GetFavorToSim("TA_CurrentJury","SIM")
						if SimGetGender("TA_CurrentJury") ~= SimGetGender("SIM") then
							CountDiffGenderTotal = CountDiffGenderTotal + 1
						end
						if (Favor < MaxFavor) and (Favor > MinFavor) then
							if SimGetGender("TA_CurrentJury") ~= SimGetGender("SIM") then
								CountDiffGender = CountDiffGender + 1
							end
							MinFavor = Favor
							GetAliasByID(CurrentJury,"TA_VictimJury")
							ModifyFavorJury = "TA_VictimJury"
						end
					end
				end
			end
		end
	end

	if (ModifyFavorJury ~= -1) then
		local HavePerfume = GetItemCount("SIM", "Perfume",INVENTORY_STD)
		local HavePoem = GetItemCount("SIM", "Poem",INVENTORY_STD)
		
		local CharismaSkill = GetSkillValue("SIM", CHARISMA)
		local MinimumFavor = 45 - (CharismaSkill*3)
		local CanFlirt = 999
		if (GetFavorToSim(ModifyFavorJury, "SIM") >= MinimumFavor) then
			CanFlirt = GetMeasureRepeat("SIM", "Flirt")
		end
		
		local RethoricSkill = GetSkillValue("SIM", RHETORIC)
		local MinimumFavor = 45 - (RethoricSkill*2)		
		local CanCompliment = 999
		if (GetFavorToSim(ModifyFavorJury, "SIM") >= MinimumFavor) then
			CanCompliment = GetMeasureRepeat("SIM", "MakeACompliment")
		end			
		
		if (CountDiffGenderTotal > 1) then
			if (HavePerfume > 0) and (GetMeasureRepeat("SIM", "UsePerfume") <= 0) then
				SetData("Div_GenItemToUse","UsePerfume")
				SetData("Div_GenVictim",0)
				return -1
			elseif (HavePoem > 0) and (GetMeasureRepeat("SIM", "UsePoem") <= 0) then
				SetData("Div_GenItemToUse","UsePoem")
				SetData("Div_GenVictim",ModifyFavorJury)
				return -1
			end
		elseif (CountDiffGenderTotal == 1) then
			if (HavePoem > 0) and (GetMeasureRepeat("SIM", "UsePoem") <= 0) then
				SetData("Div_GenItemToUse","UsePoem")
				SetData("Div_GenVictim",ModifyFavorJury)
				return -1
			elseif (HavePerfume > 0) and (GetMeasureRepeat("SIM", "UsePerfume") <= 0) then
				SetData("Div_GenItemToUse","UsePerfume")
				SetData("Div_GenVictim",0)
				return -1
			elseif (CanFlirt <= 0) and (GetMeasureRepeat("SIM", "Flirt") <= 0) then
				SetData("Div_GenItemToUse","Flirt")
				SetData("Div_GenVictim",ModifyFavorJury)
				return -1
			elseif (CanCompliment <= 0) then
				SetData("Div_GenItemToUse","MakeACompliment")
				SetData("Div_GenVictim",ModifyFavorJury)
				return -1
			end
		end
	end
	return 0
end

function GetDataFromCutscene(CutsceneAlias,Data)
	CutsceneGetData("CutsceneAlias",Data)
	local returnData = GetData(Data)
	return returnData
end

function Execute()
	if GetData("Div_GenVictim") ~= 0 then
		MeasureRun("SIM", GetData("Div_GenVictim"), GetData("Div_GenItemToUse"))
	else
		MeasureRun("SIM", nil, "UsePerfume",true)
	end
end

function CleanUp()
end
