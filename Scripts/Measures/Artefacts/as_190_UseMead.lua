-------------------------------------------------------------------------------
----
----	OVERVIEW "as_190_UseMead"
----
----	with this artifact, the player can increase his HP by 50
----
-------------------------------------------------------------------------------

function Run()

	if IsStateDriven() then
		local ItemName = "Mead"
		if GetItemCount("", ItemName, INVENTORY_STD)==0 then
			if not ai_BuyItem("", ItemName, 1, INVENTORY_STD) then
				return
			end
		end
	end

	--amount of HP added
	local HPBonus = GetMaxHP("")/2
	--time before artefact can be used again

	local MeasureID = GetCurrentMeasureID("")
	local TimeOut = mdata_GetTimeOut(MeasureID)
	
	--play anims 
	if RemoveItems("","Mead",1)>0 then
		local Time = PlayAnimationNoWait("","use_potion_standing")
		GetPosition("Owner", "ParticleSpawnPos")
		Sleep(1)
		PlaySound3D("","measures/usemead+0.wav", 1.0)
		CarryObject("","Handheld_Device/ANIM_horn.nif",false)
		Sleep(Time-2)
		
		CarryObject("","",false)
		StartSingleShotParticle("particles/healthglow.nif", "ParticleSpawnPos")
		PlaySound3D("","Effects/mystic_gift+0.wav", 1.0)
		--remove item from inventory, add the impact, raise HP and torkel a little bit
		SetMeasureRepeat(TimeOut)
		
		
		ModifyHP("", HPBonus,false)
	
		feedback_OverheadComment("","@L_ARTEFACTS_190_USEMEAD_OVERHEAD_+0", false, false, HPBonus)	
    Sleep(1)
    chr_GainXP("",GetData("BaseXP"))
	
		LoopAnimation("","idle_drunk",5)
	end
	StopMeasure()
	
end

function CleanUp()
	StopAnimation("")
end

function GetOSHData(MeasureID)
	--can be used again in:
	OSHSetMeasureRepeat("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+2",Gametime2Total(mdata_GetTimeOut(MeasureID)))
	--active time immediately
	OSHSetMeasureRuntime("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+1",Gametime2Total(mdata_GetDuration(MeasureID)))
end

