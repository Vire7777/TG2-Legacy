function Run()
	MeasureSetNotRestartable()

	if GetInsideBuilding("", "Building") then
		return
	end

	SetState("", STATE_CAPTURED, false)
	CityAddPenalty("city","Destination",PENALTY_FUGITIVE,360)
	AddImpact("","REVOLT",1,360)
	
--	CommitAction("revolt","","")

--	if GetHomeBuilding("", "Home") then
--		f_MoveTo("", "Home", GL_MOVESPEED_RUN)
--	end
	StopMeasure()
end

function CleanUp()

end
