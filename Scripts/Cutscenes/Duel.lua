function Start()
	if not GetSettlement("challenger", "my_settlement") then
		return	  
	end
	
	if CityGetRandomBuilding("my_settlement", -1, GL_BUILDING_TYPE_DUELPLACE, -1, -1, FILTER_IGNORE, "duel_place") then -- 31 = duel place type, 23=townhall (preliminary)
	
		CityScheduleCutsceneEvent("my_settlement","duel_date","","EverybodyInTheirPlace",5,5,"@L_DUELL_6_TIMEPLANNERENTRY_DATEBOOK_+0",GetID("challenger"),GetID("challenged"))	-- hourofday=7,mintimeinfuture=2

		--invite sims to duel
		if GetID("challenger")>0 then
			SimAddDate("challenger","duel_place","Duel", SettlementEventGetTime("duel_date")-40,"AttendDuel")
			feedback_MessageCharacter("challenger",
					"@L_DUELL_6_TIMEPLANNERENTRY_DUELLIST2_+0",
					"@L_DUELL_6_TIMEPLANNERENTRY_DUELLIST2_+1",
					GetID("challenged"),GetID("challenger"))
			
			SimAddDatebookEntry("challenger",SettlementEventGetTime("duel_date"),"duel_place",
						"@L_NEWSTUFF_DUEL_DATEBOOK_HEADER","@L_DUELL_6_TIMEPLANNERENTRY_DATEBOOK_+0",GetID("challenger"),GetID("challenged"))
		end
		if GetID("challenged")>0 then
			SimAddDate("challenged","duel_place","Duel", SettlementEventGetTime("duel_date")-40,"AttendDuel")
--			feedback_MessageCharacter("challenged",
--					"@L_DUELL_6_TIMEPLANNERENTRY_DUELLIST1_+0",
--					"@L_DUELL_6_TIMEPLANNERENTRY_DUELLIST1_+1",
--					GetID("challenged"),GetID("challenger"))
			
			SimAddDatebookEntry("challenged",SettlementEventGetTime("duel_date"),"duel_place",
							"@L_NEWSTUFF_DUEL_DATEBOOK_HEADER","@L_DUELL_6_TIMEPLANNERENTRY_DATEBOOK_+0",GetID("challenger"),GetID("challenged"))
		end
		
		
		
	else
		-- TODO: send feedback message to players that there is no duel place in town
		EndCutscene("")
	end
end

function EverybodyInTheirPlace()
			
	-- Gebäude und darinstehende Sims locken
	--BuildingLockForCutscene("duel_place","")
	
	-- Save the current hitpoints of the challengers for calculation of xp-points in case of a draw
	SetData("ChallengerHP", GetHP("challenger"))
	SetData("ChallengedHP", GetHP("challenged"))
		
	-- take place
	local wait_cnt = 0
	wait_cnt = wait_cnt + duel_StandAt("challenger","a_start")
	wait_cnt = wait_cnt + duel_StandAt("challenged","b_start")
	wait_cnt = wait_cnt + duel_StandAt("Doctor","Doctor")
	wait_cnt = wait_cnt + duel_StandAt("Sekundant1","Sekundant1")
	wait_cnt = wait_cnt + duel_StandAt("Sekundant2","Sekundant2")
	
	
	
	-- set next event
	CutsceneAddTriggerEvent("","Go", "Reached", wait_cnt,60)
end

function Go()
	--initiate sekundanten and doc		
	if Find("duel_place","__F( (Object.GetObjectsByRadius(Sim) == 2000) AND (Object.Property.BUILDING_NPC==5))","Doctor",-1)==1 then
		if AliasExists("challenger") then
			AlignTo("Doctor","challenger")
		end
	end
	if Find("duel_place","__F( (Object.GetObjectsByRadius(Sim) == 2000) AND (Object.Property.BUILDING_NPC==6))","Sekundant1",-1)==1 then
		if AliasExists("challenger") then
			AlignTo("Sekundant1","challenger")
		end
	end
	if Find("duel_place","__F( (Object.GetObjectsByRadius(Sim) == 2000) AND (Object.Property.BUILDING_NPC==7))","Sekundant2",-1)==1 then
		if AliasExists("challenger") then
			AlignTo("Sekundant2","challenger")
		end
	end
	
	Sleep(1)
	
	--init locators
	GetLocatorByName("duel_place","a_start","a_start")
	GetLocatorByName("duel_place","b_start","b_start")
	GetLocatorByName("duel_place","a_end","a_end")
	GetLocatorByName("duel_place","b_end","b_end")
	GetLocatorByName("duel_place","camera1","camera1")
	GetLocatorByName("duel_place","camera2","camera2")
	GetLocatorByName("duel_place","camera3","camera3")
	GetLocatorByName("duel_place","camera4","camera4")
	
	CutsceneAddSim("","challenger")
	CutsceneAddSim("","challenged")
	CutsceneAddSim("","Doctor")
	CutsceneAddSim("","Sekundant1")
	CutsceneAddSim("","Sekundant2")
	
	
	CutsceneCameraCreate("","Doctor")
	CutsceneCameraSetRelativePosition("","CameraPortrait","Doctor")

	--check if all sims are aboard
	local ChallengerMissing = 0
	local ChallengedMissing = 0
	
	--challenger is missing
	if duel_SimIsPresent("challenger")~=1 then
		feedback_MessageCharacter("challenger",
					"@L_DUELL_1_DIALOGMSG_TOOLATE_+0",
					"@L_DUELL_1_DIALOGMSG_TOOLATE_+1",GetID("challenger"),GetID("challenged"))
		ChallengerMissing = 1
	end
	--challenged is missing
	if duel_SimIsPresent("challenged")~=1 then
		feedback_MessageCharacter("challenged",
					"@L_DUELL_1_DIALOGMSG_TOOLATE_+0",
					"@L_DUELL_1_DIALOGMSG_TOOLATE_+1",GetID("challenged"),GetID("challenger"))
		ChallengedMissing = 1
	end
	
	--if one duelist is missing
	if ChallengerMissing == 1 or ChallengedMissing == 1 then
		local Spoker = 0
		if ChallengerMissing == 1 then
			CutsceneCameraSetRelativePosition("","CameraPortrait","Sekundant1")
			MsgSay("Sekundant1","@L_DUELL_2_MISSING_1ST",GetID("challenger"))
			Spoken = 1
		elseif ChallengedMissing == 1 then
			CutsceneCameraSetRelativePosition("","CameraPortrait","Sekundant2")
			MsgSay("Sekundant2","@L_DUELL_2_MISSING_1ST",GetID("challenged"))
			Spoken = 2
		end
		
		--if both are missing
		if ChallengerMissing == 1 and ChallengedMissing == 1 then
			if Spoken == 1 then
				CutsceneCameraSetRelativePosition("","CameraPortrait","Sekundant1")
				MsgSay("Sekundant1","@L_DUELL_2_MISSING_2ND",GetID("challenged"))
			else
				CutsceneCameraSetRelativePosition("","CameraPortrait","Sekundant2")
				MsgSay("Sekundant2","@L_DUELL_2_MISSING_2ND",GetID("challenger"))
			end
		end
		
		CutsceneCameraSetRelativePosition("","CameraPortrait","Doctor")
		MsgSay("Doctor","@L_DUELL_2_MISSING_END_1")
		if Rand(100) > 49 then
			MsgSay("Doctor","@L_DUELL_2_MISSING_END_2")
		end
		--CameraUnlock()
		duel_EndDuel()
	end
		
	--make light
	CutsceneCameraSetRelativePosition("","DuelView","challenger")
	gameplayformulas_StartHighPriorMusic(MUSIC_FIGHT)
	duel_Torch(1)
	MoveSetActivity("challenged","duel")
	local ActivityTime = MoveSetActivity("challenger","duel")
	Sleep(1)
	CarryObject("challenger","Handheld_Device/ANIM_gun.nif",false)
	CarryObject("challenged","Handheld_Device/ANIM_gun.nif",false)
	Sleep(ActivityTime)
	
	--INTRO
	local Speaker = "Sekundant"..Rand(2)+1
	MsgSay("Doctor","@L_DUELL_3_INTRO_1",GetID("challenger"),GetID("challenged"))
	MsgSay("Doctor","@L_DUELL_3_INTRO_2")


	--ROUND 1 ... FIGHT
	local MsgTimeOut = 0.5
	SetData("MsgTimeOut",MsgTimeOut)
	
	
	--ask for cheating
	CutsceneCallThread("", "Cheat","","challenger")
	CutsceneCallThread("", "Cheat","","challenged")
	
	-- set next event
	CutsceneAddTriggerEvent("","InitiateDuel", "Cheated", 2,160)
	
end

function InitiateDuel()
	
	--let the sims walk their 10 steps, or 9 if cheat
	local Actor
	local i
	for i=1,2 do
		if i==1 then
			Actor = "challenger"
		else
			Actor = "challenged"
		end
		
		if GetData("Cheat"..Actor) == "A" then
			SetData("Betray"..Actor,100)
			CutsceneCallThread("", "Walk","",Actor)
		else
			SetData("Betray"..Actor,0)
			CutsceneCallThread("", "Walk","",Actor)
		end
	end
	-- set next event
	CutsceneAddTriggerEvent("","Round1Init", "Walked", 2,160)
end

function Round1Init()
	--check if someone has cheaten
	local Actor
	local i
	local SekundantSkill
	local Sekundant
	for i=1,2 do	
		SekundantSkill = Rand(6) + 1
		if i==1 then
			Actor = "challenger"
			Sekundant = "Sekundant1"
		else
			Actor = "challenged"
			Sekundant = "Sekundant2"
		end

		--reset damage for duel
		SetData("DamageTaken"..Actor,0)
		
		--check if sekundant recognizes the cheat
		if GetData("Cheat"..Actor) == "A" then 
			if not CheckSkill(Actor,6,SekundantSkill) then
				PlayAnimationNoWait(Sekundant,"propel")
				MsgSay(Sekundant,"@L_DUELL_4_FIGHT_BETRAY_COMMENTS")
				SetData("DefensiveMalus"..Actor,-4)
				SetData("CheatSuccess"..Actor,1)
			end
		end
		
	end
	
	AlignTo("challenger","challenged")
	Sleep(0.75)
	AlignTo("challenged","challenger")
	Sleep(2)
	
	
	SetData("ChallengerAttackSkill",GetSkillValue("challenger",FIGHTING))
	SetData("ChallengerDefendSkill",GetSkillValue("challenger",DEXTERITY))
	SetData("ChallengedAttackSkill",GetSkillValue("challenged",FIGHTING))
	SetData("ChallengedDefendSkill",GetSkillValue("challenged",DEXTERITY))
	
	
	local Round = 1
	SetData("Round",Round)
	
	--TURN
	CutsceneCallThread("", "Action","","challenger")
	CutsceneCallThread("", "Action","","challenged")
	
	CutsceneAddTriggerEvent("","Round1Action", "ActionRound", 2,160)
end

function Round1Action()
	
	local ActivityTime
	local i=1
	local Attacker
	local Defender
	local TotalShots = 0
	local AttackerAttackSkill 
	local AttackerDefendSkill 
	local DefenderAttackSkill
	local DefenderDefendSkill 
	
	if GetData("Round")==1 then
		MoveSetActivity("challenger","duelshoot")
		ActivityTime = MoveSetActivity("challenged","duelshoot")
		Sleep(ActivityTime)
	end
	
	for i=1,2 do
		if i == 1 then 	--first part of round
			Attacker = "challenger"
			Defender = "challenged"
			AttackerAttackSkill = GetData("ChallengerAttackSkill")
			AttackerDefendSkill = GetData("ChallengerDefendSkill")		
			DefenderAttackSkill = GetData("ChallengedAttackSkill")
			DefenderDefendSkill = GetData("ChallengedDefendSkill")
		else		--second part of round
			Attacker = "challenged"
			Defender = "challenger"
			AttackerAttackSkill = GetData("ChallengedAttackSkill")
			AttackerDefendSkill = GetData("ChallengedDefendSkill")
			DefenderAttackSkill = GetData("ChallengerAttackSkill")
			DefenderDefendSkill = GetData("ChallengerDefendSkill")	
		end
		
		local DamageTaken = 0
		local AttackerHit = 0
		local AttackerDamage = -50 - (10 * AttackerAttackSkill) - (Rand(10) * AttackerAttackSkill)
		local ShotDone = 0
		local Time1
		local Time2
		local AttackerDecision = GetData("Action"..Attacker)
		local ChanceToHitDoctor = 5
		local WeaponFailure = Rand(100)
		if WeaponFailure < (10 - GetSkillValue(Attacker,FIGHTING)) then
			if Rand(10) < 6 then
				WeaponFailure = 2  --weapon will explode and make damage on attacker
			else
				WeaponFailure = 1  --weapon will fail
			end
		else 
			WeaponFailure = 0  --weapon will not fail
		end
		
		--if message has canceled or time out, let AI decide
		if AttackerDecision == "C" then
			AttackerDecision = duel_AIDecideAction()
		end
		
		--camera_DialogCam(Attacker,0,0)
		--CutsceneCameraSetRelativePosition("","CameraPortrait",Attacker)
		
		if AttackerDecision == "A" then --quick shot
			AttackerAttackSkill = AttackerAttackSkill - 2
			DefenderDefendSkill = DefenderDefendSkill - 4
			ShotDone = 1
			--PlayAnimationNoWait(Attacker,"threat")
			MsgSay(Attacker,"@L_DUELL_4_FIGHT_TURN_SHOT_FAST")
		elseif AttackerDecision == "B" then --aimed shot
			ShotDone = 1
			--PlayAnimationNoWait(Attacker,"threat")
			MsgSay(Attacker,"@L_DUELL_4_FIGHT_TURN_SHOT_AIMED")
		elseif AttackerDecision == "D" then --insult
			--PlayAnimationNoWait(Attacker,"threat")
			MsgSay(Attacker,"@L_DUELL_4_FIGHT_TURN_SLANDER")
			Sleep(1)
			--camera_DialogCam(Defender,0,0)
			--CutsceneCameraSetRelativePosition("","CameraPortrait",Defender)
			if CheckSkill(Attacker,7,GetSkillValue(Defender,8)) then
				MsgSayNoWait(Defender,"@L_DUELL_4_FIGHT_TURN_SLANDER_SUCCESS")
				PlayAnimation(Defender,"threat")
				DefenderDefendSkill = DefenderDefendSkill - 3	
			else
				MsgSayNoWait(Defender,"@L_DUELL_4_FIGHT_TURN_SLANDER_FAILED")
				PlayAnimation(Defender,"shake_head")
			end
			ShotDone = 0
			
		else --evade
			if CheckSkill(Attacker,2,5) then --evade success
				MsgQuick(Attacker,"@L_DUELL_4_FIGHT_TURN_EVADE_SUCCESS_+0")
				MsgQuick(Defender,"@L_DUELL_4_FIGHT_TURN_EVADE_SUCCESS_+1")
				Sleep(2)
				AttackerDefendSkill = AttackerDefendSkill + 4
			else
				MsgQuick(Attacker,"@L_DUELL_4_FIGHT_TURN_EVADE_FAILED_+0")
				MsgQuick(Defender,"@L_DUELL_4_FIGHT_TURN_EVADE_FAILED_+1")
				Sleep(2)
			end
			ShotDone = 0
		end
		
		--CameraBlend(2,2)
		--CameraLock("camera2")
		--CameraLockLookAt("doctor")
		--CutsceneCameraSetRelativePosition("","DuelView","challenger")
		Sleep(2)
		
		--cheat malus
		if GetData("Round")==1 then
			--only round 1
			if HasData("DefensiveMalus"..Attacker) then
				DefenderDefendSkill = DefenderDefendSkill - GetData("DefensiveMalus"..Attacker)
			end
			
		end
		
		
		if i == 1 then
			SetData("ChallengerAttackSkill",AttackerAttackSkill)
			SetData("ChallengerDefendSkill",AttackerDefendSkill)
			SetData("ChallengedAttackSkill",DefenderAttackSkill)
			SetData("ChallengedDefendSkill",DefenderDefendSkill)
		else
			SetData("ChallengedAttackSkill",AttackerAttackSkill)
			SetData("ChallengedDefendSkill",AttackerDefendSkill)
			SetData("ChallengerAttackSkill",DefenderAttackSkill)
			SetData("ChallengerDefendSkill",DefenderDefendSkill)
		end
		
		if ShotDone == 1 then			
			
			if WeaponFailure > 0 then
				--camera_DialogCam(Attacker,0,0)
				if WeaponFailure == 2 then --weapon explodes and deals damage to attacker
					
					if GetPositionOfSubobject(Attacker,"Game_Wrist_r" ,"Game_Wrist_r") then
						StartSingleShotParticle("particles/small_explo.nif", "Game_Wrist_r",1,5)
					end
					PlaySound3D(Attacker,"fire/Explosion_s_04.wav",1)
					if GetHP(Attacker) > 20 then
						ModifyHP(Attacker,-10,true)
					end
					PlayAnimationNoWait(Attacker,"appal")
					MsgSay(Attacker,"@L_DUELL_4_FIGHT_TURN_SHOT_HIT_+0")
					ShotDone = 0
				elseif WeaponFailure == 1 then --jam
					PlaySound3D(Attacker,"Locations/forge/forge+1.wav",1)
					Sleep(2.5)
					PlayAnimationNoWait(Attacker,"cogitate")
					Sleep(2)
					MsgSay(Attacker,"@L_DUELL_4_FIGHT_TURN_SHOT_JAM")
					ShotDone = 0
				end
			else	
				
--				GetPositionOfSubobject(Attacker,"Game_Wrist_r" ,"Game_Wrist_r")
--				StartSingleShotParticle("particles/gunshot.nif", "Game_Wrist_r",2,5)
				Time1 = PlayAnimationNoWait(Attacker,"duel_shoot")
--				PlaySound3D(Attacker,"Effects/combat_cannon_shot/combat_cannon_shot+0.wav",1)
				if AttackerAttackSkill >= DefenderDefendSkill then --hit
					AttackerHit = 1
				else --no hit
					AttackerHit = 0
				end
			end	
		end
		
		--time the bullet needs to hit
		Sleep(0.25)	
	
		if AttackerHit == 1 and ShotDone == 1 then
			if GetPositionOfSubobject(Defender, "Game_Chest_Scale","Game_Chest_Scale") then
				StartSingleShotParticle("particles/bloodsplash.nif", "Game_Chest_Scale", 1, 3.0)
			end
			Time1 = PlayAnimationNoWait(Defender,"duel_shoot_gothit")
			PlaySound3D(Attacker,"Effects/combat_strike_fist/combat_strike_fist+4.wav",1)
			Sleep(0.5)
			PlaySound3D(Attacker,"combat/pain/Hurt_s_01.wav",1)
			ModifyHP(Defender,AttackerDamage,true)
			DamageTaken = (AttackerDamage *-1) + GetData("DamageTaken"..Defender)
			SetData("DamageTaken"..Defender,DamageTaken)
			Sleep(0.5)
			MsgSay(Defender,"@L_DUELL_4_FIGHT_TURN_SHOT_HIT")
		elseif AttackerHit == 0 and ShotDone == 1 then
			if Rand(100) < ChanceToHitDoctor then
				Time1 = PlayAnimationNoWait("Doctor","crouch_down")
				if GetPositionOfSubobject(Defender, "Game_Chest_Scale","Game_Chest_Scale") then
					StartSingleShotParticle("particles/bloodsplash.nif", "Game_Chest_Scale", 1, 3.0)
				end
				ModifyHP("Doctor",-5,true)
				MsgSay("Doctor","@L_DUELL_4_FIGHT_TURN_SHOT_DOCHIT")
			else
				Time1 = PlayAnimationNoWait(Defender,"duel_shoot_avoid")
				feedback_OverheadComment(Defender, "@L_DUELL_4_FIGHT_TURN_SHOT_OVERHEAD_MISSED_+0", false, true)
				MsgSay(Defender,"@L_DUELL_4_FIGHT_TURN_SHOT_MISS")
			end
		end
		TotalShots = TotalShots + ShotDone
		Sleep(Time1)
		
	
		--check if one sim is already dead
		if GetHP(Defender)<=0 then
			--camera_DialogCam("Doctor",0,0)
			local TransitionTime = MoveSetActivity(Attacker,"")
			Sleep(TransitionTime)
			MoveSetActivity(Attacker,"")
			Sleep(2)
			CarryObject("challenger","",false)
			CarryObject("challenged","",false)
			if HasData("CheatSuccess"..Defender) then
				PlayAnimationNoWait("Doctor","cheer_02")
				MsgSay("Doctor","@L_DUELL_5_OUTRO_DOCTOR_BETRAYED")
				--CameraLock("camera2")
				--CameraLockLookAt("doctor")
				f_MoveTo("Doctor",Defender,GL_MOVESPEED_WALK,128)
				Sleep(1)
				MsgSay("Doctor","@L_DUELL_5_OUTRO_DOCTOR_BETRAYED_DEAD")
			else
				--CameraLock("camera2")
				--CameraLockLookAt("doctor")
				f_MoveTo("Doctor",Defender,GL_MOVESPEED_WALK,128)
				MsgSay("Doctor","@L_DUELL_5_OUTRO_DOCTOR_HEALS_DEAD")
			end
			
			AlignTo("Doctor",Attacker)
			Sleep(1)	
			
			if HasData("CheatSuccess"..Attacker) then
				--camera_DialogCam("Doctor",0,0)
				PlayAnimationNoWait("Doctor","cheer_02")
				MsgSay("Doctor","@L_DUELL_5_OUTRO_DOCTOR_BETRAYED")
			else
				f_MoveTo("Doctor",Attacker,GL_MOVESPEED_WALK,60)
				Sleep(1)
				if GetData("DamageTaken"..Attacker) > 0 then --has taken damage during duel
					local Heal = GetData("DamageTaken"..Attacker)/2
					MsgSay("Doctor","@L_DUELL_5_OUTRO_DOCTOR_HEALS_WOUNDED_1")
					PlayAnimation("Doctor","manipulate_middle_twohand")
					GetPosition(Attacker, "ParticleSpawnPos")
					StartSingleShotParticle("particles/healthglow.nif", "ParticleSpawnPos",1,10)
					ModifyHP(Attacker, Heal,false,true)
					MsgSay("Doctor","@L_DUELL_5_OUTRO_DOCTOR_HEALS_WOUNDED_2")
				else --no damage
					MsgSay("Doctor","@L_DUELL_5_OUTRO_DOCTOR_HEALS_NOSCRATCH")
				end
			end
			duel_EndDuel()
		end
		
		--check if one sim is unconscious
		if GetState(Defender,STATE_UNCONSCIOUS) then
			local TransitionTime = MoveSetActivity(Attacker,"")
			Sleep(TransitionTime)
			MoveSetActivity(Attacker,"")
			Sleep(2)
			CarryObject("challenger","",false)
			CarryObject("challenged","",false)
			--get the critic hit
			local CriticHit =      {"_EYE",8,
						"_KNEE",2,
						"_HANDS",5,
						"_STOMACH",1,
						"_EAR",3,
						"_ARM",4}
			local Number = 0
			while CriticHit[Number+1]~=nil do
				Number = Number + 2
			end
			Number  = Number / 2		
			
			local Lauf1 = 1 + (Rand(Number)*2)
			local Lauf2 = 1 + (Rand(Number)*2)
			while Lauf1 == Lauf2 do
				Lauf2 = 1 + (Rand(Number)*2)
			end
			local Replace1 = CriticHit[Lauf1]
			local CriticDamage1 = CriticHit[Lauf1+1]
			local Replace2 = CriticHit[Lauf2]
			local CriticDamage2 = CriticHit[Lauf2+1]
			--CameraLock("camera2")
			--CameraLockLookAt("doctor")
			--do the visual stuff on defender
			f_MoveTo("Doctor",Defender,GL_MOVESPEED_WALK,60)
			MsgSay("Doctor","@L_DUELL_5_OUTRO_DOCTOR_HEALS_CRITICAL_1")
			PlayAnimation("Doctor","manipulate_bottom_r")
			MsgSay("Doctor","@L_DUELL_5_OUTRO_DOCTOR_HEALS_CRITICAL"..Replace1.."_+0")
			SetSkillValue(Defender,CriticDamage1,GetSkillValue(Defender,CriticDamage1)-1)
			Time = PlayAnimationNoWait("Doctor","manipulate_bottom_r")
			MsgSay("Doctor","@L_DUELL_5_OUTRO_DOCTOR_HEALS_CRITICAL_2")
			MsgSay("Doctor","@L_DUELL_5_OUTRO_DOCTOR_HEALS_CRITICAL"..Replace2.."_+0")
			SetSkillValue(Defender,CriticDamage2,GetSkillValue(Defender,CriticDamage2)-1)
			
			--go to attacker
			AlignTo("Doctor",Attacker)
			Sleep(1)	
			
			if HasData("CheatSuccess"..Attacker) then
				--camera_DialogCam("Doctor",0,0)
				PlayAnimationNoWait("Doctor","cheer_02")
				MsgSay("Doctor","@L_DUELL_5_OUTRO_DOCTOR_BETRAYED")
			else
				f_MoveTo("Doctor",Attacker,GL_MOVESPEED_WALK,60)
				Sleep(1)
				if GetData("DamageTaken"..Attacker) > 0 then --has taken damage during duel
					local Heal = GetData("DamageTaken"..Attacker)/2
					MsgSay("Doctor","@L_DUELL_5_OUTRO_DOCTOR_HEALS_WOUNDED_1")
					PlayAnimation("Doctor","manipulate_middle_twohand")
					GetPosition(Attacker, "ParticleSpawnPos")
					StartSingleShotParticle("particles/healthglow.nif", "ParticleSpawnPos",1,10)
					ModifyHP(Attacker, Heal,true)
					MsgSay("Doctor","@L_DUELL_5_OUTRO_DOCTOR_HEALS_WOUNDED_2")
				else --no damage
					MsgSay("Doctor","@L_DUELL_5_OUTRO_DOCTOR_HEALS_NOSCRATCH")
				end
			end
			duel_EndDuel()
		end
		
	end
	
	Round = GetData("Round") + 1
	SetData("Round",Round)
	
	--final round
	if Round == 4 then
		local TransitionTime = MoveSetActivity("challenger","")
		MoveSetActivity("challenged","")
		Sleep(TransitionTime)
		MoveSetActivity("challenger","")
		MoveSetActivity("challenged","")
		Sleep(2)
		CarryObject("challenger","",false)
		CarryObject("challenged","",false)
		--CameraLock("camera2")
		--CameraLockLookAt("doctor")
		Sleep(1)
		local i
		for i=1,2 do
			if i==1 then
				Actor = "challenger"
			else
				Actor = "challenged"
			end
			AlignTo("Doctor",Actor)
			Sleep(1.5)
			if HasData("CheatSuccess"..Actor) then
				MsgSay("Doctor","@L_DUELL_5_OUTRO_DOCTOR_BETRAYED")
			else
				f_MoveTo("Doctor",Actor,GL_MOVESPEED_WALK,60)
				Sleep(1)
				if GetData("DamageTaken"..Actor) > 0 then --has taken damage during duel
					local Heal = GetData("DamageTaken"..Actor)/2
					MsgSay("Doctor","@L_DUELL_5_OUTRO_DOCTOR_HEALS_WOUNDED_1")
					PlayAnimation("Doctor","manipulate_middle_twohand")
					GetPosition(Actor, "ParticleSpawnPos")
					StartSingleShotParticle("particles/healthglow.nif", "ParticleSpawnPos",1,10)
					ModifyHP(Actor, Heal,true)
					MsgSay("Doctor","@L_DUELL_5_OUTRO_DOCTOR_HEALS_WOUNDED_2")
				else --no damage
					MsgSay("Doctor","@L_DUELL_5_OUTRO_DOCTOR_HEALS_NOSCRATCH")
				end
			end	
			
		end	
		duel_EndDuel()	
	end
	
	--if no dead and no unconscious and no final round then next round
	if TotalShots == 0 then
		MsgSay("Doctor","@L_DUELL_4_FIGHT_TURN_SHOT_DOCTOR")
	end
	
	CutsceneCallThread("", "Action","","challenger")
	CutsceneCallThread("", "Action","","challenged")
	
	CutsceneAddTriggerEvent("","Round1Action", "ActionRound", 2,160)
end

function EndDuel()

	-- Add xp
	if GetState("challenger", STATE_UNCONSCIOUS) or GetState("challenger", STATE_DEAD) then
		xp_DuelWithOpponent("challenged", true, GetSkillValue("challenger", FIGHTING) - GetSkillValue("challenged", FIGHTING), 0)
	elseif GetState("challenged", STATE_UNCONSCIOUS) or GetState("challenged", STATE_DEAD) then
		xp_DuelWithOpponent("challenger", true, GetSkillValue("challenged", FIGHTING) - GetSkillValue("challenger", FIGHTING), 0)
	else
		xp_DuelWithOpponent("challenged", false, GetSkillValue("challenger", FIGHTING) - GetSkillValue("challenged", FIGHTING), GetData("ChallengerHP") - GetHP("challenger"))
		xp_DuelWithOpponent("challenger", false, GetSkillValue("challenged", FIGHTING) - GetSkillValue("challenger", FIGHTING), GetData("ChallengedHP") - GetHP("challenged"))
	end
	
	--CameraLock("camera2")
	--CameraLockLookAt("Sekundant1")
	MsgSay("Doctor","@L_DUELL_5_OUTRO_END")
	if DynastyGetDiplomacyState("challenger","challenged")==DIP_ALLIANCE then
		chr_ModifyFavor("challenger","challenged",-10)
		chr_ModifyFavor("challenged","challenger",-10)
	else
		chr_ModifyFavor("challenger","challenged",40)
		chr_ModifyFavor("challenged","challenger",40)
	end
	duel_Torch(0)
	Sleep(1)
	--CameraUnlock()
	SetState("challenger",STATE_LOCKED,false)
	SetState("challenged",STATE_LOCKED,false)
	SimResetBehavior("doctor")
	SimSetBehavior("doctor","doctor")
	ModifyHP("Doctor",50,false)
	CarryObject("challenger","",false)
	CarryObject("challenged","",false)
	--BuildingLockForCutscene("duel_place",0)
	EndCutscene("")	
end


----------------------------------------------------
---- Duel Functions
----------------------------------------------------
function Walk(SimAlias)
	local BetraySteps = GetData("Betray"..SimAlias)
	local Position
	if SimAlias == "challenger" then
		Position = "a_end"
	else
		Position = "b_end"
	end
	Sleep(0.5)
	f_MoveTo(SimAlias,Position,GL_MOVESPEED_WALK,BetraySteps)
	Sleep(0.5)
	CutsceneSendEventTrigger("owner", "Walked")
end

function Cheat(SimAlias)
	local MsgTimeOut = 0 + GetData("MsgTimeOut")
	local Cheat = MsgSayInteraction(SimAlias,SimAlias,"duel_place",
				"@B[A,@L_DUELL_4_FIGHT_BETRAY_MENU_+2]"..
				"@B[B,@L_DUELL_4_FIGHT_BETRAY_MENU_+3]",
				duel_AIDecideToBetray,  --AIFunc
				--"@L_DUELL_4_FIGHT_BETRAY_MENU_+0",
				"@L_DUELL_4_FIGHT_BETRAY_MENU_+1",
				GetID(SimAlias))
	SetData("Cheat"..SimAlias,Cheat)
	CutsceneSendEventTrigger("owner", "Cheated")
end

function Action(SimAlias)
	local MsgTimeOut = 0 + GetData("MsgTimeOut")
	local Round = 0 + GetData("Round")
	local Action = MsgSayInteraction(SimAlias,SimAlias,"duel_place",
				"@B[A,@L_DUELL_4_FIGHT_TURN_MENU_+2]"..
				"@B[B,@L_DUELL_4_FIGHT_TURN_MENU_+3]"..
				"@B[D,@L_DUELL_4_FIGHT_TURN_MENU_+4]"..
				"@B[E,@L_DUELL_4_FIGHT_TURN_MENU_+5]",
				duel_AIDecideAction,  --AIFunc
				--"@L_DUELL_4_FIGHT_TURN_MENU_+0",
				"@L_DUELL_4_FIGHT_TURN_MENU_+1",
				Round,GetID(SimAlias))
	SetData("Action"..SimAlias,Action)
	CutsceneSendEventTrigger("owner", "ActionRound")
end

----------------------------------------------------
---- Init Functions
----------------------------------------------------

function StandAt(SimAlias, LocatorName)
	if duel_SimIsPresent(SimAlias)==1 then
		CutsceneCallThread("", "SimStandAt", SimAlias, LocatorName)
		return 1
	end
	return 0
end

function SimStandAt(LocatorName)
	if(GetLocatorByName("duel_place", LocatorName, LocatorName)) then
		f_BeginUseLocator("",LocatorName,GL_STANCE_STAND,true)
		SimStopMeasure("")
		SetState("",STATE_LOCKED,true)
		Sleep(1.5)
	end
	CutsceneSendEventTrigger("owner", "Reached")
end

function SimIsPresent(SimAlias)
	if GetID(SimAlias)>0 then
		if GetState(SimAlias,STATE_DEAD) then
			return 2 -->sim is dead
		end
		local Distance = GetDistance(SimAlias,"duel_place")
		if Distance > 2000 then
			return 0 --> sim is too far away
		end
		return 1 -->sim is here
	end
	return 2 -->sim does not exists -> sim is dead
end

function Torch(x)
	--make light
	local FireLocatorCount = 1
	while GetFreeLocatorByName("duel_place", "torchflame"..FireLocatorCount, -1, -1, "Fire"..FireLocatorCount) do
		FireLocatorCount = FireLocatorCount + 1
	end
	FireLocatorCount = FireLocatorCount - 1
	local FlameCount = FireLocatorCount
	if x == 1 then
		while(FlameCount > 0) do			
			GfxStartParticle("Flame"..FlameCount, "particles/flame_small.nif", "Fire"..FlameCount, 1)
			Sleep(0.5)
			FlameCount = FlameCount -1	
		end
	else
		while(FlameCount > 0) do			
			GfxStopParticle("Flame"..FlameCount)
			FlameCount = FlameCount -1	
		end
	end
end



----------------------------------------------------
---- AI Functions
----------------------------------------------------

function AIDecideToBetray()
	if Rand(100) < 50 then
		return "A"
	else
		return "B"
	end
end

function AIDecideAction()
	local choice = Rand(100)
	if choice < 25 then
		return "A"
	elseif choice < 50 then
		return "B"
	elseif choice < 75 then
		return "D"
	else
		return "E"
	end
end


function OnCameraEnable()
	CutsceneHUDShow("","LetterBoxPanel")
end

function OnCameraDisable()
	CutsceneHUDShow("","LetterBoxPanel",false)
end

function CleanUp()
	DestroyCutscene("")
end