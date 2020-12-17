-- The tax system is only for you as a player
function Run()
	BuildingGetOwner("", "sim")
	CopyAlias("", "Building")
	
	-- Calculate the normal fee you have to pay for your workers
	local dueWages = managewages_CalculateWages()

	-- Find the actual salary choice for that building
	local wageChoiceNb = GetProperty("Building", "WageChoice")
	
	local wageChoice = ""
	if (wageChoiceNb == 2) then
		wageChoice = "@L_MANAGEWAGES_NOPAYMENT"
	elseif (wageChoiceNb == 1) then
		wageChoice = "@L_MANAGEWAGES_HALFPAYMENT"
	else
		wageChoice = "@L_MANAGEWAGES_FULLPAYMENT"
	end

	-- Create the options
	local options = "@P"
	options = options.."@B[0,@L_MANAGEWAGES_FULLPAYMENT]"
	options = options.."@B[1,@L_MANAGEWAGES_HALFPAYMENT]"
	options = options.."@B[2,@L_MANAGEWAGES_NOPAYMENT]"

	-- Make the message
	local result = MsgNews("Sim",-1,
		options, --options
		-1,  --AIFunc
		"economie", --MessageClass
		-1, --TimeOut
		"@L_MANAGEWAGES_INFORMATION_HEAD",
		"@L_MANAGEWAGES_INFORMATION_BODY",
		GetID("Sim"),dueWages, wageChoice)
			
	SetProperty("Building", "WageChoice", result)
end	

function CalculateWages()
	-- Calculate building wages
	local totalWages = 0
	local workerCount = BuildingGetWorkerCount("Building")
	for i = 0, workerCount-1 do
		BuildingGetWorker("Building", i, "Worker")
		totalWages = totalWages + SimGetWage("Worker")
	end
	
	return totalWages
end

function ManageWorkerWages()
	GetDynasty("", "Dyn")

	-- initalize wages to get back
	local totalWagesBack = 0
	
	local buildingCount = DynastyGetBuildingCount2("Dyn")
	for i = 0, buildingCount - 1 do
		DynastyGetBuilding2("Dyn", 1, "Building")
		if (BuildingGetClass("Building") == GL_BUILDING_CLASS_WORKSHOP) then
		
    		-- calculate the wages for this building
    		local dueWages = managewages_CalculateWages()
    
    		-- Find how much you get back
    		local wageChoiceNb = GetProperty("Building", "WageChoice")

    		local buildingWagesBack = managewages_CalculateMoneyBack(dueWages, wageChoiceNb)
    		totalWagesBack = totalWagesBack + buildingWagesBack
    		
    		-- Change the worker view about you
    		managewages_ChangeWorkersFavor(wageChoiceNb)
    	end
	end
	
	-- Credit the amount
	if (totalWagesBack > 0) then
		CreditMoney("Dyn", totalWagesBack, "Wages not paid")
	end
	
	-- Launch again
	CreateScriptcall("ManageWorkerWages",1,"Measures/Mods/ManageWages.lua","ManageWorkerWages","","",0)
end

function CalculateMoneyBack(dueWages, wageChoiceNb)
	local buildingWagesBack = 0

	if (wageChoiceNb == 2) then
		buildingWagesBack = dueWages
	elseif (wageChoiceNb == 1) then
		buildingWagesBack = dueWages / 2
	end
	
	return buildingWagesBack
end

function ChangeWorkersFavor(wageChoiceNb)
	if (wageChoiceNb > 0) then
		local maxFavor = (wageChoiceNb*5)

		-- fine each worker
    	local workerCount = BuildingGetWorkerCount("Building")
    	MsgQuick("",workerCount)
    	for workerNum = 0, workerCount - 1 do
    		BuildingGetWorker("Building", workerNum, "Worker")
    		MsgQuick("","worker numer")
    		MsgQuick("",workerNum)
    		local workerLevel = SimGetLevel("Worker")
    		
    		-- each worker ll like you less
    		local changeFavor = -1*(Rand(maxFavor) + maxFavor) / workerLevel
    		MsgQuick("","Favor")
    		MsgQuick("",changeFavor)
    		chr_ModifyFavor("Worker","",changeFavor)
    	end
	end
end

function CleanUp()
end
