function AIReturnO()
	return "O"
end

function AttendTrialMeeting(DestinationID)
	if GetState("Sim",STATE_CUTSCENE) then
		return
	end
	if GetCurrentMeasureName("Sim")=="AttendTrialMeeting" then
		DestroyCutscene("")
		return
	end
	
	if GetImpactValue("Sim", 369)>0 then
		DestroyCutscene("")
		return
	end

	AddImpact("Sim", 369, 1, 3)

	local bRun = true
	if DynastyIsPlayer("Sim") and IsPartyMember("Sim") then
		GetInsideBuilding("Sim","InsideBuilding")
		if (GetID("destination") ~= GetID("InsideBuilding")) then
			if MsgNews("Sim","destination",
					"@P@B[O,@L_GENERAL_TIMEPLANNERENTRY_MESSAGE_BUTTONS_+0]@B[C,@L_GENERAL_TIMEPLANNERENTRY_MESSAGE_BUTTONS_+1]",
					queries_AIReturnO,"politics",0.5,"@L_LAWSUIT_DIARY_REMEMBER_+0","@L_LAWSUIT_DIARY_REMEMBER_+1",GetID("Sim"),GetSettlementID("destination"))=="C" then
				bRun = false
			end
		end
	end 

	if bRun==true then
		if not GetState(SimAlias,STATE_CRUSADE) then
			if not GetState(SimAlias,STATE_DEAD) then
				if not GetState(SimAlias,STATE_DYING) then
					if not GetState(SimAlias,STATE_DUEL) then
						if not GetState(SimAlias,STATE_FIGHTING) then
							if not GetState(SimAlias,STATE_FEAST) then
								if not GetState(SimAlias,STATE_HIJACKED) then
									if not GetState(SimAlias,STATE_LOCKED) then
										if not GetState(SimAlias,STATE_LOCKEDALT) then
											if not GetState(SimAlias,STATE_PILLORY) then
												if not GetState(SimAlias,STATE_PREGNANT) then
													if not GetState(SimAlias,STATE_UNCONSCIOUS) then
														if not GetState(SimAlias,STATE_CHILD) then
															if not GetState(SimAlias,STATE_CAPTURED) then
																if not GetState(SimAlias,STATE_HPFZ_TRAUMLAND) then
																	if not GetState(SimAlias,STATE_HPFZ_HYPNOSE) then
																		if not GetState(SimAlias,STATE_IMPRISONED) then
																			if not GetState(SimAlias,STATE_GUARDING) then
																				if not GetState(SimAlias,STATE_HPFZ_BETTLER) then
																					if not GetState(SimAlias,STATE_ROBBERGUARD) then
																						if GetState(SimAlias,STATE_EXPEL) then
																							SetState(SimAlias,STATE_EXPEL,false)
																						elseif GetState(SimAlias,STATE_HPFZ_BAUARBEITER) then
																							SetState(SimAlias,STATE_HPFZ_BAUARBEITER,false)
																						elseif GetState(SimAlias,STATE_LITTLEDRUNK) then
																							SetState(SimAlias,STATE_LITTLEDRUNK,false)
																						elseif GetState(SimAlias,STATE_SITAROUND) then
																							SetState(SimAlias,STATE_SITAROUND,false)
																						elseif GetState(SimAlias,STATE_SLEEPING) then
																							SetState(SimAlias,STATE_SLEEPING,false)
																						elseif GetState(SimAlias,STATE_TOTALLYDRUNK) then
																							SetState(SimAlias,STATE_TOTALLYDRUNK,false)
																						elseif GetState(SimAlias,STATE_WORKING) then
																							SetState(SimAlias,STATE_WORKING,false)
																						end
																						MeasureRun("Sim", "Destination", "AttendTrialMeeting", true)
																					end
																				end
																			end
																		end
																	end
																end
															end
														end
													end
												end
											end
										end
									end
								end
							end
						end	
					end
				end
			end
		end
	end
	DestroyCutscene("")
end	

function AttendOfficeMeeting(DestinationID)

	if GetState("Sim",STATE_CUTSCENE) then
		return
	end

	if GetCurrentMeasureName("Sim")=="AttendOfficeMeeting" then
		DestroyCutscene("")
		return
	end
	
	if GetImpactValue("Sim", 369)>0 then
		DestroyCutscene("")
		return
	end
	
	AddImpact("Sim", 369, 1, 3)
	
	local bRun = true
	if DynastyIsPlayer("Sim") and IsPartyMember("Sim") then
		GetInsideBuilding("Sim","InsideBuilding")
		if (GetID("destination") ~= GetID("InsideBuilding")) then
			if MsgNews("Sim","destination",
					"@P@B[O,@L_GENERAL_TIMEPLANNERENTRY_MESSAGE_BUTTONS_+0]@B[C,@L_GENERAL_TIMEPLANNERENTRY_MESSAGE_BUTTONS_+1]",
					queries_AIReturnO,"politics",0.5,"@L_SESSION_6_TIMEPLANNERENTRY_ELECTOR_+0","@L_LAWSUIT_DIARY_REMEMBER_+1",GetID("Sim"),GetSettlementID("destination"))=="C" then
				bRun = false
			end
		end
	end
	
	if bRun==true then
		if not GetState(SimAlias,STATE_CRUSADE) then
			if not GetState(SimAlias,STATE_DEAD) then
				if not GetState(SimAlias,STATE_DYING) then
					if not GetState(SimAlias,STATE_DUEL) then
						if not GetState(SimAlias,STATE_FIGHTING) then
							if not GetState(SimAlias,STATE_FEAST) then
								if not GetState(SimAlias,STATE_HIJACKED) then
									if not GetState(SimAlias,STATE_LOCKED) then
										if not GetState(SimAlias,STATE_LOCKEDALT) then
											if not GetState(SimAlias,STATE_PILLORY) then
												if not GetState(SimAlias,STATE_PREGNANT) then
													if not GetState(SimAlias,STATE_UNCONSCIOUS) then
														if not GetState(SimAlias,STATE_CHILD) then
															if not GetState(SimAlias,STATE_CAPTURED) then
																if not GetState(SimAlias,STATE_HPFZ_TRAUMLAND) then
																	if not GetState(SimAlias,STATE_HPFZ_HYPNOSE) then
																		if not GetState(SimAlias,STATE_IMPRISONED) then
																			if not GetState(SimAlias,STATE_GUARDING) then
																				if not GetState(SimAlias,STATE_HPFZ_BETTLER) then
																					if not GetState(SimAlias,STATE_ROBBERGUARD) then
																						if GetState(SimAlias,STATE_EXPEL) then
																							SetState(SimAlias,STATE_EXPEL,false)
																						elseif GetState(SimAlias,STATE_HPFZ_BAUARBEITER) then
																							SetState(SimAlias,STATE_HPFZ_BAUARBEITER,false)
																						elseif GetState(SimAlias,STATE_LITTLEDRUNK) then
																							SetState(SimAlias,STATE_LITTLEDRUNK,false)
																						elseif GetState(SimAlias,STATE_SITAROUND) then
																							SetState(SimAlias,STATE_SITAROUND,false)
																						elseif GetState(SimAlias,STATE_SLEEPING) then
																							SetState(SimAlias,STATE_SLEEPING,false)
																						elseif GetState(SimAlias,STATE_TOTALLYDRUNK) then
																							SetState(SimAlias,STATE_TOTALLYDRUNK,false)
																						elseif GetState(SimAlias,STATE_WORKING) then
																							SetState(SimAlias,STATE_WORKING,false)
																						end
																						MeasureRun("Sim", "Destination", "AttendOfficeMeeting", true)
																					end
																				end
																			end
																		end
																	end
																end
															end
														end
													end
												end
											end
										end
									end
								end
							end
						end	
					end
				end
			end
		end
	end
	DestroyCutscene("")
end	

function AttendFuneral(DestinationID)
	MeasureRun("Sim", "Destination", "AttendFuneral", true)
	DestroyCutscene("")
end

function AttendDuel(DestinationID)
	local bRun = true
	if GetState("Sim",STATE_CUTSCENE) then
		return
	end
	if DynastyIsPlayer("Sim") and IsPartyMember("Sim") then
		if MsgNews("Sim","destination",
				"@P"..
				"@B[O,@L_GENERAL_TIMEPLANNERENTRY_MESSAGE_BUTTONS_+0]"..
				"@B[C,@L_GENERAL_TIMEPLANNERENTRY_MESSAGE_BUTTONS_+1]",
				queries_AIReturnO,"intrigue",0.5,
				"@L_DUELL_6_TIMEPLANNERENTRY_REMEMBER_+0",
				"@L_DUELL_6_TIMEPLANNERENTRY_REMEMBER_+1",GetID("Sim"))=="C" then
					
				bRun = false
		end
	end

	if bRun==true then
		if not GetState(SimAlias,STATE_CRUSADE) then
			if not GetState(SimAlias,STATE_DEAD) then
				if not GetState(SimAlias,STATE_DYING) then
					if not GetState(SimAlias,STATE_DUEL) then
						if not GetState(SimAlias,STATE_FIGHTING) then
							if not GetState(SimAlias,STATE_FEAST) then
								if not GetState(SimAlias,STATE_HIJACKED) then
									if not GetState(SimAlias,STATE_LOCKED) then
										if not GetState(SimAlias,STATE_LOCKEDALT) then
											if not GetState(SimAlias,STATE_PILLORY) then
												if not GetState(SimAlias,STATE_PREGNANT) then
													if not GetState(SimAlias,STATE_UNCONSCIOUS) then
														if not GetState(SimAlias,STATE_CHILD) then
															if not GetState(SimAlias,STATE_CAPTURED) then
																if not GetState(SimAlias,STATE_HPFZ_TRAUMLAND) then
																	if not GetState(SimAlias,STATE_HPFZ_HYPNOSE) then
																		if not GetState(SimAlias,STATE_IMPRISONED) then
																			if not GetState(SimAlias,STATE_GUARDING) then
																				if not GetState(SimAlias,STATE_HPFZ_BETTLER) then
																					if not GetState(SimAlias,STATE_ROBBERGUARD) then
																						if GetState(SimAlias,STATE_EXPEL) then
																							SetState(SimAlias,STATE_EXPEL,false)
																						elseif GetState(SimAlias,STATE_HPFZ_BAUARBEITER) then
																							SetState(SimAlias,STATE_HPFZ_BAUARBEITER,false)
																						elseif GetState(SimAlias,STATE_LITTLEDRUNK) then
																							SetState(SimAlias,STATE_LITTLEDRUNK,false)
																						elseif GetState(SimAlias,STATE_SITAROUND) then
																							SetState(SimAlias,STATE_SITAROUND,false)
																						elseif GetState(SimAlias,STATE_SLEEPING) then
																							SetState(SimAlias,STATE_SLEEPING,false)
																						elseif GetState(SimAlias,STATE_TOTALLYDRUNK) then
																							SetState(SimAlias,STATE_TOTALLYDRUNK,false)
																						elseif GetState(SimAlias,STATE_WORKING) then
																							SetState(SimAlias,STATE_WORKING,false)
																						end
																						MeasureRun("Sim", "Destination", "AttendDuel", true)
																					end
																				end
																			end
																		end
																	end
																end
															end
														end
													end
												end
											end
										end
									end
								end
							end
						end	
					end
				end
			end
		end
	end
	DestroyCutscene("")
end	


function AttendFestivity(DestinationID)
	local bRun = true
	local message = 0
	if GetInsideBuilding("Sim","Currentbuilding") then
		if GetID("CurrentBuilding") == GetID("Destination") then
			--is schon da
		else
			message = 1
		end
	else
		message = 1
	end
	if message == 1 then
		if DynastyIsPlayer("Sim") and IsPartyMember("Sim") then
			if MsgNews("Sim","destination",
					"@P"..
					"@B[O,@L_GENERAL_TIMEPLANNERENTRY_MESSAGE_BUTTONS_+0]"..
					"@B[C,@L_GENERAL_TIMEPLANNERENTRY_MESSAGE_BUTTONS_+1]",
					queries_AIReturnO,"schedule",0.5,
					"@L_FEAST_5_TIMEPLANNERENTRY_REMEMBER_+0",
					"@L_FEAST_5_TIMEPLANNERENTRY_REMEMBER_+1",GetID("Sim"))=="C" then
						bRun = false
			end
		end
	end

	if bRun==true then
		if not GetState(SimAlias,STATE_CRUSADE) then
			if not GetState(SimAlias,STATE_DEAD) then
				if not GetState(SimAlias,STATE_DYING) then
					if not GetState(SimAlias,STATE_DUEL) then
						if not GetState(SimAlias,STATE_FIGHTING) then
							if not GetState(SimAlias,STATE_FEAST) then
								if not GetState(SimAlias,STATE_HIJACKED) then
									if not GetState(SimAlias,STATE_LOCKED) then
										if not GetState(SimAlias,STATE_LOCKEDALT) then
											if not GetState(SimAlias,STATE_PILLORY) then
												if not GetState(SimAlias,STATE_PREGNANT) then
													if not GetState(SimAlias,STATE_UNCONSCIOUS) then
														if not GetState(SimAlias,STATE_CHILD) then
															if not GetState(SimAlias,STATE_CAPTURED) then
																if not GetState(SimAlias,STATE_HPFZ_TRAUMLAND) then
																	if not GetState(SimAlias,STATE_HPFZ_HYPNOSE) then
																		if not GetState(SimAlias,STATE_IMPRISONED) then
																			if not GetState(SimAlias,STATE_GUARDING) then
																				if not GetState(SimAlias,STATE_HPFZ_BETTLER) then
																					if not GetState(SimAlias,STATE_ROBBERGUARD) then
																						if GetState(SimAlias,STATE_EXPEL) then
																							SetState(SimAlias,STATE_EXPEL,false)
																						elseif GetState(SimAlias,STATE_HPFZ_BAUARBEITER) then
																							SetState(SimAlias,STATE_HPFZ_BAUARBEITER,false)
																						elseif GetState(SimAlias,STATE_LITTLEDRUNK) then
																							SetState(SimAlias,STATE_LITTLEDRUNK,false)
																						elseif GetState(SimAlias,STATE_SITAROUND) then
																							SetState(SimAlias,STATE_SITAROUND,false)
																						elseif GetState(SimAlias,STATE_SLEEPING) then
																							SetState(SimAlias,STATE_SLEEPING,false)
																						elseif GetState(SimAlias,STATE_TOTALLYDRUNK) then
																							SetState(SimAlias,STATE_TOTALLYDRUNK,false)
																						elseif GetState(SimAlias,STATE_WORKING) then
																							SetState(SimAlias,STATE_WORKING,false)
																						end
																						MeasureRun("Sim", "Destination", "AttendFestivity", true)
																					end
																				end
																			end
																		end
																	end
																end
															end
														end
													end
												end
											end
										end
									end
								end
							end
						end	
					end
				end
			end
		end
	end
	DestroyCutscene("")
end	


function Attend(DestinationID)
	local bRun = true
	if DynastyIsPlayer("Sim") and IsPartyMember("Sim") then
		if MsgNews("Sim","destination",
					"@P@B[O,@L_GENERAL_TIMEPLANNERENTRY_MESSAGE_BUTTONS_+0]@B[C,@L_GENERAL_TIMEPLANNERENTRY_MESSAGE_BUTTONS_+1]",
					queries_AIReturnO,"politics",0.5,"@L_LAWSUIT_DIARY_REMEMBER_+0","@L_LAWSUIT_DIARY_REMEMBER_+1",GetID("Sim"),GetSettlementID("destination"))=="C" then
			bRun = false
		end
	end

	if (bRun==true) then
		if not GetState(SimAlias,STATE_CRUSADE) then
			if not GetState(SimAlias,STATE_DEAD) then
				if not GetState(SimAlias,STATE_DYING) then
					if not GetState(SimAlias,STATE_DUEL) then
						if not GetState(SimAlias,STATE_FIGHTING) then
							if not GetState(SimAlias,STATE_FEAST) then
								if not GetState(SimAlias,STATE_HIJACKED) then
									if not GetState(SimAlias,STATE_LOCKED) then
										if not GetState(SimAlias,STATE_LOCKEDALT) then
											if not GetState(SimAlias,STATE_PILLORY) then
												if not GetState(SimAlias,STATE_PREGNANT) then
													if not GetState(SimAlias,STATE_UNCONSCIOUS) then
														if not GetState(SimAlias,STATE_CHILD) then
															if not GetState(SimAlias,STATE_CAPTURED) then
																if not GetState(SimAlias,STATE_HPFZ_TRAUMLAND) then
																	if not GetState(SimAlias,STATE_HPFZ_HYPNOSE) then
																		if not GetState(SimAlias,STATE_IMPRISONED) then
																			if not GetState(SimAlias,STATE_GUARDING) then
																				if not GetState(SimAlias,STATE_HPFZ_BETTLER) then
																					if not GetState(SimAlias,STATE_ROBBERGUARD) then
																						if GetState(SimAlias,STATE_EXPEL) then
																							SetState(SimAlias,STATE_EXPEL,false)
																						elseif GetState(SimAlias,STATE_HPFZ_BAUARBEITER) then
																							SetState(SimAlias,STATE_HPFZ_BAUARBEITER,false)
																						elseif GetState(SimAlias,STATE_LITTLEDRUNK) then
																							SetState(SimAlias,STATE_LITTLEDRUNK,false)
																						elseif GetState(SimAlias,STATE_SITAROUND) then
																							SetState(SimAlias,STATE_SITAROUND,false)
																						elseif GetState(SimAlias,STATE_SLEEPING) then
																							SetState(SimAlias,STATE_SLEEPING,false)
																						elseif GetState(SimAlias,STATE_TOTALLYDRUNK) then
																							SetState(SimAlias,STATE_TOTALLYDRUNK,false)
																						elseif GetState(SimAlias,STATE_WORKING) then
																							SetState(SimAlias,STATE_WORKING,false)
																						end
																						MeasureRun("Sim", "Destination", "Attend", true)
																					end
																				end
																			end
																		end
																	end
																end
															end
														end
													end
												end
											end
										end
									end
								end
							end
						end	
					end
				end
			end
		end
	end
	DestroyCutscene("")
end

function DecideFugitive()
	
	if AliasExists("Sim") then
		if GetSettlement("Sim","City") then
			local Decision = 0
			local Fee = GetData("RawPenalty") * DynastyGetRanking("Sim") * 0.05
			if Fee <= 200 then
				Fee = 200
			end
			
			local FugitiveYears = GetData("FugitiveYears")
			local HoursInPrison = GetData("RawPenalty")*3
			local CanPayFee = true
			if Fee>GetMoney("Sim") then
				CanPayFee = false
			end

			if DynastyIsPlayer("Sim") and IsPartyMember("") then
				-- user decision
				local Result = "C"
				if Fee>GetMoney("Sim") then	-- cannot pay fee, omit option pay_fee
					Result = MsgNews("Sim","Sim",
							"@P@B[I,@L_LAWSUIT_3_INTRO_PERSON_NOT_PRESENT_ANGEKLAGTER_MESSAGES_+7]"..
							"@B[P,@L_LAWSUIT_3_INTRO_PERSON_NOT_PRESENT_ANGEKLAGTER_MESSAGES_+8]",
							-1,"politics",1.0,
							"@L_LAWSUIT_3_INTRO_PERSON_NOT_PRESENT_ANGEKLAGTER_MESSAGES_+9",
							"@L_LAWSUIT_3_INTRO_PERSON_NOT_PRESENT_ANGEKLAGTER_MESSAGES_+5",GetID("Sim"),Fee,FugitiveYears)
				else -- can pay fee
					Result = MsgNews("Sim","Sim",
							"@P@B[O,@L_LAWSUIT_3_INTRO_PERSON_NOT_PRESENT_ANGEKLAGTER_MESSAGES_+6]"..
							"@B[I,@L_LAWSUIT_3_INTRO_PERSON_NOT_PRESENT_ANGEKLAGTER_MESSAGES_+7]"..
							"@B[P,@L_LAWSUIT_3_INTRO_PERSON_NOT_PRESENT_ANGEKLAGTER_MESSAGES_+8]",
							-1,"politics",1.0,
							"@L_LAWSUIT_3_INTRO_PERSON_NOT_PRESENT_ANGEKLAGTER_MESSAGES_+9",
							"@L_LAWSUIT_3_INTRO_PERSON_NOT_PRESENT_ANGEKLAGTER_MESSAGES_+5",GetID("Sim"),Fee,FugitiveYears)
				end

				if Result=="C" or Result=="I" then
					Decision = 0
				elseif Result=="O" then
					Decision = 2
				elseif Result=="P" then
					Decision = 1
				end
			else
				-- AI decision
				if SimGetClass("Sim")==4 then	-- if is chiseler
					Decision = 0		-- ignore
				elseif Fee*2<GetMoney("Sim") then
					Decision = 2		-- ich zahle
				else 
					Decision = 1		-- ich gehe freiwillig ins Gefängnis
				end
			end

			if (Decision==0) then
				-- ignore
				local Options = FindNode("\\Settings\\Options")
				local YearsPerRound = Options:GetValueInt("YearsPerRound")
				local FugitiveHours = FugitiveYears * 24 / YearsPerRound
				CityAddPenalty("City","Sim",PENALTY_FUGITIVE,FugitiveYears)
				AddImpact("Sim","REVOLT",1,FugitiveHours)
				CommitAction("revolt","Sim","Sim")
				SetNobilityTitle("Sim", 3, true)
				if SimGetOffice("Sim","Office") then
					SimSetOffice("Sim",0)
				end
				feedback_MessagePolitics("Sim","@L_LAWSUIT_3_INTRO_PERSON_NOT_PRESENT_ANGEKLAGTER_MESSAGES_+0",
						"@L_LAWSUIT_3_INTRO_PERSON_NOT_PRESENT_ANGEKLAGTER_MESSAGES_+1",GetID("Sim"),FugitiveYears)
				feedback_MessagePolitics("accuser","@L_LAWSUIT_3_INTRO_PERSON_NOT_PRESENT_ANGEKLAGTER_MESSAGES_+2",
						"@L_LAWSUIT_3_INTRO_PERSON_NOT_PRESENT_ANGEKLAGTER_MESSAGES_+3",GetID("Sim"),FugitiveYears)
				feedback_MessagePolitics("judge","@L_LAWSUIT_3_INTRO_PERSON_NOT_PRESENT_ANGEKLAGTER_MESSAGES_+2",
						"@L_LAWSUIT_3_INTRO_PERSON_NOT_PRESENT_ANGEKLAGTER_MESSAGES_+3",GetID("Sim"),FugitiveYears)
				feedback_MessagePolitics("assessor1","@L_LAWSUIT_3_INTRO_PERSON_NOT_PRESENT_ANGEKLAGTER_MESSAGES_+2",
						"@L_LAWSUIT_3_INTRO_PERSON_NOT_PRESENT_ANGEKLAGTER_MESSAGES_+3",GetID("Sim"),FugitiveYears)
				feedback_MessagePolitics("assessor2","@L_LAWSUIT_3_INTRO_PERSON_NOT_PRESENT_ANGEKLAGTER_MESSAGES_+2",
						"@L_LAWSUIT_3_INTRO_PERSON_NOT_PRESENT_ANGEKLAGTER_MESSAGES_+3",GetID("Sim"),FugitiveYears)

			elseif (Decision==1) then
				-- prison
				CityAddPenalty("City","Sim",PENALTY_PRISON, HoursInPrison )
				feedback_MessagePolitics("Accuser","@L_LAWSUIT_3_INTRO_PERSON_NOT_PRESENT_ANGEKLAGTER_MESSAGES_+12",
						"@L_LAWSUIT_3_INTRO_PERSON_NOT_PRESENT_ANGEKLAGTER_MESSAGES_+13",GetID("Sim"),HoursInPrison,GetID("City"))
				feedback_MessagePolitics("Assessor1","@L_LAWSUIT_3_INTRO_PERSON_NOT_PRESENT_ANGEKLAGTER_MESSAGES_+12",
						"@L_LAWSUIT_3_INTRO_PERSON_NOT_PRESENT_ANGEKLAGTER_MESSAGES_+13",GetID("Sim"),HoursInPrison,GetID("City"))
				feedback_MessagePolitics("Assessor2","@L_LAWSUIT_3_INTRO_PERSON_NOT_PRESENT_ANGEKLAGTER_MESSAGES_+12",
						"@L_LAWSUIT_3_INTRO_PERSON_NOT_PRESENT_ANGEKLAGTER_MESSAGES_+13",GetID("Sim"),HoursInPrison,GetID("City"))
				feedback_MessagePolitics("Judge","@L_LAWSUIT_3_INTRO_PERSON_NOT_PRESENT_ANGEKLAGTER_MESSAGES_+12",
						"@L_LAWSUIT_3_INTRO_PERSON_NOT_PRESENT_ANGEKLAGTER_MESSAGES_+13",GetID("Sim"),HoursInPrison,GetID("City"))
			elseif (Decision==2) then
				-- fee
				CityAddPenalty("City","Sim",PENALTY_MONEY, Fee )
				feedback_MessagePolitics("Accuser","@L_LAWSUIT_3_INTRO_PERSON_NOT_PRESENT_ANGEKLAGTER_MESSAGES_+10",
						"@L_LAWSUIT_3_INTRO_PERSON_NOT_PRESENT_ANGEKLAGTER_MESSAGES_+11",GetID("Sim"),Fee)
				feedback_MessagePolitics("Assessor1","@L_LAWSUIT_3_INTRO_PERSON_NOT_PRESENT_ANGEKLAGTER_MESSAGES_+10",
						"@L_LAWSUIT_3_INTRO_PERSON_NOT_PRESENT_ANGEKLAGTER_MESSAGES_+11",GetID("Sim"),Fee)
				feedback_MessagePolitics("Assessor2","@L_LAWSUIT_3_INTRO_PERSON_NOT_PRESENT_ANGEKLAGTER_MESSAGES_+10",
						"@L_LAWSUIT_3_INTRO_PERSON_NOT_PRESENT_ANGEKLAGTER_MESSAGES_+11",GetID("Sim"),Fee)
				feedback_MessagePolitics("Judge","@L_LAWSUIT_3_INTRO_PERSON_NOT_PRESENT_ANGEKLAGTER_MESSAGES_+10",
						"@L_LAWSUIT_3_INTRO_PERSON_NOT_PRESENT_ANGEKLAGTER_MESSAGES_+11",GetID("Sim"),Fee)
			end
		end
	end
	DestroyCutscene("")
end
function CleanUp()
	DestroyCutscene("")
end