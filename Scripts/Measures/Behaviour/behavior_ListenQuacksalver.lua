function Run()

	-- etwa Abstand vom Geschehen, und gaffen
	GetFleePosition("Owner", "Actor", 200+Rand(50), "Away")
	f_MoveTo("Owner", "Away", GL_MOVESPEED_WALK)
	AlignTo("Owner", "Actor")
	Sleep(1)

	local ActionName = GetData("Action_Name")
	local TimeLeft = -1
	local	TimeOut = GetGametime()+1
	SetRepeatTimer("Owner", "Listen2Quacksalver", 16)

	--listen
	while not ActionIsStopped("Action") do

		if GetGametime() > TimeOut then
			break
		end
			
		if TimeLeft < 0 then

			local Value = Rand(100)
			if Value < 50 then
				if SimGetGender("")==GL_GENDER_MALE then
					PlaySound3DVariation("","CharacterFX/male_cheer",1)
				else
					PlaySound3DVariation("","CharacterFX/female_cheer",1)
				end
				TimeLeft = PlayAnimation("Owner", "cheer_01")
			else
				TimeLeft = PlayAnimation("Owner", "cheer_02")
			end
		end
		Sleep(1)
		TimeLeft = TimeLeft - 1
	end
	
	--buy stuff or not
	if (GetID("Actor")) then
		local RhetoricSkillActor = GetSkillValue("Actor",7)
		local MoneyToGet = RhetoricSkillActor * 10 + Rand(10)
		
		-- only for farmers
    	if (SimGetProfession("Actor") == 1 or SimGetClass("Actor") == 1) then
    		if GetSkillValue("", "EMPATHY") >= GetSkillValue("Actor", "RHETORIC") and Rand(5) == 1 then
        		behavior_listenquacksalver_NotConvinced()
    			local modval = -Rand(5)-1
        		chr_ModifyFavor("","Actor",modval)
    		else
				-- How much you got
        		MoneyToGet = (GetSkillValue("Actor","RHETORIC")+GetSkillValue("Actor","BARGAINING"))*10
        		
				PlayAnimation("","nod")
        		CreditMoney("Actor",MoneyToGet,"SellMagicBeans")
        		ShowOverheadSymbol("Actor",false,true,0,"%1t",MoneyToGet)
    		end
    	elseif not CheckSkill("",8,RhetoricSkillActor) then
			PlayAnimation("","nod")
			
			if RemoveItems("Actor", "MiracleCure", 1, INVENTORY_STD)==1 then
				MoneyToGet = MoneyToGet + 100
				CreditMoney("Actor",MoneyToGet,"Offering")
				ShowOverheadSymbol("Actor",false,true,0,"%1t",MoneyToGet)
			else
				SatisfyNeed("", 6, -0.5)
			end
		else
			behavior_listenquacksalver_NotConvinced()
		end
	end
	
	Sleep(2.0)
end

function NotConvinced()
	if SimGetGender("")==GL_GENDER_MALE then
		PlaySound3DVariation("","CharacterFX/male_hoot",1)
	else
		PlaySound3DVariation("","CharacterFX/female_hoot",1)
	end
	PlayAnimation("","shake_head")
end

function CleanUp()
end
