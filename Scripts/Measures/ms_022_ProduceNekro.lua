function GetLocator()

	local LocatorArray = {
	  "Work1", ms_022_producenekro_UseSargA,"",
		"Work2", ms_022_producenekro_UseLager,"",
		"Work3", ms_022_producenekro_UseAltar,"",
		"Work4", ms_022_producenekro_UseKessel,"",
		"Work5", ms_022_producenekro_UseSargB,"",
		"Work6", ms_022_producenekro_UseWerktisch,"",
		"Work7", ms_022_producenekro_UseWerkhilfe,"werkhilfe",
	}
	local	LocatorCount = 7
	IncrementXPQuiet("",5)
	local Position = (Rand(LocatorCount))*3+1
	return	LocatorArray[Position], LocatorArray[Position+1], LocatorArray[Position+2]
end

function UseSargA()

	GetLocatorByName("WorkBuilding","Work1","WorkPosi")
	f_BeginUseLocator("","WorkPosi",GL_STANCE_STAND,true)
		
	CarryObject("","Handheld_Device/ANIM_spatula.nif", false)
	Sleep(0.5)
	PlayAnimation("","manipulate_middle_twohand")
	Sleep(2)
	PlayAnimation("","manipulate_middle_up_l")

	CarryObject("","",false)
	
end

function UseLager()

	GetLocatorByName("WorkBuilding","Work2","WorkPosi")
	f_BeginUseLocator("","WorkPosi",GL_STANCE_STAND,true)

	PlayAnimation("", "cogitate")
	local animat = Rand(3)
	if animat == 0 then
	    if BuildingHasUpgrade("WorkBuilding",943) == true then
	        PlayAnimation("","manipulate_bottom_r")
		else
		    PlayAnimation("","manipulate_top_r")
		end
	elseif animat == 1 then
	    PlayAnimation("","manipulate_middle_up_l")
	else
	    PlayAnimation("","manipulate_top_r")
	end	
	
end

function UseAltar()

	GetLocatorByName("WorkBuilding","Work3","WorkPosi")
	f_BeginUseLocator("","WorkPosi",GL_STANCE_STAND,true)
	
	CarryObject("","Handheld_Device/ANIM_fishknife.nif", false)
	PlayAnimation("", "manipulate_middle_twohand")
	CarryObject("","",false)
	PlayAnimation("", "cogitate")
	if Rand(2) == 0 then
	    CarryObject("","Handheld_Device/ANIM_metahammer.nif", false)
	    Sleep(0.5)
	    PlayAnimation("","hammer_in")
	    for i=0,5 do
		    local waite = PlayAnimationNoWait("","hammer_loop")
		    Sleep(1)
		    PlaySound3DVariation("","Locations/hammer_stone",1.0)
		    Sleep(waite-1)
	    end
	    PlayAnimation("","hammer_out")
	    CarryObject("","",false)
	else
	    local Time = PlayAnimationNoWait("", "saw")
	    CarryObject("","Handheld_Device/Anim_handsaw.nif",false)
	    Sleep(3)
	    for i=0,5 do
		    PlaySound3DVariation("","Locations/handsaw",1.0)
		    Sleep(1)
	    end
	    Sleep(Time-12)
	    CarryObject("","",false)
	end
	
end

function UseKessel()

	GetLocatorByName("WorkBuilding","Work4","WorkPosi")
	f_BeginUseLocator("","WorkPosi",GL_STANCE_STAND,true)

	PlayAnimation("", "cogitate")
	if Rand(2) == 0 then
	    PlayAnimation("", "manipulate_middle_twohand")
	else
	    PlayAnimation("","manipulate_middle_low_r")
	end
	CarryObject("","Handheld_Device/ANIM_scoop.nif",false)
	PlayAnimation("", "stir_in")
	LoopAnimation("", "stir_loop", 10)
	PlayAnimation("", "stir_out")
	CarryObject("","",false)	
	
end

function UseSargB()

	GetLocatorByName("WorkBuilding","Work5","WorkPosi")
	f_BeginUseLocator("","WorkPosi",GL_STANCE_STAND,true)

    if Rand(2) == 0 then
	    PlayAnimation("","manipulate_middle_low_l")
	else
	    PlayAnimation("","manipulate_middle_low_r")
	end
	
end

function UseWerktisch()

	GetLocatorByName("WorkBuilding","Work6","WorkPosi")
	f_BeginUseLocator("","WorkPosi",GL_STANCE_STAND,true)

	CarryObject("","Handheld_Device/ANIM_fishknife.nif", false)
	PlayAnimation("", "manipulate_middle_twohand")
	CarryObject("","",false)
	
end

function UseWerkhilfe()

	GetLocatorByName("WorkBuilding","Work7","WorkPosi")
	f_BeginUseLocator("","WorkPosi",GL_STANCE_STAND,true)

   PlayAnimation("","manipulate_bottom_r")

end

function KnochenGraben()

  while true do
	local ItemID = SimGetProduceItemID("")
	local platzSim = 0
    local platzGeb = 0
	if ItemID == 973 then
	    platzSim = GetRemainingInventorySpace("",973,INVENTORY_STD)
        platzGeb = GetRemainingInventorySpace("WorkBuilding",973,INVENTORY_STD)
	elseif ItemID == 972 then
	    platzSim = GetRemainingInventorySpace("",972,INVENTORY_STD)
        platzGeb = GetRemainingInventorySpace("WorkBuilding",972,INVENTORY_STD)
	elseif ItemID == 971 then
	    platzSim = GetRemainingInventorySpace("",971,INVENTORY_STD)
        platzGeb = GetRemainingInventorySpace("WorkBuilding",971,INVENTORY_STD)
	end
	
	if platzSim < 5 and platzGeb < 5 then
		MsgQuick("","_HPFZ_PRODUCENEKRO_FEHLER_+0")
		return false
	elseif platzSim < 5 then
		TransferItems("","WorkBuilding")
	end 
	
	CarryObject("","Handheld_Device/ANIM_torchparticles.nif", false)
	GetFreeLocatorByName("WorkBuilding","bomb",1,3,"GehPunkt")
	--GetPosition("WorkBuilding","GehPunkt")
	local range = 300
	local x,y,z = PositionGetVector("GehPunkt")
	x = x + ((Rand(range))-range)
	z = z + ((Rand(range))-range)
	PositionModify("GehPunkt",x,y,z)
	SetPosition("GehPunkt",x,y,z)
	--if not f_MoveToSilent("","GehPunkt",GL_MOVESPEED_WALK) then
	if not f_MoveTo("","GehPunkt",GL_MOVESPEED_WALK) then
	    --MsgQuick("","_HPFZ_PRODUCEMILL_FEHLER_+1")
		SimBeamMeUp("","GehPunkt",false)
		--return false
	end
	PlayAnimationNoWait("","watch_for_guard")
	local spruch = Rand(4)
	if spruch == 1 then
        MsgSay("","_HPFZ_PRODUCENEKRO_SPRUCH_+0")
	elseif spruch == 2 then
		MsgSay("","_HPFZ_PRODUCENEKRO_SPRUCH_+1")
	elseif spruch == 3 then
		MsgSay("","_HPFZ_PRODUCENEKRO_SPRUCH_+2")
	else
		MsgSay("","_HPFZ_PRODUCENEKRO_SPRUCH_+3")
	end
	PlayAnimation("","knee_work_in")
	LoopAnimation("","knee_work_loop",Rand(6)+21)
	CarryObject("","",false)
    PlayAnimation("","knee_work_out")
	MoveSetActivity("","carry")
	Sleep(2)
	CarryObject("","Handheld_Device/ANIM_Bag.nif", false)
	if ItemID == 973 then
	    AddItems("",973,5,INVENTORY_STD)
	elseif ItemID == 972 then
	    AddItems("",972,5,INVENTORY_STD)
	elseif ItemID == 971 then
	    AddItems("",971,5,INVENTORY_STD)
	end
	GetLocatorByName("WorkBuilding","Work2","LagerPos")
	--if not f_MoveToSilent("","WorkBuilding",GL_MOVESPEED_WALK) then
	if not f_MoveTo("","LagerPos",GL_MOVESPEED_WALK) then
	    --MsgQuick("","_HPFZ_PRODUCEMILL_FEHLER_+1")
		SimBeamMeUp("","LagerPos",false)
		--return false
	end
    TransferItems("","WorkBuilding")
	MoveSetActivity("","")
	Sleep(2)
    CarryObject("","",false)
	end
end

function CleanUp()
	if AliasExists("WorkBuilding") and DynastyIsAI("WorkBuilding") then
		ms_022_gather_ReturnItems("", "WorkBuilding")
	end
end
