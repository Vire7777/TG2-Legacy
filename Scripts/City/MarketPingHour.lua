
function GameStart()

	if not GetSettlement("", "City") then
		return 0
	end
	
	if CityIsKontor("City") then
		return 0
	end
	
	local Level = CityGetLevel("City")
	
	marketpinghour_CheckItem(Level, "FlowerOfDiscord", 1, 3)
	marketpinghour_CheckItem(Level, "Perfume", 4, 8)
	marketpinghour_CheckItem(Level, "CartBooster", 4, 10)
	marketpinghour_CheckItem(Level, "AboutTalents1", 3, 9)
	marketpinghour_CheckItem(Level, "Poem", 1, 2)
	marketpinghour_CheckItem(Level, "CamouflageCloak", 1, 3)
	marketpinghour_CheckItem(Level, "GlovesOfDexterity", 0, 2)
	marketpinghour_CheckItem(Level, "MoneyBag", 1, 3)
	marketpinghour_CheckItem(Level, "WalkingStick",2, 6)
	marketpinghour_CheckItem(Level, "BeltOfMetaphysic",0, 1)
	marketpinghour_CheckItem(Level, "Mead", 4, 8)
	marketpinghour_CheckItem(Level, "Cake", 2, 4)
	marketpinghour_CheckItem(Level, "Antidote", 2, 4)
	marketpinghour_CheckItem(Level, "Dagger", 2, 4)
	marketpinghour_CheckItem(Level, "SilverRing", 4, 8)
	marketpinghour_CheckItem(Level, "FarmersClothes", 4, 8)
	marketpinghour_CheckItem(Level, "Charcoal", 4, 12)
	marketpinghour_CheckItem(Level, "Wool", 4, 12)
	marketpinghour_CheckItem(Level, "Iron", 4, 12)
	marketpinghour_CheckItem(Level, "Silver", 4, 12)
	marketpinghour_CheckItem(Level, "Oakwood", 4, 12)
	marketpinghour_CheckItem(Level, "Pinewood", 4, 12)
	marketpinghour_CheckItem(Level, "Leather", 4, 12)
	marketpinghour_CheckItem(Level, "Wheat", 4, 12)
	marketpinghour_CheckItem(Level, "Barley", 4, 12)
	marketpinghour_CheckItem(Level, "Fungi", 4, 12)
	marketpinghour_CheckItem(Level, "Blackberry", 2, 8)
	marketpinghour_CheckItem(Level, "Fruit", 4, 12)
	marketpinghour_CheckItem(Level, "Honey", 4, 12)
	marketpinghour_CheckItem(Level, "WheatFlour", 4, 12)
	marketpinghour_CheckItem(Level, "BarleyFlour", 4, 12)
	marketpinghour_CheckItem(Level, "Dye", 4, 12)
	marketpinghour_CheckItem(Level, "Round", 1, 2)

	GetScenario("World")
	if HasProperty("World","seamap") then
		marketpinghour_CheckItem(Level, "Herring", 4, 12)
		marketpinghour_CheckItem(Level, "Salmon", 2, 4)
	else
		marketpinghour_CheckItem(Level, "Herring", 6, 18)
		marketpinghour_CheckItem(Level, "Salmon", 3, 6)
	end
end


function PingHour()
	marketpinghour_RemoveItemMarket()
	
	GetScenario("World")
	if not HasProperty("World","seamap") then
		if GetSettlement("", "City") then
			if not CityIsKontor("City") then
				local Level = CityGetLevel("City")
				if Rand(4)==0 then
					marketpinghour_CheckItem(Level, "Herring", 6, 18)
				end
				if Rand(5)==0 then
					marketpinghour_CheckItem(Level, "Salmon", 3, 6)
				end
			end
		end
	end
end


function CheckItem(CityLevel, Item, MinCount, MaxCount)
	local Wanted = 0

	if MinCount == -1 then
		local	Value = 3 + 2*GetRound()
		if Rand(Value)==0 then
			Wanted = 1
		end	
	else
		Wanted = MinCount + math.floor( (Rand(5) + MaxCount - MinCount)*CityLevel/5)
	end

	local Count = GetItemCount("", Item, INVENTORY_STD)
	if Count < Wanted then
		AddItems("", Item, Wanted - Count, INVENTORY_STD)
	end
end


function RemoveItemMarket()
	if not GetSettlement("", "City") then
		return 0
	end

	if CityIsKontor("City") then
		return 0
	end

 local chance, Name, Baseprice, Sellprice
 local Reducevalue = Rand(6)
 local item = {
		"Barleybread", "Cookie", "Wheatbread", "Cake", "BreadRoll", "CreamPie", "Candy",
		"vase", "GrainPap", "SmallBeer", "SalmonFilet", "WheatBeer", "Mead", "RoastBeef",
		"BoozyBreathBeer", "GhostlyFog", "Tool", "Dagger", "SilverRing", "Shortsword", "IronBrachelet",
		"GemRing", "BeltOfMetaphysic", "GoldChain", "Longsword", "IronCap", "Chainmail",
		"FullHelmet", "Platemail", "OakwoodRing", "BuildMaterial", "Torch", "WalkingStick",
		"Mace", "CrossOfProtection", "RubinStaff", "Axe", "Cloth", "MoneyBag", "Blanket",
		"FarmersClothes", "LeatherArmor", "CitizensClothes", "GlovesOfDexterity", "NoblesClothes",
		"CamouflageCloak", "LeatherGloves", "HerbTea", "Perfume", "DartagnansFragrance",
		"DrFaustusElixir", "FragranceOfHoliness", "FlowerOfDiscord", "ToadExcrements", 
		"Toadslime", "CartBooster", "BoobyTrap", "Housel", "Poem", "Chaplet", "AboutTalents1",
		"LetterOfIndulgence", "LetterFromRome", "ThesisPaper", "AboutTalents2", "Shellchain", 
		"FriedHerring", "Shellsoup", "SmokedSalmon", "StinkBomb", "Pearlchain", "Bandage",
		"Soap", "MiracleCure", "Salve", "Medicine", "StaffOfAesculap", "Mixture", "MediPack",
		"PainKiller","WeaponPoison", "Antidote", "ParalysisPoison", "BlackWidowPoison", "Amulet",
		"Hasstirade", "Handwerksurkunde", "Kamm", "Holzzapfen", "Beschlag", "Stonerotary",
		"bust", "statue", "Blissstone", "Optigold", "Optisilber", "Optieisen", "Goldveryhigh",
		"Goldmedhigh", "Goldlowmed", "Urkunde", "Schuldenbrief", "HexerdokumentII", 
		"HexerdokumentI", "Schadelkerze", "Dye", "Knochenarmreif", "Pendel", "Spindel",
		"Voodo", "Robe", "Pddv", "Round"
		}
 
	for i=0, 114 do
	Name = item[i]

		if (Name ~= nil) then
		Baseprice = ItemGetBasePrice(Name)
		NewBaseprice = Baseprice - math.floor((Baseprice / 100 * 10))
		Sellprice = ItemGetPriceSell(Name, "") 
			if Sellprice < NewBaseprice then
			RemoveItems ("", Name, Reducevalue, INVENTORY_STD)
			end 

		end
	end
end