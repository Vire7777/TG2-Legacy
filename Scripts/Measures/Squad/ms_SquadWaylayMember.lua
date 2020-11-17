function Run()
	Sleep(0.5)
	MeasureSetNotRestartable()
	local	Member = GetData("Member")
	if not Member or Member==-1 then
		StopMeasure()
	end
	
	if not SquadGet("", "Squad") then
		StopMeasure()
	end
	
	if not SquadGetMeetingPlace("Squad", "Destination") then
		StopMeasure()
	end
	
	if not SimGetWorkingPlace("","MyRobbercamp") then
		if IsPartyMember("") then
			local NextBuilding = ai_GetNearestDynastyBuilding("",GL_BUILDING_CLASS_WORKSHOP,GL_BUILDING_TYPE_ROBBER)
			if not NextBuilding then
				StopMeasure()
			end
			CopyAlias(NextBuilding,"MyRobbercamp")
		else
			StopMeasure()
		end
	end
		
	SetData("InventoryFull",0)
	while true do
		
		f_MoveTo("","Destination",GL_MOVESPEED_RUN)
		if GetDistance("","Destination") > 15 then
			f_MoveTo("","Destination",GL_MOVESPEED_RUN,25)
			if GetDistance("","Destination") > 25 then
				f_MoveTo("","Destination",GL_MOVESPEED_RUN,50)
				if GetDistance("","Destination") > 50 then
					f_MoveTo("","Destination",GL_MOVESPEED_RUN,100)
					if GetDistance("","Destination") > 100 then
						PlayAnimationNoWait("","scout_object")
						Sleep(5)
						return true
					end
				end
			end
		end
		
		CarryObject("","Handheld_Device/ANIM_telescope.nif",false)
		PlayAnimation("","scout_object")
		CarryObject("","",false)
		GfxSetRotation("",0,Rand(360),0,false)
		Sleep(1)
		SetState("", STATE_HIDDEN, true)
		SetProperty("", "WaylayReady", 1)
		
		if HasProperty("", "PrimaryTarget") then
			RemoveProperty("", "PrimaryTarget")
		end
		
		local ItemId
		local Found
		local RemainingSpace
		local Removed 
		
		local Count = InventoryGetSlotCount("", INVENTORY_STD)
		for i=0,Count-1 do
			ItemId, Found = InventoryGetSlotInfo("", i, INVENTORY_STD)
			if ItemId and ItemId>0 and Found>0 then
				RemainingSpace	= GetRemainingInventorySpace("MyRobbercamp",ItemId)
				if Found > RemainingSpace then
					LogMessage("LogMessage: No Space for this item")
					return true --No more space for this item try again
				end
			end
		end
		
		local Victim = ms_squadwaylaymember_Scan("")
		if AliasExists(Victim) then
			SetState("",STATE_HIDDEN,false)
			ms_squadwaylaymember_Attack("",Victim)
			Sleep(1)
			if AliasExists(Victim) then
				ms_squadwaylaymember_Plunder("",Victim)
			else
				LogMessage("LogMessage: Victim#2 Does not exist")
			end
		else
			LogMessage("LogMessage: Victim#1 Does not exist")
		end
	end
	SetState("", STATE_HIDDEN, false)
	Sleep(1)
end

function Scan(Member)
	
	-- constants
	local MinBooty = 50
	local BootyRadius = 250
	local RobberRadius = 250
	
	local Count
	local BootyFilterCart = "__F((Object.GetObjectsByRadius(Cart) == "..BootyRadius..")AND NOT(Object.BelongsToMe())AND(Object.ActionAdmissible())AND NOT(Object.HasImpact(CartPlundered)))"
	
	local NumVictimCarts = Find(Member,BootyFilterCart,"VictimCart", -1)
	local NumOwnRobbers = SquadGetMemberCount(Member)
	local Attack = 0
	
	if NumVictimCarts <= 0 then --no booty carts found
		LogMessage("LogMessage: No Victims Found")
		Sleep(2)
		return true
	end

	local CurrentTargetValue = 0
	local MaxTargetValue = 0
	local	Num = NumVictimCarts
	local	TargetAlias = "VictimCart"
	
	for FoundObject=0,Num-1 do
		if DynastyGetDiplomacyState("Dynasty",TargetAlias..FoundObject)<=DIP_NEUTRAL then --no attack agreement, no booty
				CurrentTargetValue = chr_GetBootyCount(TargetAlias..FoundObject,INVENTORY_STD)
			if (CurrentTargetValue > MaxTargetValue) then
				CopyAlias(TargetAlias..FoundObject,"Victim")
				MaxTargetValue = CurrentTargetValue
			end
		end
	end
		
	--check if booty is enough
	Sleep(0.7)
		
	if MaxTargetValue < MinBooty then
		LogMessage("LogMessage","Not Enough Booty for consideration")
		Sleep(2)
		return true
	end
	
	--check the forces
	
	local	Att
	local	Def
	Att, Def = ai_CheckForces(Member, "Victim", BootyRadius)
	
	Attack = false

	if Def>0 then

		local	Quote = Att / Def
	
		--we are more, so attack 'em
		if Quote < 0.5 then
			Attack = true
		elseif Quote > 2 then
			Attack = false
		else
			Attack =  (MaxTargetValue > MinBooty + 1500*Quote)
		end
	end
	
	if not Attack then
		LogMessage("LogMessage","Victim Does not meet quota")
		Sleep(2)
		return true
	end
		
	--start attack

	AlignTo(Member,"Victim")
	return "Victim"
end

function Attack(ObjectAlias, Victim)
	
	SetState(ObjectAlias, STATE_HIDDEN, false)
	local AttDist = GetDistance(ObjectAlias,Victim)
	if AttDist > 250 or AttDist == -1 or GetImpactValue(Victim,"CartPlundered") > 0 then
		AddImpact(Victim,"CartPlundered",1,2)
		return true
	else
		MoveStop(Victim)
		f_MoveTo(ObjectAlias, Victim, GL_MOVESPEED_RUN, 100)
	end
	
	CommitAction("attackcart", ObjectAlias, ObjectAlias, Victim)
	StopAction("attackcart", ObjectAlias)
	
	SetProperty(ObjectAlias,"PrimaryTarget",GetID(Victim))
	
	if IsType(Victim,"Cart") then
		SetState(Victim, STATE_ACTIVE_ESCORT, true)
		if GetImpactValue(Victim,"messagesent")==0 then
			GetPosition(Victim,"ParticleSpawnPos")
			PlaySound3D(Victim,"fire/Explosion_01.wav", 1.0)
			StartSingleShotParticle("particles/Explosion.nif", "ParticleSpawnPos", 1,5)
			
			AddImpact(Victim,"messagesent",1,3)
			feedback_MessageMilitary(Victim,
				"@L_ROBBER_135_WAYLAYFORBOOTY_VICTIM_HEAD_+0",
				"@L_ROBBER_135_WAYLAYFORBOOTY_VICTIM_BODY_+0")
		
		end
		if CartGetOperator(Victim, "Operator") then
			SetState("Operator", STATE_DRIVERATTACKED, true)
		end
		
		SetProperty(ObjectAlias,"Plunder",GetID(Victim))
	end
	LogMessage("LogMessage: Attack Complete")
end

function Plunder(ObjectAlias,Victim)

	if GetID(Victim)~=GetProperty(ObjectAlias, "PrimaryTarget") then
		RemoveProperty(ObjectAlias,"Plunder")
		return true
	end
	
	if IsType(Victim,"Cart") then
		if CartGetOperator(Victim, "Operator") then
			if not GetState("Operator", STATE_DRIVERATTACKED) then
				PlayAnimation(ObjectAlias,"cheer_02")
				return true
			end
		end
	end

	SetProperty(ObjectAlias,"DontLeave", 1)
	CommitAction("plunder", ObjectAlias, ObjectAlias, Victim)
	Sleep(2)
	
	if IsType(Victim,"Sim") then
		local Money = 0.1*GetMoney(Victim)
		chr_RecieveMoney("Dynasty",Money,"IncomeRobbers")
		--for the mission
		mission_ScoreCrime("Dynasty",Money)
		SpendMoney(Victim,Money,"CostRobbers")
		ItemValue = Plunder(ObjectAlias, Victim,10)
		if ItemValue > 0 then
		--for the mission
			mission_ScoreCrime("Dynasty",ItemValue)
		end
	elseif IsType(Victim,"Cart") then
		ItemValue = Plunder(ObjectAlias, Victim,10)
		if ItemValue > 0 then
			--for the mission
			mission_ScoreCrime("Dynasty",ItemValue)
		end
		local TransitionTime
		TransitionTime = MoveSetActivity(ObjectAlias,"carry")
		Sleep(2)
		CarryObject(ObjectAlias, "Handheld_Device/ANIM_Bag.nif", false)

		Sleep(TransitionTime - 2)
	
		GetOutdoorMovePosition(ObjectAlias,"MyRobbercamp","MovePos")

		if not f_MoveTo(ObjectAlias,"MovePos") then
			return true
		end
	
		local	ItemId
		local	Found
		local RemainingSpace
		local Removed 

		local Count = InventoryGetSlotCount(ObjectAlias, INVENTORY_STD)
		for i=0,Count-1 do
			ItemId, Found = InventoryGetSlotInfo(ObjectAlias, i, INVENTORY_STD)
			if ItemId and ItemId>0 and Found>0 then
				RemainingSpace	= GetRemainingInventorySpace("MyRobbercamp",ItemId)
				if Found > RemainingSpace then
					MsgQuick("MyRobbercamp","@L_GENERAL_INFORMATION_INVENTORY_INVENTORY_FULL_+1",GetID("MyRobbercamp"),ItemGetLabel(ItemId,false))
					-- added by Napi
					RemoveItems(ObjectAlias,ItemId, Found, INVENTORY_STD) --1
					RemoveItems(ObjectAlias,ItemId, Found, INVENTORY_STD) --2
					RemoveItems(ObjectAlias,ItemId, Found, INVENTORY_STD) --3
					RemoveItems(ObjectAlias,ItemId, Found, INVENTORY_STD) --4
					RemoveItems(ObjectAlias,ItemId, Found, INVENTORY_STD) --5
				
					TransitionTime = MoveSetActivity(ObjectAlias,ObjectAlias)
					Sleep(2)
					CarryObject(ObjectAlias,ObjectAlias,false)
					Sleep(TransitionTime - 2)
				
					--SquadDestroy("Squad")
					return true
				end
				Removed		= RemoveItems(ObjectAlias, ItemId, RemainingSpace)
				if Removed>0 then
					AddItems("MyRobbercamp", ItemId, Removed)
				end
			
			end
		end
		TransitionTime = MoveSetActivity(ObjectAlias,ObjectAlias)
		Sleep(2)
		CarryObject(ObjectAlias,ObjectAlias,false)
		Sleep(TransitionTime - 2)
		StopAction("plunder", ObjectAlias)
		RemoveProperty(ObjectAlias,"DontLeave")
		RemoveProperty(ObjectAlias,"Plunder")
	end
	LogMessage("LogMessage: Plunder Complete")
	AddImpact(Victim,"CartPlundered",1,2)
end 

function CleanUp()
	StopAction("plunder", "")
	CarryObject("","",false)
	RemoveProperty("", "WaylayReady")
	SetState("", STATE_HIDDEN, false)
	StopAnimation("")
	MoveSetActivity("","")
	if not HasProperty("","DontLeave") then
		SquadRemoveMember("", true)
		if AliasExists("Squad") then
			if SquadGetMemberCount("Squad", true)<1 then
				SquadDestroy("Squad")
			end
		end
	else
		RemoveProperty("","DontLeave")
	end

	if not GetState("",STATE_FIGHTING) then
		if HasProperty("","Plunder") then
			local victim = GetProperty("","Plunder")
			GetAliasByID(victim,"Victim")
			if AliasExists("Victim") then
				if not IsType("Victim","Sim") then
					if CartGetOperator("Victim", "Operator") then
						if GetState("Operator",STATE_DRIVERATTACKED) then
							SetState("Operator", STATE_DRIVERATTACKED, false)
						end
					end
				end
			end
			RemoveProperty("","Plunder")
		end
	end

end

