function Init()
end

--Alternate Text Version (new entries in Text.dbt required; fixes text inconsistencies; makes the text look better/make sense - see README) 
--Modified by DarkLiz

function Run()		
	local IsBuilding = false
	if IsType("Destination","Building") and BuildingCanBeEntered("Destination","") then
		IsBuilding = true
	end

	local Result
	local costs = 0
	local DecisionBtns = "@B[1,@L_USE_HORSE_DECISION_BUTTON_NEW_+0]@B[0,@L_USE_HORSE_DECISION_BUTTON_NEW_+1]"
	
	--check it the player owns an estate with a stable
	local HasStable = false
	GetDynasty("", "MyDynasty")
	local BuildingCount = DynastyGetBuildingCount2("MyDynasty")

	for n=0, BuildingCount-1 do
		if DynastyGetBuilding2("MyDynasty", n, "MyBuilding") then
			if BuildingGetType("MyBuilding") == 111 then
				if BuildingHasUpgrade("MyBuilding", 808) then
					HasStable = true
				end
			end
		end
	end	

	--set dialogue options based on whether the player has to pay or not
	if HasStable == true then --the ride is free
		Result = MsgBox("","", "@P"..
		DecisionBtns,
		"@L_USE_HORSE_DECISION_HEAD_NEW_+1",
		"@L_USE_HORSE_DECISION_BODY_NEW_+0",
		GetID(""))
		SetProperty("", "RideIsFree", 1)

	else --you have to pay for the ride
		costs = 0.1 * GetDistance("","Destination")
		if costs > GetMoney("") then
			DecisionBtns = "@B[0,@L_USE_HORSE_DECISION_BUTTON_+2]"
		end
	
		Result = MsgBox("","", "@P"..
		DecisionBtns,
		"@L_USE_HORSE_DECISION_HEAD_NEW_+0",
		"@L_USE_HORSE_DECISION_BODY_+0",
		GetID(""), costs)
		SetProperty("", "RideIsFree", 0)
	end

	if Result ~= 1 then
		SetProperty("","aborted",1)
		StopMeasure()
	end
	
	SetProperty("","aborted",0)

	--spend the money
	if HasStable == false then 
		if not SpendMoney("", costs, "travelling") then
			MsgQuick("", "@L_USE_HORSE_FAILURE_+1")
			StopMeasure()
		end	
	end
	
	--do movement
	Mount("")
	SetState("", STATE_RIDING, true)
	
	GetVehicle("","Horse")
	
	PlaySound3DVariation("","Animals/Horse/whinny",1)
	
	if IsBuilding then 
		if not GetOutdoorMovePosition("", "Destination", "Target") then
			CopyAlias("Destination","Target")
		end
	else
		CopyAlias("Destination","Target")
	end
	
	if not f_MoveTo("Horse", "Target", GL_MOVESPEED_RUN, 15) then
		StopMeasure()
	end
	Sleep(4)
	
	Unmount("")
	SetState("", STATE_RIDING, false)
	
	if IsBuilding then
		f_MoveTo("","Destination")
	end
	SetProperty("","aborted",1)
end

function CleanUp()
	if HasProperty("","aborted") and GetProperty("","aborted") == 0 then
		Sleep(1)
		MoveSetActivity("","")
		Unmount("")
		SetState("", STATE_RIDING, false)
		if HasProperty("","RideIsFree") and GetProperty("","RideIsFree") == 0 then
			local refunds = 0.05 * GetDistance("","Destination")
			if refunds > 100 then
				CreditMoney("", refunds, "")
				MsgQuick("","@L_USE_HORSE_CANCEL_NEW_+0",GetID(""),refunds)
			else
				MsgQuick("","@L_USE_HORSE_CANCEL_NEW_+1")
			end
		else
			MsgQuick("","@L_USE_HORSE_CANCEL_NEW_+1")
		end
		RemoveProperty("","aborted")
	end
	if HasProperty("","RideIsFree") then
		RemoveProperty("","RideIsFree")
	end
	if HasProperty("","aborted") then
		RemoveProperty("","aborted")
	end
	
end

