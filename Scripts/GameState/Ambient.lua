function OnButtonPressed(x, y, device, key)
	local Options = FindNode("\\Settings\\Options")
	local Ambient = Options:GetValueInt("Ambient")
	local AmbientNextStep = Options:GetValueInt("AmbientNextStep")

	if Ambient==1 then
		Options:SetValueInt("Ambient",0)
		Options:SetValueInt("AmbientNextStep",0)
--		LogMessage("AmbientNextStep = "..AmbientNextStep);
--		LogMessage("Ambient = 0");
	else
		Options:SetValueInt("Ambient",1)
		Options:SetValueInt("AmbientNextStep",0)
--		LogMessage("AmbientNextStep = "..AmbientNextStep);
--		LogMessage("Ambient = 1");
	end
end


function OnButtonPressed_Back(x, y, device, key)
	local Options = FindNode("\\Settings\\Options")
	local AmbientNextStep = Options:GetValueInt("AmbientNextStep")

	if (AmbientNextStep < 2) or (AmbientNextStep > 2) then
		Options:SetValueInt("AmbientNextStep",0)
--		LogMessage("AmbientNextStep = 0");
		Options:SetValueInt("Ambient",1)
--		LogMessage("Ambient = 1");
	else
		Options:SetValueInt("AmbientNextStep",AmbientNextStep-1)
--		LogMessage("AmbientNextStep = "..AmbientNextStep-1);
	end
end


function OnButtonPressed_Next(x, y, device, key)
	local Options = FindNode("\\Settings\\Options")
	local AmbientNextStep = Options:GetValueInt("AmbientNextStep")

	Options:SetValueInt("AmbientNextStep",AmbientNextStep+1)
--	LogMessage("AmbientNextStep = "..AmbientNextStep+1);
end

function CleanUp()
end
