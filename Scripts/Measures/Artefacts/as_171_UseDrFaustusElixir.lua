-------------------------------------------------------------------------------
----
----	OVERVIEW "as_171_UseDrFaustusElixir"
----
----	with this artifact, the player can increase his life time
----
-------------------------------------------------------------------------------
function Run()

	if IsStateDriven() then
		local ItemName = "DrFaustusElixir"
		if GetItemCount("", ItemName, INVENTORY_STD)==0 then
			if not ai_BuyItem("", ItemName, 1, INVENTORY_STD) then
				return
			end
		end
	end

	local MeasureID = GetCurrentMeasureID("")
	local TimeOut = mdata_GetTimeOut(MeasureID)
	--amount of years, the life will be expanded
	local YearsToLive = 3
	
	--play animation and spawn particles
	local Time = PlayAnimationNoWait("","use_potion_standing")
	Sleep(1)
	PlaySound3D("","Locations/wear_clothes/wear_clothes+1.wav", 1.0)
	CarryObject("","Handheld_Device/ANIM_perfumebottle.nif",false)
	Sleep(Time-2)
	PlaySound3D("","Locations/wear_clothes/wear_clothes+1.wav", 1.0)
	CarryObject("","",false)
	Sleep(1)
	
	if RemoveItems("","DrFaustusElixir",1)>0 then
		if Rand(100)>60 then
			Time = PlayAnimationNoWait("","cheer_01")
			GetPosition("","ParticleSpawnPos")
			StartSingleShotParticle("particles/pray_glow.nif","ParticleSpawnPos",1,4)
			PlaySound3D("","Effects/mystic_gift+0.wav", 1.0)
			AddImpact("","LifeExpanding",YearsToLive,-1)
			feedback_MessageCharacter("","@L_ARTEFACTS_171_USEDRFAUSTUSELIXIR_MSG_SUCCES_HEAD_+0",
							"@L_ARTEFACTS_171_USEDRFAUSTUSELIXIR_MSG_SUCCES_BODY_+0")
			chr_GainXP("",GetData("BaseXP"))
		else	
			Time = PlayAnimationNoWait("","appal")	
			GetPosition("","ParticleSpawnPos")
			StartSingleShotParticle("particles/BoozyBreathBeer.nif", "ParticleSpawnPos",2.2,3)
			feedback_MessageCharacter("","@L_ARTEFACTS_171_USEDRFAUSTUSELIXIR_MSG_FAILED_HEAD_+0",
							"@L_ARTEFACTS_171_USEDRFAUSTUSELIXIR_MSG_FAILED_BODY_+0")			
			--ApplyBadEffect
			AddImpact("","FaustBad",1,8) --applies the negative effect for 8 hours
			SetState("",STATE_CONTAMINATED,true)
		end
		
		SetMeasureRepeat(TimeOut)
		Sleep(Time)
	end
	StopMeasure()

end

function CleanUp()
	StopAnimation("")
end

function GetOSHData(MeasureID)
	--can be used again in:
	OSHSetMeasureRepeat("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+2",Gametime2Total(mdata_GetTimeOut(MeasureID)))
	--active time:
	OSHSetMeasureRuntime("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+1",Gametime2Total(mdata_GetDuration(MeasureID)))
end

