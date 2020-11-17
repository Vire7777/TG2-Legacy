-- -----------------------
-- Init
-- -----------------------
function Init()
 --needed for caching
end

-- -----------------------
-- GetEmployeesInBuilding
-- -----------------------
function GetEmployeesInBuilding(BuildingAlias)

	WorkerCount = BuildingGetWorkerCount(BuildingAlias)
	Counter = WorkerCount
	while(Counter>0) do		
	
		BuildingGetWorker(BuildingAlias, Counter-1, "EmployeeNr"..Counter)
		Counter = Counter - 1
		
	end

	return WorkerCount

end

-- ------------------
-- GetScaffoldOffsets
-- ------------------
function GetScaffoldOffsets(Proto)
	
	local OffsetX = 0
	local OffsetZ = 0

	if Proto == 100 then -- Barnyard (Hufe)
		OffsetX = -780
		OffsetZ = 240
	elseif Proto == 101 then -- Farm (Bauernhof)
		OffsetX = -850
		OffsetZ = 350
	elseif Proto == 102 then -- FarmEstate (Gutshof)
		OffsetX = -850
		OffsetZ = -150
	elseif Proto == 120 then -- BreadShop (Backstube)
		OffsetX = 100
		OffsetZ = -30
	elseif Proto == 121 then -- Bakery2 (Bäckerei)
		OffsetX = 50
		OffsetZ = -80
	elseif Proto == 122 then -- PastryShop (Konditorei)
		OffsetX = 55
		OffsetZ = -15
	elseif Proto == 130 then -- Taproom (Schänke)
		OffsetX = -10
		OffsetZ = -100
	elseif Proto == 131 then -- Inn (Taverne)
		OffsetX = 50
		OffsetZ = 0
	elseif Proto == 132 then -- Tavern (Gasthaus)
		OffsetX = 0
		OffsetZ = -180
	elseif Proto == 140 then -- Foundry (Giesserei)
		OffsetX = 50
		OffsetZ = 20
	elseif Proto == 141 then -- Smithy (Schmiede)
		OffsetX = 250
		OffsetZ = -110
	elseif Proto == 142 then -- Goldsmithy (Goldschmiede)
		OffsetX = 160
		OffsetZ = -105
	elseif Proto == 143 then -- CannonFoundry (Kanonengiesserei)
		OffsetX = 300
		OffsetZ = -140
	elseif Proto == 144 then -- Armourer (Rüstungsschmiede)
		OffsetX = 60
		OffsetZ = -1750
	elseif Proto == 150 then -- Joinery (Tischlerei)
		OffsetX = 190
		OffsetZ = 560
	elseif Proto == 151 then -- Turnery (Drechslerei)
		OffsetX = 140
		OffsetZ = 150
	elseif Proto == 152 then -- Finejoinery (Kunsttischlerei)
		OffsetX = 20
		OffsetZ = -200
	elseif Proto == 160 then -- WeavingMill (Weberei)
		OffsetX = 0
		OffsetZ = -100
	elseif Proto == 161 then -- TailorShop (Schneiderei)
		OffsetX = -50
		OffsetZ = -25
	elseif Proto == 162 then -- Couturier (Schneiderei)
		OffsetX = -20
		OffsetZ = -60
	elseif Proto == 170 then -- Tinctury (Tinkturei)
		OffsetX = 15
		OffsetZ = -135
	elseif Proto == 171 then -- AlchemistParlour (Alchimistenstube)
		OffsetX = 70
		OffsetZ = -115
	elseif Proto == 172 then -- InventorWorkshop (Erfinderwerkstatt)
		OffsetX = 100
		OffsetZ = -100
	elseif Proto == 173 then -- GloomyParlour (Zauberstube)
		OffsetX = 140
		OffsetZ = -130
	elseif Proto == 174 then -- SorcererHouse (Magiergilde)
		OffsetX = 300
		OffsetZ = -1350
	elseif Proto == 190 then -- ev.Church (Kirche)
		OffsetX = -40
		OffsetZ = 90
	elseif Proto == 191 then -- ev.Minster (ev.Dom)
		OffsetX = 60
		OffsetZ = 30
	elseif Proto == 192 then -- ev.Cathedral (ev.Kathedrale)
		OffsetX = 220
		OffsetZ = -300
	elseif Proto == 193 then -- kath.Church (kath.Kirche)
		OffsetX = -50
		OffsetZ = 80
	elseif Proto == 194 then -- kath.Minster (kath.Dom)
		OffsetX = 80
		OffsetZ = -100
	elseif Proto == 195 then -- kath.Cathedral (kath.Kathedrale)
		OffsetX = 280
		OffsetZ = -400
	elseif Proto == 230 then -- robber low
		OffsetX = -450
		OffsetZ = -200
	elseif Proto == 231 then -- robber med
		OffsetX = -450
		OffsetZ = -200
	elseif Proto == 240 then -- SmugglerHole (Schmugglerloch)
		OffsetX = 15
		OffsetZ = -100
	elseif Proto == 241 then -- ThievesShelter (Diebesunterschlupf)
		OffsetX = 30
		OffsetZ = -180
	elseif Proto == 242 then -- ThievesGuild (Diebesgilde)
		OffsetX = 130
		OffsetZ = -370
	elseif Proto == 270 then -- rangerhut
		OffsetX = 220
		OffsetZ = -160
	elseif Proto == 300 then -- Pawnshop (Pfandhaus)
		OffsetX = 100
		OffsetZ = -115
	elseif Proto == 301 then -- BankingHouse (Bank)
		OffsetX = 100
		OffsetZ = -1400
	elseif Proto == 310 then -- ConventionHouse (Versammlungshaus)
		OffsetX = -320
		OffsetZ = 60
	elseif Proto == 311 then -- TownHall (Rathaus)
		OffsetX = 100
		OffsetZ = -1950
	elseif Proto == 312 then -- CouncilPalace (Ratspalast)
		OffsetX = 200
		OffsetZ = -2200
	elseif Proto == 330 then -- Dungeon (Schuldturm)
		OffsetX = -30
		OffsetZ = 200
	elseif Proto == 331 then -- Prison (Kerker)
		OffsetX = 80
		OffsetZ = 330
	elseif Proto == 340 then -- School (Schule)
		OffsetX = 10
		OffsetZ = -130
	elseif Proto == 341 then -- University (Universität)
		OffsetX = 200
		OffsetZ = -440
	elseif Proto == 200 then -- Watchtower1
		OffsetX = 180
		OffsetZ = -150
	elseif Proto == 201 then -- Watchtower2
		OffsetX = 180
		OffsetZ = -100
	elseif Proto == 202 then -- Watchtower3
		OffsetX = 180
		OffsetZ = -100
	elseif Proto == 365 then -- Warehouse (Warenhaus)
		OffsetX = 750
		OffsetZ = -1900
	elseif Proto == 370 then -- Fishinghut1
		OffsetX = 0
		OffsetZ = -1150
	elseif Proto == 371 then -- Fishinghut2
		OffsetX = 0
		OffsetZ = -1150
	elseif Proto == 372 then -- Fishinghut3
		OffsetX = -100
		OffsetZ = -900
	elseif Proto == 390 then -- Hospital1
		OffsetX = -180
		OffsetZ = -1050
	elseif Proto == 391 then -- Hospital2
		OffsetX = 50
		OffsetZ = -75
	elseif Proto == 392 then -- Hospital3
		OffsetX = 150
		OffsetZ = -200
	elseif Proto == 430 then -- WorkersHut1 (Arbeiterhaus)
		OffsetX = 0
		OffsetZ = -200
	elseif Proto == 431 then -- WorkersHut2 (Arbeiterhaus)
		OffsetX = 80
		OffsetZ = -200
	elseif Proto == 432 then -- WorkersHut3 (Arbeiterhaus)
		OffsetX = 40
		OffsetZ = -210
	elseif Proto == 440 then -- Hütte
		OffsetX = -45
		OffsetZ = -180
	elseif Proto == 441 then -- Haus
		OffsetX = -30
		OffsetZ = -160
	elseif Proto == 442 then -- Giebelhaus
		OffsetX = -50
		OffsetZ = -130
	elseif Proto == 443 then -- Patrizierhaus
		OffsetX = 20
		OffsetZ = -160
	elseif Proto == 444 then -- Herrenhaus
		OffsetX = 200
		OffsetZ = -300
	elseif Proto == 483 then -- Prison_lv3 (Gefängnis)
		OffsetX = 130
		OffsetZ = -330
	elseif Proto == 654 then -- Piratenest
		OffsetX = 750
		OffsetZ = -1900
	elseif Proto == 1001 then -- Piratenest
		OffsetX = 750
		OffsetZ = -1900
	elseif Proto == 1002 then -- Piratenest
		OffsetX = 750
		OffsetZ = -1900
	end
	
	return OffsetX, OffsetZ

end

function BauStuff(typeID,gebLVL,owner)
	local bNam,gLNam
	local nenr, gebId = 5, 1
	if typeID == 2 then
	    bNam = "Residence"
	elseif typeID == 3 then
	    bNam = "Farm"
	elseif typeID == 4 then
	    bNam = "Tavern"
	elseif typeID == 6 then
	    bNam = "Bakery"
	elseif typeID == 7 then
	    bNam = "Blacksmith"
		if BuildingGetProto(owner) == 141 or BuildingGetProto(owner) == 142 then
		    gebId = 5
		end
	elseif typeID == 8 then
	    bNam = "Joinery"
	elseif typeID == 9 then
	    bNam = "Couturier"
	elseif typeID == 11 then
	    bNam = "Piratesnest"
	elseif typeID == 12 then
	    bNam = "Mine"
	elseif typeID == 15 then
	    bNam = "Robber"
	elseif typeID == 16 then
	    bNam = "Alchemist"
		if BuildingGetProto(owner) == 173 or BuildingGetProto(owner) == 174 then
		    gebId = 5
		end
	elseif typeID == 18 then
	    bNam = "Rangerhut"
	elseif typeID == 19 or typeID == 20 then
	    bNam = "Church"
		if BuildingGetProto(owner) == 191 or BuildingGetProto(owner) == 192 then
		    gebId = 5
		end
	elseif typeID == 21 then
	    bNam = "Mercenary"
	elseif typeID == 22 then
	    bNam = "Thief"
	elseif typeID == 35 then
	    bNam = "Fishinghut"
	elseif typeID == 36 then
	    bNam = "Divehouse"
	elseif typeID == 37 then
	    bNam = "Hospital"
	elseif typeID == 38 then
	    bNam = "Warehouse"
	elseif typeID == 43 then
	    bNam = "Bank"
	elseif typeID == 98 then
	    bNam = "Friedhof"
	elseif typeID == 102 then
	    bNam = "Gaukler"
	elseif typeID == 104 then
	    bNam = "Mill"
	elseif typeID == 108 then
	    bNam = "Fruitfarm"
	elseif typeID == 110 then
	    bNam = "Stonemason"
	else
	    bNam = ""
	end	
	
	if gebLVL == 1 then
	    gLNam = "low"
  elseif gebLVL == 2 then
	    gLNam = "med"
	elseif gebLVL == 3 then
	    gLNam = "high"
	elseif gebLVL == 4 then
	    gLNam = "veryhigh"
	elseif gebLVL == 5 then
	    gLNam = "max"
	end
	
	return bNam, gLNam, nenr, gebId

end	