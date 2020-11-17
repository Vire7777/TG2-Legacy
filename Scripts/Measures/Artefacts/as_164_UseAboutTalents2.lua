-------------------------------------------------------------------------------
----
----	OVERVIEW "as_164_UseAboutTalents2"
----
----	with this artifact, the player can increase his craftsmanship skill by 2
----
-------------------------------------------------------------------------------

function Run()
	if (GetState("", STATE_CUTSCENE)) then
		as_164_useabouttalents2_Cutscene()
	else
		as_164_useabouttalents2_Normal()
	end
end

function Normal()

	if IsStateDriven() then
		local ItemName = "AboutTalents2"
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
		
	--take a book and read
	local Time = PlayAnimationNoWait("","use_book_standing") 
	Sleep(1)
	CarryObject("","Handheld_Device/ANIM_book.nif",false)
	PlaySound3D("","Locations/wear_clothes/wear_clothes+1.wav", 1.0)
	Sleep(Time-2)
	CarryObject("","",false)
	PlaySound3D("","Locations/wear_clothes/wear_clothes+1.wav", 1.0)
	
	--show particles
	if RemoveItems("","Abouttalents2",1) > 0 then
		GetPosition("Owner", "ParticleSpawnPos")
		StartSingleShotParticle("particles/sparkle_talents.nif", "ParticleSpawnPos",1,5)
		PlaySound3D("","Effects/mystic_gift+0.wav", 1.0)
		--show overhead text
		feedback_OverheadSkill("", "@L_ARTEFACTS_OVERHEAD_+0", false,
			"@L_TALENTS_rhetoric_ICON_+0", "@L_TALENTS_rhetoric_NAME_+0", skillmodify)
		Sleep(1)
		
		feedback_OverheadSkill("", "@L_ARTEFACTS_OVERHEAD_+0", false,
			"@L_TALENTS_craftsmanship_ICON_+0", "@L_TALENTS_craftsmanship_NAME_+0", skillmodify)
	
	--add the impacts and remove the artefact from inventory
	
		SetMeasureRepeat(duration)
		AddImpact("","abouttalents2",1,duration)
		AddImpact("","craftsmanship",skillmodify,duration)
		AddImpact("","rhetoric",skillmodify,duration)
		Sleep(1)
		chr_GainXP("",GetData("BaseXP"))
	end		
	
end

function Cutscene()
	 
	local MeasureID = GetCurrentMeasureID("")
	local duration = mdata_GetDuration(MeasureID)
	local TimeOut = mdata_GetTimeOut(MeasureID)
	
	local skillmodify = 2
		
	
	--show particles
	GetPosition("Owner", "ParticleSpawnPos")
	StartSingleShotParticle("particles/sparkle_talents.nif", "ParticleSpawnPos",1,5)
	
	--show overhead text
	feedback_OverheadSkill("", "@L_ARTEFACTS_OVERHEAD_+0", false,
		"@L_TALENTS_rhetoric_ICON_+0", "@L_TALENTS_rhetoric_NAME_+0", skillmodify)
	Sleep(1)
	
	feedback_OverheadSkill("", "@L_ARTEFACTS_OVERHEAD_+0", false,
		"@L_TALENTS_craftsmanship_ICON_+0", "@L_TALENTS_craftsmanship_NAME_+0", skillmodify)

	--add the impacts and remove the artefact from inventory
	RemoveItems("","Abouttalents2",1)
	SetMeasureRepeat(duration)
	AddImpact("","abouttalents2",1,duration)
	AddImpact("","craftsmanship",skillmodify,duration)
	AddImpact("","rhetoric",skillmodify,duration)
	chr_GainXP("",GetData("BaseXP"))
	if SimGetCutscene("","cutscene") then
		CutsceneCallUnscheduled("cutscene", "UpdatePanel")
		Sleep(0.1)
	else
		return
	end						
	
end

function CleanUp()
	StopAnimation("")
end

function GetOSHData(MeasureID)
	--can be used again in:
	OSHSetMeasureRepeat("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+2",Gametime2Total(mdata_GetTimeOut(MeasureID)))
	--active time:
	OSHSetMeasureRuntime("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+0",Gametime2Total(mdata_GetDuration(MeasureID)))
end

