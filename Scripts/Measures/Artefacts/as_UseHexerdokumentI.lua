function Run()

	if IsStateDriven() then
		local ItemName = "HexerdokumentI"
		if GetItemCount("", ItemName, INVENTORY_STD)==0 then
			if not ai_BuyItem("", ItemName, 1, INVENTORY_STD) then
				return
			end
		end
	end

	local MeasureID = GetCurrentMeasureID("")
	local TimeOut = mdata_GetTimeOut(MeasureID)

	MeasureSetNotRestartable()
	SetMeasureRepeat(TimeOut)	

	GetPosition("", "ParticleSpawnPos")
	RemoveItems("","HexerdokumentI",1)

	PlayAnimation("","watch_for_guard")
	PlaySound3D("","Locations/wear_clothes/wear_clothes+1.wav", 1.0)
  CarryObject("","Handheld_Device/ANIM_openscroll.nif",false)
	Sleep(1)
  
  PlayAnimationNoWait("","pray_standing")
	if SimGetGender("Destination") == 1 then
		PlaySound3DVariation("", "CharacterFX/male_neutral")
	else
    PlaySound3DVariation("", "CharacterFX/female_neutral")
  end
	Sleep(5)
	
	StartSingleShotParticle("particles/rage.nif", "ParticleSpawnPos",1,5)
	PlaySound3D("","Effects/mystic_gift+0.wav", 1.0)
	Sleep(1)
	
	CarryObject("","",false)
	
  local Evidence
	local Random = Rand(5)
	if Random == 0 then
		Evidence = 1
	elseif Random == 1 then
		Evidence = 4
	elseif Random == 2 then
		Evidence = 7
	elseif Random == 3 then
		Evidence = 10
	else
		Evidence = 11
  end
  
  AddEvidence("","Destination","",Evidence)
  AddImpact("","PerformingWitchcraft",1,1)

	StopMeasure()
	
end

function CleanUp()
	StopAnimation("")
	CarryObject("","",false)
end

function GetOSHData(MeasureID)
	OSHSetMeasureRepeat("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+2",Gametime2Total(mdata_GetTimeOut(MeasureID)))
end
