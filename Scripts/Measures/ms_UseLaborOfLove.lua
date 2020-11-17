function Run()
	
	if not AliasExists("Destination") then
		StopMeasure()
	end
	
	SetProperty("Destination","CocotteHasClient",1)
	
	MeasureSetNotRestartable()
	
	if not AliasExists("Destination") then
		return
	end
	
	if not ai_StartInteraction("", "Destination", 500, 66) then
		StopMeasure("")
	end
	
	chr_AlignExact("","Destination",50,1)
	if (GetDynastyID("") == GetDynastyID("Destination")) then
		MsgSay("","@L_PIRATE_LABOROFLOVE_VISIT_EMPLOYER")
		MsgSay("Destination","@L_PIRATE_LABOROFLOVE_VISIT_COCOTTE")
	else
		-- Todo Cutscene Speech and Animation
		MsgSay("","@L_PIRATE_LABOROFLOVE_TALK_VICTIM")
		MsgSay("Destination","@L_PIRATE_LABOROFLOVE_TALK_AGREED")
		
		-- calc price depending on the charisma of the cocotte and pay it
		local charskill = 2
		charskill = GetSkillValue("Destination",CHARISMA)
		local Age = SimGetAge("Destination")
		local Beauty = 0
		if Age < 36 then
			Beauty = 25
		elseif Age > 49 then
			Beauty = -25
		end
		local MoneyToPay = 50 * charskill + Beauty
		if IsDynastySim("") then
			if not SpendMoney("",MoneyToPay ,"LaborOfLove") then
				PlayAnimationNoWait("Destination","threat")
				MsgSay("Destination","@L_PIRATE_LABOROFLOVE_TALK_DISAGREE")
				StopMeasure()
			end
		end
		ShowOverheadSymbol("",false,false,0,"%1t",-MoneyToPay)
		CreditMoney("Destination", MoneyToPay , "LaborOfLove")
		
	end
	MsgSay("","@L_PIRATE_LABOROFLOVE_TALK_START")
	
	-- Do some animation
	PlayAnimationNoWait("","seduce_m_in")
	PlayAnimation("Destination","seduce_f_in")
	PlaySound3DVariation("Destination","CharacterFX/female_jolly",1)
	LoopAnimation("","seduce_m_idle_01",0)
	PlaySound3DVariation("","CharacterFX/male_jolly",1)
	LoopAnimation("Destination","seduce_f_idle_03",10)
	PlayAnimationNoWait("","seduce_m_out")
	PlayAnimation("destination","seduce_f_out")
	
	if HasProperty("Destination","ThiefOfLove") then
		local empskill = GetSkillValue("","EMPATHY")
		local chakill = GetSkillValue("Destination","CHARISMA")
		if chakill < empskill then
			ai_GetWorkBuilding("Destination", GL_BUILDING_TYPE_PIRAT, "WorkBuilding")
			ModifyFavorToSim("","WorkBuilding",-10)
			SetProperty("Destination","UnterVerdacht",1)
			feedback_OverheadComment("","@L_THIEF_068_PICKPOCKETPEOPLE_SCREAM_+0", false, true)
			StopMeasure()
		else
			local spend = 45 * chakill
			if IsDynastySim("") then
				SpendMoney("",spend,"LaborOfLove")
			end
			CreditMoney("Destination",spend,"LaborOfLove")
			IncrementXPQuiet("",15)
		end
	end
	
	-- process the boost 
	local HeaderLabel = "@L_PIRATE_LABOROFLOVE_MSG_HEAD_+0"
	local Idx = Rand(8)
	if(Idx == 0) then
		-- + 50 Hitpoints
		ModifyHP("",50)
		feedback_MessageCharacter("",HeaderLabel,"@L_PIRATE_LABOROFLOVE_MSG_BODY_+0")
	elseif(Idx == 1) then
		-- - 50 Hitpoints
		ModifyHP("",-50,true,10)
		feedback_MessageCharacter("",HeaderLabel,"@L_PIRATE_LABOROFLOVE_MSG_BODY_+1")
	elseif(Idx == 2) then
		-- + 2 Random Skill
		local Skill = Rand(10) + 20
		AddImpact("",Skill,2,2)
		feedback_MessageCharacter("",HeaderLabel,"@L_PIRATE_LABOROFLOVE_MSG_BODY_+2")
	elseif(Idx == 3) then
		-- - 2 Random Skill
		local Skill = Rand(10) + 20
		AddImpact("",Skill,-2,2)
		feedback_MessageCharacter("",HeaderLabel,"@L_PIRATE_LABOROFLOVE_MSG_BODY_+3")
	elseif(Idx == 4) then
		-- Influenza infection
		diseases_Influenza("",true,true)
	elseif(Idx == 5)  then
		-- decreaset movespeed
		AddImpact("","MoveSpeed",0.8,2)
		feedback_MessageCharacter("",HeaderLabel,"@L_PIRATE_LABOROFLOVE_MSG_BODY_+4")
	elseif(Idx == 6) then
		-- increase movespeed
		AddImpact("","MoveSpeed",1.2,2)
		feedback_MessageCharacter("",HeaderLabel,"@L_PIRATE_LABOROFLOVE_MSG_BODY_+5")
	elseif(Idx == 7) then
		-- increase XP
		IncrementXP("",500)
		feedback_MessageCharacter("",HeaderLabel,"@L_PIRATE_LABOROFLOVE_MSG_BODY_+6")
	end
	
	-- satisfy the pleasure need
	SatisfyNeed("", 2, 0.5)
	
	MsgSay("Destination","@L_PIRATE_LABOROFLOVE_TALK_END")
	AddImpact("","FullOfLove",1,4)
	--DestroyCutscene("cutscene")
	StopMeasure()
end

function CleanUp()
	StopAnimation("")
	--DestroyCutscene("cutscene")
	if AliasExists("Destination") then
		--MoveSetStance("Destination",GL_STANCE_STAND)
		StopAnimation("Destination")
		SetProperty("Destination","CocotteHasClient",0)
	end
end

function GetOSHData(MeasureID)
	OSHSetMeasureCost("@L_INTERFACE_HEADER_+6",500)
end


