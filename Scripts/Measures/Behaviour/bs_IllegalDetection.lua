function Run()
	
	if IsType("","Cart") then
		return "-"
	end
	
	if HasProperty("", "NotAffectable") then
		return "-"
	end
	
	if ActionIsStopped("Action") then
		-- Check if its a city guard
		if not GetState("", STATE_SCANNING) then
			return ""
		end
	end
	
	if GetState("",STATE_NPC) then
		return "-"
	end
	
	if GetImpactValue("","spying") == 1 then
		return ""
	end
	
	if BattleIsFighting("") then
		if not HasProperty("","AttBld") then
			return ""
		end
	end
	
	if GetState("",STATE_ROBBERGUARD) then
		return ""
	end
	
	if GetCurrentMeasureID("")==660 then  --burglary
		return ""
	end

	if GetCurrentMeasureID("")==680 then  --pickpocketing
		return ""
	end
	
	if GetCurrentMeasureID("")==360 then  --attackenemy
		return ""
	end
	
	if GetCurrentMeasureID("")==3505 then  --SquadWaylayMember
		SetProperty("","DontLeave",1)
	end
	
	--put this code here so that it will only be called on affected Sim. Also got rid of the Empathy factor. Only someone trained in the arts of stealth can see through it. How would empathy even play a role? just too stupid to fathom lol
	local ActorStealth = GetSkillValue("Actor","SHADOW_ARTS") 
	local WatcherStealth = GetSkillValue("","SHADOW_ARTS")
	local Advantage = 0
	local Equation = 0
	if not GetState("Actor",STATE_FIGHTING) then --I mean if the guy is in a fight then he isn't exactly sneaking around...am I right? Yes, yes I am....
		if ActorStealth > WatcherStealth then
			if WatcherStealth > 0 and ActorStealth > 1 then
				WatcherStealth = WatcherStealth - 1 --Rand calls zero so this ensures proper advantage
				ActorStealth = ActorStealth - 1
			end
			local currentGameTime = math.mod(GetGametime(),24)
			if (currentGameTime > 21) or (currentGameTime < 5) then
				ActorStealth = ActorStealth * 2
			end
			Equation = ActorStealth - WatcherStealth
			if Rand(ActorStealth) < Equation and not HasProperty("","KIbodyguard") then 
				if GetEvidenceValues("","Actor") < 9 or (GetEvidenceValues("","Actor") == 15 and GetCurrentMeasureID("Actor") == 2815) then --Good to go!
					RemoveEvidences("","Actor")
				end
				--LogMessage("LogMessage: This Happened")
				return "" --Did not see anything! Stealth Skill Worked :)
			end
		end
	end
	
	--LogMessage("WatcherStealth: "..WatcherStealth.."  ActorStealth: "..ActorStealth.."  Equation: "..Equation)
	
	local GuardOffice = 0
	local Count = DynastyGetMemberCount("Actor")
	for i=0,Count-1 do
		DynastyGetMember("Actor",i,"Member")
		if GetImpactValue("Member","CommandCityGuard")>=1 then
			GuardOffice = 1
			break
		end
	end
	GetDynasty("Actor","Dynasty")
	local AggressorID = GetDynastyID("Actor")
	local VictimID = GetDynastyID("Victim")
	local WatcherID = GetDynastyID("")
	local bEvidence = ActionIsEvidence("Action")
	local bIsGuard = (GetDynastyID("") == -1) and (SimGetClass("") == GL_CLASS_CHISELER)
	local VDistance = CalcDistance("","Victim")
	local ADistance = CalcDistance("","Actor")
	if GetImpactValue("Actor","CommandCityGuard")==0 and GetImpactValue("Actor","BribeGuard")==0 and GuardOffice==0 then
		-- Attack Aggressor if victim is same dynasty
		if VictimID == WatcherID and AliasExists("Actor") and not GetState("Actor",STATE_UNCONSCIOUS) then
			if ADistance ~= -1 and ADistance < 4001 then
				if HasProperty("Actor","AttBld") then
					f_Follow("","Actor",GL_MOVESPEED_RUN,100,true)
					CreateScriptcall("AttackDem",0.05,"Measures/Behaviour/bs_IllegalDetection.lua","AttackThem","Actor","")
					return
				end
				f_Follow("","Actor",GL_MOVESPEED_RUN,100,true)
				CopyAlias("Actor", "Destination")
				return "Attack"
			end
		end
		-- Attack Victim if aggressor is same dynasty
		if AggressorID == WatcherID and AliasExists("Victim") and not GetState("Victim",STATE_UNCONSCIOUS) then
			if AliasExists("") then
				if VDistance ~= -1 and VDistance < 4001 then
					if HasProperty("","AttBld") then
						if not IsType("Victim","Building") then
							f_Follow("","Victim",GL_MOVESPEED_RUN,100,true)
							CreateScriptcall("AttackDem",0.05,"Measures/Behaviour/bs_IllegalDetection.lua","AttackThem","","Victim")
							return
						end
					end
					f_Follow("","Victim",GL_MOVESPEED_RUN,100,true)
					CopyAlias("Victim", "Destination")
					return "Attack"
				end
			end
		end
		
		-- join an existing Fight
		if bIsGuard then
			if AggressorID == SimGetServantDynastyId("") then
				if VDistance ~= -1 and VDistance < 4001 then
					if HasProperty("","AttBld") then
						if not IsType("Victim","Building") then
							BattleLeave("")
							SetState("",STATE_FIGHTING,false)
						end
					end
					f_Follow("","Victim",GL_MOVESPEED_RUN,100,true)
					CopyAlias("Victim", "Destination")
					return "Attack"
				end
			elseif VictimID == SimGetServantDynastyId("") then
				if ADistance ~= -1 and ADistance < 4001 then
					if HasProperty("Actor","AttBld") then
						f_Follow("","Actor",GL_MOVESPEED_RUN,100,true)
						CreateScriptcall("AttackDem",0.05,"Measures/Behaviour/bs_IllegalDetection.lua","AttackThem","Actor","")
						return
					end
				end
			else
				f_Follow("","Actor",GL_MOVESPEED_RUN,100,true)
				CopyAlias("Actor", "Destination")
				return "Attack"
			end
		end
		
		-- starts a new Fight
		if IsType("", "Ship") then
			-- attack if i am the victim to protect myself
			if GetDynastyID("") == GetDynastyID("Victim") then
				if DynastyGetDiplomacyState("", "Actor")>DIP_NEUTRAL then
					DynastySetDiplomacyState("", "Actor", DIP_NEUTRAL)
				end
				CopyAlias("Actor", "Destination")
				return "Attack"
			end
			
			-- attack if i am allied with victim
			if DynastyGetDiplomacyState("", "Victim") == DIP_ALLIANCE then
				if DynastyGetDiplomacyState("", "Actor") <= DIP_NEUTRAL then
					if ADistance ~= -1 and ADistance < 4001 then
						if HasProperty("Actor","AttBld") then
							f_Follow("","Actor",GL_MOVESPEED_RUN,100,true)
							CreateScriptcall("AttackDem",0.05,"Measures/Behaviour/bs_IllegalDetection.lua","AttackThem","Actor","")
							return
						end
						f_Follow("","Actor",GL_MOVESPEED_RUN,100,true)
						CopyAlias("Actor", "Destination")
						return "Attack"
					end
				end
			end
		end
		
		
		if SimGetClass("") == GL_CLASS_CHISELER then
			
			-- am i a robber with protectionmoney measure (ms_134_PressProtectionMoney.lua) and is my house the victim
			local bRobberGuard = HasProperty("", "RobberProtecting")
			if (bRobberGuard == true) then
				local iRobberID = GetDynastyID("")
				if AliasExists("VictimObject") then
					local iRobberProtHouseDynID = GetProperty("VictimObject", "RobberProtected")
					if (iRobberID == iRobberProtHouseDynID) then
						if IsType("Victim","Building") and IsType("","Sim") and GetCurrentMeasureID("Actor") == 360 then
							f_Follow("","Actor",GL_MOVESPEED_RUN,100,true)
							CreateScriptcall("AttackDem",0.05,"Measures/Behaviour/bs_IllegalDetection.lua","AttackThem","Actor","")
							return
						end
						f_Follow("","Actor",GL_MOVESPEED_RUN,100,true)
						CopyAlias("Actor", "Destination")
						return "Attack"
					end
				end
			end
			
			-- Fighter without a dynasty means guard, and guards attack illegals
			if (bEvidence and bIsGuard) then
				local	ActorID = GetDynastyID("Actor")
				if ActorID<1 or ActorID~=SimGetServantDynastyId("") then
					if ADistance ~= -1 and ADistance < 4001 then
						if HasProperty("Actor","AttBld") then
							f_Follow("","Actor",GL_MOVESPEED_RUN,100,true)
							CreateScriptcall("AttackDem",0.05,"Measures/Behaviour/bs_IllegalDetection.lua","AttackThem","Actor","")
							return
						end
						f_Follow("","Actor",GL_MOVESPEED_RUN,100,true)
						CopyAlias("Actor", "Destination")
						return "Attack"
					end
				end
				SetData("Distance", 2500)
				return "-Flee"
			end
			
			-- attack if i am the victim to protect myself
			if AliasExists("Victim") and GetDynastyID("") == GetDynastyID("Victim") then
				if DynastyGetDiplomacyState("", "Actor")>DIP_NEUTRAL then
					DynastySetDiplomacyState("", "Actor", DIP_NEUTRAL)
				end
				if ADistance ~= -1 and ADistance < 4001 then
					if HasProperty("Actor","AttBld") then
						f_Follow("","Actor",GL_MOVESPEED_RUN,100,true)
						CreateScriptcall("AttackDem",0.05,"Measures/Behaviour/bs_IllegalDetection.lua","AttackThem","Actor","")
						return
					end
					f_Follow("","Actor",GL_MOVESPEED_RUN,100,true)
					CopyAlias("Actor", "Destination")
					return "Attack"
				end
			end
			
			-- attack if i am allied with victim
			if AliasExists("Victim") and DynastyGetDiplomacyState("", "Victim") == DIP_ALLIANCE then
				if DynastyGetDiplomacyState("", "Actor") <= DIP_NEUTRAL then
					if ADistance ~= -1 and ADistance < 4001 then	
						if HasProperty("Actor","AttBld") then
							f_Follow("","Actor",GL_MOVESPEED_RUN,100,true)
							CreateScriptcall("AttackDem",0.05,"Measures/Behaviour/bs_IllegalDetection.lua","AttackThem","Actor","")
							return
						end
						f_Follow("","Actor",GL_MOVESPEED_RUN,100,true)
						CopyAlias("Actor", "Destination")
						return "Attack"
					end
				end
			end
		end
		
		local Status = DynastyGetDiplomacyState("","Victim")
		if GetDynastyID("")>0 and AliasExists("Victim") and GetDynastyID("")==GetDynastyID("Victim") then
			return "-CallGuards"
		end
		
		if Status >= DIP_NEUTRAL and not SimGetClass("") == 4 then
			return "-CallGuards"
		elseif Status > DIP_NAP then
			return "-CallGuards"
		end
		
		if Status < DIP_NEUTRAL then
			return "-Gape:8"
			--return ""   --this might be needed again if this measure is too disruptive
		end
		
		-- some workless just flee at random
		local random = Rand(5)
		if ((random > 3) and (GetDynastyID("Owner") < 1)) then
			return "-Flee"
		elseif (GetDynastyID("Owner") < 1) then
			return "-Gape:8"
		end
		
		---This is dumb....Sims will call guards on their own dynasty
		-- der Rest ruft Wachen
		--if (bEvidence) then
		--	return "-CallGuards:2"
		--end
		
		--return "-Gape:8"
		return ""
	else
		MeasureSetNotRestartable()
		-- Attack Aggressor if victim is same dynasty
		if VictimID == WatcherID and AliasExists("Actor") and not GetState("Actor",STATE_UNCONSCIOUS) then
			if ADistance ~= -1 and ADistance < 4001 then
				if HasProperty("Actor","AttBld") then
					f_Follow("","Actor",GL_MOVESPEED_RUN,100,true)
					CreateScriptcall("AttackDem",0.05,"Measures/Behaviour/bs_IllegalDetection.lua","AttackThem","Actor","")
					return
				end
				f_Follow("","Actor",GL_MOVESPEED_RUN,100,true)
				CopyAlias("Actor", "Destination")
				return "Attack"
			end
		end
		
		-- Attack Victim if aggressor is same dynasty
		if AggressorID == WatcherID and AliasExists("Victim") and not GetState("Victim",STATE_UNCONSCIOUS) then
			if AliasExists("") then
				if VDistance ~= -1 and VDistance < 4001 then
					if HasProperty("","AttBld") then
						if not IsType("Victim","Building") then
							BattleLeave("")
							SetState("",STATE_FIGHTING,false)
						end
					end
					f_Follow("","Victim",GL_MOVESPEED_RUN,100,true)
					CopyAlias("Victim", "Destination")
					return "Attack"
				end
			end
		end
		
		if bIsGuard then
			if AggressorID == SimGetServantDynastyId("") then
				if VDistance ~= -1 and VDistance < 4001 then
					if HasProperty("","AttBld") then
						if not IsType("Victim","Building") then
							BattleLeave("")
							SetState("",STATE_FIGHTING,false)
						end
					end
					f_Follow("","Victim",GL_MOVESPEED_RUN,100,true)
					CopyAlias("Victim", "Destination")
					return "Attack"
				end
			elseif VictimID == SimGetServantDynastyId("") then
				if ADistance ~= -1 and ADistance < 4001 then
					if HasProperty("Actor","AttBld") then
						f_Follow("","Actor",GL_MOVESPEED_RUN,100,true)
						CreateScriptcall("AttackDem",0.05,"Measures/Behaviour/bs_IllegalDetection.lua","AttackThem","Actor","")
						return
					end
				end
			else
				f_Follow("","Actor",GL_MOVESPEED_RUN,100,true)
				CopyAlias("Actor", "Destination")
				return "Attack"
			end
		end
		
		if GetImpactValue("Dynasty","Timer") == 0 then
			if GetImpactValue("Dynasty","BadBoy") > 0 then
				local random = Rand(30) + 20
				if GetImpactValue("Dynasty","BadBoy") >= random then
					local famdyncnt = DynastyGetFamilyMemberCount("Actor")
					for x=0,famdyncnt-1 do
						DynastyGetFamilyMember("Actor",x,"FamMembr")
						if GetImpactValue("FamMembr","BadBoy") > 0 then
							if find_HomeCity("FamMembr","City") then
								SimSetOffice("FamMembr",0)
								CityAddPenalty("City","FamMembr",PENALTY_PRISON,12)
								RemoveImpact("FamMembr","BadBoy")
							end
						elseif GetID("FamMembr") == GetID("CommandGuards") then
							if find_HomeCity("FamMembr","City") then
								GetOfficeTypeHolder("City",2,"CommandGuards")
								SimSetOffice("FamMembr",0)
								CityAddPenalty("City","FamMembr",PENALTY_PRISON,24)
								RemoveImpact("FamMembr","BadBoy")
							end
						end
					end
					for r=0,famdyncnt-famdyncnt do
						DynastyGetFamilyMember("Actor",r,"Fam")
						SetNobilityTitle("Fam", 2, true)
						MsgNewsNoWait("Fam","","","intrigue",-1,
							"@L_INTRIGUE_STRIPPEDOFOFFICE_MSG_HEAD_+0",
							"@L_INTRIGUE_STRIPPEDOFOFFICE_MSG_BODY_+1",GetID(""))
					end
					local WkrCnt = DynastyGetWorkerCount("Dynasty",-1)
					for z=0,WkrCnt-1 do
						DynastyGetWorker("Dynasty",-1,z,"Wkr")
						if SimGetClass("Wkr") == 4 then
							if find_HomeCity("Wkr","City") then
								CityAddPenalty("City","Wkr",PENALTY_FUGITIVE,360)
								 AddImpact("Wkr","REVOLT",1,360)
							end
						end
					end
				else
					bs_illegaldetection_StopBroadcasting("Actor")
					bs_illegaldetection_RealBadBoy("Dynasty")
					if GetImpactValue("Actor","BadBoy") > 0 then
						bs_illegaldetection_RealBadBoy("Actor")
					else
						AddImpact("Actor","BadBoy",1,8)
					end
				end
			else
				if GetImpactValue("Actor","CommandCityGuard")==1 then
					if GetImpactValue("Actor","BadBoy") > 0 then
						local random = Rand(10) + 10
						if GetImpactValue("Actor","BadBoy") >= random then
							SimGetCityOfOffice("Actor","city")
							SimSetOffice("Actor",0)
							CityAddPenalty("city","Actor",PENALTY_PRISON,24)
							SetNobilityTitle("Actor", 2, true)
							MsgNewsNoWait("Actor","","","intrigue",-1,
								"@L_INTRIGUE_STRIPPEDOFOFFICE_MSG_HEAD_+0",
								"@L_INTRIGUE_STRIPPEDOFOFFICE_MSG_BODY_+0",GetID(""))
							RemoveImpact("Actor","BadBoy")
						else
							bs_illegaldetection_StopBroadcasting("Actor")
							bs_illegaldetection_RealBadBoy("Actor")
						end
					else
						bs_illegaldetection_StopBroadcasting("Actor")
						AddImpact("Actor","BadBoy",1,8)
					end
				else
					bs_illegaldetection_StopBroadcasting("Actor")
					AddImpact("Dynasty","BadBoy",1,8)
					AddImpact("Actor","BadBoy",1,8)
				end
			end
			AddImpact("Dynasty","Timer",1,0.5)
		end
		local Status = DynastyGetDiplomacyState("","Victim")
		if GetDynastyID("")>0 and AliasExists("Victim") and GetDynastyID("")==GetDynastyID("Victim") then
			return "-CallGuards"
		end
		
		if Status >= DIP_NEUTRAL and not SimGetClass("") == 4 then
			return "-CallGuards"
		elseif Status > DIP_NAP then
			return "-CallGuards"
		end
		
		if Status < DIP_NEUTRAL then
			return "-Gape:8"
			--return ""   --this might be needed again if this measure is too disruptive
		end
		
		-- some workless just flee at random
		local random = Rand(5)
		if ((random > 3) and (GetDynastyID("Owner") < 1)) then
			return "-Flee"
		elseif (GetDynastyID("Owner") < 1) then
			return "-Gape:8"
		end
		
		---This is dumb....Sims will call guards on their own dynasty
		-- der Rest ruft Wachen
		--if (bEvidence) then
		--	return "-CallGuards:2"
		--end
		
		--return "-Gape:8"
		return ""
	end
end

function StopBroadcasting(Actor)
	StopAction("attack",Actor)
	StopAction("attackcivilian",Actor)
	StopAction("lay_bomb",Actor)
	StopAction("murder",Actor)
	StopAction("burgleahouse",Actor)
	StopAction("rob",Actor)
	StopAction("pickpocket",Actor)
	StopAction("attackbuilding",Actor)
	StopAction("attackcart",Actor)
	StopAction("plunder",Actor)
	StopAction("attackship",Actor)
	StopAction("anschlag",Actor)
end

function RealBadBoy(Actor)
	local Crimes = GetImpactValue(Actor,"BadBoy")
	local Time = ImpactGetMaxTimeleft(Actor,"BadBoy")
	AddImpact(Actor,"BadBoy",Crimes+1,Time+8)
end

function AttackThem()
	if GetInsideBuilding("Destination") then
		f_ExitCurrentBuilding("Destination")
	end
	f_Follow("","Destination",GL_MOVESPEED_RUN,100,true)
	SimStopMeasure("Destination")
	BattleLeave("Destination")
	SimStopMeasure("Destination")
	MeasureRun("","Destination","AttackEnemy",true)
end

function CleanUp()
end
