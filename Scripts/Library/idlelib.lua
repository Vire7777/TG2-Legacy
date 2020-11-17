-- -----------------------
-- Init
-- -----------------------
function Init()
	--needed for caching
end

-- -----------------------
-- GetActivity
-- The main acivity facor
-- 0 = no activity, 100 = full activity of the sims
-- -----------------------
function GetActivity(Alias) --McCoy Fix
	if not GetSettlement(Alias,"MyCity") then
		return 0
	end
	
	local CityLevel = CityGetLevel("MyCity")
	local res = 0
	
	if CityLevel<=2 then
		res = 100
	elseif CityLevel==3 then
		res = 90
	elseif CityLevel==4 then
		res = 80
	elseif CityLevel==5 then
		res = 70
	else
		res = 60
	end
	if (HasProperty(Alias,"SchuldenGeb")) and (res<80) then
		res = 80
	end
	
	return res
end

-- -----------------------
-- CheckWeather
-- -----------------------
function CheckWeather() --No Fix Required
	local RainValue = Weather_GetValue(0)
	local CloudValue = Weather_GetValue(1)
	local WindValue = Weather_GetValue(3)
	
	local Weather = (RainValue*7) + CloudValue + (WindValue*2) --0(good) - 10(bad)
	local Activity = 0
	if Weather <=1  then		--sun is shining, everything is allright
	Activity = 100
elseif Weather <=3 then	--cloudy sky
Activity = 70
	elseif Weather <=7 then	--rain or snow
	Activity = 35
	else				--stormy weather, bah
	Activity = 10
	end
	
	if Rand(100) < Activity then
		return true
	else
		return false
	end
end

-- -----------------------
-- Sleep
-- -----------------------
function Sleep(Alias, SleepStart, SleepEnd) --McCoy Fix
	MsgDebugMeasure("Sleeping...")
	if not GetHomeBuilding(Alias, "HomeBuilding") then
		Sleep(Gametime2Realtime(1))
		return false
	end
	
	if not GetInsideBuilding(Alias, "Inside") or GetID("Inside")~=GetID("HomeBuilding") then
		if not f_MoveTo(Alias, "HomeBuilding", GL_MOVESPEED_RUN) then
			Sleep(3)
			return
		end
	end
	
	if GetLocatorByName("HomeBuilding", "Bed1", "SleepPosition") then
		if not f_BeginUseLocator(Alias, "SleepPosition", GL_STANCE_LAY, true) then
			RemoveAlias("SleepPosition")
			if IsDynastySim(Alias) then
				if GetHPRelative(Alias)<1 then
					GetSettlement(Alias,"MyCity")
					if CityGetRandomBuilding("MyCity", GL_BUILDING_CLASS_PUBLIC, 32, -1, -1, FILTER_IGNORE, "Destination") then
						f_MoveTo(Alias,"Destination")
						MeasureRun(Alias,"Destination","Linger",true)
						return
					end
				else
					return
				end
			end
		end
	end
	
	local SleepTime = Gametime2Realtime(EN_RECOVERFACTOR_HOME/60)
	local	ContinueSleeping = true
	SetState(Alias,STATE_SLEEPING,true)
	while ContinueSleeping do
		
		ContinueSleeping = false
		
		Sleep(SleepTime)
		
		if GetHPRelative(Alias) < 1 then
			ModifyHP(Alias, 1)
			ContinueSleeping = true
		end
		
		local time = math.mod(GetGametime(),24)
		if time>SleepStart or time<SleepEnd then
			ContinueSleeping = true
		end
		Sleep(1)
	end
	SetState(Alias,STATE_SLEEPING,false)
	if AliasExists("SleepPosition") then
		f_EndUseLocatorNoWait(Alias, "SleepPosition", GL_STANCE_STAND)
		RemoveAlias("SleepPosition")
	end
end

-- -----------------------
-- ThiefIdle
-- -----------------------
function ThiefIdle(Alias) -- McCoy Fix
	SimGetWorkingPlace(Alias, "WorkingPlace")
	local WhatToDo = Rand(5)
	if WhatToDo == 0 then
		if GetFreeLocatorByName("WorkingPlace", "Chair",1,4, "ChairPos") then
			if not f_BeginUseLocator(Alias, "ChairPos", GL_STANCE_SIT, true) then
				RemoveAlias("ChairPos")
				return
			end
			while true do
				local WhatToDo2 = Rand(4)
				if WhatToDo2 == 0 then
					Sleep(10) 
				elseif WhatToDo2 == 1 then
					return
				elseif WhatToDo2 == 2 then
					PlayAnimation(Alias,"sit_talk")
				else
					PlayAnimation(Alias,"sit_laugh")					
				end
				Sleep(1)
			end
		end
	elseif WhatToDo == 1 then
		if GetLocatorByName("WorkingPlace", "Chair_Cellwatch", "ChairPos") then
			if not f_BeginUseLocator(Alias, "ChairPos", GL_STANCE_SIT, true) then
				RemoveAlias("ChairPos")
				return
			end
			PlayAnimation(Alias,"sit_laugh")
			Sleep(Rand(12)+1)
		end
	elseif WhatToDo == 2 then
		if GetLocatorByName("WorkingPlace", "Fistfight", "ChairPos") then
			if not f_BeginUseLocator(Alias, "ChairPos", GL_STANCE_STAND, true) then
				RemoveAlias("ChairPos")
				return
			end
			PlayAnimation(Alias,"point_at")
			PlayAnimation(Alias,"fistfight_in")
			PlayAnimation(Alias,"fistfight_punch_01")
			PlayAnimation(Alias,"fistfight_punch_05")
			PlayAnimation(Alias,"fistfight_punch_02")
			PlayAnimation(Alias,"fistfight_punch_06")
			PlayAnimation(Alias,"fistfight_punch_03")
			PlayAnimation(Alias,"fistfight_punch_07")
			PlayAnimation(Alias,"fistfight_punch_04")
			PlayAnimation(Alias,"fistfight_punch_08")
			PlayAnimation(Alias,"fistfight_out")
		end
	elseif WhatToDo == 3 then
		if GetLocatorByName("WorkingPlace", "Pickpocket", "ChairPos") then
			if not f_BeginUseLocator(Alias, "ChairPos", GL_STANCE_STAND, true) then
				RemoveAlias("ChairPos")
				return
			end
			PlayAnimation(Alias,"pickpocket")
		end
	else
		if GetLocatorByName("WorkingPlace", "Cell_Outside", "ChairPos") then
			if not f_BeginUseLocator(Alias, "ChairPos", GL_STANCE_STAND, true) then
				RemoveAlias("ChairPos")
				return
			end
			PlayAnimation(Alias,"sentinel_idle")
		end
	end
end

-- -----------------------
-- RobberIdle
-- -----------------------
function RobberIdle(Alias) ---McCoy Fix
	SimGetWorkingPlace(Alias, "WorkingPlace")
	GetLocatorByName("WorkingPlace", "Entry1", "WaitingPos")
	
	if GetDistance(Alias, "WaitingPos") > 115 then
		local dist = Rand(100)+10	
		if not f_MoveTo(Alias,"WaitingPos",GL_MOVESPEED_RUN, dist) then
			return
		end
	end
	
	Sleep(5)
end

-- -----------------------
-- GoHome
-- -----------------------
function GoHome(Alias)--McCoy fix
	MsgDebugMeasure("Going Home")
	if not GetHomeBuilding(Alias, "HomeBuilding") then
		Sleep(Gametime2Realtime(1))
		return
	end
	
	if SimIsCourting(Alias) and not GetState(Alias,STATE_BLACKDEATH) then
		return
	end
	
	if not GetInsideBuilding(Alias, "Inside") or GetID("Inside")~=GetID("HomeBuilding") then
		if GetImpactValue(Alias,"Sickness")>0 then
			if not f_MoveTo(Alias, "HomeBuilding", GL_MOVESPEED_WALK) then
				return
			end
		else
			if not f_MoveTo(Alias, "HomeBuilding", GL_MOVESPEED_RUN) then
				return
			end
		end
	end
	Sleep(Rand(15)+30)
	
	if Rand(300)==37 then
		if BuildingGetLevel("HomeBuilding") < 3 then
			SetState("HomeBuilding",STATE_BURNING,true)
		elseif Rand(100)<10 then
			SetState("HomeBuilding",STATE_BURNING,true)
		end
	end
	
	while GetState(Alias,STATE_BLACKDEATH) do
		Sleep(5)
	end
end

-- -----------------------
-- DoNothing
-- -----------------------
function DoNothing(Alias) --McCoy Fix
	MsgDebugMeasure("I'm really bored")
	local ThingsToDo = Rand(4)
	if ThingsToDo == 0 then
		PlayAnimation(Alias,"cogitate")
	elseif ThingsToDo == 1 then
		CarryObject(Alias, "Handheld_Device/ANIM_Pretzel.nif", false)
		PlayAnimationNoWait(Alias,"eat_standing")
		Sleep(6)
		CarryObject(Alias,Alias,false)
		Sleep(Rand(5)+3)
	elseif ThingsToDo == 2 then
		CarryObject(Alias, "Handheld_Device/ANIM_beaker.nif", false)
		PlayAnimationNoWait(Alias,"use_potion_standing")
		Sleep(6)
		CarryObject(Alias,Alias,false)
		Sleep(Rand(5)+3)
	else
		if GetInsideBuilding(Alias,"drinne") == false then
			CarryObject(Alias,"Handheld_Device/ANIM_besen.nif", false)
			PlayAnimation(Alias,"hoe_in")	
			for i=0,5 do
				local waite = PlayAnimationNoWait(Alias,"hoe_loop")
				Sleep(0.5)
				PlaySound3DVariation(Alias,"Locations/herbs",1.0)
				Sleep(waite-0.5)
			end
			PlayAnimation(Alias,"hoe_out")
			CarryObject(Alias,Alias,false)
		end		
	end
	Sleep(Rand(10)+5)
end

-- -----------------------
-- GoToRandomPosition
-- -----------------------
function GoToRandomPosition(Alias) --McCoy Fix
	MsgDebugMeasure("Walking around...")
	if GetID(Alias) == nil then
		return
	end
	local offset 	= math.mod(GetID(Alias), 30) * 0.1
	local class
	if GetSettlement(Alias, "City") then
		local	RandVal = Rand(7)
		if RandVal<2 then
			class = GL_BUILDING_CLASS_MARKET
		elseif RandVal<4 then
			class = GL_BUILDING_CLASS_PUBLIC
		else
			class = GL_BUILDING_CLASS_WORKSHOP
		end
		
		if CityGetRandomBuilding("City", class, -1, -1, -1, FILTER_IGNORE, "Destination") then
			if GetOutdoorMovePosition(Alias, "Destination", "MoveToPosition") then
				if not f_MoveTo(Alias,"MoveToPosition", GL_MOVESPEED_WALK, 400+offset*15) then
					return
				end
			end
		end
	end
end

-- -----------------------
-- ForceAFight
-- -----------------------
function ForceAFight(Alias,Enemy) --McCoy Fix
	if BattleIsFighting(Enemy) then
		return
	end
	if not SimGetAge(Alias) >= 16 then
		return
	end
	if not SimGetAge(Enemy) >= 16 then
		return
	end
	MsgDebugMeasure("Force a Fight")
	SimStopMeasure(Enemy)
	StopAnimation(Enemy) 
	MoveStop(Enemy)
	AlignTo(Alias,Enemy)
	AlignTo(Enemy,Alias)
	Sleep(1)
	PlayAnimationNoWait(Alias,"threat")
	PlayAnimation(Enemy,"insult_character")
	SetProperty(Enemy,"Berserker",1)
	SetProperty(Alias,"Berserker",1)
	BattleJoin(Alias,Enemy,false,false)
end

-- -----------------------
-- SitDown
-- -----------------------
function SitDown(Alias) --McCoy Fix
	MsgDebugMeasure("Sit down and enjoy the season")
	local season = GetSeason()
	local Distance = Rand(10000)+1000
	if season == EN_SEASON_SPRING or season == EN_SEASON_SUMMER or season == EN_SEASON_AUTUMN then
		if GetSettlement(Alias, "City") then
			if CityGetRandomBuilding("City", GL_BUILDING_CLASS_PUBLIC, 32, -1, -1, FILTER_IGNORE, "Destination") then
				local Stance = 2
				--0=sitground, 1=sitbench, 2=stand
				if GetFreeLocatorByName("Destination","idle_Sit",1,5,"SitPos") then
					f_BeginUseLocator(Alias,"SitPos",GL_STANCE_SITBENCH,true)
					Stance = 1
					if GetLocatorByName("Destination","campfire","CampFirePos") then
						if GetImpactValue("Destination","torch")==0 then
							AddImpact("Destination","torch",1,1)
							GfxStartParticle("Campfire","particles/Campfire2.nif","CampFirePos",3)
							--GfxStartParticle("Camplight","Lights/candle_M_01.nif","CampFirePos",6)		
						end
					end
				elseif GetFreeLocatorByName("Destination","idle_SitGround",1,5,"SitPos") then
					Stance = 0
					f_BeginUseLocator(Alias,"SitPos",GL_STANCE_SITGROUND,true)
				elseif GetFreeLocatorByName("Destination","idle_Stand",1,5,"SitPos") then
					Stance = 2
					f_BeginUseLocator(Alias,"SitPos",GL_STANCE_STAND,true)
				end
				local EndTime = GetGametime()+1
				while GetGametime() < EndTime do				
					if Stance == 1 then
						Sleep(2)
						local AnimTime = 0
						local idx = Rand(3)
						if idx == 0 then
							PlaySound3DVariation(Alias,"CharacterFX/male_anger",1)
							PlayAnimation(Alias,"bench_sit_offended")
						elseif idx == 1 then
							PlaySound3DVariation(Alias,"CharacterFX/male_amazed",1)
							PlayAnimation(Alias,"bench_sit_talk_short")
						else
							PlaySound3DVariation(Alias,"CharacterFX/male_neutral",1)
							PlayAnimation(Alias,"bench_talk")						
						end
					end
					Sleep(Rand(10)+10)
				end
				if GetImpactValue("Destination","torch")==0 then
					GfxStopParticle("Campfire")
					--GfxStopParticle("Camplight")
				end
				
				f_EndUseLocator(Alias,"SitPos",GL_STANCE_STAND)
				
				Sleep(6)
			end
		end
	else
		if Rand(100)>50 then
			local FightPartners = Find(Alias, "__F((Object.GetObjectsByRadius(Sim)==2500)AND NOT(Object.HasDynasty()))","FightPartner", -1)
			if FightPartners>0 then
				idlelib_SnowballBattle(Alias,"FightPartner")
				return
			end
		end
	end
end

-- -----------------------
-- Graveyard
-- -----------------------
function Graveyard(Alias) --McCoy fix
	MsgDebugMeasure("Cry around at the Graveyard")
	if GetSettlement(Alias, "City") then
		if not CityGetRandomBuilding("City", -1, 98, -1, -1, FILTER_IGNORE, "Destination") then
			return
		end
		if GetState("Destination",2) == true then
			return
		end
		if GetState("Destination",5) == true then
			return
		end
		if not f_MoveTo(Alias,"Destination", GL_MOVESPEED_RUN, Rand(40)+120) then
			return
		end
		MoveSetStance(Alias,GL_STANCE_KNEEL)
		Sleep(Rand(10)+5)
		PlayAnimation(Alias,"knee_pray")
		Sleep(Rand(12)+6)
		MoveSetStance(Alias,GL_STANCE_STAND)
		SatisfyNeed(Alias,4,0.2)
		if BuildingGetOwner("Destination","Sitzer") then
			CreditMoney("Destination",Rand(5)+1,"tip")
		end
		Sleep(6)
	end
end

-- -----------------------
-- GetCorn
-- -----------------------
function GetCorn(Alias) --McCoy Fix
	MsgDebugMeasure("Get Corn from the farm")
	if GetSettlement(Alias, "City") then
		if CityGetRandomBuilding("City", -1, 3, -1, -1, FILTER_IGNORE, "Destination") then
			if not f_MoveTo(Alias,"Destination") then
				return
			end
			if not GetHomeBuilding(Alias, "HomeBuilding") then	
				return
			end
			if not GetInsideBuilding(Alias, "Inside") or GetID("Inside")~=GetID("HomeBuilding") then
				Sleep(2)
				
				local Carry = 0
				if GetItemCount("Destination","Wheat",INVENTORY_SELL)>0 then
					--if Transfer(nil,Alias,INVENTORY_STD,"Destination",INVENTORY_SELL,"Wheat",1) then
					Carry = 1
					--end
				end
				if Carry == 1 then
					MoveSetActivity(Alias,"carry")
					Sleep(2)
					CarryObject(Alias,"Handheld_Device/ANIM_Bag.nif",false)	
					if not f_MoveTo(Alias, "HomeBuilding") then
						MoveSetActivity(Alias,Alias)
						CarryObject(Alias,Alias,false)
						return
					end
					MoveSetActivity(Alias,Alias)
					CarryObject(Alias,Alias,false)
				else
					if not f_MoveTo(Alias, "HomeBuilding") then
						return
					end
				end
				
			end
			Sleep(Rand(10)+5)
		end
	end
end

-- -----------------------
-- CollectWater
-- -----------------------
function CollectWater(Alias) --McCoy Fix
	MsgDebugMeasure("Collecting Water from a Well")
	if GetSettlement(Alias, "City") then
		if FindNearestBuilding(Alias, -1,24,-1,false, "Destination") then
			if not f_MoveTo(Alias,"Destination", GL_MOVESPEED_RUN, 170) then
				return
			end
			PlayAnimationNoWait(Alias,"manipulate_middle_low_r")
			Sleep(2)
			if (GetImpactValue("Destination","polluted")>0) then
				if Rand(100)>70 then
					diseases_Pox(Alias,true)
				else
					diseases_Fever(Alias,true)
				end
			end
			
			if not GetHomeBuilding(Alias, "HomeBuilding") then	
				return
			end
			if not GetInsideBuilding(Alias, "Inside") or GetID("Inside")~=GetID("HomeBuilding") then
				PlaySound3DVariation(Alias,"measures/putoutfire",1)
				CarryObject("Owner", "Handheld_Device/ANIM_Bucket.nif", false)
				Sleep(3)
				if not f_MoveTo(Alias, "HomeBuilding", GL_MOVESPEED_WALK) then
					return
				end
				CarryObject(Alias,Alias,false)
			end
			Sleep(Rand(10)+5)
		end
	end
end

-- -----------------------
-- BuySomething
-- -----------------------
function BuySomethingAtTheMarket(Alias) --McCoy Fix
	MsgDebugMeasure("Buying Stuff at the Market")
	if GetSettlement(Alias, "City") then
		local Market = Rand(5)+1
		if CityGetRandomBuilding("City", 5,14,Market,-1, FILTER_IGNORE, "Destination") then
			if not f_MoveTo(Alias,"Destination",GL_WALKSPEED_RUN, 200) then
				return
			end
			PlayAnimation(Alias,"cogitate")
			if SimGetGender(Alias)==GL_GENDER_MALE then
				PlaySound3DVariation(Alias,"CharacterFX/male_neutral",1)
			else
				PlaySound3DVariation(Alias,"CharacterFX/female_neutral",1)
			end
			Sleep(Rand(5)+2)
			
			if not GetHomeBuilding(Alias, "HomeBuilding") then	
				return
			end
			if not GetInsideBuilding(Alias, "Inside") or GetID("Inside")~=GetID("HomeBuilding") then
				MoveSetActivity(Alias,"carry")
				Sleep(2)
				local Amount = 1
				if SimGetGender(Alias)==GL_GENDER_MALE then
					Amount = 2
				end
				local art = Rand(3)
				if art == 1 then
					SatisfyNeed(Alias,1,0.5)
				else
					SatisfyNeed(Alias,7,0.5)
				end
				
				local Choice = Rand(6)
				local Ware
				if Choice == 0 then
					Ware = "Handheld_Device/ANIM_holzscheite.nif"
				elseif Choice == 1 then
					Ware = "Handheld_Device/ANIM_Boxvegetable.nif"
				elseif Choice == 2 then
					Ware = "Handheld_Device/ANIM_Breadbasket.nif"
				elseif Choice == 3 then
					Ware = "Handheld_Device/ANIM_Barrel.nif"
				elseif Choice == 4 then
					Ware = "Handheld_Device/ANIM_Bottlebox.nif"
				else
					Ware = "Handheld_Device/ANIM_Tailorbasket.nif"
				end
				PlaySound3DVariation(Alias,"Effects/digging_box",1)
				CarryObject(Alias,Ware,false)	
				if not f_MoveTo(Alias, "HomeBuilding") then
					MoveSetActivity(Alias,Alias)
					CarryObject(Alias,Alias,false)
					return
				end
				MoveSetActivity(Alias,Alias)
				CarryObject(Alias,Alias,false)
				
			end
			Sleep(Rand(10)+5)
		end
	end
end
-- -----------------------
-- SnowballBattle
-- -----------------------
function SnowballBattle(Alias,Target) --McCoy Fix
	if not AliasExists(Target) then
		return
	end
	MsgDebugMeasure("Throwing Snowballs...")
	AlignTo(Alias,Target)
	Sleep(1.7)
	PlayAnimationNoWait(Alias,"manipulate_bottom_r")
	Sleep(1.5)
	SimStopMeasure(Target)
	MoveStop(Target)
	StopAnimation(Target)
	
	CarryObject(Alias, "Handheld_Device/ANIM_snowball.nif", false)
	Sleep(1)
	PlayAnimationNoWait(Alias, "throw")
	Sleep(1.8)
	CarryObject(Alias, Alias ,false)
	local fDuration = ThrowObject(Alias, Target, "Handheld_Device/ANIM_snowball.nif",0.1,"snowball",0,150,0)
	Sleep(fDuration)
	GetPosition(Target,"ParticleSpawnPos")
	
	StartSingleShotParticle("particles/snowball.nif", "ParticleSpawnPos",1,5)
	AlignTo(Target,Alias)
	Sleep(0.7)
	PlayAnimation(Target,"threat")
end

-- -----------------------
-- GoTownhall
-- -----------------------
function GoTownhall(Alias) --McCoy Fix
	MsgDebugMeasure("Watching, whats going on in the townhall")
	if GetSettlement(Alias, "City") then
		if CityGetRandomBuilding("City", 3,23,-1,-1, FILTER_IGNORE, "Destination") then
			f_MoveTo(Alias,"Destination")
			if not GetFreeLocatorByName("Destination","Wait",1,8,"SitPos") then
				f_Stroll(Alias,300,10)
				return
			end
			-- if not f_MoveTo(Alias,"SitPos") then
			-- f_Stroll(Alias,300,10)
			-- return
			-- end
			if f_BeginUseLocator(Alias,"SitPos",GL_STANCE_SITBENCH,true) then
				local anim = { "bench_talk","bench_talk_short","bench_talk_offended" }
				Sleep(Rand(5)+10)
				PlayAnimation(Alias,anim[Rand(3)+1])
				Sleep(Rand(5)+15)
				f_EndUseLocator(Alias,"SitPos",GL_STANCE_STAND)
				f_Stroll(Alias,300,10)
				if Rand(3) == 1 then
					f_ExitCurrentBuilding(Alias)
					idlelib_GoToRandomPosition(Alias)
				end
				return
			else
				f_Stroll(Alias,300,10)
				return
			end
		end
	end
end

-- -----------------------
-- Illness
-- -----------------------
function Illness(Alias) --McCoy Fix
	MsgDebugMeasure("Buying HerbTea or Blanket")
	if GetSettlement(Alias, "City") then
		if CityGetLocalMarket("City","Market") then
			--buy herbtea
			if GetImpactValue(Alias,"Caries")==1 then
				if CityGetRandomBuilding("City", 5,14,-1,-1, FILTER_IGNORE, "Destination") then
					if not f_MoveTo(Alias,"Destination", GL_MOVESPEED_RUN, 100) then
						return
					end
					Transfer(nil,nil,INVENTORY_STD,"Market",INVENTORY_STD,"HerbTea",1)
				end
				--or blanket
			elseif  GetImpactValue(Alias,"Fever")==1 or GetImpactValue(Alias,"Cold")==1 then
				if CityGetRandomBuilding("City", 5,14,-1,-1, FILTER_IGNORE, "Destination") then
					if not f_MoveTo(Alias,"CampPos", GL_MOVESPEED_RUN, 100) then
						return
					end
					Transfer(nil,nil,INVENTORY_STD,"Market",INVENTORY_STD,"Blanket",1)
				end
				-- soap
			else
				if CityGetRandomBuilding("City", 5,14,-1,-1, FILTER_IGNORE, "Destination") then
					if not f_MoveTo(Alias,"CampPos", GL_MOVESPEED_RUN, 100) then
						return
					end
					Transfer(nil,nil,INVENTORY_STD,"Market",INVENTORY_STD,"Soap",1)
				end
			end
			PlayAnimation(Alias,"talk")
			Sleep(Rand(5)+2)
			if Rand(100) > 60 then
				if GetImpactValue(Alias,"Cold")==1 then
					diseases_Cold(Alias,false)
				elseif GetImpactValue(Alias,"Caries")==1 then
					diseases_Caries(Alias,false)
				elseif GetImpactValue(Alias,"BurnWound")==1 then
					diseases_BurnWound(Alias,false)
				end
			end
		end
		idlelib_GoHome(Alias)
	end
end

-- -----------------------
-- CheckInsideStore
-- -----------------------
function CheckInsideStore(Alias)--McCoy Fix
	
	local store = Rand(5)
	if not GetSettlement(Alias, "City") then
		return
	end
	local Wares = {}
	
	if store == 0 then
		Wares = {"Barleybread","Cookie","Wheatbread","Candy","BreadRoll","CreamPie"}
		local Choice = Wares[(Rand(6)+1)]
		if not CityGetRandomBuilding("City",2,6,-1,-1,FILTER_HAS_DYNASTY,"backerei") then
			return
		end
		--GetLocatorByName("backerei", "BreadsSale", "KaufPos")
		if not f_MoveTo(Alias,"backerei",GL_MOVESPEED_RUN,Rand(50)) then
			return
		end
		local prodNam = ItemGetLabel(Choice,true)
		if GetItemCount("backerei", Choice, INVENTORY_SELL)>0 then
			if Rand(2) == 0 then
				PlayAnimationNoWait(Alias,"manipulate_middle_twohand")
				MsgSay(Alias,"@L_HPFZ_IDLELIB_GETFOOD_SPRUCH_+0",prodNam)
			else
				MsgSayNoWait(Alias,"@L_HPFZ_IDLELIB_GETFOOD_SPRUCH_+1",prodNam)
				CarryObject(Alias, "Handheld_Device/ANIM_Pretzel.nif", false)
				PlayAnimationNoWait(Alias,"eat_standing")
				Sleep(6)
				CarryObject(Alias,Alias,false)
			end
			Transfer(nil,nil,INVENTORY_STD,"backerei",INVENTORY_SELL,Choice,(Rand(5)+1))
		else
			PlayAnimationNoWait(Alias,"propel")
			if Rand(2) == 0 then
				MsgSay(Alias,"@L_HPFZ_IDLELIB_GETFOOD_SPRUCH_+2",prodNam)
			else
				MsgSay(Alias,"@L_HPFZ_IDLELIB_GETFOOD_SPRUCH_+3",prodNam)
			end
			if BuildingGetOwner("backerei","Cheffi") then
				chr_ModifyFavor(Alias,"Cheffi",-5)
			end
		end
		SatisfyNeed(Alias, 1, 0.15)
	elseif store == 1 then
		Wares = {"FarmersClothes","CitizensClothes","NoblesClothes"}
		local Choice = Wares[(Rand(3)+1)]
		if not CityGetRandomBuilding("City",2,9,-1,-1,FILTER_HAS_DYNASTY,"schneiderei") then
			return
		end
		--GetLocatorByName("schneiderei", "Hallstand_01_2", "KaufPos")
		if not f_MoveTo(Alias,"schneiderei",GL_MOVESPEED_RUN,Rand(50)) then
			return
		end
		local prodNam = ItemGetLabel(Choice,true)
		if GetItemCount("schneiderei", Choice, INVENTORY_SELL)>0 then
			PlayAnimationNoWait(Alias,"manipulate_middle_twohand")
			if Rand(2) == 0 then
				MsgSay(Alias,"@L_HPFZ_IDLELIB_GETGOOD_SPRUCH_+0",prodNam)
			else
				MsgSayNoWait(Alias,"@L_HPFZ_IDLELIB_GETGOOD_SPRUCH_+1",prodNam)
			end
			Transfer(nil,nil,INVENTORY_STD,"schneiderei",INVENTORY_SELL,Choice,(Rand(5)+1))
		else
			PlayAnimationNoWait(Alias,"propel")
			if Rand(2) == 0 then
				MsgSay(Alias,"@L_HPFZ_IDLELIB_GETGOOD_SPRUCH_+2",prodNam)
			else
				MsgSay(Alias,"@L_HPFZ_IDLELIB_GETGOOD_SPRUCH_+3",prodNam)
			end
			if BuildingGetOwner("schneiderei","Cheffi") then
				chr_ModifyFavor(Alias,"Cheffi",-5)
			end
		end
		SatisfyNeed(Alias, 7, 0.15)
	elseif store == 2 then
		Wares = {"Torch","BuildMaterial","WalkingStick","CrossOfProtection","RubinStaff"}
		local Choice = Wares[(Rand(5)+1)]
		if not CityGetRandomBuilding("City",2,8,-1,-1,FILTER_HAS_DYNASTY,"tischler") then
			return
		end
		--GetLocatorByName("tischler", "SawDust1", "KaufPos")
		if not f_MoveTo(Alias,"tischler",GL_MOVESPEED_RUN,Rand(50)) then
			return
		end
		local prodNam = ItemGetLabel(Choice,true)
		if GetItemCount("tischler", Choice, INVENTORY_SELL)>0 then
			PlayAnimationNoWait(Alias,"manipulate_middle_twohand")
			if Rand(2) == 0 then
				MsgSay(Alias,"@L_HPFZ_IDLELIB_GETGOOD_SPRUCH_+0",prodNam)
			else
				MsgSayNoWait(Alias,"@L_HPFZ_IDLELIB_GETGOOD_SPRUCH_+1",prodNam)
			end
			Transfer(nil,nil,INVENTORY_STD,"tischler",INVENTORY_SELL,Choice,(Rand(5)+1))
		else
			PlayAnimationNoWait(Alias,"propel")
			if Rand(2) == 0 then
				MsgSay(Alias,"@L_HPFZ_IDLELIB_GETGOOD_SPRUCH_+2",prodNam)
			else
				MsgSay(Alias,"@L_HPFZ_IDLELIB_GETGOOD_SPRUCH_+3",prodNam)
			end
			if BuildingGetOwner("tischler","Cheffi") then
				chr_ModifyFavor(Alias,"Cheffi",-5)
			end
		end		
		SatisfyNeed(Alias, 7, 0.15)
	elseif store == 3 then
		Wares = {"Tool","SilverRing","GoldChain","GemRing"}
		local Choice = Wares[(Rand(4)+1)]
		if not CityGetRandomBuilding("City",2,7,-1,-1,FILTER_HAS_DYNASTY,"schmied") then
			return
		end
		--GetLocatorByName("schmied", "Anvil", "KaufPos")
		if not f_MoveTo(Alias,"schmied",GL_MOVESPEED_RUN,Rand(50)) then
			return
		end
		local prodNam = ItemGetLabel(Choice,true)
		if GetItemCount("schmied", Choice, INVENTORY_SELL)>0 then
			PlayAnimationNoWait(Alias,"manipulate_middle_twohand")
			if Rand(2) == 0 then
				MsgSay(Alias,"@L_HPFZ_IDLELIB_GETGOOD_SPRUCH_+0",prodNam)
			else
				MsgSayNoWait(Alias,"@L_HPFZ_IDLELIB_GETGOOD_SPRUCH_+1",prodNam)
			end
			Transfer(nil,nil,INVENTORY_STD,"schmied",INVENTORY_SELL,Choice,(Rand(5)+1))
		else
			PlayAnimationNoWait(Alias,"propel")
			if Rand(2) == 0 then
				MsgSay(Alias,"@L_HPFZ_IDLELIB_GETGOOD_SPRUCH_+2",prodNam)
			else
				MsgSay(Alias,"@L_HPFZ_IDLELIB_GETGOOD_SPRUCH_+3",prodNam)
			end
			if BuildingGetOwner("schmied","Cheffi") then
				chr_ModifyFavor(Alias,"Cheffi",-5)
			end
		end		
		SatisfyNeed(Alias, 7, 0.15)
	else
		Wares = {"bust","statue"}
		local Choice = Wares[(Rand(2)+1)]
		if not CityGetRandomBuilding("City",2,110,-1,-1,FILTER_HAS_DYNASTY,"smetz") then
			return
		end
		--GetLocatorByName("smetz", "Propel", "KaufPos")
		if not f_MoveTo(Alias,"smetz",GL_MOVESPEED_RUN,Rand(50)) then
			return
		end
		local prodNam = ItemGetLabel(Choice,true)
		if GetItemCount("smetz", Choice, INVENTORY_SELL)>0 then
			PlayAnimationNoWait(Alias,"manipulate_middle_twohand")
			if Rand(2) == 0 then
				MsgSay(Alias,"@L_HPFZ_IDLELIB_GETGOOD_SPRUCH_+0",prodNam)
			else
				MsgSayNoWait(Alias,"@L_HPFZ_IDLELIB_GETGOOD_SPRUCH_+1",prodNam)
			end
			Transfer(nil,nil,INVENTORY_STD,"smetz",INVENTORY_SELL,Choice,(Rand(5)+1))
		else
			PlayAnimationNoWait(Alias,"propel")
			if Rand(2) == 0 then
				MsgSay(Alias,"@L_HPFZ_IDLELIB_GETGOOD_SPRUCH_+2",prodNam)
			else
				MsgSay(Alias,"@L_HPFZ_IDLELIB_GETGOOD_SPRUCH_+3",prodNam)
			end
			if BuildingGetOwner("smetz","Cheffi") then
				chr_ModifyFavor(Alias,"Cheffi",-5)
			end
		end			
		SatisfyNeed(Alias, 7, 0.15)
	end
	
end

-- -----------------------
-- GoToTavern
-- -----------------------
function GoToTavern(Alias) ---McCoy Fix
	local DistanceBest = -1
	local Attractivity
	local Distance
	
	MsgDebugMeasure("Have some drink in a Tavern")
	if GetSettlement(Alias, "City") then
		
		local stage = GetData("#MusicStage")
		if stage~=nil and GetAliasByID(stage,"stageobj") then
			BuildingGetCity("stageobj","stageCity")
			if GetID("City")==GetID("stageCity") and (Rand(100)>39) then
				if BuildingGetType("stageobj")==GL_BUILDING_TYPE_PIRAT then
					idlelib_GoToDivehouse(Alias)
					return
				end
			end
		end
		
		local NumTaverns = CityGetBuildings("City",2,4,-1,-1,FILTER_HAS_DYNASTY,"Tavern")
		if NumTaverns > 0 then
			
			for i=0,NumTaverns-1 do
				Attractivity	= GetImpactValue("Tavern"..i,"Attractivity")
				
				if HasProperty("Tavern"..i,"Versengold") then
					Attractivity = Attractivity + 1
				end
				
				Distance = GetDistance(Alias,"Tavern"..i)
				
				if Distance == -1 then
					Distance = 50000
				end
				
				Distance = Distance / (0.5 + Attractivity)
				if DistanceBest==-1 or Distance<DistanceBest then
					CopyAlias("Tavern"..i,"Destination")
					DistanceBest = Distance
				end
			end
		end
		
		if not f_MoveTo(Alias,"Destination") then
			return
		end
		
		if Rand(4)==0 then
			if HasProperty("Destination","Versengold") then
				MeasureRun(Alias, nil, "CheerMusicians")
			else
				idlelib_KissMeHonza(Alias)
			end
		end
		
		local SimFilter = "__F((Object.GetObjectsByRadius(Sim) == 10000))"
		local NumSims = Find(Alias, SimFilter,"Sim", -1)
		if NumSims > 30 then
			f_ExitCurrentBuilding(Alias)
			idlelib_GoToRandomPosition(Alias)
			return
		end
		
		if IsDynastySim(Alias) then
			if not GetFreeLocatorByName("Destination","SitRich",1,5,"SitPos") then
				f_Stroll(Alias,150,2)
				return
			end
			if not f_BeginUseLocator(Alias,"SitPos",GL_STANCE_SIT,true) then
				return
			end			
		else
			if not GetFreeLocatorByName("Destination","SitInn",1,12,"SitPos") then
				f_Stroll(Alias,150,2)
				return
			end
			if not f_BeginUseLocator(Alias,"SitPos",GL_STANCE_SIT,true) then
				return
			end
		end
		
		local Hour = math.mod(GetGametime(), 24)
		local verweile = 0
		local basicvalue = 1
		
		if Hour > 6 and Hour < 20 then
			verweile = Rand(3)+2
		else
			verweile = Rand(6)+2
		end
		if HasProperty("Destination","DanceShow") then
			verweile = verweile + 3
		end
		if HasProperty("Destination","ServiceActive") then
			verweile = verweile + 2
		end
		if HasProperty("Destination","Versengold") then
			basicvalue = basicvalue + 1
			verweile = verweile + 3
		end
		
		while verweile > 0 do
			
			if HasProperty("Destination","Versengold") and Rand(10)>7 then
				f_EndUseLocator(Alias,"SitPos",GL_STANCE_STAND)
				MeasureRun(Alias, nil, "CheerMusicians")
			end
			
			local AnimTime
			local AnimType = Rand(3)
			PlaySound3DVariation(Alias,"Locations/tavern_people",1)
			if SimGetNeed(Alias, 8) >  SimGetNeed(Alias, 1) then
				AnimTime = PlayAnimationNoWait(Alias,"sit_drink")
				Sleep(1)
				CarryObject(Alias,"Handheld_Device/ANIM_beaker_sit_drink.nif",false)
				Sleep(1)
				PlaySound3DVariation(Alias,"CharacterFX/drinking",1)
				Sleep(AnimTime-1.5)
				CarryObject(Alias,Alias,false)
				if SimGetGender(Alias)==GL_GENDER_MALE then
					PlaySound3DVariation(Alias,"CharacterFX/male_belch",1)
				else
					PlaySound3DVariation(Alias,"CharacterFX/female_belch",1)
				end
				SatisfyNeed(Alias, 8, 0.1)
				Sleep(1.5)
			else
				PlayAnimation(Alias,"sit_eat")
				SatisfyNeed(Alias, 1, 0.1)
			end
			
			if AnimType == 0 then
				PlayAnimation(Alias,"sit_talk")
			elseif AnimType == 1 then
				AnimTime = PlayAnimationNoWait(Alias,"sit_cheer")
				Sleep(1)
				PlaySound3D(Alias,"Locations/tavern/cheers_01.wav",1)
				CarryObject(Alias,"Handheld_Device/ANIM_beaker_sit_drink.nif",false)
				Sleep(1)
				PlaySound3DVariation(Alias,"CharacterFX/drinking",1)
				Sleep(AnimTime-1.5)
				CarryObject(Alias,Alias,false)
				Sleep(1.5)
			else
				PlayAnimationNoWait(Alias,"sit_laugh")
				Sleep(2)
				if Rand(2)==0 then
					PlaySound3D(Alias,"Locations/tavern/laugh_01.wav",1)
				else
					PlaySound3D(Alias,"Locations/tavern/laugh_02.wav",1)
				end
				Sleep(5)	
			end
			
			if SimGetNeed(Alias, 8) > 0.3 or  SimGetNeed(Alias, 1) > 0.3 then
				local NumItems = 1
				if HasProperty("Destination","DanceShow") then
					NumItems = 2
				end
				
				local Items, needo
				if SimGetNeed(Alias, 8) >  SimGetNeed(Alias, 1) then
					Items = { "SmallBeer", "WheatBeer" }
					needo = 8
				else
					Items = { "GrainPap", "RoastBeef" }
					needo = 1
				end
				
				local Choice = Items[Rand(2)+1]	
				if GetItemCount("Destination", Choice, INVENTORY_SELL)>0 then
					Transfer(nil, nil, INVENTORY_STD, "Destination", INVENTORY_SELL, Choice, NumItems)
					SatisfyNeed(Alias, needo, 0.3)
					if HasProperty("Destination","ServiceActive") then
						local TavernLevel = BuildingGetLevel("Destination")
						local TavernAttractivity = GetImpactValue("Destination", "Attractivity")
						local Tip = math.floor(TavernLevel * (10 + (Rand(20)+1) * (TavernAttractivity + basicvalue)))
						CreditMoney("Destination",Tip,"tip")
					end
				end
			end
			
			verweile = verweile - 1
		end
		f_EndUseLocator(Alias,"SitPos",GL_STANCE_STAND)
		
		local Hour = math.mod(GetGametime(), 24)
		if Hour > 21 or Hour < 4 then
			if Rand(100) > 80 then
				--LoopAnimation(Alias,"idle_drunk",10)
				AddImpact(Alias,"totallydrunk",1,6)
				AddImpact(Alias,"MoveSpeed",0.7,6)
				SetState(Alias,STATE_TOTALLYDRUNK,true)
				StopMeasure()
			end
		end
	end
end

-- -----------------------
-- UseCocotte
-- -----------------------
function UseCocotte(Alias) --McCoy Fix
	
	MsgDebugMeasure("Search a cocotte to fullfill your need")
	-- search cocotte in range
	
	local CocottsCnt = Find(Alias,"__F((Object.GetObjectsByRadius(Sim)==20000) AND (Object.GetProfession() == 30) AND (Object.Property.CocotteProvidesLove == 1) AND (Object.Property.CocotteHasClient == 0) AND (Object.HasDifferentSex()))","Cocotte", -1)
	if (CocottsCnt == 0) or (CocottsCnt == nil) then
		Sleep(5+Rand(10))
		return false
	end
	
	-- go to random cocotte
	ChangeAlias("Cocotte"..Rand(CocottsCnt),"Target")
	if AliasExists("Target") then
		MeasureCreate("UseLaborOfLove")
		MeasureStart("UseLaborOfLove",Alias,"Target","UseLaborOfLove",true)
	end
end

-- -----------------------
-- KissMeHonza
-- -----------------------
function KissMeHonza(Alias) --McCoy Fix
	if HasProperty(Alias,"KissMeHoney") then
		local Musician = GetProperty(Alias,"KissMeHoney")
		if GetAliasByID(Musician,"Musician") then
			if not HasProperty("Musician","Moving") and not HasProperty("Musician","KissMe") and (GetDistance(Alias,"Musician")<6001) then
				SetProperty("Musician","KissMe",GetID(Alias))
				
				f_MoveTo(Alias, "Musician", GL_MOVESPEED_RUN, 500)
				if not HasProperty("Musician","Moving") and not HasProperty("Musician","MusicStage") then
						
					while true do
						if not HasProperty("Musician","KissMe") or HasProperty("Musician","Moving") or HasProperty("Musician","MusicStage") then
							RemoveProperty(Alias,"KissMeHoney")
							SatisfyNeed(Alias, 2, 0.2)
							IncrementXP(Alias, 15)
							break
						end
						if Rand(100)<5 then
							local AnimTime = PlayAnimationNoWait(Alias,"giggle")
							Sleep(1)
							MsgSay(Alias,GetName("Musician"))
							Sleep(AnimTime)
						else
							Sleep(3)
						end
					end
						
				else
					RemoveProperty(Alias,"KissMeHoney")
					RemoveProperty("Musician","KissMe")
				end
			else
				RemoveProperty(Alias,"KissMeHoney")
			end
		else
			RemoveProperty(Alias,"KissMeHoney")
		end
	end
end

-- -----------------------
-- RepairHome
-- -----------------------
function RepairHome(Alias,Building) --McCoy Fix
	if not AliasExists(Building) then
		return
	end
	
	MsgDebugMeasure("Buying Buildmaterial at the Market")
	if not GetSettlement(Alias, "City") then
		return
	end
	local Market = Rand(5)+1
	if not CityGetRandomBuilding("City", 5,14,Market,-1, FILTER_IGNORE, "Destination") then
		return
	end
	if not f_MoveTo(Alias,"Destination",GL_WALKSPEED_RUN, 200) then
		return
	end
	GetOutdoorMovePosition(Alias,Building,"WorkPos2")
	if not GetInsideBuilding(Alias, "Inside") or GetID("Inside")~=GetID(Building) then
		
		if Rand(100)<50 then
			Transfer(nil,nil,INVENTORY_STD,"Destination",INVENTORY_STD,"BuildMaterial",1)
		else
			Transfer(nil,nil,INVENTORY_STD,"Destination",INVENTORY_STD,"Tool",1)
		end
		
		MoveSetActivity(Alias,"carry")
		Sleep(2)
		CarryObject(Alias,"Handheld_Device/ANIM_holzscheite.nif",false)
		
		if not f_MoveTo(Alias, "WorkPos2",GL_WALKSPEED_RUN, 200) then
			return
		end
		MoveSetActivity(Alias,Alias)
		Sleep(2)
		CarryObject(Alias,Alias,false)
	end
	MsgDebugMeasure("Repairing My Home")
	if not GetFreeLocatorByName(Building,"bomb",1,3,"WorkPos",true) then
		return
	end
	
	if not f_BeginUseLocator(Alias,"WorkPos",GL_STANCE_STAND,true) then
		if not f_MoveTo(Alias,"WorkPos2") then
			return
		end
	end
	AlignTo(Alias,Building)
	Sleep(0.7)
	SetContext(Alias,"rangerhut")
	CarryObject(Alias,"Handheld_Device/Anim_Hammer.nif", false)
	PlayAnimation(Alias,"chop_in")
	local RepairPerTick = GetMaxHP(Building)/400
	for i=0,20 do
		PlayAnimation(Alias,"chop_loop")
		ModifyHP(Building,RepairPerTick,false)
	end
	f_EndUseLocator(Alias,"WorkPos",GL_STANCE_STAND)
	PlayAnimation(Alias,"chop_out")
	CarryObject(Alias,Alias,false)
	
	
end

-- -----------------------
-- MyrmidonIdle
-- -----------------------
function MyrmidonIdle(Alias) --McCoy Fix
	SimGetWorkingPlace(Alias, "WorkingPlace")
	if GetFreeLocatorByName("WorkingPlace", "backroom_sit_",1,3, "ChairPos") then
		if not f_BeginUseLocator(Alias, "ChairPos", GL_STANCE_SIT, true) then
			RemoveAlias("ChairPos")
			return
		end
		while true do
			local WhatToDo2 = Rand(4)
			if WhatToDo2 == 0 then
				Sleep(10) 
			elseif WhatToDo2 == 1 then
				Sleep(Rand(20)+4)
			elseif WhatToDo2 == 2 then
				PlayAnimation(Alias,"sit_talk")
			else
				PlayAnimation(Alias,"sit_laugh")
			end
			Sleep(1)
		end
	end
	Sleep(3)
end

-- -----------------------
-- VisitDoc
-- -----------------------
function VisitDoc(Alias) --McCoy Fix
	local DistanceBest = -1
	local Attractivity
	local Distance
	
	if gameplayformulas_CheckMoneyForTreatment(Alias)==0 then
		if GetInsideBuilding(Alias,"CurrentBuilding") then
			if BuildingGetType("CurrentBuilding") == GL_BUILDING_TYPE_HOSPITAL then
				f_ExitCurrentBuilding(Alias)
			end
		end
	end
	
	if GetInsideBuilding(Alias,"CurrentBuilding") then
		if BuildingGetType("CurrentBuilding") == GL_BUILDING_TYPE_HOSPITAL then
			if HasProperty(Alias,"WaitingForTreatment") then
				return
			end
		end
	end
	
	if not GetNearestSettlement(Alias, "City") then
		return
	end
	
	local IgnoreID
	
	if HasProperty(Alias, "IgnoreHospital") then
		local Time = GetProperty(Alias, "IgnoreHospitalTime")
		if Time < GetGametime() then
			RemoveProperty(Alias, "IgnoreHospital")
			RemoveProperty(Alias, "IgnoreHospitalTime")
		else
			IgnoreID = GetProperty(Alias, "IgnoreHospital")
		end
	end
	
	local Distance = -1
	local BestDistance = -1
	GetHomeBuilding(Alias,"MyHouse")
	local Filter = "__F((Object.GetObjectsOfWorld(Building))AND(Object.IsType(37)))"
	local NumHospitals = Find("MyHouse", Filter,"Hospital",-1)
	if (NumHospitals == 0) or (NumHospitals == nil) or (NumHospitals == false) then
		MsgQuick(Alias,"@L_MEDICUS_FAILURES_+1")
		StopMeasure()
	end
	for i=0,NumHospitals-1 do
		local HospAlias = "Hospital"..i
		local MinLevel = 1
		if GetImpactValue(Alias,"Sprain")==1 then
			MinLevel = 1
		elseif GetImpactValue(Alias,"Cold")==1 then
			MinLevel = 1
		elseif GetImpactValue(Alias,"Influenza")==1 then
			MinLevel = 2
		elseif GetImpactValue(Alias,"BurnWound")==1 then
			MinLevel = 2
		elseif GetImpactValue(Alias,"Pox")==1 then
			MinLevel = 2
		elseif GetImpactValue(Alias,"Pneumonia")==1 then
			MinLevel = 3
		elseif GetImpactValue(Alias,"Blackdeath")==1 then
			MinLevel = 3
		elseif GetImpactValue(Alias,"Fracture")==1 then
			MinLevel = 3
		elseif GetImpactValue(Alias,"Caries")==1 then
			MinLevel = 3
		end
			
		BuildingGetCity(HospAlias,"HospCity")
		if BuildingGetLevel(HospAlias) >= MinLevel and GetID("City")==GetID("HospCity") then  ---Send to local hospital
			Distance = GetDistance("",HospAlias)
			if GetDistance("",HospAlias) ~= -1 then
				BestDistance = Distance
				if Distance < BestDistance then
					CopyAlias(HospAlias,"Destination")
					LogMessage("Log: Alias = "..GetID("Destination"))
					Distance = GetDistance("","Destination")
					break
				elseif BestDistance < Distance then
					CopyAlias(HospAlias,"Destination")
					LogMessage("Log: Alias = "..GetID("Destination"))
					Distance = GetDistance("","Destination")
					break
				else
					CopyAlias(HospAlias,"Destination")
					LogMessage("Log: Alias = "..GetID("Destination"))
					Distance = GetDistance("","Destination")
					break
				end
			end
		elseif BuildingGetLevel(HospAlias) >= MinLevel then
			Distance = GetDistance("",HospAlias) --local hospital isn't big enough! Send to another city
			if GetDistance("",HospAlias) ~= -1 then
				BestDistance = Distance
				if Distance < BestDistance then
					CopyAlias(HospAlias,"Destination")
					LogMessage("Log: Alias = "..GetID("Destination"))
					Distance = GetDistance("","Destination")
				elseif BestDistance < Distance then
					CopyAlias(HospAlias,"Destination")
					LogMessage("Log: Alias = "..GetID("Destination"))
					Distance = GetDistance("","Destination")
				else
					CopyAlias(HospAlias,"Destination")
					LogMessage("Log: Alias = "..GetID("Destination"))
					Distance = GetDistance("","Destination")
				end
			end
		end
	end
	if Distance==-1 then
		if GetHomeBuilding(Alias, "HomeBuilding") and GetFreeLocatorByName("HomeBuilding", "Bed",1,3, "SleepPosition") then
			MeasureRun(Alias,nil,"GoToSleep")
			return
		end
	end
	
	if not f_MoveTo(Alias,"Destination") then
		return
	end
	
	if GetFreeLocatorByName("Destination", "bench",1,6, "BenchPos") then
		f_BeginUseLocator(Alias,"BenchPos",GL_STANCE_SITBENCH,true)
	end
	
	if ((GetImpactValue(Alias,"Sickness")>0) or (GetHP(Alias) < GetMaxHP(Alias))) then
		RemoveOverheadSymbols(Alias)
		
		SetProperty(Alias,"WaitingForTreatment",1)
		local Waittime = GetGametime() + 3
		while GetGametime()<Waittime do
			if HasProperty(Alias, "StartTreat") then
				Sleep(25)
			else
				Sleep(Rand(10)+1*5)
				if AliasExists("BenchPos") then
					if (LocatorGetBlocker("BenchPos") ~= GetID(Alias)) then
						if GetFreeLocatorByName("Destination", "bench",1,6, "BenchPos") then
							f_BeginUseLocator(Alias,"BenchPos",GL_STANCE_SITBENCH,true)
						end
					end
				else
					if GetFreeLocatorByName("Destination", "bench",1,6, "BenchPos") then
						f_BeginUseLocator(Alias,"BenchPos",GL_STANCE_SITBENCH,true)
					end
				end
			end
		end
		RemoveProperty(Alias,"WaitingForTreatment")
	end
	
	--go home if you were not treated
	if not DynastyIsPlayer(Alias) then
		if GetHomeBuilding(Alias, "HomeBuilding") and GetFreeLocatorByName("HomeBuilding", "Bed",1,3, "SleepPosition") then
			MeasureRun(Alias,nil,"GoToSleep")
			return
		end
		return
	end
end

-- -----------------------
-- ChangeReligion
-- -----------------------
function ChangeReligion(Alias,FinalReligion) --McCoy Fix
	MsgDebugMeasure("Changing my religion")
	if not AliasExists("MyCity") then
		AddImpact(Alias,"WasInChurch",1,4)
		return
	end
	local ChurchType = 19
	if FinalReligion == RELIGION_CATHOLIC then
		ChurchType = 20
	end
	if not CityGetRandomBuilding("MyCity",-1,ChurchType,2,-1,FILTER_IGNORE,"Church") then
		AddImpact(Alias,"WasInChurch",1,4)
		return
	end
	if not f_MoveTo(Alias,"Church") then
		AddImpact(Alias,"WasInChurch",1,4)
		return
	end
	MeasureRun(Alias,"Church","ChangeFaith",true)
	return
	
end

-- -----------------------
-- GoToDivehouse
-- -----------------------
function GoToDivehouse(Alias) --McCoy Fix
	local DistanceBest = -1
	local Attractivity
	local Distance
	
	MsgDebugMeasure("Have some drink in a Divehouse")
	if GetSettlement(Alias, "City") then
		
		local stage = GetData("#MusicStage")
		if stage~=nil and GetAliasByID(stage,"stageobj") then
			BuildingGetCity("stageobj","stageCity")
			if GetID("City")==GetID("stageCity") and (Rand(100)>39) then
				if BuildingGetType("stageobj")==GL_BUILDING_TYPE_TAVERN then
					idlelib_GoToTavern(Alias)
					return
				end
			end
		end
		
		local NumTaverns = CityGetBuildings("City",2,36,-1,-1,FILTER_HAS_DYNASTY,"Divehouse")
		if NumTaverns > 0 then
			
			for i=0,NumTaverns-1 do
				Attractivity	= GetImpactValue("Divehouse"..i,"Attractivity")
				
				if HasProperty("Divehouse"..i,"Versengold") then
					Attractivity = Attractivity + 1.5
				end
				
				Distance = GetDistance(Alias,"Divehouse"..i)
				
				if Distance == -1 then
					Distance = 50000
				end
				
				Distance = Distance / (0.5 + Attractivity)
				if DistanceBest==-1 or Distance<DistanceBest then
					CopyAlias("Divehouse"..i,"Destination")
					DistanceBest = Distance
				end
			end
		end
		
		if DistanceBest==-1 then
			-- not exist Divehouse
			SatisfyNeed(Alias, 8, 0.5)
			SatisfyNeed(Alias, 2, 0.5)
			return
		end
		
		if not f_MoveTo(Alias,"Destination") then
			return
		end
		
		if GetState("Destination",STATE_BUILDING) then
			return
		end
		
		if Rand(5)==0 then
			if HasProperty("Destination","Versengold") then
				MeasureRun(Alias, nil, "CheerMusicians")
			else
				idlelib_KissMeHonza(Alias)
			end
		end
		
		local SimFilter = "__F((Object.GetObjectsByRadius(Sim) == 1000))"--need to go bank
		SatisfyNeed(Alias,9,-0.15)
		
		local NumSims = Find(Alias, SimFilter,"Sim", -1)
		if NumSims > 30 then
			f_ExitCurrentBuilding(Alias)
			idlelib_GoToRandomPosition(Alias)
			return
		end
		
		local lokalPos = 0
		
		if Rand(3) == 0 then
			if GetFreeLocatorByName("Destination","Bar",1,4,"StehPos") then
				f_BeginUseLocator(Alias,"StehPos",GL_STANCE_STAND,true)
				lokalPos = 1
			else
				if GetFreeLocatorByName("Destination","appeal",1,4,"StehPos") then
					f_BeginUseLocator(Alias,"StehPos",GL_STANCE_STAND,true)
					lokalPos = 1
				else
					local posPlatz = Rand(3)
					if posPlatz == 0 then
						GetFreeLocatorByName("Destination","Sit",1,4,"SitPos")
					elseif posPlatz == 1 then
						GetFreeLocatorByName("Destination","Sit",5,7,"SitPos")
					else
						GetFreeLocatorByName("Destination","Sit",8,11,"SitPos")
					end
					if not f_BeginUseLocator(Alias,"SitPos",GL_STANCE_SIT,true) then
						return
					end
				end
			end
		else
			local posPlatz = Rand(3)
			if posPlatz == 0 then
				if not GetFreeLocatorByName("Destination","Sit",1,4,"SitPos") then
					f_Stroll(Alias,150,2) 
					return
				end
			elseif posPlatz == 1 then
				if not GetFreeLocatorByName("Destination","Sit",5,7,"SitPos") then
					f_Stroll(Alias,150,2) 
					return				
				end
			else
				if not GetFreeLocatorByName("Destination","Sit",8,11,"SitPos") then
					f_Stroll(Alias,150,2) 
					return			
				end
			end
			if not f_BeginUseLocator(Alias,"SitPos",GL_STANCE_SIT,true) then
				return
			end
		end			
		
		local Hour = math.mod(GetGametime(), 24)
		local verweile = 0
		local basicvalue = 1
		
		if Hour > 6 and Hour < 20 then
			verweile = Rand(2)+3
		else
			verweile = Rand(4)+4
		end
		if HasProperty("Destination","DanceShow") then
			verweile = verweile + 3
		end
		if HasProperty("Destination","ServiceActive") then
			verweile = verweile + 2
		end
		if HasProperty("Destination","Versengold") then
			basicvalue = basicvalue + 1
			verweile = verweile + 3
		end
		
		local simstand = SimGetRank(Alias)
		local grundBetrag = 0
		
		if HasProperty("Destination","ServiceActive") then
			if simstand == 0 or simstand == 1 then
				grundBetrag = Rand(3)+5
			elseif simstand == 2 then
				grundBetrag = Rand(5)+5
			elseif simstand == 3 then
				grundBetrag = Rand(3)+10
			elseif simstand == 4 then
				grundBetrag = Rand(5)+15
			elseif simstand == 5 then
				grundBetrag = Rand(10)+20
			end				
		else
			if simstand == 0 or simstand == 1 then
				grundBetrag = 5
			elseif simstand == 2 then
				grundBetrag = 5
			elseif simstand == 3 then
				grundBetrag = 10
			elseif simstand == 4 then
				grundBetrag = 15
			elseif simstand == 5 then
				grundBetrag = 20
			end
		end
		if HasProperty("Destination","Versengold") then
			grundBetrag = grundBetrag + 15
		end
		
		while verweile > 0 do
			
			if HasProperty("Destination","Versengold") and Rand(10)>7 then
				if lokalPos == 0 then
					f_EndUseLocator(Alias,"SitPos",GL_STANCE_STAND)--need to go bank
					SatisfyNeed(Alias,9,-0.15)
					
				else
					f_EndUseLocator(Alias,"StandPos",GL_STANCE_STAND)
				end
				MeasureRun(Alias, nil, "CheerMusicians")
			end
			
			local AnimTime
			local AnimType = Rand(4)
			if AnimType == 0 then
				if lokalPos == 0 then
					AnimTime = PlayAnimationNoWait(Alias,"sit_drink")
					Sleep(1)
					CarryObject(Alias,"Handheld_Device/ANIM_beaker_sit_drink.nif",false)
				else
					AnimTime = PlayAnimationNoWait(Alias,"use_potion_standing")
					Sleep(1)
					CarryObject(Alias,"Handheld_Device/ANIM_beaker.nif",false)
				end
				CreditMoney("Destination",grundBetrag,"Offering")
				Sleep(1)
				PlaySound3DVariation(Alias,"CharacterFX/drinking",1)
				Sleep(AnimTime-1.5)
				CarryObject(Alias,Alias,false)
				PlaySound3DVariation(Alias,"CharacterFX/nasty",1)
				Sleep(1.5)
			elseif AnimType == 1 then
				if lokalPos == 0 then
					PlayAnimation(Alias,"sit_talk")
				else
					PlayAnimation(Alias,"talk")
				end
			elseif AnimType == 2 then
				if lokalPos == 0 then
					AnimTime = PlayAnimationNoWait(Alias,"sit_cheer")
					Sleep(1)
					PlaySound3D(Alias,"Locations/tavern/cheers_01.wav",1)
					CarryObject(Alias,"Handheld_Device/ANIM_beaker_sit_drink.nif",false)
				else
					AnimTime = PlayAnimationNoWait(Alias,"cheer_01")
					Sleep(1)
					PlaySound3D(Alias,"Locations/tavern/cheers_01.wav",1)
					CarryObject(Alias,"Handheld_Device/ANIM_beaker.nif",false)
				end
				CreditMoney("Destination",grundBetrag,"Offering")
				Sleep(1)
				PlaySound3DVariation(Alias,"CharacterFX/drinking",1)
				Sleep(AnimTime-1.5)
				CarryObject(Alias,Alias,false)
				Sleep(1.5)
			elseif AnimType == 3 then
				if lokalPos == 0 then
					PlayAnimationNoWait(Alias,"sit_laugh")
				else
					PlayAnimationNoWait(Alias,"laud_02")
				end
				Sleep(2)
				if Rand(2)==0 then
					PlaySound3D(Alias,"Locations/tavern/laugh_01.wav",1)
				else
					PlaySound3D(Alias,"Locations/tavern/laugh_02.wav",1)
				end
				Sleep(2)
			end
			SatisfyNeed(Alias, 8, 0.1)
			
			--			if SimGetNeed(Alias, 8) > 0.2 then
			local NumItems = Rand(2)+1
			if HasProperty("Destination","DanceShow") then
				NumItems = Rand(3)+2
			end
			local	Items = { "SmallBeer", "WheatBeer", "PiratenGrog", "Schadelbrand" }
			local Choice = Items[Rand(4)+1]	
			if GetItemCount("Destination", Choice, INVENTORY_SELL)>0 then
				if Choice == "PiratenGrog" or Choice == "Schadelbrand" then
					RemoveItems("Destination",Choice,NumItems,INVENTORY_SELL)
					if Choice == "PiratenGrog" then
						CreditMoney("Destination",20,"Offering")
					else
						CreditMoney("Destination",50,"Offering")
					end
				else
					Transfer(nil, nil, INVENTORY_STD, "Destination", INVENTORY_SELL, Choice, NumItems)
				end
				--					SatisfyNeed(Alias, 8, 0.3)
				if HasProperty("Destination","ServiceActive") then
					local TavernLevel = BuildingGetLevel("Destination")
					local TavernAttractivity = GetImpactValue("Destination", "Attractivity")	
					
					local Tip = math.floor(TavernLevel * (10 + (Rand(20)+1) * (TavernAttractivity + basicvalue)))
					CreditMoney("Destination",Tip,"tip")
				end
			end
			--			end
			verweile = verweile - 1
		end
		if lokalPos == 0 then
			f_EndUseLocator(Alias,"SitPos",GL_STANCE_STAND)
		else
			f_EndUseLocator(Alias,"StandPos",GL_STANCE_STAND)
		end
		
		local Hour = math.mod(GetGametime(), 24)
		if Hour > 21 or Hour < 4 then
			if Rand(100) > 70 then
				AddImpact(Alias,"totallydrunk",1,6)
				AddImpact(Alias,"MoveSpeed",0.7,6)
				SetState(Alias,STATE_TOTALLYDRUNK,true)
				StopMeasure()
			end
		end
	end
end

-- -----------------------
-- TakeACredit
-- -----------------------
function TakeACredit(Alias) --McCoy Fix
	if HasProperty(Alias,"ProTCBank") then
		return
	end
	SetProperty(Alias,"ProTCBank",1)
	local DistanceBest = -1
	local Attractivity
	local Distance
	
	if GetSettlement(Alias, "City") then
		local NumBankhouses = CityGetBuildings("City",2,43,-1,-1,FILTER_HAS_DYNASTY,"Bank")
		if NumBankhouses > 0 then
			if HasProperty(Alias, "IgnoreBank") then
				local Time = GetProperty(Alias, "IgnoreBankTime")
				local IgnoreID
				if Time < GetGametime() then
					RemoveProperty(Alias, "IgnoreBank")
					RemoveProperty(Alias, "IgnoreBankTime")
				else
					IgnoreID = GetProperty(Alias, "IgnoreBank")
				end
			end
			for i=0,NumBankhouses-1 do
				if IgnoreID and IgnoreID == GetID("Bank"..i) then
					Distance = -1
				else
					Attractivity	= GetImpactValue("Bank"..i,"Attractivity")
					Distance	= GetDistance(Alias,"Bank"..i)
					if Distance == -1 then
						Distance = 50000
					end
					CopyAlias("Bank"..i,"TmpPointer")
					if HasProperty("TmpPointer","OfferCreditNow") then
						Attractivity = Attractivity + 0.15
					end
					if HasProperty("TmpPointer","KreditKonto") then
						Distance = Distance / (0.5 + Attractivity)
						if DistanceBest==-1 or Distance<DistanceBest then
							CopyAlias("Bank"..i,"Destination")
							DistanceBest = Distance
						end
					end
					RemoveAlias("TmpPointer")
				end
			end
		end
		if (DistanceBest==-1) or (AliasExists("Destination")==false) or (BuildingGetType("Destination")~=43) then
			-- bank not exist
			SatisfyNeed(Alias, 9, 1)
			return
		end
		if f_MoveTo(Alias,"Destination") then
			if not GetLocatorByName("Destination","Wait4","SitPos") then
				if not GetLocatorByName("Destination","Wait3","SitPos") then
					if not GetFreeLocatorByName("Destination","Wait",1,4,"SitPos") then
						return
					else
						if not HasProperty("Destination","BankKundschaft") then
							SetProperty("Destination","BankKundschaft",1)
						end	
					end
				else
					if not HasProperty("Destination","BankKundschaft") then
						SetProperty("Destination","BankKundschaft",2)
					end						
				end
			else
				if not HasProperty("Destination","BankKundschaft") then
					SetProperty("Destination","BankKundschaft",2)
				end
			end
			
			local coinCheckEnd = false
			if not f_BeginUseLocator(Alias,"SitPos",GL_STANCE_SIT,true) then
				if idlelib_BuySomeCoin(Alias,"Destination",1) == "c" then
					while true do
						local WaitSimFilter = "__F((Object.GetObjectsByRadius(Sim) == 5000) AND (Object.Property.WaitForCredit==1) AND NOT (Object.Property.StartSay==1))"
						local NumWaitSims = Find(Alias, WaitSimFilter,"WaitSim", -1)
						if NumWaitSims < 4 then
							SetProperty(Alias, "WaitForCredit", 1)
							if f_BeginUseLocator(Alias,"SitPos",GL_STANCE_SIT,true) then
								break
							else
								local BehaviourRand = Rand(5)
								local AnimTime
								if BehaviourRand == 0 then
									AnimTime = PlayAnimation(Alias,"cogitate")
								elseif BehaviourRand == 1 then
									if NumWaitSims == 2 then
										local myID = GetID(Alias)
										local OtherID
										for i=0, NumWaitSims do
											OtherID = GetID("WaitSim"..i)
											if myID ~= OtherID then
												CopyAlias("WaitSim"..i,"OtherSim")
												break
											end
										end
										if AliasExists("OtherSim") then
											SetProperty(Alias, "StartSay", 1)
											SetProperty("OtherSim", "StartSay", 1)
											if not f_MoveTo(Alias,"OtherSim",GL_MOVESPEED_WALK,100) then
												return
											end
											AlignTo(Alias,"OtherSim")
											AlignTo("OtherSim",Alias)
											Sleep(1.5)
											AnimTime = PlayAnimationNoWait(Alias,"talk")
											if SimGetGender(Alias)==GL_GENDER_MALE then
												PlaySound3DVariation(Alias,"CharacterFX/male_neutral",1)
											else
												PlaySound3DVariation(Alias,"CharacterFX/female_neutral",1)
											end
										end
									end
								end
								Sleep(AnimTime)
								if HasProperty(Alias, "StartSay") then
									RemoveProperty(Alias, "StartSay")
								end
								if AliasExists("OtherSim") then
									if HasProperty("OtherSim", "StartSay") then
										RemoveProperty("OtherSim", "StartSay")
									end
								end
							end
						else
							coinCheckEnd = true
							break
						end
					end
					if HasProperty(Alias, "WaitForCredit") then
						RemoveProperty(Alias, "WaitForCredit")
					end
				else
					coinCheckEnd = true
				end
			end
			
			if not coinCheckEnd then
				if HasProperty(Alias, "WaitForCredit") then
					RemoveProperty(Alias, "WaitForCredit")
				end
				if HasProperty("Destination","KreditKonto") then
					if HasProperty("Destination","OfferCreditNow") then
						local kreditMeng = GetProperty("Destination","KreditKonto")
						if kreditMeng == 0 then
							f_EndUseLocator(Alias,"SitPos",GL_STANCE_STAND)
							if not f_MoveTo(Alias,"Destination") then
								return
							end
							idlelib_BuySomeCoin(Alias,"Destination",0)
						else
							local anim = { "sit_talk","sit_talk_02" }
							local dowhat = PlayAnimationNoWait(Alias,anim[Rand(2)+1])
							MsgSayNoWait(Alias,"@L_MEASURE_IDLE_TAKECREDIT_SPRUCH")
							
							local schuldner = SimGetRank(Alias)
							local lev = SimGetLevel(Alias)
							
							local hmuch = 0
							if kreditMeng >	8000 then  
								hmuch = (lev*40)+(80*((schuldner*2.5)+Rand(9)+1))
							else
								hmuch = (lev*35)+((kreditMeng/100) * ((schuldner*2)+Rand(8)+1))
								if hmuch < 50 then
									hmuch = 50
								end
							end
							
							local PlaceIs = SimGetWorkingPlaceID(Alias)
							if lev == 1 and not IsDynastySim(Alias) and PlaceIs == -1 then
								hmuch = 30
							end
							if kreditMeng < hmuch then
								hmuch = kreditMeng
							end
							hmuch = math.floor(hmuch)
							
							kreditMeng = kreditMeng - hmuch
							SetProperty(Alias,"SchuldenGeb",GetID("Destination"))
							SetProperty(Alias,"SchuldenMeng",hmuch)
							SetProperty(Alias, "TimeBank", GetGametime()+4)
							
							SetProperty("Destination","KreditKonto",kreditMeng)
							
							SatisfyNeed(Alias, 9, 1)
							
							if BuildingGetOwner("Destination","Glaubiger") then
								chr_ModifyFavor(Alias,"Glaubiger",4)					
							end
							
							Sleep(dowhat)
							f_EndUseLocator(Alias,"SitPos",GL_STANCE_STAND)
						end
					else
						
						f_EndUseLocator(Alias,"SitPos",GL_STANCE_STAND)
						if not f_MoveTo(Alias,"Destination") then
							return
						end
						idlelib_BuySomeCoin(Alias,"Destination",0)
					end
				else
					
					f_EndUseLocator(Alias,"SitPos",GL_STANCE_STAND)
					if not f_MoveTo(Alias,"Destination") then
						return
					end
					idlelib_BuySomeCoin(Alias,"Destination",0)
				end
			end
		end			
	end
	f_ExitCurrentBuilding(Alias)
	if AliasExists("Destination") then
		RemoveProperty("Destination","BankKundschaft")
	end
	RemoveProperty(Alias,"ProTCBank")
	idlelib_GoToRandomPosition(Alias)
end

-- -----------------------
-- ReturnACredit
-- -----------------------
function ReturnACredit(Alias) --McCoy Fix
	-- ******** THANKS TO KINVER ********
	if HasProperty(Alias,"ProRCBank") then
		return
	end
	SetProperty(Alias,"ProRCBank",1)
	if not HasProperty(Alias,"SchuldenGeb") then
		return false
	end
	local bankkonto = 0
	local bankID = GetProperty(Alias,"SchuldenGeb")
	if GetAliasByID(bankID,"Destination") then
		if f_MoveTo(Alias,"Destination") then
			local playTime = PlayAnimationNoWait(Alias,"use_object_standing")
			CarryObject("Destination","Handheld_Device/ANIM_Smallsack.nif",false)
			Sleep(1)
			MsgSayNoWait(Alias,"@L_MEASURE_IDLE_RETURNCREDIT_SPRUCH")
			PlaySound3D(Alias,"Effects/coins_to_moneybag+0.wav", 1.0)
			
			if BuildingGetOwner("Destination","Glaubiger") then
				chr_ModifyFavor(Alias,"Glaubiger",-3)					
			end
			
			local schuld = GetProperty(Alias,"SchuldenMeng")
			BuildingGetOwner("Destination","Glaubiger")
			local zinsA = GetSkillValue("Glaubiger",BARGAINING)
			local zinsB = GetSkillValue("Glaubiger",SECRET_KNOWLEDGE)
			local schuldner = SimGetRank(Alias)
			local lev = SimGetLevel(Alias)
			local knowhow = 1.5*(zinsA + zinsB)
			
			if schuldner <= 1 then
				knowhow=knowhow+3
			elseif schuldner == 2 then
				knowhow=knowhow+4
			elseif schuldner == 3 then
				knowhow=knowhow+6
			elseif schuldner == 4 then
				knowhow=knowhow+8
			else
				knowhow=knowhow+10
			end
			
			local hecost = (schuld/100) * (knowhow + (lev/2))
			local mecost = 45+(knowhow)+(lev*2)
			local ecost = math.max(hecost,mecost)
			ecost = math.floor(ecost)
			
			local PlaceIs = SimGetWorkingPlaceID(Alias)
			if PlaceIs ~= -1 then
				ecost = ecost + knowhow
			end
			
			if not HasProperty("Destination","KreditKonto") then
				bankkonto = schuld + ecost
				CreditMoney("Destination",bankkonto,"tip")
			else
				bankkonto = GetProperty("Destination","KreditKonto") + schuld
				SetProperty("Destination","KreditKonto",bankkonto)
				CreditMoney("Destination",ecost,"tip")
			end
			
			if HasProperty(Alias,"SchuldenMeng") then
				RemoveProperty(Alias,"SchuldenMeng")
			end
			if HasProperty(Alias,"SchuldenGeb") then
				RemoveProperty(Alias,"SchuldenGeb")
			end
			if HasProperty(Alias, "TimeBank") then
				RemoveProperty(Alias, "TimeBank")
			end
			Sleep(playTime-1)
			f_ExitCurrentBuilding(Alias)
			
			idlelib_GoToRandomPosition(Alias)
			return true
		end
	end
	f_ExitCurrentBuilding(Alias)
	RemoveProperty(Alias,"ProRCBank")
	idlelib_GoToRandomPosition(Alias)
	return false
end

-- -----------------------
-- BeADrunkChamp
-- -----------------------
function BeADrunkChamp(Alias) --McCoy Fix
	
	if GetSettlement(Alias, "City") then
		if CityGetRandomBuilding("City", 2,36,-1,-1, FILTER_HAS_DYNASTY, "Destination") then
			if f_MoveTo(Alias,"Destination") then
				if not GetFreeLocatorByName("Destination","Bar",1,4,"StehPos") then
					f_Stroll(Alias,300,10)
					return
				end
				if not f_BeginUseLocator(Alias,"StehPos",GL_STANCE_STAND,true) then
					return
				else
					Sleep(1)
					local dowas = PlayAnimationNoWait(Alias,"clink_glasses")
					Sleep(1)
					CarryObject(Alias,"Handheld_Device/ANIM_beaker.nif",false)
					Sleep(dowas-2)
					if SimGetGender(Alias) == 1 then
						PlaySound3DVariation(Alias,"CharacterFX/male_belch",1)
					else
						PlaySound3DVariation(Alias,"CharacterFX/female_belch",1)
					end
					CarryObject(Alias,Alias,false)
					CreditMoney("Destination",Rand(90)+10,"tip")
					local newwinner = GetName(Alias)
					if HasProperty("Destination","BestDrunkPlayer") then
						local altpoint = GetProperty("Destination","BestDrunkPoints")
						if altpoint > 90 then
							return
						else
							RemoveProperty("Destination","BestDrunkPlayer")
							RemoveProperty("Destination","BestDrunkPoints")
							local bonus = {2,5,10}
							local newpoints = altpoint + bonus[Rand(3)+1]
							SetProperty("Destination","BestDrunkPlayer",newwinner)
							SetProperty("Destination","BestDrunkPoints",newpoints)
						end
					else
						local bonus = {10,30,50}
						local newpoints = bonus[Rand(3)+1]
						SetProperty("Destination","BestDrunkPlayer",newwinner)
						SetProperty("Destination","BestDrunkPoints",newpoints)
					end
					f_EndUseLocator(Alias,"StandPos",GL_STANCE_STAND)
				end
			end
		end
	end
end

-- -----------------------
-- BeADiceChamp
-- -----------------------
function BeADiceChamp(Alias)
	
	if GetSettlement(Alias, "City") then
		if CityGetRandomBuilding("City", 2,36,-1,-1, FILTER_HAS_DYNASTY, "Destination") then
			if f_MoveTo(Alias,"Destination") then
				if not GetFreeLocatorByName("Destination","DiceCEO",-1,-1,"StandPos") then
					f_Stroll(Alias,300,10)
					return
				end
				if not f_BeginUseLocator("Owner","StandPos",GL_STANCE_STAND,true) then
					return
				else
					Sleep(1)
					PlaySound3D(Alias,"measures/shake_dices/shake_dices+0.wav", 1.0)
					local wfallen = PlayAnimationNoWait(Alias,"manipulate_middle_low_r")
					Sleep(wfallen-1)
					PlaySound3D(Alias,"measures/throw_dices/throw_dices+0.wav", 1.0)
					CreditMoney("Destination",Rand(20)+5,"tip")
					local newwinner = GetName(Alias)
					local bonus
					if HasProperty("Destination","BestDicePlayer") then
						local altpoint = GetProperty("Destination","BestDicePott")
						bonus = { 2, 5, 10 }
						local neuPott = altpoint + ((altpoint / 100) * bonus[Rand(3)+1])
						RemoveProperty("Destination","BestDicePlayer")
						RemoveProperty("Destination","BestDicePott")
						
						SetProperty("Destination","BestDicePlayer",newwinner)
						SetProperty("Destination","BestDicePott",neuPott)
					else
						bonus = {50,300,700}
						local newpoints = Rand(300) + bonus[Rand(3)+1]
						SetProperty("Destination","BestDicePlayer",newwinner)
						SetProperty("Destination","BestDicePott",newpoints)
					end
					f_EndUseLocator(Alias,"StandPos",GL_STANCE_STAND)
				end
			end
		end
	end
end

-- -----------------------
-- LeibwacheIdle
-- -----------------------
function LeibwacheIdle(Alias) --McCoy Fix
	SimGetWorkingPlace(Alias, "WorkingPlace")
	while true do
		if Rand(2) == 0 then
			if GetFreeLocatorByName("WorkingPlace", "GuardPos",1,4, "WachPos") then
				if not f_BeginUseLocator(Alias, "WachPos", GL_STANCE_STAND, true) then
					RemoveAlias("WachPos")
					return
				end
				if Rand(2) == 0 then
					Sleep(10) 
				else
					PlayAnimationNoWait(Alias,"sentinel_idle")
				end
			else
				f_Stroll(Alias,300,10)
			end
		else
			if GetFreeLocatorByName("WorkingPlace", "Walledge",1,4, "WachPos") then
				if not f_BeginUseLocator(Alias, "WachPos", GL_STANCE_STAND, true) then
					RemoveAlias("WachPos")
					return
				end
				local WhatToDo2 = Rand(3)
				if WhatToDo2 == 0 then
					Sleep(10) 
				elseif WhatToDo2 == 1 then
					PlayAnimationNoWait(Alias,"sentinel_idle")
				else
					CarryObject(Alias,Alias,false)
					CarryObject(Alias,"Handheld_Device/ANIM_telescope.nif",false)
					PlayAnimation(Alias,"scout_object")
					CarryObject(Alias,Alias,false)
				end
			else
				f_Stroll(Alias,300,10)
			end
		end
		Sleep(3)
		f_EndUseLocator(Alias, "WachPos", GL_STANCE_STAND)
	end
	
end

-- -----------------------
-- DinnerAtEstate
-- -----------------------
function DinnerAtEstate(Alias) --McCoy Fix
	
	if DynastyGetRandomBuilding(Alias,8,111,"Schlossie") then
		if not GetState("Schlossie",STATE_BURNING) and not GetState("Schlossie",STATE_FIGHTING) then
			if f_MoveTo(Alias,"Schlossie") then
				if GetFreeLocatorByName("Schlossie", "Sit",2,12, "DoDinner") then
					if not f_BeginUseLocator(Alias, "DoDinner", GL_STANCE_SIT, true) then
						RemoveAlias("DoDinner")
						return
					end
					local duration = Rand(2)+1
					local CurrentTime = GetGametime()
					local EndTime = CurrentTime + duration
					local AnimTime, dinner
					local CurrentHP = GetHP(Alias)
					local MaxHP = GetMaxHP(Alias)
					local ToHeal = MaxHP - CurrentHP
					local HealPerTic = ToHeal / (duration * 12)	
					while GetGametime()<EndTime do
						dinner = Rand(4)
						if dinner == 0 then
							AnimTime = PlayAnimationNoWait(Alias,"sit_drink")
							Sleep(1)
							CarryObject(Alias,"Handheld_Device/ANIM_beaker_sit_drink.nif",false)
							Sleep(1)
							PlaySound3DVariation(Alias,"CharacterFX/drinking",1)
							Sleep(AnimTime-1.5)
							CarryObject(Alias,Alias,false)
							if SimGetGender(Alias)==GL_GENDER_MALE then
								PlaySound3DVariation(Alias,"CharacterFX/male_belch",1)
							else
								PlaySound3DVariation(Alias,"CharacterFX/female_belch",1)
							end
							SatisfyNeed(Alias, 8, 0.2)
							Sleep(1.5)
						elseif dinner == 1 then
							if Rand(2) == 0 then
								PlayAnimation(Alias,"sit_eat")
								SatisfyNeed(Alias, 1, 0.2)
							else
								PlayAnimation(Alias,"sit_talk")
							end
						elseif dinner == 2 then			
							AnimTime = PlayAnimationNoWait(Alias,"sit_cheer")
							Sleep(1)
							PlaySound3D(Alias,"Locations/tavern/cheers_01.wav",1)
							CarryObject(Alias,"Handheld_Device/ANIM_beaker_sit_drink.nif",false)
							Sleep(1)
							PlaySound3DVariation(Alias,"CharacterFX/drinking",1)
							Sleep(AnimTime-1.5)
							CarryObject(Alias,Alias,false)
							Sleep(1.5)
						else
							PlayAnimationNoWait(Alias,"sit_laugh")
							Sleep(2)
							if Rand(2)==0 then
								PlaySound3D(Alias,"Locations/tavern/laugh_01.wav",1)
							else
								PlaySound3D(Alias,"Locations/tavern/laugh_02.wav",1)
							end
							Sleep(5)					
						end
						
						if GetHP(Alias) < MaxHP then
							ModifyHP(Alias, HealPerTic,false)
						end
					end
					f_EndUseLocator(Alias, "DoDinner", GL_STANCE_STAND)
				end
			end
		end
	end
	Sleep(2)
	
end

function CheckBank(Alias) --McCoy Fix
	-- ******** THANKS TO KINVER ********
	if not HasProperty(Alias,"SchuldenGeb") then
		return idlelib_TakeACredit(Alias)
	else
		return idlelib_ReturnACredit(Alias)
	end
end

function BuySomeCoin(Alias,DestAlias,SplitNumber) --McCoy Fix
	if BuildingGetOwner(DestAlias,"Glaubiger") then
		local zinsA = GetSkillValue("Glaubiger",BARGAINING)
		local percent = 50 + (zinsA * 3)
		if Rand(100) < percent then
			local Items = { "Goldlowmed", "Goldmedhigh", "Goldveryhigh" }
			local Choice
			local schuldner = SimGetRank(Alias)
			local lrand = Rand(100)
			if schuldner <= 1 then
				Choice=1
			elseif schuldner == 2 then
				if lrand > 75 then
					Choice=2
				else
					Choice=1
				end
			elseif schuldner == 3 then
				if lrand > 85 then
					Choice=3
				elseif lrand > 30 and lrand < 84 then
					Choice=2
				else
					Choice=1
				end
			elseif schuldner == 4 then
				if lrand > 85 then
					Choice=2
				elseif  lrand > 30 and lrand < 84 then
					Choice=3
				else
					Choice=1
				end
			else
				if lrand > 25 then
					Choice=3
				else
					Choice=2
				end
			end
			Choice=Items[Choice]
			if GetItemCount(DestAlias, Choice, INVENTORY_SELL)>0 then
				CarryObject(DestAlias,"Handheld_Device/ANIM_Smallsack.nif",false)
				local playTime = PlayAnimationNoWait(Alias,"use_object_standing")
				local prodNam = ItemGetLabel(Choice,true)
				if Rand(2) == 0 then
					MsgSay(Alias,"@L_HPFZ_IDLELIB_GETGOOD_SPRUCH_+0",prodNam)
				else
					MsgSayNoWait(Alias,"@L_HPFZ_IDLELIB_GETGOOD_SPRUCH_+1",prodNam)
				end
				Transfer(nil, nil, INVENTORY_STD, DestAlias, INVENTORY_SELL, Choice, 1)
				PlaySound3D(Alias,"Effects/coins_to_moneybag+0.wav", 1.0)
				
				if BuildingGetOwner(DestAlias,"Glaubiger") then
					chr_ModifyFavor(Alias,"Glaubiger",1)					
				end
				Sleep(playTime-1)
			else
				if SplitNumber == 1 then
					return "c"
				else
					if BuildingGetOwner(DestAlias,"Glaubiger") then
						chr_ModifyFavor(Alias,"Glaubiger",-1)					
					end
					SetProperty(Alias, "IgnoreBank", DestAlias)
					SetProperty(Alias, "IgnoreBankTime", GetGametime()+36)
				end
			end
		end
	end
	
	SatisfyNeed(Alias, 9, 1)
end

function CleanUp()
end
