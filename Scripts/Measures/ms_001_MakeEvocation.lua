-------------------------------------------------------------------------------
----
----	OVERVIEW "ms_001_MakeEvocation"
----
----	with this measure the alchimist is able to make an evocation
----
-------------------------------------------------------------------------------


function Run()
	if not GetInsideBuilding("", "Building") then
		StopMeasure()
	end

	local MeasureID = GetCurrentMeasureID("")
	local TimeOut = mdata_GetTimeOut(MeasureID)

	SetData("SummonComplete",0)
	local	Slots = InventoryGetSlotCount("", INVENTORY_STD)
	local	Number
	local	ItemId
	local	ItemCount
	local	NumItems = 0
	local	ItemName = {}
	local	ItemLabel = {}
	local 	btn = ""
	local	added = {}
	local	ItemTexture
	
	--count all items, remove duplicates
	for Number = 0, Slots-1 do
		ItemId, ItemCount = InventoryGetSlotInfo("", Number, InventoryType)
		if ItemId and ItemId>0 and ItemCount then
			if ItemGetType(ItemId) == 8 and ItemId ~= 971 then	--gathering items - except for shroud
				if not added[ItemId] then
					
					added[ItemId] = true
				
					--create labels for replacements
					ItemName[NumItems] = ItemId 
					ItemTextureName = ItemGetName(ItemId)
					ItemTexture = "Hud/Items/Item_"..ItemTextureName..".tga"
					btn = btn.."@B[A"..NumItems..",,%"..1+NumItems.."l,"..ItemTexture.."]"
					ItemLabel[NumItems] = ""..ItemGetLabel(ItemName[NumItems],true)
					NumItems = NumItems + 1
	
				end
			end
		end
	end
	SetData("NumItems",NumItems)
	
	local Result
	if Slots > 0 and NumItems > 0 then				
		Result = InitData("@P"..btn,
				ms_001_makeevocation_AIDecide,  --AIFunc
				"@L_MEASURE_MakeEvocation_NAME_+0",
				"",
				ItemLabel[0],ItemLabel[1],
				ItemLabel[2],ItemLabel[3],
				ItemLabel[4],ItemLabel[5])
				
		
	else
		MsgQuick("","@L_ALCHEMIST_001_MAKEEVOCATION_FAILURES_+0")
		StopMeasure()
	end
	
	if Result == "C" then
		StopMeasure()
	end
	
	--check the item
	local ItemIndex
	if Result == "A0" then
		ItemIndex = 0
	elseif Result == "A1" then
		ItemIndex = 1
	elseif Result == "A2" then
		ItemIndex = 2
	elseif Result == "A3" then
		ItemIndex = 3
	elseif Result == "A4" then
		ItemIndex = 4
	else
		ItemIndex = 5
	end
	
	--make sure there's room in inventory with item removed. If not, put item back and end measure.
	--Note: new slots that have not had an item put in them yet don't seem to be recognized by the function InventoryGetSlotCount, so an erroneous message
	--saying there is no room, when there is, will appear at times.
	RemoveItems("",ItemName[ItemIndex],1,INVENTORY_STD)
	local HasRoom = 0
	Slots = InventoryGetSlotCount("", INVENTORY_STD)
	for Number = 0, Slots-1 do
		ItemId, ItemCount = InventoryGetSlotInfo("", Number, InventoryType)
		if ItemId and ItemId>0 and ItemCount then
			--nothing
		else
			HasRoom = 1
		end
	end
	
	if HasRoom == 0 then
		MsgQuick("","Summoning failed. Not enough space in inventory.")
		AddItems("",ItemName[ItemIndex],1,INVENTORY_STD)
		StopMeasure()
	end

	SetData("ItemUsed",ItemName[ItemIndex])

	-- do the visual stuff here
	GetLocatorByName("Building", "Ritual1", "Evocation1")
	f_MoveTo("","Evocation1")
	PlayAnimation("", "cogitate")
	GetLocatorByName("Building", "Ritual2", "Evocation2")
	f_MoveTo("","Evocation2")
	PlayAnimation("", "manipulate_middle_twohand")
	GetLocatorByName("Building", "Ritual3", "Evocation3")
	GetLocatorByName("Building", "ParticleSpawnPos","SpawnPos")
	f_MoveTo("","Evocation3")
	local AnimTime = PlayAnimationNoWait("", "make_evocation")
	Sleep(AnimTime-2)

	MeasureSetStopMode(STOP_NOMOVE)


	--check if inventory still has room after the animations are done (the player might have put stuff in while the character was doing the animations)
	--if there's no room, then treat as if the magic failed (simplest solution)
	if GetRemainingInventorySpace("", ItemName[ItemIndex]) <= 0 then
		ms_001_makeevocation_Nothing()
	end

	--do the evocation stuff
	local RefreshTime = 1
	local OldItemName = "Old Item"
	local NewItemName = "New Item"
	local GotMoney = 0
	local GotSame = 0
	local GotLesser = 0
	local MarginalSucc = 0
	local GotSkillUp = 0
	local GotSkillDown = 0
	local GotPoisoned = 0
	local nSpeed = 1.0
	local GotSpeedUp = 0
	local GotSpeedDown = 0
	local GotAllSkillsUp = 0
	local GotAllSkillsDown = 0
	local GotYouth = 0
	local GotXP = 0
	local XPGain = 0
	local GotMultiplied = 0
	local GotArms = 0
	local GotOccultInsight = 0
	local SpecialItem = ""
	local SumGold
	local EvocationSkill = GetSkillValue("",10) * 10 --arcane knowledge times ten
	local ArcaneKnowledge = GetSkillValue("",10)
	local EvocationChance = Rand(100)
	local EvocationResult = EvocationChance + EvocationSkill

	--for debugging -----------------------------------------------------
	--MsgQuick("","")

--chance of mishap or special result

	GetInsideBuilding("", "CurrentBuilding")
	local EvocationSkill4 = GetSkillValue("",10) * 4
	local Message1 = ""

	SetProperty("CurrentBuilding", "BurnDamage", 50)
	local BuildingStatus = GetHP("CurrentBuilding")
	local Damage = BuildingStatus*(20/100)

	local EffectType = Rand(100)
	local Effect1Chance = Rand(100) + EvocationSkill4
	local Effect2Chance = Rand(100) + EvocationSkill4
	local Effect3Chance = Rand(100) + EvocationSkill4
	local SpecialSuccRange = 100 - math.ceil(ArcaneKnowledge/3) -- 0% chance, +1% chance at level 4 and every 3 levels after
	local SpecialFailRange = 15 - ArcaneKnowledge   -- 15% chance, -1% chance per level (starts at 14%)


	--the bad stuff
	if EvocationChance < SpecialFailRange then
		--is it fire-based?
		if EffectType < 60 then
			--Is there an explosion?
			if Effect1Chance < 55 then
				GetFreeLocatorByName("CurrentBuilding", "Bomb", 1, 3, "SabotagePosition")
				StartSingleShotParticle("particles/Explosion.nif", "SabotagePosition", 4,5)
				PlaySound3D("CurrentBuilding","fire/Explosion_01.wav", 1.0)
				GfxDetachObject("tntbarrel")
				ModifyHP("CurrentBuilding",-Damage)
				feedback_MessageWorkshop("","Summoning Mishap", "Your magic caused an explosion!$NYour workshop has been damaged!")
				RefreshTime = 24
			end

			--Does the building catch fire?
			if Effect1Chance < 55 then
				Effect2Chance = Effect2Chance - 20
			end 
			if Effect2Chance < 55 then
				SetState("CurrentBuilding", STATE_BURNING, true)
				PlaySound("measures/warning_horn+1.wav", 1.0, 1, "c3")
				CameraIndoorGetBuilding("CameraInside")
				if GetID("CameraInside") == GetID("CurrentBuilding") then
					PlaySound("fire/Fire_l_02.wav", 1.0, 3)
				end
				feedback_MessageWorkshop("","Summoning Mishap", "Your magic started a fire in your workshop!!")
				RefreshTime = 24
			end

			--Is character burned?
			if Effect1Chance < 55 then
				Effect3Chance = Effect3Chance - 20
			end 
			if Effect2Chance < 55 then
				Effect3Chance = Effect3Chance - 20
			end 
			if Effect3Chance < 55 then
				diseases_BurnWound("", true)
				feedback_MessageWorkshop("","Summoning Mishap", "Your magic blew up in your face!$NYou were burned. :(")
				RefreshTime = 24
			end

			if Effect1Chance >= 55 and Effect2Chance >= 55 and Effect3Chance >= 55 then
				Message1 = "But you were skilled enough, or lucky enough, to prevent anything bad from happening.$N Your materials, however, were destroyed."
				RefreshTime = 1
			end

			SetData("SummonComplete",1)

			--GetPosition("", "EffectPosition")
			StartSingleShotParticle("particles/Explosion.nif", "SpawnPos", 2,5)
			PlaySound3D("","Effects/combat_cannon_strike_ground/combat_cannon_strike_ground+1.wav", 1.0)
			PlaySound("Effects/combat_cannon_strike_ground/combat_cannon_strike_ground+1.wav")

		--or is a noxious fume released? (toad excrement)
		elseif EffectType >= 60 and EffectType < 90 then
			if Effect1Chance < 65 and GetImpactValue("CurrentBuilding","toadexcrements") == 0 then
				local FumeDuration = 8
				FumeDuration = FumeDuration - chr_ArtifactsDuration("",FumeDuration)
				GetLocatorByName("CurrentBuilding", "Entry1", "ParticleSpawnPos")
				StartSingleShotParticle("particles/toadexcrements_hit.nif", "ParticleSpawnPos",6,5)

				--GetPosition("", "EffectPosition")
				StartSingleShotParticle("particles/toadexcrements_hit.nif", "SpawnPos",6,5)
				PlaySound("CharacterFX/nasty/Furzen+1.wav")

				SetData("SummonComplete",1)
				feedback_MessageWorkshop("","Summoning Mishap", "Your magic released a noxious fume in your workshop. You are forced to evacuate the building. No one will be able to go in there for a while.")
				RefreshTime = 24

				-- set contaminated and evacuate building
				SetState("CurrentBuilding", STATE_CONTAMINATED, true)
				AddImpact("CurrentBuilding","toadexcrements",1,FumeDuration)

				Sleep(1)
				Evacuate("CurrentBuilding")
			else
				Message1 = "But you were skilled enough, or lucky enough, to prevent anything bad from happening.$N Your materials, however, were destroyed."
			end

		--or does the player character get infected with a disease?
		elseif EffectType >= 90 then
			if Effect1Chance < 55 and GetImpactValue("","Resist") == 0 and GetImpactValue("","Sickness") == 0 then
				GetPosition("", "EffectPosition")
				StartSingleShotParticle("particles/disease.nif", "EffectPosition",2.7,5)
				PlaySound3D("","CharacterFX/nasty/Ruelpsen+0.wav", 1.0)
				PlaySound("CharacterFX/nasty/Ruelpsen+0.wav")
				
				--if item used was fungi
				if ItemGetID(ItemName[ItemIndex]) == 204 then		--fungi
					if Effect2Chance < 70 then
						diseases_Blackdeath("",true,true)
					else
						diseases_Cold("",true,true)
					end

				--if item used was a skull or bones
				elseif ItemGetID(ItemName[ItemIndex]) == 972 or ItemGetID(ItemName[ItemIndex]) == 973 then	--skull or bones
					if Effect2Chance < 30 then
						diseases_Blackdeath("",true,true)
					elseif Effect2Chance >= 30 and Effect2Chance < 70 then
						diseases_Pox("",true,true)
					else
						diseases_Cold("",true,true)
					end
				else
					if Effect2Chance < 40 then
						diseases_Pneumonia("",true,true)
					elseif Effect2Chance >= 40 and Effect2Chance < 70 then
						diseases_Influenza("",true,true)
					else
						diseases_Cold("",true,true)
					end
				end
				SetData("SummonComplete",1)
				feedback_MessageWorkshop("","Summoning Mishap", "Your magic exposed you to an unnatural filth and you have become diseased.")
				RefreshTime = 24
			else
				Message1 = "But you were skilled enough, or lucky enough, to prevent anything bad from happening.$N Your materials, however, were destroyed."
			end
		end

		SetData("SummonComplete",1)
		feedback_MessageWorkshop("","@L_ALCHEMIST_001_MAKEEVOCATION_FAILED_HEAD_+0", "Something went terribly wrong with your attempt at working magic!$N" ..Message1)
		RefreshTime = RefreshTime - chr_ArtifactsDuration("",RefreshTime)
		SetMeasureRepeat(RefreshTime)
		StopMeasure()
		
		
		
	--the good stuff
	elseif EvocationChance >= SpecialSuccRange then
		RefreshTime = 21
		local sItemName = ItemGetName(ItemName[ItemIndex])
		local RandSpecial = Rand(10)
		if RandSpecial < 4 then
			SpecialItem = "OrientalTobacco"
			NewItemName = "some Oriental Tobacco"
		elseif RandSpecial == 4 then
			SpecialItem = "OrientalStatues"
			NewItemName = "an Oriental Statue"
		elseif RandSpecial == 5 then
			SpecialItem = "OrientalCarpet"
			NewItemName = "an Oriental Carpet"
		else
			local BoxGrade = math.ceil(ArcaneKnowledge/4)
			if BoxGrade > 3 then
				BoxGrade = 3
			end
			if sItemName == "Wheat" or sItemName == "Barley" or sItemName == "Wool" or sItemName == "Leather" or 
			sItemName == "Fungi" or sItemName == "Pinewood" or sItemName == "Oakwood" or sItemName == "Iron" or 
			sItemName == "Silver" or sItemName == "Gold" or sItemName == "Herring" then
				SpecialItem = sItemName.."Box"..BoxGrade
				if sItemName == "Fungi" then
					NewItemName = "a Box of Mushrooms"
				else
					NewItemName = "a Box of "..sItemName
				end
				GotMultiplied = 1
			elseif sItemName == "Gemstone" or sItemName == "Clay" or sItemName == "Granite" or 
			sItemName == "Shell" or sItemName == "Willowrot" then
				if sItemName == "Shell" then
					SpecialItem = "ArmorsBox"..BoxGrade
					NewItemName = "Armor"
				elseif sItemName == "Willowrot" then
					SpecialItem = "WeaponsBox"..BoxGrade
					NewItemName = "Weapons"
				else
					local BoxType = Rand(2)
					if BoxType == 0 then
						SpecialItem = "ArmorsBox"..BoxGrade
						NewItemName = "Armor"		
					else
						SpecialItem = "WeaponsBox"..BoxGrade
						NewItemName = "Weapons"
					end
				end
				GotArms = 1
			elseif sItemName == "Beef" or sItemName == "Salmon" or sItemName == "Honey" or 
			sItemName == "Frogeye" or sItemName == "Spiderleg" then
				local EnhanceAmount = math.ceil(GetSkillValue("",10)/4)	--1 to 4 points
				ms_001_makeevocation_AllSkillsUp(EnhanceAmount, 24, "SpawnPos")
				GotAllSkillsUp = 1
			elseif sItemName == "Schadel" or sItemName == "Knochen" or sItemName == "HolyWater" then
				AddImpact("","secret_knowledge",1,-1)
				AddImpact("","LifeExpanding",-3,-1)
				GotOccultInsight = 1
			else
				SpecialItem = "OrientalTobacco"
				NewItemName = "some Oriental Tobacco"
			end
		end
		
		
		--if item, add it
		if SpecialItem ~= "" then
			AddItems("",SpecialItem,1,INVENTORY_STD)	
		end
		SetData("SummonComplete",1)
		
		--feedback
		if GotMultiplied == 1 then
			feedback_MessageWorkshop("","@L_ALCHEMIST_001_MAKEEVOCATION_GOLDSUCCESS_HEAD_+0",
							"Something strange occurred.$NIt seems the item used has multiplied, leaving you with " .. NewItemName ..  "!$NYou don't think you could do this again on purpose.")
		elseif GotArms == 1 then
			feedback_MessageWorkshop("","@L_ALCHEMIST_001_MAKEEVOCATION_GOLDSUCCESS_HEAD_+0",
							"Something odd happened.$NIt seems you may have accidentally teleported someone's stash of " .. NewItemName ..  " to you. Cool!!$NYou don't think you could do this again on purpose.")
		elseif GotAllSkillsUp == 1 then
			-- nothing - message is in ms_001_makeevocation_AllSkillsUp
		elseif GotOccultInsight == 1 then
			feedback_MessageWorkshop("","@L_ALCHEMIST_001_MAKEEVOCATION_GOLDSUCCESS_HEAD_+0",
							"A dark voice spoke to you, telling you secrets no mortal could know.$N(Permanent +1 to Arcane Knowledge)$NHowever, this diabolic contact has taken its toll on your mortal body.$N(-3 years to life expectancy)")
		else
			feedback_MessageWorkshop("","@L_ALCHEMIST_001_MAKEEVOCATION_GOLDSUCCESS_HEAD_+0",
							"Something strange occurred.$N It seems you have conjured up " .. NewItemName .. "!$NYou don't think you could do this again on purpose.")
		end

		RefreshTime = RefreshTime - chr_ArtifactsDuration("",RefreshTime)
		SetMeasureRepeat(RefreshTime)

		--do visual stuff

		if GotOccultInsight == 1 then
			StartSingleShotParticle("particles/change_effect.nif", "SpawnPos", 0.7,2)
			PlaySound3D("","Effects/mystic_gift+0.wav", 1.0)

			GetPosition("", "EffectPosition")
			StartSingleShotParticle("particles/sparkle_talents.nif", "EffectPosition",1,5)

			PlaySound3D("","CharacterFX/male_evocation/male_evocation+0.ogg", 1.0)
			PlaySound3D("","Locations/pigs_grunt/pigs_grunt+1.wav", 1.0)

			chr_GainXP("",GetData("BaseXP"))
			
			Sleep(2)
			
			ShowOverheadSymbol("", true, false, 0, "@L_ARTEFACTS_OVERHEAD_+0", "@L_TALENTS_secret_knowledge_ICON_+0", "@L_TALENTS_secret_knowledge_NAME_+0", 1)
			StartSingleShotParticle("particles/levelup.nif", "EffectPosition", 0.7,2)
			PlaySound("levelup/levelup.ogg")
			
			Sleep(6)
			RemoveOverheadSymbols("")
							
		elseif GotAllSkillsUp == 1 then
			--do nothing - effects and xp are in ms_001_makeevocation_AllSkillsUp
		else
			StartSingleShotParticle("particles/change_effect.nif", "SpawnPos", 0.7,2)
			PlaySound3D("","Effects/mystic_gift+0.wav", 1.0)
			PlaySound("levelup/levelup.ogg")
			
			Sleep(2)
			chr_GainXP("",GetData("BaseXP"))
			
		end
		--end visual stuff


		StopMeasure()
	end


--regular alchemy/magic stuff

	--wheat to wheat flour or spices
	if ItemGetID(ItemName[ItemIndex]) == 2 then		--wheat
		OldItemName = "Wheat"
		if EvocationResult >= 130 then
			ms_001_makeevocation_Transmute("Spicery", "SpawnPos")
			NewItemName = "Spices"
			RefreshTime = 6
		elseif EvocationResult < 130 and EvocationResult >= 90 then
			ms_001_makeevocation_Transmute("WheatFlour", "SpawnPos")
			NewItemName = "Wheat Flour"
			RefreshTime = 1
			MarginalSucc = 1
		else
			ms_001_makeevocation_Nothing()
		end
	--barley to barley flour or wine
	elseif ItemGetID(ItemName[ItemIndex]) == 3 then		--Barley
		OldItemName = "Barley"
		if EvocationResult >= 130 then
			ms_001_makeevocation_Transmute("Wine", "SpawnPos")
			NewItemName = "Wine"
			RefreshTime = 10
		elseif EvocationResult < 130 and EvocationResult >= 90 then
			ms_001_makeevocation_Transmute("BarleyFlour", "SpawnPos")
			NewItemName = "Barley Flour"
			RefreshTime = 1
			MarginalSucc = 1
		else
			ms_001_makeevocation_Nothing()
		end
	--wool to wool blanket or clothes
	elseif ItemGetID(ItemName[ItemIndex]) == 8 then		--Wool
		OldItemName = "Wool"
		if EvocationResult >= 130 then
			if ArcaneKnowledge < 5 then
				ms_001_makeevocation_Transmute("FarmersClothes", "SpawnPos")
				NewItemName = "Peasant's Clothes"
				RefreshTime = 1	
			elseif ArcaneKnowledge < 10 then
				ms_001_makeevocation_Transmute("CitizensClothes", "SpawnPos")
				NewItemName = "Citizen's Clothes"
				RefreshTime = 2
			else
				ms_001_makeevocation_Transmute("NoblesClothes", "SpawnPos")
				NewItemName = "Noble's Clothes"
				RefreshTime = 2
			end
		elseif EvocationResult < 130 and EvocationResult >= 90 then
			ms_001_makeevocation_Transmute("Blanket", "SpawnPos")
			NewItemName = "a Woolen Blanket"
			RefreshTime = 1
			MarginalSucc = 1
		else
			ms_001_makeevocation_Nothing()
		end
	--Beef to +Constitution or bones or -constitution
	elseif ItemGetID(ItemName[ItemIndex]) == 10 then	--Beef
		OldItemName = "Beef"
		if EvocationResult >= 130 then
			ms_001_makeevocation_SkillUp("constitution", 8, "SpawnPos")
			GotSkillUp = 1
			RefreshTime = 12
			NewItemName = "Constitution"
		elseif EvocationResult < 130 and EvocationResult >= 90 then
			ms_001_makeevocation_Transmute("Knochen", "SpawnPos")
			NewItemName = "Bones"
			RefreshTime = 1
			MarginalSucc = 1
		elseif EvocationResult < 50 then
			ms_001_makeevocation_SkillDown("constitution", 8, "SpawnPos")
			GotSkillDown = 1
			RefreshTime = 12
			NewItemName = "Constitution"
		else
			ms_001_makeevocation_Nothing()
		end
	--Leather to +Handicrafts or Beef or -Handicrafts
	elseif ItemGetID(ItemName[ItemIndex]) == 11 then	--Leather
		OldItemName = "Leather"
		if EvocationResult >= 130 then
			ms_001_makeevocation_SkillUp("craftsmanship", 8, "SpawnPos")
			GotSkillUp = 1
			RefreshTime = 12
			NewItemName = "Handicrafts skill"
		elseif EvocationResult < 130 and EvocationResult >= 90 then
			ms_001_makeevocation_Transmute("Beef", "SpawnPos")
			NewItemName = "Beef"
			RefreshTime = 1
			MarginalSucc = 1
		elseif EvocationResult < 50 then
			ms_001_makeevocation_SkillDown("craftsmanship", 8, "SpawnPos")
			GotSkillDown = 1
			RefreshTime = 12
			NewItemName = "Handicrafts skill"
		else
			ms_001_makeevocation_Nothing()
		end
	--Clay to bones or porcelain
	elseif ItemGetID(ItemName[ItemIndex]) == 30 then		--Clay
		OldItemName = "Clay"
		if EvocationResult >= 130 then
			ms_001_makeevocation_Transmute("Porcelain", "SpawnPos")
			NewItemName = "Tableware"
			RefreshTime = 12
		elseif EvocationResult < 130 and EvocationResult >= 90 then
			ms_001_makeevocation_Transmute("Knochen", "SpawnPos")
			NewItemName = "Bones"
			RefreshTime = 1
			MarginalSucc = 1
		else
			ms_001_makeevocation_Nothing()
		end
	--Granite to clay or granite or gemstones
	elseif ItemGetID(ItemName[ItemIndex]) == 39 then		--Granite
		OldItemName = "a Stone Block"
		if EvocationResult >= 150 then
			ms_001_makeevocation_Transmute("Gemstone", "SpawnPos")
			NewItemName = "Precious Stones"
			RefreshTime = 5
		elseif EvocationResult < 150 and EvocationResult >= 90 then
			ms_001_makeevocation_Transmute("Granite", "SpawnPos")
			NewItemName = "a Stone Block"
			RefreshTime = 1
			GotSame = 1
		elseif EvocationResult < 90 and EvocationResult >= 50 then
			ms_001_makeevocation_Transmute("Clay", "SpawnPos")
			NewItemName = "Clay"
			RefreshTime = 1
			GotLesser = 1
		else
			ms_001_makeevocation_Nothing()
		end
	--lavender to +charisma or Wheat or -charisma
	elseif ItemGetID(ItemName[ItemIndex]) == 120 then	--lavender
		OldItemName = "Lavender"
		if EvocationResult >= 130 then
			ms_001_makeevocation_SkillUp("charisma", 8, "SpawnPos")
			GotSkillUp = 1
			RefreshTime = 12
			NewItemName = "Charisma"
		elseif EvocationResult < 130 and EvocationResult >= 90 then
			ms_001_makeevocation_Transmute("Wheat", "SpawnPos")
			NewItemName = "Wheat"
			RefreshTime = 1
			MarginalSucc = 1
		elseif EvocationResult < 50 then
			ms_001_makeevocation_SkillDown("charisma", 8, "SpawnPos")
			GotSkillDown = 1
			RefreshTime = 12
			NewItemName = "Charisma"
		else
			ms_001_makeevocation_Nothing()
		end
	--blackberry to +Bargaining or Fruit or -Bargaining
	elseif ItemGetID(ItemName[ItemIndex]) == 121 then	--blackberry
		OldItemName = "Blackberry"
		if EvocationResult >= 130 then
			ms_001_makeevocation_SkillUp("bargaining", 8, "SpawnPos")
			GotSkillUp = 1
			RefreshTime = 12
			NewItemName = "Bargaining skill"
		elseif EvocationResult < 130 and EvocationResult >= 90 then
			ms_001_makeevocation_Transmute("Honey", "SpawnPos")
			NewItemName = "Honey"
			RefreshTime = 1
			MarginalSucc = 1
		elseif EvocationResult < 50 then
			ms_001_makeevocation_SkillDown("bargaining", 8, "SpawnPos")
			GotSkillDown = 1
			RefreshTime = 12
			NewItemName = "Bargaining skill"
		else
			ms_001_makeevocation_Nothing()
		end
	--moonflower to +shadow_arts or Mushrooms or -shadow_arts
	elseif ItemGetID(ItemName[ItemIndex]) == 122 then	--moonflower
		OldItemName = "Moon Flower"
		if EvocationResult >= 130 then
			ms_001_makeevocation_SkillUp("shadow_arts", 8, "SpawnPos")
			GotSkillUp = 1
			RefreshTime = 12
			NewItemName = "Stealth"
		elseif EvocationResult < 130 and EvocationResult >= 90 then
			ms_001_makeevocation_Transmute("Fungi", "SpawnPos")
			NewItemName = "Mushooms"
			RefreshTime = 1
			MarginalSucc = 1
		elseif EvocationResult < 50 then
			ms_001_makeevocation_SkillDown("shadow_arts", 8, "SpawnPos")
			GotSkillDown = 1
			RefreshTime = 12
			NewItemName = "Stealth"
		else
			ms_001_makeevocation_Nothing()
		end
	--stonelilly to  +fighting or Granite or -fighting
	elseif ItemGetID(ItemName[ItemIndex]) == 128 then	--stonelily
		OldItemName = "Stone Lilly"
		if EvocationResult >= 130 then
			ms_001_makeevocation_SkillUp("fighting", 8, "SpawnPos")
			GotSkillUp = 1
			RefreshTime = 12
			NewItemName = "Martial Arts skill"
		elseif EvocationResult < 130 and EvocationResult >= 90 then
			ms_001_makeevocation_Transmute("Granite", "SpawnPos")
			NewItemName = "a Stone Block"
			RefreshTime = 1
			MarginalSucc = 1
		elseif EvocationResult < 50 then
			ms_001_makeevocation_SkillDown("fighting", 8, "SpawnPos")
			GotSkillDown = 1
			RefreshTime = 12
			NewItemName = "Martial Arts skill"
		else
			ms_001_makeevocation_Nothing()
		end
	--frogeye to charcoal or Poisoned Cake or get poisoned
	elseif ItemGetID(ItemName[ItemIndex]) == 131 then	--frogeye
		OldItemName = "Toad Eyes"
		if EvocationResult >= 140 then
			ms_001_makeevocation_Transmute("PoisonedCake", "SpawnPos")
			NewItemName = "a Poisoned Cake"
			RefreshTime = 10
		elseif EvocationResult < 140 and EvocationResult >= 100 then
			ms_001_makeevocation_Transmute("Charcoal", "SpawnPos")
			NewItemName = "Charcoal"
			RefreshTime = 1
			MarginalSucc = 1
		elseif EvocationResult < 60 then
			ms_001_makeevocation_DoPoison(3, 8, "SpawnPos")
			RefreshTime = 8
			GotPoisoned = 1
		else
			ms_001_makeevocation_Nothing()
		end
	--spiderleg to Silk or cloth
	elseif ItemGetID(ItemName[ItemIndex]) == 134 then	--spiderleg
		OldItemName = "Spider Legs"
		if EvocationResult >= 130 then
			ms_001_makeevocation_Transmute("Silk", "SpawnPos")
			NewItemName = "Silk"
			RefreshTime = 14
		elseif EvocationResult < 130 and EvocationResult >= 90 then
			ms_001_makeevocation_Transmute("Cloth", "SpawnPos")
			NewItemName = "Cloth"
			RefreshTime = 1
			MarginalSucc = 1
		elseif EvocationResult < 50 then
			ms_001_makeevocation_DoPoison(3, 8, "SpawnPos")
			RefreshTime = 8
			GotPoisoned = 1
		else
			ms_001_makeevocation_Nothing()
		end
	--holywater to wine or alcohol
	elseif ItemGetID(ItemName[ItemIndex]) == 161 then	--holywater
		OldItemName = "Holy Water"
		if EvocationResult >= 200 then
			ms_001_makeevocation_DoYouth("SpawnPos")
			RefreshTime = 24
			GotYouth = 1
		elseif EvocationResult < 200 and EvocationResult >= 130 then
			ms_001_makeevocation_Transmute("Wine", "SpawnPos")
			NewItemName = "Wine"
			RefreshTime = 10
		elseif EvocationResult < 130 and EvocationResult >= 90 then
			ms_001_makeevocation_Transmute("Alcohol", "SpawnPos")
			NewItemName = "Alcohol"
			RefreshTime = 1
			MarginalSucc = 1
		else
			ms_001_makeevocation_Nothing()
		end
	--pinewood to charcoal or amber
	elseif ItemGetID(ItemName[ItemIndex]) == 201 then	--pinewood
		OldItemName = "Pine  Wood"
		if EvocationResult >= 130 then
			ms_001_makeevocation_Transmute("Amber", "SpawnPos")
			NewItemName = "Amber"
			RefreshTime = 8
		elseif EvocationResult < 130 and EvocationResult >= 90 then
			ms_001_makeevocation_Transmute("Charcoal", "SpawnPos")
			NewItemName = "Charcoal"
			RefreshTime = 1
			MarginalSucc = 1
		else
			ms_001_makeevocation_Nothing()
		end
	--oakwood to charcoal or amber
	elseif ItemGetID(ItemName[ItemIndex]) == 202 then	--oakwood
			OldItemName = "Oak Wood"
		if EvocationResult >= 130 then
			ms_001_makeevocation_Transmute("Amber", "SpawnPos")
			NewItemName = "Amber"
			RefreshTime = 8
		elseif EvocationResult < 130 and EvocationResult >= 90 then
			ms_001_makeevocation_Transmute("Charcoal", "SpawnPos")
			NewItemName = "Charcoal"
			RefreshTime = 1
			MarginalSucc = 1
		else
			ms_001_makeevocation_Nothing()
		end
	--Charcoal to charcoal or Antidote
	elseif ItemGetID(ItemName[ItemIndex]) == 203 then	--Charcoal
		OldItemName = "Charcoal"
		if EvocationResult >= 130 then
			ms_001_makeevocation_Transmute("Antidote", "SpawnPos")
			NewItemName = "Antidote"
			RefreshTime = 10
		elseif EvocationResult < 130 and EvocationResult >= 50 then
			ms_001_makeevocation_Transmute("Charcoal", "SpawnPos")
			NewItemName = "Charcoal"
			RefreshTime = 1
			GotSame = 1
		else
			ms_001_makeevocation_Nothing()
		end
	--Fungi to Fruit or Toadslime or secret mixture or get poisoned
	elseif ItemGetID(ItemName[ItemIndex]) == 204 then	--Fungi
		OldItemName = "Mushrooms"
		if EvocationResult >= 190 then
			ms_001_makeevocation_Transmute("Mixture", "SpawnPos")
			NewItemName = "Secret Mixture"
			RefreshTime = 10
		elseif EvocationResult < 190 and EvocationResult >= 130 then
			ms_001_makeevocation_Transmute("Toadslime", "SpawnPos")
			NewItemName = "Toadslime"
			RefreshTime = 6
		elseif EvocationResult < 130 and EvocationResult >= 90 then
			ms_001_makeevocation_Transmute("Fruit", "SpawnPos")
			NewItemName = "Fruit"
			RefreshTime = 1
			MarginalSucc = 1
		elseif EvocationResult < 50 then
			ms_001_makeevocation_DoPoison(3, 8, "SpawnPos")
			RefreshTime = 8
			GotPoisoned = 1
		else
			ms_001_makeevocation_Nothing()
		end
	--iron to iron or silver or gold
	elseif ItemGetID(ItemName[ItemIndex]) == 241 then	--iron
		OldItemName = "Iron"
		if EvocationResult >= 130 then
			ms_001_makeevocation_Transmute("Gold", "SpawnPos")
			RefreshTime = 3
			NewItemName = "Gold"
		elseif EvocationResult < 130 and EvocationResult >= 90 then
			ms_001_makeevocation_Transmute("Silver", "SpawnPos")
			NewItemName = "Silver"
			RefreshTime = 1
		elseif EvocationResult < 90 and EvocationResult >= 50 then
			ms_001_makeevocation_Transmute("Iron", "SpawnPos")
			NewItemName = "Iron"
			RefreshTime = 1
			GotSame = 1
		else
			ms_001_makeevocation_Nothing()
		end
	--silver to iron or gold or silver
	elseif ItemGetID(ItemName[ItemIndex]) == 242 then	--silver
		OldItemName = "Silver"
		if EvocationResult >= 110 then
			ms_001_makeevocation_Transmute("Gold", "SpawnPos")
			RefreshTime = 3
			NewItemName = "Gold"
		elseif EvocationResult < 110 and EvocationResult >= 70 then
			ms_001_makeevocation_Transmute("Silver", "SpawnPos")
			NewItemName = "Silver"
			RefreshTime = 1
			GotSame = 1
		elseif EvocationResult < 70 and EvocationResult >= 30 then
			ms_001_makeevocation_Transmute("Iron", "SpawnPos")
			NewItemName = "Iron"
			RefreshTime = 1
			GotLesser = 1
		else
			ms_001_makeevocation_Nothing()
		end
	--gold to iron or silver or gold or gemstones
	elseif ItemGetID(ItemName[ItemIndex]) == 243 then	--gold
		OldItemName = "Gold"
		if EvocationResult >= 150 then
			ms_001_makeevocation_Transmute("Gemstone", "SpawnPos")
			RefreshTime = 5
			NewItemName = "Precious Stones"
		elseif EvocationResult < 150 and EvocationResult >= 110 then
			ms_001_makeevocation_Transmute("Gold", "SpawnPos")
			RefreshTime = 3
			NewItemName = "Gold"
			GotSame = 1
		elseif EvocationResult < 110 and EvocationResult >= 70 then
			ms_001_makeevocation_Transmute("Silver", "SpawnPos")
			NewItemName = "Silver"
			RefreshTime = 1
			GotLesser = 1
		elseif EvocationResult < 70 and EvocationResult >= 30 then
			ms_001_makeevocation_Transmute("Iron", "SpawnPos")
			NewItemName = "Iron"
			RefreshTime = 1
			GotLesser = 1
		else
			ms_001_makeevocation_Nothing()
		end
	--gemstone to money
	elseif ItemGetID(ItemName[ItemIndex]) == 244 then	--gemstone
		if EvocationResult >= 130 then
			OldItemName = "Precious Stones"
			StartSingleShotParticle("particles/change_effect.nif", "SpawnPos", 0.7,2)
			PlaySound3D("","Effects/mystic_gift+0.wav", 1.0)
			SumGold = chr_RecieveMoney("",ArcaneKnowledge*20+Rand(ArcaneKnowledge*100)+Rand(600),"IncomeOther")
			RefreshTime = 8
			GotMoney = 1
		else
			ms_001_makeevocation_Nothing()
		end
	--herring to +Rhetoric or fried herring or -Rhetoric
	elseif ItemGetID(ItemName[ItemIndex]) == 310 then	--Herring
		OldItemName = "Herring"
		if EvocationResult >= 130 then
			ms_001_makeevocation_SkillUp("rhetoric", 8, "SpawnPos")
			GotSkillUp = 1
			RefreshTime = 8
			NewItemName = "Rhetoric skill"
		elseif EvocationResult < 130 and EvocationResult >= 90 then
			ms_001_makeevocation_Transmute("FriedHerring", "SpawnPos")
			NewItemName = "Fried Herring"
			RefreshTime = 1
			MarginalSucc = 1
		elseif EvocationResult < 50 then
			ms_001_makeevocation_SkillDown("rhetoric", 8, "SpawnPos")
			GotSkillDown = 1
			RefreshTime = 8
			NewItemName = "Rhetoric skill"
		else
			ms_001_makeevocation_Nothing()
		end
	--salmon to +empathy or smoked salmon or -empathy
	elseif ItemGetID(ItemName[ItemIndex]) == 311 then	--Salmon
		OldItemName = "Salmon"
		if EvocationResult >= 130 then
			ms_001_makeevocation_SkillUp("empathy", 8, "SpawnPos")
			GotSkillUp = 1
			RefreshTime = 12
			NewItemName = "Empathy"
		elseif EvocationResult < 130 and EvocationResult >= 90 then
			ms_001_makeevocation_Transmute("SmokedSalmon", "SpawnPos")
			NewItemName = "Smoked Salmon"
			RefreshTime = 1
			MarginalSucc = 1
		elseif EvocationResult < 50 then
			ms_001_makeevocation_SkillDown("empathy", 8, "SpawnPos")
			GotSkillDown = 1
			RefreshTime = 12
			NewItemName = "Empathy"
		else
			ms_001_makeevocation_Nothing()
		end
	--shell to Mussel Soup or Iron Cap
	elseif ItemGetID(ItemName[ItemIndex]) == 313 then	--Shell
		OldItemName = "Mussels"
		if EvocationResult >= 140 then
			ms_001_makeevocation_Transmute("IronCap", "SpawnPos")
			RefreshTime = 12
			NewItemName = "an Iron Cap"
		elseif EvocationResult < 140 and EvocationResult >= 90 then
			ms_001_makeevocation_Transmute("Shellsoup", "SpawnPos")
			NewItemName = "Mussel soup"
			RefreshTime = 1
			MarginalSucc = 1
		else
			ms_001_makeevocation_Nothing()
		end
	--Willow Withe to +Speed or Barley or -Speed
	elseif ItemGetID(ItemName[ItemIndex]) == 569 then	--Willowrot
		OldItemName = "Willow Withe"
		if EvocationResult >= 130 then
			nSpeed = ArcaneKnowledge/10
			if nSpeed > 1 then
				nSpeed = 1
			end
			ms_001_makeevocation_SpeedAdjust(1+nSpeed, 6, "SpawnPos")
			GotSpeedUp = 1
			RefreshTime = 8
		elseif EvocationResult < 130 and EvocationResult >= 90 then
			ms_001_makeevocation_Transmute("SmokedSalmon", "SpawnPos")
			NewItemName = "Smoked Salmon"
			RefreshTime = 1
			MarginalSucc = 1
		elseif EvocationResult < 50 then
			nSpeed = 0.5
			ms_001_makeevocation_SpeedAdjust(nSpeed, 6, "SpawnPos")
			GotSpeedDown = 1
			RefreshTime = 8
		else
			ms_001_makeevocation_Nothing()
		end
	--Honey to Medicine or salve or mead
	elseif ItemGetID(ItemName[ItemIndex]) == 940 then	--Honey
		OldItemName = "Honey"
		if EvocationResult >= 150 then
			ms_001_makeevocation_Transmute("Mead", "SpawnPos")
			NewItemName = "Mead"
			RefreshTime = 6
		elseif EvocationResult < 150 and EvocationResult >= 110 then
			ms_001_makeevocation_Transmute("Salve", "SpawnPos")
			NewItemName = "Ointment"
			RefreshTime = 3
		elseif EvocationResult < 110 and EvocationResult >= 70 then
			ms_001_makeevocation_Transmute("Medicine", "SpawnPos")
			NewItemName = "Medicine"
			RefreshTime = 1
			--MarginalSucc = 1
		else
			ms_001_makeevocation_Nothing()
		end
	--Fruit to +Dexterity or Alcohol or -Dexterity
	elseif ItemGetID(ItemName[ItemIndex]) == 941 then	--Fruit
		OldItemName = "Fruit"
		if EvocationResult >= 130 then
			ms_001_makeevocation_SkillUp("dexterity", 8, "SpawnPos")
			GotSkillUp = 1
			RefreshTime = 12
			NewItemName = "Dexterity"
		elseif EvocationResult < 130 and EvocationResult >= 90 then
			ms_001_makeevocation_Transmute("Alcohol", "SpawnPos")
			NewItemName = "Alcohol"
			RefreshTime = 1
			MarginalSucc = 1
		elseif EvocationResult < 50 then
			ms_001_makeevocation_SkillDown("dexterity", 8, "SpawnPos")
			GotSkillDown = 1
			RefreshTime = 12
			NewItemName = "Dexterity"
		else
			ms_001_makeevocation_Nothing()
		end
	--Skull to +Arcane Knowledge or Ectoplasm or -Arcane Knowledge
	elseif ItemGetID(ItemName[ItemIndex]) == 972 then	--Skull
		OldItemName = "Skull"
		if EvocationResult >= 130 then
			ms_001_makeevocation_SkillUp("secret_knowledge", 8, "SpawnPos")
			GotSkillUp = 1
			RefreshTime = 12
			NewItemName = "Arcane Knowledge"
		elseif EvocationResult < 130 and EvocationResult >= 90 then
			ms_001_makeevocation_Transmute("Ektoplasma", "SpawnPos")
			NewItemName = "Ectoplasm"
			RefreshTime = 1
			MarginalSucc = 1
		elseif EvocationResult < 50 then
			ms_001_makeevocation_SkillDown("secret_knowledge", 8, "SpawnPos")
			GotSkillDown = 1
			RefreshTime = 12
			NewItemName = "Arcane Knowledge"
		else
			ms_001_makeevocation_Nothing()
		end
	--Bones to +XP or Ectoplasm or -All Stats
	elseif ItemGetID(ItemName[ItemIndex]) == 973 then	--Bone
		OldItemName = "Bones"
		if EvocationResult >= 180 then
			StartSingleShotParticle("particles/change_effect.nif", "SpawnPos", 0.7,2)
			PlaySound3D("","Effects/mystic_gift+0.wav", 1.0)
			GotXP = 1
			RefreshTime = 18
			XPGain = 100 + ArcaneKnowledge*10
			chr_GainXP("", XPGain)
		elseif EvocationResult < 180 and EvocationResult >= 140 then
			ms_001_makeevocation_Transmute("Ektoplasma", "SpawnPos")
			NewItemName = "Ectoplasm"
			RefreshTime = 1
			MarginalSucc = 1
		elseif EvocationResult < 100 then
			ms_001_makeevocation_AllSkillsDown(24, "SpawnPos")
			GotAllSkillsDown = 1
			RefreshTime = 18
		else
			ms_001_makeevocation_Nothing()
		end
	--no item?
	else
		SetData("SummonComplete",1)
		PlayAnimation("","cogitate")
		RefreshTime = 1
		StopMeasure()
	end


	RefreshTime = RefreshTime - chr_ArtifactsDuration("",RefreshTime)
	SetMeasureRepeat(RefreshTime)


	if GotMoney == 1 then
		feedback_MessageWorkshop("","@L_ALCHEMIST_001_MAKEEVOCATION_GOLDSUCCESS_HEAD_+0",	
						"Using all of your arcane powers, you managed to convert %1l into %2t.", OldItemName, SumGold)
	elseif MarginalSucc == 1 then
		feedback_MessageWorkshop("","@L_ALCHEMIST_001_MAKEEVOCATION_GOLDSUCCESS_HEAD_+0",
						"Your magic worked, but you only turned the " .. OldItemName .. " into " .. NewItemName .. ".$NYou can do better with more skill... or more luck.")
	elseif GotSame == 1 then
		feedback_MessageWorkshop("","@L_ALCHEMIST_001_MAKEEVOCATION_FAILED_HEAD_+0",
						"The material used is unchanged by your alchemical efforts.$NThe " .. OldItemName .. " remains " .. OldItemName .. ".")
	elseif GotLesser == 1 then
		feedback_MessageWorkshop("","@L_ALCHEMIST_001_MAKEEVOCATION_FAILED_HEAD_+0",
						"The material used was degraded by your alchemical efforts.$NThe " .. OldItemName .. " is now " .. NewItemName .. ".")
	elseif GotSkillUp == 1 then
		feedback_MessageWorkshop("","@L_ALCHEMIST_001_MAKEEVOCATION_GOLDSUCCESS_HEAD_+0",
						"Your magic has temporarily enhanced your " .. NewItemName .. "!")
	elseif GotSkillDown == 1 then
		feedback_MessageWorkshop("","@L_ALCHEMIST_001_MAKEEVOCATION_FAILED_HEAD_+0",
						"Something went wrong and your " .. NewItemName .. " has been temporarily reduced!$NYou are not skilled enough to work magic properly yet.")
	elseif GotPoisoned == 1 then
		feedback_MessageWorkshop("","@L_ALCHEMIST_001_MAKEEVOCATION_FAILED_HEAD_+0",
						"Something went wrong and you ended up getting yourself poisoned!$NYou are not skilled enough to work magic properly yet.")
		feedback_MessageWorkshop("","@L_MEASURE_USEPOISON_HEAD_+0",
						"Better get yourself some antidote!")
	elseif GotSpeedUp == 1 then
		feedback_MessageWorkshop("","@L_ALCHEMIST_001_MAKEEVOCATION_GOLDSUCCESS_HEAD_+0",
						"Your movement speed has been temporarily increased by " .. nSpeed*100 .. "%!")
	elseif GotSpeedDown == 1 then
		feedback_MessageWorkshop("","@L_ALCHEMIST_001_MAKEEVOCATION_FAILED_HEAD_+0",
						"Your magic went awry and your movement speed has been temporarily decreased to half! Otherwise, you're fine.$NYou are not skilled enough to work magic properly yet.")
	elseif GotXP == 1 then
		feedback_MessageWorkshop("","@L_ALCHEMIST_001_MAKEEVOCATION_GOLDSUCCESS_HEAD_+0",
						"Your magic produced a vision that gave you insight into the nature of reality.$NYou have gained some extra Experience Points as a result.")
	elseif GotAllSkillsDown == 1 then
		--nothing - message is in ms_001_makeevocation_AllSkillsDown
	elseif GotYouth == 1 then
		feedback_MessageWorkshop("","@L_ALCHEMIST_001_MAKEEVOCATION_GOLDSUCCESS_HEAD_+0",
						"Your magic has extended your life span!$NYou will live slightly longer.")
	else
		feedback_MessageWorkshop("","@L_ALCHEMIST_001_MAKEEVOCATION_GOLDSUCCESS_HEAD_+0",
						"You turned " .. OldItemName .. " into " .. NewItemName .. "!")
	end

	SetData("SummonComplete",1)
	
	Sleep(2)
	
	if GotSkillDown == 1  or GotPoisoned == 1 or GotSpeedDown == 1 or GotAllSkillsDown == 1 then
		--no xp
	else
		chr_GainXP("",GetData("BaseXP"))
	end

	StopMeasure()
end





--functions start here

function AllSkillsUp(EnhanceAmount, EnhanceDuration, SpawnPos)
	StartSingleShotParticle("particles/change_effect.nif", "SpawnPos", 0.7,2)
	PlaySound3D("","Effects/mystic_gift+0.wav", 1.0)
	PlaySound("levelup/levelup.ogg") --could use a better sound
	GetPosition("", "EffectPosition")
	StartSingleShotParticle("particles/sparkle_talents.nif", "EffectPosition",1,5)

	local SkillArray = {"constitution","dexterity","charisma","fighting","craftsmanship",
					"shadow_arts","rhetoric","empathy","bargaining","secret_knowledge"}
	local NumSkills = 10
	
	EnhanceDuration = EnhanceDuration + chr_ArtifactsDuration("",EnhanceDuration)
	
	for i=1,NumSkills do
		AddImpact("",SkillArray[i],EnhanceAmount,EnhanceDuration)
	end
	
	feedback_MessageWorkshop("","@L_ALCHEMIST_001_MAKEEVOCATION_GOLDSUCCESS_HEAD_+0",
				"Something unexpected occurred.$NFor a moment, you felt like you understood EVERYTHING!!$NYou are vibrating with arcane power.$NAll your skills are enhanced for the next day or so.")
	
	chr_GainXP("",GetData("BaseXP"))
	
	Sleep(2)
	for i=1,NumSkills do
		feedback_OverheadSkill("", "@L_ARTEFACTS_OVERHEAD_+0", false,
		"@L_TALENTS_"..SkillArray[i].."_ICON_+0", "@L_TALENTS_"..SkillArray[i].."_NAME_+0", EnhanceAmount)
		Sleep(1)
	end

end


function AllSkillsDown(DepressDuration, SpawnPos)
	StartSingleShotParticle("particles/change_effect.nif", "SpawnPos", 0.7,2)
	PlaySound3D("","Effects/mystic_gift+0.wav", 1.0)
	PlaySound3D("","ambient/lightning_thunder_strong/lightning_thunder_strong+2.wav", 1.0)
	PlaySound("ambient/lightning_thunder/lightning_thunder+2.wav")
	
	GetPosition("", "EffectPosition")
	StartSingleShotParticle("particles/sparkle_talents.nif", "EffectPosition",1,5)
	local skillmodify = -3

	local SkillArray = {"constitution","dexterity","charisma","fighting","craftsmanship",
					"shadow_arts","rhetoric","empathy","bargaining","secret_knowledge"}
	local NumSkills = 10
		
	DepressDuration = DepressDuration - chr_ArtifactsDuration("",DepressDuration)
		
	for i=1,NumSkills do
		AddImpact("",SkillArray[i],skillmodify,DepressDuration)
	end
	
	feedback_MessageWorkshop("","@L_ALCHEMIST_001_MAKEEVOCATION_FAILED_HEAD_+0",
					"Your magic has shown you some disturbing things about reality. You are depressed.$NAll your abilities are reduced for the next day or so.$NOnly those with great understanding of the arcane are be able to handle certain truths.")
					
	Sleep(2)
	for i=1,NumSkills do
		feedback_OverheadSkill("", "@L_ARTEFACTS_OVERHEAD_+1", false,
		"@L_TALENTS_"..SkillArray[i].."_ICON_+0", "@L_TALENTS_"..SkillArray[i].."_NAME_+0", math.abs(skillmodify))
		Sleep(1)
	end
end

function SpeedAdjust(Speed, SpeedDuration, SpawnPos)
	StartSingleShotParticle("particles/change_effect.nif", "SpawnPos", 0.7,2)
	PlaySound3D("","Effects/mystic_gift+0.wav", 1.0)
	GetPosition("", "EffectPosition")
	StartSingleShotParticle("particles/sparkle_talents.nif", "EffectPosition",1,5)

	if Speed < 1 then
		SpeedDuration = SpeedDuration - chr_ArtifactsDuration("",SpeedDuration)
		ShowOverheadSymbol("", false, false, 0, "Speed $C[255,50,50]-" .. math.abs(Speed-1)*100 .. "%")	
	elseif Speed > 1 then
		SpeedDuration = SpeedDuration + chr_ArtifactsDuration("",SpeedDuration)
		ShowOverheadSymbol("", false, false, 0, "Speed $C[50,255,50]+" .. (Speed-1)*100 .. "%")
	end
	AddImpact("","MoveSpeed",Speed,SpeedDuration)
end

function DoYouth(SpawnPos)
	GetPosition("", "EffectPosition")

	StartSingleShotParticle("particles/change_effect.nif", "SpawnPos", 0.7,2)
	PlaySound3D("","Effects/mystic_gift+0.wav", 1.0)
	AddImpact("","LifeExpanding",1,-1)
	StartSingleShotParticle("particles/pray_glow.nif","EffectPosition",1,4)
end

function DoPoison(PoisonType, PoisonDuration, SpawnPos)
	--PoisonType: 2 = paralytic poison, 3 = damaging poison (only 3 is used in the script)
	--GetPosition("", "EffectPosition")
	StartSingleShotParticle("particles/toadexcrements_hit.nif", "SpawnPos",4,3)
	StartSingleShotParticle("particles/change_effect.nif", "SpawnPos", 0.7,2)
	PlaySound3D("","Effects/mystic_gift+0.wav", 1.0)

	AddImpact("","poisoned",1,PoisonDuration)
	SetProperty("","poisoned",PoisonType)
	SetState("",STATE_POISONED,true)
	--AddImpact("","MoveSpeed",0.6,duration) --for paralytic poison

	--play male/female hurt sound
	if SimGetGender("") == GL_GENDER_MALE then
		PlaySound3D("","CharacterFX/male_pain_short/male_pain_short+2.ogg", 1.0)
	else
		PlaySound3D("","CharacterFX/female_pain_short/female_pain_short+2.ogg", 1.0)
	end
end

function SkillUp(Skill, UpDuration, SpawnPos)
	StartSingleShotParticle("particles/change_effect.nif", "SpawnPos", 0.7,2)
	GetPosition("", "EffectPosition")
	StartSingleShotParticle("particles/sparkle_talents.nif", "EffectPosition",1,5)
	PlaySound3D("","Effects/mystic_gift+0.wav", 1.0)
	local skillmodify = math.ceil(GetSkillValue("",10)/4)	--1 to 4 points (at level 13)
	UpDuration = UpDuration + chr_ArtifactsDuration("",UpDuration)
	AddImpact("",Skill,skillmodify,UpDuration)

	feedback_OverheadSkill("", "@L_ARTEFACTS_OVERHEAD_+0", false,
			"@L_TALENTS_"..Skill.."_ICON_+0", "@L_TALENTS_"..Skill.."_NAME_+0", skillmodify)
end

function SkillDown(Skill, DownDuration, SpawnPos)
	local skillmodify = -4

	StartSingleShotParticle("particles/change_effect.nif", "SpawnPos", 0.7,2)
	GetPosition("", "EffectPosition")
	StartSingleShotParticle("particles/sparkle_talents.nif", "EffectPosition",1,5)
	PlaySound3D("","Effects/mystic_gift+0.wav", 1.0)
	PlaySound3D("","ambient/lightning_thunder_strong/lightning_thunder_strong+2.wav", 1.0)
	DownDuration = DownDuration - chr_ArtifactsDuration("",DownDuration)
	AddImpact("",Skill,skillmodify,DownDuration)

	feedback_OverheadSkill("", "@L_ARTEFACTS_OVERHEAD_+1", false,
			"@L_TALENTS_"..Skill.."_ICON_+0", "@L_TALENTS_"..Skill.."_NAME_+0", math.abs(skillmodify))
end

function Transmute(ItemString, SpawnPos)
	StartSingleShotParticle("particles/change_effect.nif", "SpawnPos", 0.7,2)
	PlaySound3D("","Effects/mystic_gift+0.wav", 1.0)
	AddItems("", ItemString, 1)
end


function Nothing()
	StartSingleShotParticle("particles/toadexcrements_hit.nif", "SpawnPos", 1.3,5)
	feedback_MessageWorkshop("","@L_ALCHEMIST_001_MAKEEVOCATION_FAILED_HEAD_+0",
					"@L_ALCHEMIST_001_MAKEEVOCATION_FAILED_BODY_+0")
	SetData("SummonComplete",1)
	local RefreshTime = 1
	RefreshTime = RefreshTime - chr_ArtifactsDuration("",RefreshTime)
	SetMeasureRepeat(RefreshTime)
	StopMeasure()
end

function AIDecide()
	NumItems = GetData("NumItems")
	return "A"..NumItems
end

function CleanUp()
	MsgMeasure("","")
	if GetData("SummonComplete") == 0 then
		AddItems("",GetData("ItemUsed"),1,INVENTORY_STD)
	end
	RemoveOverheadSymbols("")

end

function GetOSHData(MeasureID)
	--can be used again in:
	OSHSetMeasureRepeat("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+2",Gametime2Total(mdata_GetTimeOut(MeasureID)))
end


