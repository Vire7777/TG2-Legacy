function Run()

  local bountyHuntPower = GetImpactValue("Actor","BountyHunt")
  local profession = SimGetProfession("")
  
  -- attack the actor only if more than 16yo 
  if SimGetAge("")<16 then
    --MsgSay("","NO HUNT, I am too young") 
    return ""
  end
  
  -- attack the actor only if not same dynasty
  if GetDynastyID("") == GetDynastyID("Actor") then
    --MsgSay("","NO HUNT, I am same dynasty") 
    return ""
  end
  
  -- attack the actor only if fighter and not guard
	if profession == 21 or profession == 22 or profession == 25 or profession == 34 then
    --MsgSay("","NO HUNT, I am a guard") 
	  return""
	end
	 
  -- attack if doesn t like
	if GetFavorToSim("","Actor")>(10*bountyHuntPower+20) then
	 --MsgSay("","NO HUNT, I like") 
	  return""
	end

	-- attack if no luck
	if Rand(6)>bountyHuntPower+1 then
	 --MsgSay("","NO HUNT, Not lucky") 
    return""
  end
  
	MsgSay("", "@L_MEASURE_BOUNTYHUNT_SPEAK_SUCCESS")
	
	gameplayformulas_SimAttackWithRangeWeapon("", "Actor")
  BattleJoin("","Actor", false)
  
	return""
end

