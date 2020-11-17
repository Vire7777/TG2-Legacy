function Init()

  ms_hpfz_autoroute_Karren()

	local routeRun = {}
  local slots = GetData("KarrenSlots")
	local checkOpti = { false, false, false, false }
	local checkRunde = 1
	local drinSafe = {}
	local slotA = {}
	for v=0, slots-1 do
	  local itID, itMenge = InventoryGetSlotInfo("",v,INVENTORY_STD)
		if itMenge and itMenge > 0 then
		  slotA[v+1] = false
			checkOpti[2] = true
		else
		  slotA[v+1] = true
			checkOpti[1] = true
		end
	end
	
	local once = 0
	local vorgang, was, wovon, wieviel, ort

	repeat
    local optionen = {"@B[1,@L_AUTOROUTE_INITIATE_OPTION_+0,]",
    									"@B[2,@L_AUTOROUTE_INITIATE_OPTION_+1,]",
    									"@B[3,@L_AUTOROUTE_INITIATE_OPTION_+2,]",
    									"@B[4,@L_AUTOROUTE_INITIATE_OPTION_+3,]",
    									"@B[5,@L_AUTOROUTE_INITIATE_OPTION_+4,]"}

    local optionen2 = ""
    if checkOpti[1] == true then
    	optionen2 = optionen2..optionen[1]
    end
    if checkOpti[2] == true then
    	optionen2 = optionen2..optionen[2]
    end
    if checkOpti[3] == true then
    	optionen2 = optionen2..optionen[3]
    end
    if checkOpti[4] == true then
    	optionen2 = optionen2..optionen[4]
    end
    optionen2 = optionen2..optionen[5]
    vorgang = MsgBox("","Owner","@P"..optionen2,"@L_AUTOROUTE_INITIATE_HEAD_+0","")	

		if vorgang == 5 then
			StopMeasure()
		end
		
	  if vorgang ~= 4 then
		  if ort == nil then
				ort = "Destination"
			end
      if vorgang == 1 then
		  	was = 1
	      wovon, wieviel, checkOpti[3] = ms_hpfz_autoroute_LogistikStand(ort,checkOpti[3])
				if wovon ~= 0 and wieviel ~= 0 then
					ms_hpfz_autoroute_KarrenLager(true, wovon, wieviel)
		      checkOpti[1],checkOpti[2],slotA[1],slotA[2],slotA[3] = ms_hpfz_autoroute_DieFormelA(true,slotA[1],slotA[2],slotA[3])
				end
      elseif vorgang == 2 then
		    was = 2
	      wovon, wieviel = ms_hpfz_autoroute_LogistikKarren()
				if wovon ~= 0 and wieviel ~= 0 then
					ms_hpfz_autoroute_KarrenLager(false, wovon, wieviel)
		      checkOpti[1],checkOpti[2],slotA[1],slotA[2],slotA[3] = ms_hpfz_autoroute_DieFormelA(false,slotA[1],slotA[2],slotA[3])
				end
	    elseif vorgang == 3 then
				ort, checkOpti[4] = ms_hpfz_autoroute_Wegpunkte(checkRunde)
      end
			if wovon ~= 0 and wieviel ~= 0 then
				if vorgang == 1 or vorgang == 2 then
	        SetData("Ort"..checkRunde, ort)
	        SetData("Was"..checkRunde, was)
	        SetData("Wovon"..checkRunde, wovon)
	        SetData("Wieviel"..checkRunde, wieviel)
					checkRunde = checkRunde + 1
			  end
			end
		end
	until vorgang == 4

	SetData("InfoAblauf",checkRunde)
	local intervall = MsgBox("","Owner","@P@B[8,@L_AUTOROUTE_INITIATE_INTERVAL_+0,]".."@B[4,@L_AUTOROUTE_INITIATE_INTERVAL_+1,]".."@B[0,@L_AUTOROUTE_INITIATE_INTERVAL_+2,]","@L_AUTOROUTE_INITIATE_HEAD_+0","")
	SetProperty("Owner","HPFZ_KarrenIntervall",intervall)

end

function Karren()

  local CartTyp = CartGetType("")
	local CSPlatz, CSMenge, CSMax
	if CartTyp == 0 then
	  CSMenge = 1
		CSPlatz = 20
		CSMax = 20
	elseif CartTyp == 1 then
	  CSMenge = 2
		CSPlatz = 20
		CSMax = 40
	elseif CartTyp == 2 then
	  CSMenge = 3
		CSPlatz = 40
		CSMax = 120
	elseif CartTyp == 3 then
	  CSMenge = 3
		CSPlatz = 20
		CSMax = 60
	end
	SetData("KarrenSlots",CSMenge)
	SetData("SlotPlatz",CSPlatz)
	SetData("PlatzMax",CSMax)
	
end

function DieFormelA(aufg,a,b,c)

  local x = 0
	local sloty = {}
	if a ~= nil then
	  sloty[1] = a
		x = x + 1
	end
	if b ~= nil then
	    sloty[2] = b
		x = x + 1
	end
	if c ~= nil then
	  sloty[3] = c
		x = x + 1
	end
	if aufg == true then
	  for c=1, x do
		  if sloty[c] == true then
			  sloty[c] = false
			  break
			end
		end
	else
	  for c=1, x do
		  if sloty[c] == false then
			  sloty[c] = true
				break
			end
		end
	end

	local z = 0
	local y = 0
	for s=1, x do
	  if sloty[s] == true then
		  z = z + 1
		elseif sloty[s] == false then
		  y = y + 1
		end
	end

	if z == x then
	  return true, false, sloty[1], sloty[2], sloty[3]
	elseif y == x then
	  return false, true, sloty[1], sloty[2], sloty[3]
	else
	  return true, true, sloty[1], sloty[2], sloty[3]
	end
	
end

function LogistikStand(f,pip)

  local pruef = false
  if BuildingGetType(f) ~= 13 and BuildingGetType(f) ~= 14 then
  	pruef = true
	end

	local zSlots = InventoryGetSlotCount(f,INVENTORY_STD)
	local itemInfo = {}	
	local schalter = {}
	local itemNam, itemKat, itemMen, itemID, itemSchalt
	local kat = { false, false, false, false, false, false }
	local n = 1
	for w = 0,zSlots-1 do
		itemID, itemMen = InventoryGetSlotInfo(f,w,INVENTORY_STD)
		if itemMen and itemMen > 0 then
			itemNam = ItemGetLabel(itemID,true)
	    itemKat = ItemGetCategory(itemID)
	    itemSchalt = "@B["..itemID..",@L"..itemNam..",]"
	    itemInfo[n] = { itemKat, itemNam, itemMen , itemSchalt, itemID }
	    kat[itemKat] = true
			n = n + 1
		end
	end

  local reA, reB, reC = "on", "off", "off"
	local backA, backB = "A", "B"
	local i, itemWahl, mengeWahl	

	repeat
		local katWahl
		local katSchalter = ""
		if reA == "on" then
	    schalter = {}
	    i = 1
	    if pruef == false then
	      if kat[1] == true then
	        katSchalter = katSchalter.."@B[A,@LResource,]"
	      end
	      if kat[2] == true then
	        katSchalter = katSchalter.."@B[B,@LFood,]"
	      end
	      if kat[3] == true then
	        katSchalter = katSchalter.."@B[C,@LHandicraft,]"
	      end
	      if kat[4] == true then
	        katSchalter = katSchalter.."@B[D,@LTextile,]"
	      end
	      if kat[5] == true then
	        katSchalter = katSchalter.."@B[E,@LAlchemist,]"
	      end
		    katSchalter = katSchalter.."@B[2222,@LBack_+0,]"
	      katWahl = MsgBox("",f,"@P"..katSchalter,"@L_AUTOROUTE_INITIATE_HEAD_+1","")
		
        if katWahl == "A" then
	        for j = 1, n-1 do
		        if itemInfo[j][1] == 1 then
			        schalter[i] = itemInfo[j][4]
			        i = i + 1
		        end
	        end
        elseif katWahl == "B" then
	        for j = 1, n-1 do
		        if itemInfo[j][1] == 2 then
			        schalter[i] = itemInfo[j][4]
			        i = i + 1
		        end
	        end
        elseif katWahl == "C" then
		      for j = 1, n-1 do
			      if itemInfo[j][1] == 3 then
				      schalter[i] = itemInfo[j][4]
				      i = i + 1
			      end
		      end
        elseif katWahl == "D" then
	        for j = 1, n-1 do
		        if itemInfo[j][1] == 4 then
			        schalter[i] = itemInfo[j][4]
			        i = i + 1
		        end
	        end
        elseif katWahl == "E" then
	        for j = 1, n-1 do
		        if itemInfo[j][1] == 5 then
			        schalter[i] = itemInfo[j][4]
			        i = i + 1
		        end
	        end
		    end
		    if katWahl == 2222 then
		      return 0, 0, pip
	      end
		    reB = "on"
		    reA = "off"
	    else
		    for j = 1, n-1 do
		        schalter[j] = itemInfo[j][4]
		    end
				reB = "on"
				reA = "off"
	    end
		end

		if reB == "on" then
	    schalter[0] = ""
	    if pruef == false then
	      for u=1, i-1 do
		      schalter[0] = schalter[0]..schalter[u]
	      end
	    else
	      for u=1, n-1 do
		      schalter[0] = schalter[0]..schalter[u]
	      end
	    end
      schalter[0] = schalter[0].."@B[8888,@LBack_+0,]"
	    itemWahl = MsgBox("",f,"@P"..schalter[0],"@L_AUTOROUTE_INITIATE_HEAD_+1","")
	    if itemWahl == 8888 then
		    if pruef == true then
			    return 0, 0, pip
				end
	      backA = "X"
		    reA = "on"
		    reB = "off"
	    else
	      backA = "A"
	      reC = "on"
		    reA = "off"
		    reB = "off"
	    end
		end

		local menge = {}
		local mengGros = 0
		local mengenWahl = ""
    local drinMengeX = 0
		if reC == "on" then
	    for u=1, n-1 do
			  if itemInfo[u][5] == itemWahl then
				  drinMengeX = itemInfo[u][3]
			  end
	    end
	
	    if drinMengeX > 0 then
	      if drinMengeX >= 1 then
	        menge[1] = 1
			    mengGros = mengGros + 1
		    end
		    if drinMengeX >= 5 then
		      menge[2] = 5
			    mengGros = mengGros + 1
		    end
		    if drinMengeX >= 10 then
		      menge[3] = 10
			    mengGros = mengGros + 1
		    end
		    if drinMengeX >= 20 then
		      menge[4] = 20
			    mengGros = mengGros + 1
		    end
		    if drinMengeX >= 40 and GetData("PlatzMax") >= 40 then
		      menge[5] = 40
			    mengGros = mengGros + 1
		    end
		    if drinMengeX >= 60 and GetData("PlatzMax") >= 60 then
		      menge[6] = 60
			    mengGros = mengGros + 1
		    end
		    if drinMengeX >= 120 and GetData("PlatzMax") >= 120 then
			    menge[7] = 120
		      mengGros = mengGros + 1
		    end
	    end	

	    for i=1, mengGros do
	      mengenWahl = mengenWahl.."@B["..menge[i]..","..menge[i]..",]"
	    end

	    mengenWahl = mengenWahl.."@B[5555,@LBack_+0,]"
	    mengeWahl = MsgBox("",desti,"@P"..mengenWahl,"@L_AUTOROUTE_INITIATE_HEAD_+2","")
	    if mengeWahl == 5555 then
	      backB = "X"
		    reB = "on"
		    reC = "off"
	    else
	      backB = "B"
	    end
		end

  until backA == "A" and backB == "B"
	
	return itemWahl, mengeWahl, true

end

function LogistikKarren()

  local backC = 1
	local drinWahl, drinMeng

  repeat
    local karSlot = GetData("KarrenSlots")
		local drinNam, drinID, drinMenge, drinMengeX
		local karStuf = ""
		local mengStuf = ""
		local menge = {}
		for k=1, karSlot do
			if GetData("Slot"..k) then
			  drinID = GetData("Slot"..k)
				if drinID ~= 0 then
					drinNam = ItemGetLabel(drinID,true)
				  karStuf = karStuf.."@B["..drinID..",@L"..drinNam..",]"
				end
			end
		end

		for k=1, karSlot do
		  drinID, drinMenge = InventoryGetSlotInfo("",k-1,INVENTORY_STD)
		  if drinMenge and drinMenge > 0 then
				drinNam = ItemGetLabel(drinID,true)
		    karStuf = karStuf.."@B["..drinID..",@L"..drinNam..",]"
			end
		end
    karStuf = karStuf.."@B[777,@LBack_+0,]"	
		drinWahl = MsgBox("","Owner","@P"..karStuf,"@L_AUTOROUTE_INITIATE_HEAD_+1","")
		if drinWahl == 777 then
			return 0,0
		end	
	
		local checkMW = 0
		for k=1, karSlot do
		  local drinIDZ, drinMengeZ = InventoryGetSlotInfo("",k-1,INVENTORY_STD)
			if drinWahl == drinIDZ then
			  checkMW = 1
			  drinMengeX = drinMengeZ
				break
	    end
		end
	
		local maxM = 0
		if checkMW == 0 then
	    for k=1, karSlot do
		    if drinWahl == GetData("Slot"..k) then
			    drinMengeX = GetData("MengeSlot"..k)
				end
			end
		end

		if drinMengeX > 0 then
	    if drinMengeX >= 1 then
	    	menge[1] = 1
				maxM = maxM + 1
			end
			if drinMengeX >= 5 then
		    menge[2] = 5
				maxM = maxM + 1
			end
			if drinMengeX >= 10 then
		    menge[3] = 10
				maxM = maxM + 1
			end
			if drinMengeX >= 20 then
		    menge[4] = 20
				maxM = maxM + 1
			end
			if drinMengeX >= 40 and GetData("PlatzMax") >= 40 then
		    menge[5] = 40
				maxM = maxM + 1
			end
			if drinMengeX >= 60 and GetData("PlatzMax") >=60 then
		    menge[6] = 60
				maxM = maxM + 1
			end
			if drinMengeX >= 120 and GetData("PlatzMax") >=120 then
		    menge[7] = 120
				maxM = maxM + 1
			end
		end 

		for p=1, maxM do
	    mengStuf = mengStuf.."@B["..menge[p]..","..menge[p]..",]"
		end
		mengStuf = mengStuf.."@B[1111,@LBack_+0,]"
		drinMeng = MsgBox("","Owner","@P"..mengStuf,"@L_AUTOROUTE_INITIATE_HEAD_+2","")
		if drinMeng == 1111 then
			backC = 0
		else
		  backC = 1
		end

	until backC == 1
	
	return drinWahl, drinMeng

end

function KarrenLager(x, y, z)

  local karLager = { }
	if GetData("Slot1") then
		karLager[1] = GetData("Slot1")
	end
	if GetData("Slot2") then
	  karLager[2] = GetData("Slot2")
	end
	if GetData("Slot3") then
	  karLager[3] = GetData("Slot3")
	end

  local karSlot = GetData("KarrenSlots")
	if x == true then
	  for k=1, karSlot do
		  if not karLager[k] or karLager[k] == 0 then
				SetData("Slot"..k,y)
				SetData("MengeSlot"..k,z)
				break
			end
		end
	elseif x == false then
	  for k=1, karSlot do
		  if karLager[k] == y then
			  if GetData("MengeSlot"..k) then
				  local fuell = GetData("MengeSlot"..k)
					fuell = fuell - z
					if fuell == 0 then
				    SetData("Slot"..k,0)
						SetData("MengeSlot"..k,0)
					else
					  SetData("MengeSlot"..k,fuell)
					end
				  break
				end
			end
		end
  end

end

function Wegpunkte(o)

	InitAlias("WegPunkt"..o,MEASUREINIT_SELECTION,
		"__F((Object.BelongsToMe()) OR (Object.IsClass(2)) OR (Object.IsClass(5)) AND (Object.Type == Building) AND NOT (Object.IsType(2)))",
		"@L_AUTOROUTE_NEXT_BUILDING_+0",0)

  return "WegPunkt"..o, true
	
end

function Run()

	--workaround for spinning carts...
	SetProperty("","AutoRoute",1)
	----------------------------------

  local ablauf = {}
	local arbeit = GetData("InfoAblauf")
	for j=1, arbeit do
		ablauf[j] = { GetData("Ort"..j), GetData("Was"..j), GetData("Wovon"..j), GetData("Wieviel"..j) }
	end
	while true do
		local warteZeit = GetProperty("Owner","HPFZ_KarrenIntervall")
		Sleep(warteZeit*60)
		for k=1, arbeit do
	    f_MoveTo("",ablauf[k][1])
			Sleep(1)
			if ablauf[k][2] == 1 then--load

				Transfer("","",INVENTORY_STD,ablauf[k][1],INVENTORY_STD,ablauf[k][3],ablauf[k][4])
				
			elseif ablauf[k][2] == 2 then--unload
				local SrcID = GetDynastyID("")
				local DestID = GetDynastyID(ablauf[k][1])

				if SrcID ~= DestID and BuildingGetClass(ablauf[k][1]) ~= GL_BUILDING_CLASS_MARKET then
					local cartDriver
					
					if CartGetOperator("", "cartDriver") then
					
						local newCount = GetItemCount("", ablauf[k][3], INVENTORY_STD)
						local oldCount = ablauf[k][4]--store old item count
						
						if newCount > 0 and newCount < ablauf[k][4] then
							ablauf[k][4] = newCount--cart does not have enough items
						end
						
						if newCount > 0 then--cart must have item in question
						
							if CanAddItems(ablauf[k][1], ablauf[k][3], ablauf[k][4], INVENTORY_STD) then
								RemoveItems("", ablauf[k][3], ablauf[k][4])
								AddItems(ablauf[k][1], ablauf[k][3], ablauf[k][4])
								ShowOverheadSymbol("",false,true,0,string.format("%dx %s\n", ablauf[k][4], ItemGetName(ablauf[k][3])))
							else
								-- ShowOverheadSymbol("",false,true,0,string.format("Full!", ablauf[k][4], ItemGetName(ablauf[k][3])))
							end
							ablauf[k][4] = oldCount
						end
					else
						--ShowOverheadSymbol("",false,true,0,"NO CART DRIVER!")
					end
				
				else

					GetDynasty("","bsitzer")
					if GetMoney("bsitzer") < (ItemGetPriceBuy(ablauf[k][3],ablauf[k][1])*ablauf[k][4]) then
						MsgNewsNoWait("bsitzer","Owner","","intrigue",-1,"@L_AUTOROUTE_STOPED_HEAD_+0",
						"@L_AUTOROUTE_STOPED_BODY_+0")
						StopMeasure()
					else
					Transfer("",ablauf[k][1],INVENTORY_STD,"",INVENTORY_STD,ablauf[k][3],ablauf[k][4])
					end
				end
			end
			Sleep(1)
		end
		Sleep(2)
	end
	StopMeasure()

end

function CleanUp()
	--workaround for spinning carts...
	RemoveProperty("","AutoRoute")
	----------------------------------
end
