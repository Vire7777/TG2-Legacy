function Run()
	local VictimArray = {}
	local Found = 0
	for i=0,3 do
		if HasProperty("Actor","Pamphlet_"..i) then
			VictimArray[i] = GetProperty("Actor","Pamphlet_"..i)
			GetAliasByID(VictimArray[i],"Victim_"..i)
			if GetID("")~=GetID("Victim_"..i) then
				chr_ModifyFavor("","Victim_"..i,-5)
			end
			Found = Found + 1
		end
	end
	
	if Found >= 1 then
		GetOutdoorMovePosition("","Actor","MovePos")
		f_MoveTo("","MovePos",GL_MOVESPEED_WALK,100)
		AlignTo("Owner", "Actor")
		Sleep(2)
		local lustig = Rand(4)		
		local j = Rand(Found-1)

		if GetID("")~=GetID("Victim_"..j) then
	    if lustig == 0 then
	    	MsgSay("","_HPFZ_BEHAVIOUR_CHEERBB_SPRUCH_+0",GetID("Victim_"..j))
	    elseif lustig == 1 then
	      MsgSay("","_HPFZ_BEHAVIOUR_CHEERBB_SPRUCH_+1",GetID("Victim_"..j))
	    elseif lustig == 2 then
	      MsgSay("","_HPFZ_BEHAVIOUR_CHEERBB_SPRUCH_+2",GetID("Victim_"..j))
	    else
	      MsgSay("","_HPFZ_BEHAVIOUR_CHEERBB_SPRUCH_+3")
	    end
			if Rand(10)>5 then
				if SimGetGender("")==GL_GENDER_MALE then
					PlaySound3DVariation("","CharacterFX/male_cheer",1)
				else
					PlaySound3DVariation("","CharacterFX/female_cheer",1)
				end
				PlayAnimation("", "cheer_01")
			else
				if SimGetGender("")==GL_GENDER_MALE then
					PlaySound3DVariation("","CharacterFX/male_joy_loop",1)
				else
					PlaySound3DVariation("","CharacterFX/female_joy_loop",1)
				end
				PlayAnimation("", "talk_2")
			end
		end
	end
end

function CleanUp()
	StopAnimation("")
	MoveSetActivity("", "")
end
