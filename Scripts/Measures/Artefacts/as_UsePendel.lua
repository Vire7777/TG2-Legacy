function Run()

	if not GetSettlement("Destination","Heimat") then
		StopMeasure()
	end

	if IsStateDriven() then
		local ItemName = "pendel"
		if GetItemCount("", ItemName, INVENTORY_STD)==0 then
			if not ai_BuyItem("", ItemName, 1, INVENTORY_STD) then
				return
			end
		end
	end

	local MaxDistance = 1500
	local ActionDistance = 100
	local MeasureID = GetCurrentMeasureID("")
	local duration = mdata_GetDuration(MeasureID)
	local TimeOut = mdata_GetTimeOut(MeasureID)

	if not ai_StartInteraction("", "Destination", MaxDistance, ActionDistance, nil) then
    MsgQuick("", "_HPFZ_ARTEFAKT_ALLGEMEIN_FEHLER_+0")
		StopMeasure()
	end

	MeasureSetNotRestartable()
	SetMeasureRepeat(TimeOut)	
	AlignTo("Owner", "Destination")
	AlignTo("Destination", "Owner")
	Sleep(0.5)

	GetPosition("Destination", "ParticleSpawnPos")
	PlayAnimationNoWait("Destination","cogitate")
	RemoveItems("","pendel",1)
	PlayAnimationNoWait("","manipulate_top_r")
  Sleep(1)
	if SimGetGender("") == 1 then
		PlaySound3D("","CharacterFX/male_neutral/male_neutral+1.ogg", 1.0)
    Sleep(3)
	else
    PlaySound3D("","CharacterFX/female_neutral/female_neutral+9.ogg", 1.0)
    Sleep(3)
  end
	StartSingleShotParticle("particles/summon.nif", "ParticleSpawnPos",2.7,5)
	PlaySound3D("","Locations/destillery/destillery+1.wav", 1.0)
	PlayAnimationNoWait("Destination", "nod")				
	PlayFE("Owner", "smile", 1, 2, 0)
	if (GetSkillValue("Owner",SHADOW_ARTS) < GetSkillValue("Destination",EMPATHY)) then	
		MsgSay("Destination", "_HPFZ_ARTEFAKT_PENDEL_SPRUCH_+0")		
	else
		AddImpact("Destination","pendel",1,duration)
		SetState("Destination", STATE_HPFZ_HYPNOSE, true)
		
		MsgNewsNoWait("","Destination","","intrigue",-1,
				"@L_HPFZ_ARTEFAKT_PENDEL_NUTZER_KOPF_+0",
				"@L_HPFZ_ARTEFAKT_PENDEL_NUTZER_RUMPF_+0",GetID("Destination"),GetID("Heimat"))
		MsgNewsNoWait("Destination","","","intrigue",-1,
				"@L_HPFZ_ARTEFAKT_PENDEL_OPFER_KOPF_+0",
				"@L_HPFZ_ARTEFAKT_PENDEL_OPFER_RUMPF_+0",GetID(""),GetID("Heimat"))
				
	end

	StopMeasure()
end

function CleanUp()
	feedback_OverheadActionName("Destination")
end

function GetOSHData(MeasureID)
	OSHSetMeasureRepeat("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+2",Gametime2Total(mdata_GetTimeOut(MeasureID)))
	OSHSetMeasureRuntime("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+0",Gametime2Total(mdata_GetDuration(MeasureID)))
end
