function Run()
	if not HasProperty("","Equiped") then
		AddItems("","Platemail",1,INVENTORY_EQUIPMENT)
		AddItems("","FullHelmet",1,INVENTORY_EQUIPMENT)
		AddItems("","IronBrachelet",1,INVENTORY_EQUIPMENT)
		AddItems("","Longsword",1,INVENTORY_EQUIPMENT)
		SetSkillValue("",CONSTITUTION,5)
		SetSkillValue("",DEXTERITY,6)
		SetSkillValue("",FIGHTING,5)
		SetProperty("","Equiped",1)	
	end
--  AND0R: Forged Epic Items v2.0 -----------------------------------------------------------------------------------------------------
	CarryObject("", "Handheld_Device/ANIM_Shield.nif", true)
--  Forged Epic Items v2.0 ------------------------------------------------------------------------------------------------------------

	SetState("",STATE_TOWNNPC,true)
	GetHomeBuilding("","home")
	BuildingGetCity("home","homecity")
	CityGetRandomBuilding("homecity",-1,23,-1,-1, FILTER_IGNORE,"mytownhall")
		 
	while true do
		-- try to walk to the townhall
		if GetInsideBuilding("","currentbuilding") then
			if GetID("mytownhall")~=-1 then
				if GetLocatorByName("mytownhall","Guard1OffPos","destpos") then
					f_MoveTo("","destpos")
					f_BeginUseLocator("","destpos", GL_STANCE_STAND, true)
					LoopAnimation("","idle")
					--SetExclusiveMeasure("", "StartDialog",EN_PASSIVE)	
				end
			end
		end

		while true do
			Sleep(1000)
		end
	end
	
	Sleep(5)
end

function CleanUp()
end
