function Run()

	if IsStateDriven() then
		local ItemName = "voodo"
		if GetItemCount("", ItemName, INVENTORY_STD)==0 then
			if not ai_BuyItem("", ItemName, 1, INVENTORY_STD) then
				return
			end
		end
	end

	local MaxDistance = 1000
	local ActionDistance = 30
	local MeasureID = GetCurrentMeasureID("")
	local TimeOut = mdata_GetTimeOut(MeasureID)
	
	if not ai_StartInteraction("", "Destination", MaxDistance, ActionDistance, nil) then
	    MsgQuick("","_HPFZ_ARTEFAKT_ALLGEMEIN_FEHLER_+0")
		StopMeasure()
	end

	MeasureSetNotRestartable()
	SetMeasureRepeat(TimeOut)	
	CommitAction("PerformingWitchcraft","","Destination","Destination")
  AddImpact("","PerformingWitchcraft",1,0.2)
	AlignTo("Owner", "Destination")
	AlignTo("Destination", "Owner")
	Sleep(1)

	RemoveItems("","voodo",1)
	PlayAnimationNoWait("Owner", "use_object_standing")
	PlayAnimationNoWait("Destination","cogitate")
	Sleep(2)
	PlaySound3D("","Locations/wear_clothes/wear_clothes+1.wav", 1.0)
	CarryObject("","Handheld_Device/Doll_med_01.nif",false)	
	Sleep(1)
	CarryObject("","",false)
	CarryObject("Destination","Handheld_Device/Doll_med_01.nif",false)
	PlayAnimationNoWait("Destination","fetch_store_obj_R")
	Sleep(2)
	PlaySound3D("Destination","Locations/wear_clothes/wear_clothes+1.wav", 1.0)
	CarryObject("Destination","",false)
	PlayFE("Destination", "smile", 0.5, 2, 0)
	Sleep(1)

	MsgSay("Destination","_HPFZ_ARTEFAKT_VODOO_SPRUCH_+0")
	if (GetSkillValue("Owner",SHADOW_ARTS) > GetSkillValue("Destination",EMPATHY)) then
        local DerFluch = Rand(10)
	    GetPosition("Destination", "ParticleSpawnPos")
        PlayAnimationNoWait("Destination", "watch_for_guard")
	    StartSingleShotParticle("particles/light_smoke.nif", "ParticleSpawnPos",2.7,5)
        Sleep(1)
        PlaySound3D("","Locations/destillery/destillery+1.wav", 1.0)
	    MsgSay("Destination", "_HPFZ_ARTEFAKT_VODOO_SPRUCH_+1")
        Sleep(1)
	chr_GainXP("",GetData("BaseXP"))
        if DerFluch < 4 then
	        AddImpact("Destination","totallydrunk",1,6)
	        AddImpact("Destination","MoveSpeed",0.7,6)
	        SetState("Destination",STATE_TOTALLYDRUNK,true)
		    StopMeasure()
        elseif DerFluch < 7 then
           	local SickChoice = Rand(8)+1
			if SickChoice==1 then
				diseases_Sprain("Destination",true,true)
			elseif SickChoice==2 then
				diseases_Cold("Destination",true,true)
			elseif SickChoice==3 then
				diseases_Influenza("Destination",true,true)
			elseif SickChoice==5 then
				diseases_Pox("Destination",true,true)
			elseif SickChoice==7 then
				diseases_Fracture("Destination",true,true)
			elseif SickChoice==8 then
				diseases_Caries("Destination",true,true)
			end
            SetState("Destination",STATE_SICK,true)
		else
			local FightPartners = Find("Destination", "__F((Object.GetObjectsByRadius(Sim)==3000)AND NOT(Object.HasDynasty())AND NOT(Object.GetState(unconscious))AND NOT(Object.GetState(dead))AND(Object.CompareHP()>30))","FightPartner", -1)
			if FightPartners>0 then
	            if not BattleIsFighting(FightPartner) then
	                MsgDebugMeasure("Force a Fight")
	                SimStopMeasure(FightPartner)
	                StopAnimation(FightPartner) 
	                MoveStop(FightPartner)
	                AlignTo("Destination",FightPartner)
	                AlignTo(FightPartner,"Destination")
	                Sleep(1)
	                PlayAnimationNoWait("Destination","threat")
	                PlayAnimation(FightPartner,"insult_character")
	                SetProperty(FightPartner,"Berserker",1)
	                SetProperty("Destination","Berserker",1)
	                BattleJoin("Destination",FightPartner,false,false)
				end
			else
			    BattleJoin("Destination","",false,false)
			end
        end
		
		MsgNewsNoWait("","Destination","","intrigue",-1,
				"@L_HPFZ_ARTEFAKT_VODOO_NUTZER_KOPF_+0",
				"@L_HPFZ_ARTEFAKT_VODOO_NUTZER_RUMPF_+0",GetID("Destination"))
		MsgNewsNoWait("Destination","","","intrigue",-1,
				"@L_HPFZ_ARTEFAKT_VODOO_OPFER_KOPF_+0",
				"@L_HPFZ_ARTEFAKT_VODOO_OPFER_RUMPF_+0",GetID(""))
				
    end
	StopAction("PerformingWitchcraft","")
  StopMeasure()

end

function CleanUp()
	CarryObject("","",false)
	CarryObject("Destination","",false)
end

function GetOSHData(MeasureID)
	OSHSetMeasureRepeat("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+2",Gametime2Total(mdata_GetTimeOut(MeasureID)))
end
