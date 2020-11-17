-------------------------------------------------------------------------------
----
----	OVERVIEW "ms_ConfiscateGoods"
----
----	With this measure the player can confiscate goods at an enemy workshop
----  
----  1. Die Waren des selektierten Gebäudes werden konfisziert
----  2. Das Gebäude verliert alles was sich im Lager/Verkaufslager befindet
----  3. Der Heerführer erhält den Basispreis aller Waren als Geldwert
-------------------------------------------------------------------------------

-- -----------------------
-- Run
-- -----------------------
function Run()
	
	if  not AliasExists("Destination") then
		StopMeasure()
	end
	
	if not GetOutdoorMovePosition("","Destination","MovePos") then
		StopMeasure()
	end
	
	if not f_MoveTo("","MovePos") then
		StopMeasure()
	end
	
	local MeasureID = GetCurrentMeasureID("")
	local duration = mdata_GetDuration(MeasureID)
	local TimeOut = mdata_GetTimeOut(MeasureID)
	
	SetMeasureRepeat(TimeOut)
	MeasureSetNotRestartable()
	
	AlignTo("","Destination")
	Sleep(1)
	PlayAnimation("","propel")
	
	local GoodMoney = chr_GetBootyCount("Destination", INVENTORY_STD) + chr_GetBootyCount("Destination", INVENTORY_SELL)
	
	if HasProperty("","BugFix") and not DynastyIsPlayer("") then
		DynastyGetFamilyMember("",0,"SugarDaddy")
		CreditMoney("SugarDaddy",GoodMoney,"Unknown")
	else
		CreditMoney("",GoodMoney,"Unknown")
	end
	
	local Count = InventoryGetSlotCount("Destination", INVENTORY_STD)
	local Removed = 0
	for i=0, Count-1 do
		ItemId, Found = InventoryGetSlotInfo("Destination", i, INVENTORY_STD)
		if ItemId and ItemId>0 and Found>0 then
			Removed = RemoveItems("Destination", ItemId, 999)
		end
	end
	
	Count = InventoryGetSlotCount("Destination", INVENTORY_SELL)
	for i=0, Count-1 do
		ItemId, Found = InventoryGetSlotInfo("Destination", i, INVENTORY_SELL)
		if ItemId and ItemId>0 and Found>0 then
			Removed = RemoveItems("Destination", ItemId, 999)
		end
	end
	MsgNewsNoWait("","Destination","","politics",-1,
				"@L_PRIVILEGES_CONFISCATEGOODS_MSG_ACTOR_HEAD_+0",
				"@L_PRIVILEGES_CONFISCATEGOODS_MSG_ACTOR_BODY_+0", GetID("Destination"),GoodMoney)
	MsgNewsNoWait("Destination","","","politics",-1,
				"@L_PRIVILEGES_CONFISCATEGOODS_MSG_VICTIM_HEAD_+0",
				"@L_PRIVILEGES_CONFISCATEGOODS_MSG_VICTIM_BODY_+0", GetID(""), GetID("Destination"))
	
	StopMeasure()
end

function CleanUp()

end

function GetOSHData(MeasureID)
	--can be used again in:
	OSHSetMeasureRepeat("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+2",Gametime2Total(mdata_GetTimeOut(MeasureID)))
end

