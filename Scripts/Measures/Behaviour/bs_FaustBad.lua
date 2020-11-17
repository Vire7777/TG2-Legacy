function Run()

	local modval = 3
	local RandomSound
	ModifyFavorToSim("Owner","Actor",-modval)

	feedback_OverheadSkill("Owner","@L$S[2006] -%1n", true, modval)

	Sleep(1/Rand(10))

	if SimGetGender("Owner") == GL_GENDER_MALE then
		RandomSound = Rand(5)
		if RandomSound == 0 then	PlaySound3D("Owner","CharacterFX/male_amazed/male_amazed+1.ogg", 1.0)
		elseif RandomSound == 1 then	PlaySound3D("Owner","CharacterFX/male_anger_loop/male_anger_loop+0.ogg", 1.0)
		elseif RandomSound == 2 then	PlaySound3D("Owner","CharacterFX/male_anger_loop/male_anger_loop+1.ogg", 1.0)
		elseif RandomSound == 3 then	PlaySound3D("Owner","CharacterFX/male_anger_loop/male_anger_loop+2.ogg", 1.0)
		elseif RandomSound == 4 then	PlaySound3D("Owner","CharacterFX/male_anger/male_anger+4.ogg", 1.0)
		end
	else
		RandomSound = Rand(7)
		if RandomSound == 0 then	PlaySound3D("Owner","CharacterFX/female_amazed/female_amazed+0.ogg", 1.0)
		elseif RandomSound == 1 then	PlaySound3D("Owner","CharacterFX/female_amazed/female_amazed+1.ogg", 1.0)
		elseif RandomSound == 2 then	PlaySound3D("Owner","CharacterFX/female_amazed/female_amazed+4.ogg", 1.0)
		elseif RandomSound == 3 then	PlaySound3D("Owner","CharacterFX/female_anger_loop/female_anger_loop+0.ogg", 1.0)
		elseif RandomSound == 4 then	PlaySound3D("Owner","CharacterFX/female_anger_loop/female_anger_loop+1.ogg", 1.0)
		elseif RandomSound == 5 then	PlaySound3D("Owner","CharacterFX/female_anger_loop/female_anger_loop+2.ogg", 1.0)
		elseif RandomSound == 6 then	PlaySound3D("Owner","CharacterFX/female_anger_loop/female_anger_loop+4.ogg", 1.0)
		end
	end

	return ""
end
