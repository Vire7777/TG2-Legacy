function BeginUseLocator(Actor, LocatorName, Stance, MoveToLocator, Speed)
	
	if not BlockLocator(Actor, LocatorName) then
		return false
	end
	
	if(MoveToLocator) then 
		if not f_MoveTo(Actor, LocatorName, Speed) then
			ReleaseLocator(Actor, LocatorName)
			return false
		end
	end
	
	local WaitTime = CUseLocator(Actor, Stance)
	Sleep(WaitTime)

	return true
end

function BeginUseLocatorWeak(Actor, LocatorName, Stance, MoveToLocator, Speed)
	if not BlockLocator(Actor, LocatorName) then
		return false  
	end
	
	if(MoveToLocator) then 
		if not f_WeakMoveTo(Actor, LocatorName, Speed) then
			ReleaseLocator(Actor, LocatorName)
			return false
		end
	end
	
	local WaitTime = CUseLocator(Actor, Stance)
	Sleep(WaitTime)

	return true
end

function BeginUseLocatorNoWait(Actor, LocatorName, Stance, MoveToLocator)
	if not BlockLocator(Actor, LocatorName) then
		return false
	end
	
	if(MoveToLocator) then
		if not f_MoveToNoWait(Actor, LocatorName) then
			ReleaseLocator(Actor, LocatorName)
			return false
		end
	end
	CUseLocator(Actor, Stance)
	return true
end

function EndUseLocator(Actor, LocatorName, Stance)

	if not AliasExists(Actor) then
		return false
	end

	if LocatorName and AliasExists(LocatorName) then
		if LocatorGetBlocker(LocatorName) ~= GetID(Actor) then
			return false
		end
	end
	
	if Stance==nil or Stance=="" then
		Stance = GL_STANCE_STAND
	end
	
	local WaitTime = CUseLocator(Actor, Stance)
	Sleep(WaitTime)
	
	return ReleaseLocator(Actor, LocatorName)
end

function EndUseLocatorNoWait(Actor, LocatorName, Stance)

	if LocatorName and AliasExists(LocatorName) then
		if LocatorGetBlocker(LocatorName) ~= GetID(Actor) then
			return false
		end
	end

	CUseLocator(Actor, Stance)
	return ReleaseLocator(Actor, LocatorName)
end

function AttendMoveTo(Owner,Destination,Speed,Hours)

	for i=0,(Hours*2-1) do
		if f_MoveTo(Owner,Destination,Speed)==true then
			return true
		end

		if BuildingGetCutscene(Destination,"_a_cutscene") then
			f_Stroll(Owner,250.0,1.0)
			MsgSay(Owner,"@L_NEWSTUFF_WAITING_COMPLAINTS")
			Sleep(15)
			f_Stroll(Owner,250.0,1.0)
			Sleep(15)
		else
			return false
		end
	end
	return false
end

function MoveToSilent(Owner, Destination, iSpeed, fRange)
	if not AliasExists(Destination) then
		return false
	end
	local Result
	local ResultName
		ResultName = "__MoveToResult_"..GetID(Owner).."_"..GetID(Destination)
		Result = CMoveTo(Owner, Destination, iSpeed, ResultName, fRange, true)	
		if (Result) then 
			WaitForMessage("WaitForTask")
	 		local lateresult = GetProperty(Owner, ResultName)
			RemoveProperty(Owner, ResultName)
			if lateresult == NIL or lateresult ~= GL_MOVERESULT_TARGET_REACHED then 
				-- if IsType("","Sim") then
					-- ai_ShowMoveError(lateresult, Owner)
				-- end
				return false
			end
			return true
		end
	-- end
	
	-- ai_ShowMoveError(GL_MOVERESULT_ERROR_TARGET_UNREACHABLE, Owner)
	return false
end

function MoveTo(Owner, Destination, iSpeed, fRange, Special)
	if not AliasExists(Owner) then
		return false
	end
	if not AliasExists(Destination) then
		return false
	end
	
	if Special == "AIDance" then
		SetProperty(Destination, "GoToDance", 1)
	elseif Special == "AIService" then
		SetProperty(Destination, "GoToService", 1)
	end

	StopAllAnimations("")

	--workaround for spinning carts...
	SetProperty("","MyDest",GetID(Destination))
	----------------------------------

	--workaround for unreachable entry locators...
	if HasProperty(Owner,"BlockLocB") then
		if SimIsInside(Owner) and (GetProperty(Owner,"BlockLocB") == GetInsideBuildingID(Owner)) then
			f_ExitCurrentBuilding(Owner)
		else
			RemoveProperty(Owner,"BlockLocB")
		end
	end
	----------------------------------------------
	
	local ResultName = "__MoveToResult_"..GetID(Owner).."_"..GetID(Destination)
	local Result = CMoveTo(Owner, Destination, iSpeed, ResultName, fRange, true)

	if (Result) then
		WaitForMessage("WaitForTask")
		local lateresult = GetProperty(Owner, ResultName)
		if HasProperty(Owner, ResultName) then
			RemoveProperty(Owner, ResultName)
		end
		
		if lateresult == NIL or lateresult ~= GL_MOVERESULT_TARGET_REACHED then 
			if IsType("","Sim") then
				ai_ShowMoveError(lateresult, Owner)
			end
			--workaround for spinning carts...
			RemoveProperty("","MyDest")
			----------------------------------
			return false
		end
		--workaround for spinning carts...
		RemoveProperty("","MyDest")
		----------------------------------
		return true
	end

	--workaround for unreachable entry locators...
	if IsType(Destination, "cl_Building") and BuildingCanBeEntered(Destination,Owner) then

		local locator = "Walledge1"
		GetLocatorByName(Destination, locator, "entry")
		
		local ResultName2 = "__MoveToResult_"..GetID(Owner).."_"..GetID(Destination)
		local Result2 = CMoveTo(Owner, "entry", iSpeed, ResultName, fRange, true)

		if (Result2) then
			WaitForMessage("WaitForTask")
			local lateresult = GetProperty(Owner, ResultName2)
			RemoveProperty(Owner, ResultName2)
			
			if lateresult == NIL or lateresult ~= GL_MOVERESULT_TARGET_REACHED then 
				local locator = "Walledge2"
				GetLocatorByName(Destination, locator, "entry")

				local Result3 = CMoveTo(Owner, "entry", iSpeed, ResultName, fRange, true)
			end

			SetProperty(Owner, "BlockLocL", locator)
			SetProperty(Owner, "BlockLocB", GetID(Destination))
		end
		RemoveProperty(Owner,"MyDest")

		SimBeamMeUp(Owner,Destination,false)
		return true
	end
	----------------------------------------------

	ai_ShowMoveError(GL_MOVERESULT_ERROR_TARGET_UNREACHABLE, Owner)
	--workaround for spinning carts...
	RemoveProperty("","MyDest")
	----------------------------------
	return false
end

function MoveToBuildingAction(Owner, Destination, iSpeed, fRange)
	local Moving = true
	local OwnerOutside = false
	local DestOutside = false
	local Distance

	while Moving == true do

		if not GetInsideRoom(Owner,"OwnerRoom") then
			OwnerOutside = true
		end
		if not GetInsideRoom(Destination,"DestRoom") then
			DestOutside = true
		end

		if (OwnerOutside==false) and (DestOutside==true) then
			f_ExitCurrentBuilding(Owner)
		elseif (OwnerOutside==true) and (DestOutside==false) then
			f_MoveTo(Owner, Destination, iSpeed, fRange)
		end

		if (GetID("OwnerRoom") == GetID("DestRoom")) or ((OwnerOutside==true) and (DestOutside==true)) then
			Distance = GetDistance(Owner,Destination)
			if Distance > fRange then
				f_MoveToNoWait(Owner, Destination, iSpeed, fRange)
				f_MoveToNoWait(Destination, Owner, iSpeed, fRange)
			end

			if Distance > 3000 then
				Sleep(10)
			elseif Distance > 2200 then
				Sleep(6)
			elseif Distance > 1700 then
				Sleep(4)	
			elseif Distance > 1200 then
				Sleep(2)
			elseif Distance > 820 then
				Sleep(0.6)
			elseif Distance < 270 then
				Moving = false
				return true
			else
				Sleep(2)
			end
		end
	end

	return false
end

function WeakMoveTo(Owner, Destination, iSpeed, fRange)
	local ResultName = "__MoveToResult_"..GetID(Owner).."_"..GetID(Destination)
	if not AliasExists(Destination) then
		return false
	end
	local Result = CMoveToWeak(Owner, Destination, iSpeed, ResultName, fRange, true)
	if (Result) then 
		WaitForMessage("WaitForTask")
		--local lateresult = GetData(ResultName)
 		local lateresult = GetProperty(Owner, ResultName)
		RemoveProperty(Owner, ResultName)
		if lateresult == NIL or lateresult ~= GL_MOVERESULT_TARGET_REACHED then 
			if IsType("","Sim") then
				ai_ShowMoveError(lateresult, Owner)
			end
			return false
		end
		return true
	end
	ai_ShowMoveError(GL_MOVERESULT_ERROR_TARGET_UNREACHABLE, Owner)
	return false
end

function Follow(pOwner, pDestination, iSpeed, fRange, bFollowOnce)
	if not pDestination or not GetID(pDestination) then
		return
	end
	
	local ResultName = "__FollowResult_"..GetID(pOwner).."_"..GetID(pDestination)
	
	local Result = CFollow(pOwner, pDestination, iSpeed, ResultName, fRange, bFollowOnce, true)
	if (Result) then 
		WaitForMessage("WaitForTask")
		--local lateresult = GetData(ResultName)
 		local lateresult = GetProperty("", ResultName)
		RemoveProperty("", ResultName)
		if lateresult ~= GL_MOVERESULT_TARGET_REACHED then 
			ai_ShowMoveError(lateresult, pOwner)
			return false
		end
		return true
	end
	ai_ShowMoveError(GL_MOVERESULT_ERROR_TARGET_UNREACHABLE, pOwner)
	return Result
end	


function MoveToNoWait(pOwner, pDestination, iSpeed, fRange) 
	return CMoveTo(pOwner, pDestination, iSpeed, NIL, fRange, false)
end

function WeakMoveToNoWait(Owner, Destination, iSpeed, fRange)
	return CMoveToWeak(Owner, Destination, iSpeed, NIL, fRange, true)
end
	
function FollowNoWait(pOwner, pDestination, iSpeed, fRange, bFollowOnce)
	if not AliasExists(pOwner) or not AliasExists(pDestination) then
		return false
	end

	return CFollow(pOwner, pDestination, iSpeed, NIL, fRange, bFollowOnce, false)
end	

function Fight(pSource,pDestination, Type)
	local Result=CFight(pSource,pDestination, Type)	
	if(Result) then
		WaitForMessage("WaitForTask")
	end
	return Result
end
	
function FightNoWait(pSource,pDestination,Type)
	return CFight(pSource,pDestination,Type)
end

function Stroll(pSource,Range, Duration)
	local Result = CStroll(pSource,Range,Duration)
	if(Result) then
		WaitForMessage("WaitForTask")
	end
end
  
function StrollNoWait(pSource,Range,Duration)
	return CStroll(pSource,Range,Duration)
end
			
function ExitCurrentBuilding(Alias)
	local Result = CExitCurrentBuilding(Alias)
	if (Result) then
		WaitForMessage("WaitForTask")
	end

	--workaround for unreachable entry locators...
	if HasProperty(Alias,"BlockLocB") then
		if GetNearestSettlement(Alias,"TheCity") then
			if CityGetNearestBuilding("TheCity",Alias,-1,-1,-1,-1,FILTER_IGNORE,"TheBuilding") then
				local l = GetProperty(Alias,"BlockLocL")
				local b = GetProperty(Alias,"BlockLocB")
				RemoveProperty(Alias,"BlockLocL")
				RemoveProperty(Alias,"BlockLocB")
				if GetID("TheBuilding")==b then
					GetLocatorByName("TheBuilding", l, "entry")
					SimBeamMeUp(Alias,"entry",false)
				end
			end
		end
	end
	----------------------------------------------

	return Result
end

function GetRandomPositionFromAlias(AliasName,Range)
	GetPosition(AliasName,"NewPos")
	local X,Y,Z = PositionGetVector("NewPos")
	X = X + ((Rand(Range)*2)-Range)
	Z = Z + ((Rand(Range)*2)-Range)
	PositionModify("NewPos",X,Y,Z)
	return "NewPos"
end

function ExitCurrentBuildingNoWait(Alias)
	return CExitCurrentBuilding(Alias)
end

function CleanUp()
end