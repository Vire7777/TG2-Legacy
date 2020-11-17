-------------------------------------------------------------------------------------------------------------------------------------
--  Forged Epic Items v2.0
--	OVERVIEW "as_1226_UseUniqueSlippers"
--	ANDOR: With this artifact, the player can increase his Charisma & Shadow Arts skills by 2 points.
-------------------------------------------------------------------------------------------------------------------------------------

function Run()

	if IsStateDriven() then
		local ItemName = "UniqueSlippers"
		if GetItemCount("", ItemName, INVENTORY_STD)==0 then
			if not ai_BuyItem("", ItemName, 1, INVENTORY_STD) then
				return
			end
		end
	end


	local MeasureID = GetCurrentMeasureID("")
	local duration = mdata_GetDuration(MeasureID)
	local TimeOut = mdata_GetTimeOut(MeasureID)
	local skillmodify = 2

	local Time = PlayAnimationNoWait("","use_object_standing")
	Sleep(1)
	PlaySound3D("","Locations/wear_clothes/wear_clothes+1.wav", 1.0)
	
	Sleep(5);
	PlaySound3D("","Locations/wear_clothes/wear_clothes+1.wav", 1.0)
	Sleep(Time-7)
		
	SetMeasureRepeat(TimeOut)
	if RemoveItems("","UniqueSlippers",1)>0 then
		AddImpact("","charisma",skillmodify,duration)
		AddImpact("","shadow_arts",skillmodify,duration)
		AddImpact("","UniqueSlippers",1,duration)
		
		GetPosition("","ParticleSpawnPos")
		StartSingleShotParticle("particles/sparkle_talents.nif", "ParticleSpawnPos",1,5)
		PlaySound3D("","Effects/mystic_gift+0.wav", 1.0)
--	Show overhead text
		feedback_OverheadSkill("", "@L_ARTEFACTS_OVERHEAD_+0", false, 
			"@L_TALENTS_charisma_ICON_+0", "@L_TALENTS_charisma_NAME_+0", skillmodify)
		Sleep(1)
		
--	Show overhead text
		feedback_OverheadSkill("", "@L_ARTEFACTS_OVERHEAD_+0", false, 
			"@L_TALENTS_shadow_arts_ICON_+0", "@L_TALENTS_shadow_arts_NAME_+0", skillmodify)
		Sleep(1)
		chr_GainXP("",GetData("BaseXP"))
	end
	StopMeasure()
end

function GetOSHData(MeasureID)
--  Can be used again in:
	OSHSetMeasureRepeat("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+2",Gametime2Total(mdata_GetTimeOut(MeasureID)))
--  Active time:
	OSHSetMeasureRuntime("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+0",Gametime2Total(mdata_GetDuration(MeasureID)))
end
-------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------