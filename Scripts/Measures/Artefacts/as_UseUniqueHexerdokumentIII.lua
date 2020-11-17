-------------------------------------------------------------------------------------------------------------------------------------
--  Forged Epic Items v2.0
--	OVERVIEW "as_UseUniqueHexerdokumentIII"
--	ANDOR: With the help of this document you can forge three pieces of evidence against a person of your choice.
-------------------------------------------------------------------------------------------------------------------------------------
function Run()

	if IsStateDriven() then
		local ItemName = "UniqueHexerdokumentIII"
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
	RemoveItems("","UniqueHexerdokumentIII",1)
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

  for k=1,2 do
    local Evidence
    local Random = Rand(11)
    if Random == 0 then
	    Evidence = 1
    elseif Random == 1 then
	    Evidence = 4
    elseif Random == 2 then
	    Evidence = 7
    elseif Random == 3 then
	    Evidence = 10
    elseif Random == 4 then
	    Evidence = 11
    elseif Random == 5 then
	    Evidence = 12
    elseif Random == 6 then
	    Evidence = 13
    elseif Random == 7 then
	    Evidence = 14
    elseif Random == 8 then
	    Evidence = 15
    elseif Random == 9 then
	    Evidence = 16 
	else
	    Evidence = 27
    end
		AddEvidence("Owner","Destination","Owner",Evidence)
  end

	StopMeasure()
	
end

function CleanUp()
	StopAnimation("")
	CarryObject("","",false)
end

function GetOSHData(MeasureID)
	OSHSetMeasureRepeat("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+2",Gametime2Total(mdata_GetTimeOut(MeasureID)))
end
-------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------