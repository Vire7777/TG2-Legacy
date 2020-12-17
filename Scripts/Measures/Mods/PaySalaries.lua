-- The tax system is only for you as a player
function Run()
	if not GetInsideBuilding("", "Building") then
		return
	end
	
	-- Calculate the normal fee you have to pay for your workers
	local dueSalaries = paysalaries_CalculateSalaries()
	
	-- Find the actual salary choice for that building
	local salaryChoiceNb = GetParameter("Building", "SalaryChoice")
	local salaryChoice = ""
	if (salaryChoiceNb == 0) then
		salaryChoice = "@L_PAYSALARIES_NOPAYMENT"
	elseif (salaryChoiceNb == 1) then
		salaryChoice = "@L_PAYSALARIES_HALFPAYMENT"
	else
		salaryChoice = "@L_PAYSALARIES_FULLPAYMENT"
	end
	
	-- Create the options
	local options = "@P"
	options = options.."@B[2,@L_PAYSALARIES_FULLPAYMENT]"
	options = options.."@B[1,@L_PAYSALARIES_HALFPAYMENT]"
	options = options.."@B[0,@L_PAYSALARIES_NOPAYMENT]"
	
	-- Make the message
	local result = MsgNews("",-1,
		options, --options
		-1,  --AIFunc
		"economie", --MessageClass
		-1, --TimeOut
		"@L_PAYSALARIES_INFORMATION_HEAD",
		"@L_PAYSALARIES_INFORMATION_BODY",
		GetID(""),dueSalaries, salaryChoice)
			
	SetParameter("Building", "SalaryChoice", result)
end	

function CalculateSalaries()
	local totalSalaries = 0
	local workerCount = BuildingGetWorkerCount("Building")
	for i = 0, workerCount-1 do
		BuildingGetWorker("Building", i, "Worker")
		totalSalaries = totalSalaries + SimGetWage("Worker")
	end
	
	return totalSalaries
end

function CleanUp()
end
