
function Run()

	if GetState("Destination",STATE_NPCFIGHTER) then
		StopMeasure()
	end
	
	MeasureSetNotRestartable()
	
	-- Display the court lover sheet
	SetProperty("", "LoverID", GetID("Destination"))
	if not (MsgBox("", 0, "CourtLover", 0, 0) == "O") then
		RemoveProperty("", "LoverID")
		StopMeasure()
		return
	end
	
	RemoveProperty("", "LoverID")
	
	local money = 0
	if HasProperty("","BugFix") and not DynastyIsPlayer("") then
		GetDynasty("", "Madynasty")
		DynastyGetFamilyMember("Madynasty",0,"DaBoss")
		money = GetMoney("DaBoss")
	else
		money = GetMoney("")
	end
	local currenttitle = GetNobilityTitle("")
	local othertitle = GetNobilityTitle("Destination")
	if othertitle > currenttitle then
		currenttitle = othertitle
	end
	local cost = currenttitle * currenttitle * 1000
	
	if SimGetCourtingSim("Destination","blabla") then
		MsgQuick("","%1SN %2l",GetID("Destination"),"@L_FILTER_IS_COURTED")
		StopMeasure()
	end
	
	if cost > money then
		MsgBox("", "Destination", "@P@B[A, @L_CHARACTERS_3_TITLES_AQUIRE_TOWNHALL_3_POSSIBLE_MENU_+1]"..
							"@B[B, @L_CHARACTERS_3_TITLES_AQUIRE_TOWNHALL_3_POSSIBLE_MENU_+2]",
							"@L_MEASURE_ForceMarriage_Proposal_HEAD_+0",
							"@L_MEASURE_ForceMarriage_Proposal_BODY_+0",
							cost, GetID("Destination"))
		StopMeasure()
		return	
	else

		local BYesNo = MsgBox("", "Destination", "@P@B[A, @L_CHARACTERS_3_TITLES_AQUIRE_TOWNHALL_3_POSSIBLE_MENU_+0]"..
							"@B[B, @L_CHARACTERS_3_TITLES_AQUIRE_TOWNHALL_3_POSSIBLE_MENU_+2]",
							"@L_MEASURE_ForceMarriage_Proposal_HEAD_+0",
							"@L_MEASURE_ForceMarriage_Proposal_BODY_+0",
							cost, GetID("Destination"))
								
		if (BYesNo == "A") then
			if HasProperty("","BugFix") and not DynastyIsPlayer("") then
				DynastyGetFamilyMember("",0,"SugarDaddy")
				SpendMoney("SugarDaddy",cost,"CostForceMarriage")
			else
				SpendMoney("",cost,"CostForceMarriage")
			end
			SimMarry("", "Destination")
		end
	end
end


-- -----------------------
-- CleanUp
-- -----------------------
function CleanUp()

end
