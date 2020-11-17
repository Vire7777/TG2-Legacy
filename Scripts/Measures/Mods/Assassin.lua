------------------------------------------------------------------
-------------------------Assassin.lua-----------------------------
------------------------------------------------------------------
--------Allows you to hire an assassin from the tavern------------

function Run()

	local Hour = math.mod(GetGametime(), 24)
	if not GetInsideBuilding("","Tavern") then -- Returns the taverns name
		StopMeasure()
	end	
		
	if Hour > 2 then
		MsgQuick("","@L_INTRIGUE_ASSASSIN_FAILURES_+0")
		StopMeasure()
	else	
		local X = SimGetOfficeLevel("Destination")
		local Title = GetNobilityTitle("Destination")
		local TitleCost = Title * 1000
		local Level = {}
			Level[-1] = 0
			Level[1] = 100000
			Level[2] = 250000
			Level[3] = 350000
			Level[4] = 350000
			Level[5] = 500000
			Level[6] = 750000
			Level[7] = 1000000
		
		local OfficeCost = Level[X]
		local Cost = 10000 + TitleCost + OfficeCost			
		local Difficulty = ScenarioGetDifficulty()
		if Difficulty < 2 then
			Cost = Cost * 0.1
		elseif Difficulty == 2 then
			Cost = Cost * 0.5
		end
		local MyMoney = GetMoney("")
		if DynastyIsPlayer("") then
			if MyMoney < Cost then
				MsgQuick("","@L_INTRIGUE_ASSASSIN_FAILURES_+1")
				StopMeasure()
			end
		end
		
		GetPosition("","Spawn")
		GetHomeBuilding("","Home")
		f_MoveToNoWait("", "Home")
		Sleep(1.5)
		MoveStop("")
		StartSingleShotParticle("particles/big_crash.nif", "Spawn",5,3)
		Sleep(4)
		SimCreate(50, "Tavern", "Spawn", "Assassin")
		SetData("Assassin", 1)
		AlignTo("","Assassin")
		AlignTo("Assassin","")
		SetState("", STATE_LOCKEDALT, true)
		--Make sure the assassin will only do his duty!
		SetState("Assassin", STATE_LOCKEDALT, true)
		Sleep(2)
		PlayAnimation("","point_at")
		Sleep(2)
		local Result = MsgNews("","","@P"..
			"@B[1,@L_Assassin_BUTTONS_+1]"..
			"@B[2,@L_REPLACEMENTS_BUTTONS_CANCEL_+0]",
			assassin_AIDecision,  --AIFunc
			"intrigue", --Message Class
			2, --TimeOut
			"@L_INTRIGUE_ASSASSIN_SCREENPLAY_ACTOR_HEAD_+0",
			"@L_INTRIGUE_ASSASSIN_SCREENPLAY_ACTOR_BODY_+0",
			GetID("Destination"),Cost) 	
		
		if Result == 2 then
			StartSingleShotParticle("particles/big_crash.nif", "Spawn",5,3)
			Sleep(4)
			InternalDie("Assassin")
			InternalRemove("Assassin")
			SetState("", STATE_LOCKEDALT, false)
			StopMeasure()
		else	
			if SimGetAlignment("Destination") > 85 then --if target is very evil assassin charges only 10% of regular cost
				Cost = Cost * 0.1
			end	
			if DynastyIsPlayer("") then
				SpendMoney("", Cost, "CostBribes")
			end
			BuildingGetOwner("","Agent") -- Returns Tavern Owner So that he can receive a cut of the assassins pay
			if AliasExists("Agent") then
				local Fee = Cost * 0.10
				chr_RecieveMoney("Agent",Fee,"IncomeOther") --give tavern owner a 10% cut or it could also be thought of as a 10% discount if you own the tavern
			end
			SetFavorToSim("","Destination",0)
			local MeasureID = GetCurrentMeasureID("")
			local TimeOut = mdata_GetTimeOut(MeasureID)
			SetRepeatTimer("", GetMeasureRepeatName(), TimeOut)
			SetProperty("","Ident1",1)
			MeasureRun("Assassin","Destination","AssassinKill",false)
			SetState("", STATE_LOCKEDALT, false)
		end	
	end	
end

function CleanUp()
end

function AIDecision()
	return 1
end

function GetOSHData(MeasureID)
	--can be used again in:
	OSHSetMeasureRepeat("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+2",Gametime2Total(mdata_GetTimeOut(MeasureID)))
end
