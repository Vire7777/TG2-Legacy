-- Mod by Zbombe
function Run()
	if not AliasExists("Destination") then
		return
	end

	if not ai_GetWorkBuilding("", GL_BUILDING_TYPE_HOSPITAL, "Hospital") then
		StopMeasure()
		return
	end
	
	if GetInsideBuildingID("") ~= GetID("Hospital") then
		StopMeasure()
		return
	end

	-- The distance between both sims to interact with each other
	local InteractionDistance=90

	if not ai_StartInteraction("", "Destination", 500, InteractionDistance) then
		StopMeasure()
		return
	end

	MsgSay("Destination","@L_MEDICUS_TREATMENT_PATIENT")
	MsgSay("","@L_MEDICUS_TREATMENT_DOC_INTRO")
	PlayAnimation("","manipulate_middle_twohand")

			local Costs = 50
			local Cured = false
			
			--SPRAIN
			if GetImpactValue("Destination","Sprain")==1 then
				Costs = diseases_GetTreatmentCost("Sprain")
				if RemoveItems("Hospital","Bandage",1,INVENTORY_STD)>0 or RemoveItems("Hospital","Bandage",1,INVENTORY_SELL)>0 then
					if IsPartyMember("Destination")==false or SpendMoney("Destination",Costs,"Offering") then
						CreditMoney("Hospital",Costs,"Offering")
						MsgSay("","@L_MEDICUS_TREATMENT_DOC_SPRAIN")
						diseases_Sprain("Destination",false)
						chr_ModifyFavor("Destination","",10)
						Cured = true
					else
						MsgSay("","@L_MEDICUS_TREATMENT_DOC_NOMONEY")
					end
				else
					--not enough mats
					MsgSay("","@L_MEDICUS_TREATMENT_DOC_NOMATS",ItemGetLabel("Bandage",false))
					if GetImpactValue("Hospital","hospitalmessagesent")==0 then
						AddImpact("Hospital","hospitalmessagesent",1,4)
						feedback_MessageWorkshop("Hospital","@L_MEDICUS_TREATMENT_MSG_NOMATS_HEAD_+0",
										"@L_MEDICUS_TREATMENT_MSG_NOMATS_BODY_+0",
										GetID("Hospital"),ItemGetLabel("Bandage",false))
					end
				end

			--COLD	
			elseif GetImpactValue("Destination","Cold")==1 then
				Costs = diseases_GetTreatmentCost("Cold")
				if RemoveItems("Hospital","Bandage",1,INVENTORY_STD)>0 or RemoveItems("Hospital","Bandage",1,INVENTORY_SELL)>0 then
					if IsPartyMember("Destination")==false or SpendMoney("Destination",Costs,"Offering") then
						CreditMoney("Hospital",Costs,"Offering")
						MsgSay("","@L_MEDICUS_TREATMENT_DOC_COLD")
						diseases_Cold("Destination",false)
						chr_ModifyFavor("Destination","",10)
						Cured = true
					else
						MsgSay("","@L_MEDICUS_TREATMENT_DOC_NOMONEY")
					end
				else
					--not enough mats
					MsgSay("","@L_MEDICUS_TREATMENT_DOC_NOMATS",ItemGetLabel("Bandage",false))
					if GetImpactValue("Hospital","hospitalmessagesent")==0 then
						AddImpact("Hospital","hospitalmessagesent",1,4)
						feedback_MessageWorkshop("Hospital","@L_MEDICUS_TREATMENT_MSG_NOMATS_HEAD_+0",
										"@L_MEDICUS_TREATMENT_MSG_NOMATS_BODY_+0",
										GetID("Hospital"),ItemGetLabel("Bandage",false))
					end
				end
				
			--INFLUENZA
			elseif GetImpactValue("Destination","Influenza")==1 then
				Costs = diseases_GetTreatmentCost("Influenza")
				if RemoveItems("Hospital","Medicine",1,INVENTORY_STD)>0 or RemoveItems("Hospital","Medicine",1,INVENTORY_SELL)>0 then
					if IsPartyMember("Destination")==false or SpendMoney("Destination",Costs,"Offering") then
						CreditMoney("Hospital",Costs,"Offering")
						MsgSay("","@L_MEDICUS_TREATMENT_DOC_INFLUENZA")
						diseases_Influenza("Destination",false)
						chr_ModifyFavor("Destination","",10)
						Cured = true
					else
						MsgSay("","@L_MEDICUS_TREATMENT_DOC_NOMONEY")
					end
				else
					--not enough mats
					MsgSay("","@L_MEDICUS_TREATMENT_DOC_NOMATS",ItemGetLabel("Medicine",false))
					if GetImpactValue("Hospital","hospitalmessagesent")==0 then
						AddImpact("Hospital","hospitalmessagesent",1,4)
						feedback_MessageWorkshop("Hospital","@L_MEDICUS_TREATMENT_MSG_NOMATS_HEAD_+0",
										"@L_MEDICUS_TREATMENT_MSG_NOMATS_BODY_+0",
										GetID("Hospital"),ItemGetLabel("Medicine",false))
					end
				end
				
			--BURNWOUND	
			elseif GetImpactValue("Destination","BurnWound")==1 then
				Costs = diseases_GetTreatmentCost("BurnWound")
				if RemoveItems("Hospital","Medicine",1,INVENTORY_STD)>0 or RemoveItems("Hospital","Medicine",1,INVENTORY_SELL)>0 then
					if IsPartyMember("Destination")==false or SpendMoney("Destination",Costs,"Offering") then
						CreditMoney("Hospital",Costs,"Offering")
						MsgSay("","@L_MEDICUS_TREATMENT_DOC_BURNWOUND")
						diseases_BurnWound("Destination",false)
						chr_ModifyFavor("Destination","",10)
						Cured = true
					else
						MsgSay("","@L_MEDICUS_TREATMENT_DOC_NOMONEY")
					end
				else
					--not enough mats
					MsgSay("","@L_MEDICUS_TREATMENT_DOC_NOMATS",ItemGetLabel("Medicine",false))
					if GetImpactValue("Hospital","hospitalmessagesent")==0 then
						AddImpact("Hospital","hospitalmessagesent",1,4)
						feedback_MessageWorkshop("Hospital","@L_MEDICUS_TREATMENT_MSG_NOMATS_HEAD_+0",
										"@L_MEDICUS_TREATMENT_MSG_NOMATS_BODY_+0",
										GetID("Hospital"),ItemGetLabel("Medicine",false))
					end
				end
				
			--POX	
			elseif GetImpactValue("Destination","Pox")==1 then
				Costs = diseases_GetTreatmentCost("Pox")
				if RemoveItems("Hospital","Medicine",1,INVENTORY_STD)>0 or RemoveItems("Hospital","Medicine",1,INVENTORY_SELL)>0 then
					if IsPartyMember("Destination")==false or SpendMoney("Destination",Costs,"Offering") then
						CreditMoney("Hospital",Costs,"Offering")
						MsgSay("","@L_MEDICUS_TREATMENT_DOC_POX")
						diseases_Pox("Destination",false)
						chr_ModifyFavor("Destination","",10)
						Cured = true
					else
						MsgSay("","@L_MEDICUS_TREATMENT_DOC_NOMONEY")
					end
				else
					--not enough mats
					MsgSay("","@L_MEDICUS_TREATMENT_DOC_NOMATS",ItemGetLabel("Medicine",false))
					if GetImpactValue("Hospital","hospitalmessagesent")==0 then
						AddImpact("Hospital","hospitalmessagesent",1,4)
						feedback_MessageWorkshop("Hospital","@L_MEDICUS_TREATMENT_MSG_NOMATS_HEAD_+0",
										"@L_MEDICUS_TREATMENT_MSG_NOMATS_BODY_+0",
										GetID("Hospital"),ItemGetLabel("Medicine",false))
					end
				end	
			
			--PNEUMONA
			elseif GetImpactValue("Destination","Pneumonia")==1 then
				Costs = diseases_GetTreatmentCost("Pneumonia")
				if RemoveItems("Hospital","PainKiller",1,INVENTORY_STD)>0 or RemoveItems("Hospital","PainKiller",1,INVENTORY_SELL)>0 then
					if IsPartyMember("Destination")==false or SpendMoney("Destination",Costs,"Offering") then
						CreditMoney("Hospital",Costs,"Offering")
						MsgSay("","@L_MEDICUS_TREATMENT_DOC_PNEUMONIA")
						diseases_Pneumonia("Destination",false)
						chr_ModifyFavor("Destination","",10)
						Cured = true
					else
						MsgSay("","@L_MEDICUS_TREATMENT_DOC_NOMONEY")
					end
				else
					--not enough mats
					MsgSay("","@L_MEDICUS_TREATMENT_DOC_NOMATS",ItemGetLabel("PainKiller",false))
					if GetImpactValue("Hospital","hospitalmessagesent")==0 then
						AddImpact("Hospital","hospitalmessagesent",1,4)
						feedback_MessageWorkshop("Hospital","@L_MEDICUS_TREATMENT_MSG_NOMATS_HEAD_+0",
										"@L_MEDICUS_TREATMENT_MSG_NOMATS_BODY_+0",
										GetID("Hospital"),ItemGetLabel("PainKiller",false))
					end
				end	
					
			--BLACKDEATH
			elseif GetImpactValue("Destination","Blackdeath")==1 then
				Costs = diseases_GetTreatmentCost("Blackdeath")
				if RemoveItems("Hospital","PainKiller",1,INVENTORY_STD)>0 or RemoveItems("Hospital","PainKiller",1,INVENTORY_SELL)>0 then
					if IsPartyMember("Destination")==false or SpendMoney("Destination",Costs,"Offering") then
						CreditMoney("Hospital",Costs,"Offering")
						MsgSay("","@L_MEDICUS_TREATMENT_DOC_BLACKDEATH")
						diseases_Blackdeath("Destination",false)
						chr_ModifyFavor("Destination","",30)
						Cured = true
					else
						MsgSay("","@L_MEDICUS_TREATMENT_DOC_NOMONEY")
					end
				else
					--not enough mats
					MsgSay("","@L_MEDICUS_TREATMENT_DOC_NOMATS",ItemGetLabel("PainKiller",false))
					if GetImpactValue("Hospital","hospitalmessagesent")==0 then
						AddImpact("Hospital","hospitalmessagesent",1,4)
						feedback_MessageWorkshop("Hospital","@L_MEDICUS_TREATMENT_MSG_NOMATS_HEAD_+0",
										"@L_MEDICUS_TREATMENT_MSG_NOMATS_BODY_+0",
										GetID("Hospital"),ItemGetLabel("PainKiller",false))
					end
				end
				
			--FRACTURE
			elseif GetImpactValue("Destination","Fracture")==1 then
				Costs = diseases_GetTreatmentCost("Fracture")
				if RemoveItems("Hospital","PainKiller",1,INVENTORY_STD)>0 or RemoveItems("Hospital","PainKiller",1,INVENTORY_SELL)>0 then
					if IsPartyMember("Destination")==false or SpendMoney("Destination",Costs,"Offering") then
						CreditMoney("Hospital",Costs,"Offering")
						MsgSay("","@L_MEDICUS_TREATMENT_DOC_FRACTURE")
						diseases_Fracture("Destination",false)
						chr_ModifyFavor("Destination","",10)
						Cured = true
					else
						MsgSay("","@L_MEDICUS_TREATMENT_DOC_NOMONEY")
					end
				else
					--not enough mats
					MsgSay("","@L_MEDICUS_TREATMENT_DOC_NOMATS",ItemGetLabel("PainKiller",false))
					if GetImpactValue("Hospital","hospitalmessagesent")==0 then
						AddImpact("Hospital","hospitalmessagesent",1,4)
						feedback_MessageWorkshop("Hospital","@L_MEDICUS_TREATMENT_MSG_NOMATS_HEAD_+0",
										"@L_MEDICUS_TREATMENT_MSG_NOMATS_BODY_+0",
										GetID("Hospital"),ItemGetLabel("PainKiller",false))
					end
				end	
					
			--CARIES					
			elseif GetImpactValue("Destination","Caries")==1 then
				Costs = diseases_GetTreatmentCost("Caries")
				if RemoveItems("Hospital","PainKiller",1,INVENTORY_STD)>0 or RemoveItems("Hospital","PainKiller",1,INVENTORY_SELL)>0 then
					if IsPartyMember("Destination")==false or SpendMoney("Destination",Costs,"Offering") then
						CreditMoney("Hospital",Costs,"Offering")
						MsgSay("","@L_MEDICUS_TREATMENT_DOC_CARIES")
						diseases_Caries("Destination",false)
						chr_ModifyFavor("Destination","",10)
						Cured = true
					else
						MsgSay("","@L_MEDICUS_TREATMENT_DOC_NOMONEY")
					end
				else
					--not enough mats
					MsgSay("","@L_MEDICUS_TREATMENT_DOC_NOMATS",ItemGetLabel("PainKiller",false))
					if GetImpactValue("Hospital","hospitalmessagesent")==0 then
						AddImpact("Hospital","hospitalmessagesent",1,4)
						feedback_MessageWorkshop("Hospital","@L_MEDICUS_TREATMENT_MSG_NOMATS_HEAD_+0",
										"@L_MEDICUS_TREATMENT_MSG_NOMATS_BODY_+0",
										GetID("Hospital"),ItemGetLabel("PainKiller",false))
					end
				end
				
			--ELSE	(HP LOSS)
			elseif (GetHP("Destination") < GetMaxHP("Destination")) then
				if RemoveItems("Hospital","Bandage",1,INVENTORY_STD)>0 or RemoveItems("Hospital","Bandage",1,INVENTORY_SELL)>0 then
					local ToHeal = GetMaxHP("Destination") - GetHP("Destination")
					if IsPartyMember("Destination")==false or SpendMoney("Destination",ToHeal,"Offering") then
						CreditMoney("Hospital",ToHeal,"Offering")
						MsgSay("","@L_MEDICUS_TREATMENT_DOC_HPLOSS")
						ModifyHP("Destination",ToHeal,true)
						chr_ModifyFavor("Destination","",5)
						Cured = true
					else
						MsgSay("","@L_MEDICUS_TREATMENT_DOC_NOMONEY")
					end
				else
					--not enough mats
					MsgSay("","@L_MEDICUS_TREATMENT_DOC_NOMATS",ItemGetLabel("Bandage",false))
					if GetImpactValue("Hospital","hospitalmessagesent")==0 then
						AddImpact("Hospital","hospitalmessagesent",1,4)
						feedback_MessageWorkshop("Hospital","@L_MEDICUS_TREATMENT_MSG_NOMATS_HEAD_+0",
										"@L_MEDICUS_TREATMENT_MSG_NOMATS_BODY_+0",
										GetID("Hospital"),ItemGetLabel("Bandage",false))
					end
				end
			else
				MsgSay("","@L_MEDICUS_TREATMENT_DOC_NOTHING")
			end

			MoveSetActivity("Destination","")
			AddImpact("Destination","Resist",1,6)
end

function CleanUp()

end