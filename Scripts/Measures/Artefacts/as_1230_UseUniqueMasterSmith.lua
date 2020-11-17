-------------------------------------------------------------------------------------------------------------------------------------
--  Forged Epic Items v2.0
--	OVERVIEW "as_1230_UseUniqueMasterSmith"
--	ANDOR: With this artifact, the player can increase his craftsmanship skill by 2 points.
-------------------------------------------------------------------------------------------------------------------------------------
function Run()

	if IsStateDriven() then
		local ItemName = "UniqueMasterSmith"
		if GetItemCount("", ItemName, INVENTORY_STD)==0 then
			if not ai_BuyItem("", ItemName, 1, INVENTORY_STD) then
				return
			end
		end
	end
	
	local MeasureID = GetCurrentMeasureID("")
	local duration = mdata_GetDuration(MeasureID)
	local TimeOut = mdata_GetTimeOut(MeasureID)
	
--  How much craftsmanship is increased
	local modifier = 2
	
--  Eat something ??
	local Time = PlayAnimationNoWait("","use_object_standing")
	Sleep(0.5)
	PlaySound3D("","Locations/wear_clothes/wear_clothes+1.wav", 1.0)
	Sleep(Time)
	
	if RemoveItems("","UniqueMasterSmith",1)>0 then
--  Show overhead text
		feedback_OverheadSkill("", "@L_ARTEFACTS_OVERHEAD_+0", false, 
			"@L_TALENTS_craftsmanship_ICON_+0", "@L_TALENTS_craftsmanship_NAME_+0", modifier)
	
		GetPosition("", "ParticleSpawnPos")
		StartSingleShotParticle("particles/sparkle_talents.nif", "ParticleSpawnPos",1,5)	
		PlaySound3D("","Effects/mystic_gift+0.wav", 1.0)
--  Add the impacts and remove the artefact from inventory
		SetMeasureRepeat(TimeOut)
		AddImpact("","craftsmanship",modifier,duration)
		AddImpact("","UniqueMasterSmith",1,duration)
		Sleep(1)
		chr_GainXP("",GetData("BaseXP"))
	end
	StopMeasure()
				
	
end

-- -----------------------
-- CleanUp
-- -----------------------
function CleanUp()
	CarryObject("","",false)
	Sleep(1)
end

function GetOSHData(MeasureID)
--  Can be used again in:
	OSHSetMeasureRepeat("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+2",Gametime2Total(mdata_GetTimeOut(MeasureID)))
--  Active time:
	OSHSetMeasureRuntime("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+0",Gametime2Total(mdata_GetDuration(MeasureID)))
end
-------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------