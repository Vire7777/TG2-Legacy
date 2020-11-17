-------------------------------------------------------------------------------
----
----	OVERVIEW "behavior_childness.lua"
----
----	Behavior of a child from 0 to 4 years of age.
----	The child cannot be controlled by the player and will stay
----	inside the residence playing.
----
-------------------------------------------------------------------------------

-- -----------------------
-- Run
-- -----------------------
function Run()
	
	SimGetMother("","Mother")
	SimGetFather("","Father")
	if AliasExists("Mother") then
		if DynastyIsPlayer("Mother") then
			if not HasProperty("","FirstSchoolMessage") then
				if SimGetAge("") > (GL_AGE_FOR_SCHOOL - 1) then
					local Money = GL_SCHOOLMONEY
					feedback_MessageSchedule("", "@L_FAMILY_149_ATTENDSCHOOL_INTRO_HEAD", "@L_FAMILY_149_ATTENDSCHOOL_INTRO_BODY", GetID(""), Money)
					SetProperty("","FirstSchoolMessage",1)
					SimSetBehavior("", "Schooldays")
					return	
				end
			end
		elseif AliasExists("Father") then
			if DynastyIsPlayer("Father") then
				if not HasProperty("","FirstSchoolMessage") then
					if SimGetAge("") > (GL_AGE_FOR_SCHOOL - 1) then
						local Money = GL_SCHOOLMONEY
						feedback_MessageSchedule("", "@L_FAMILY_149_ATTENDSCHOOL_INTRO_HEAD", "@L_FAMILY_149_ATTENDSCHOOL_INTRO_BODY", GetID(""), Money)
						SetProperty("","FirstSchoolMessage",1)
						SimSetBehavior("", "Schooldays")
						return	
					end
				end
			else
				SetProperty("","IAMAI",1)
			end
		else
			SetProperty("","IAMAI",1)
		end
	elseif AliasExists("Father") then
		if DynastyIsPlayer("Father") then
			if not HasProperty("","FirstSchoolMessage") then
				if SimGetAge("") > (GL_AGE_FOR_SCHOOL - 1) then
					local Money = GL_SCHOOLMONEY
					feedback_MessageSchedule("", "@L_FAMILY_149_ATTENDSCHOOL_INTRO_HEAD", "@L_FAMILY_149_ATTENDSCHOOL_INTRO_BODY", GetID(""), Money)
					SetProperty("","FirstSchoolMessage",1)
					SimSetBehavior("", "Schooldays")
					return
				end
			end
		else
			SetProperty("","IAMAI",1)
		end
	else
		SetProperty("","IAMAI",1)
	end

	-- Check if the sim is at the residence. If not let him move to.
	if not AliasExists("Residence") then
		if SimGetMother("","MyMother")==false or GetHomeBuilding("MyMother", "Residence")==false then
			if SimGetFather("","MyFather")==false or GetHomeBuilding("MyFather", "Residence")==false then
				if not GetHomeBuilding("", "Residence") then
					f_ExitCurrentBuilding("")
					idlelib_GoToRandomPosition("")
					return
				end
			end
		end
	end
	
	if not AliasExists("Residence") then
		f_ExitCurrentBuilding("")
		idlelib_GoToRandomPosition("")
		return
	end
	
	if BuildingGetType("Residence") ~= 2 then 
		f_ExitCurrentBuilding("")
		idlelib_GoToRandomPosition("")
		return
	end
	
	if GetInsideBuilding("", "InsideBuilding") then
		if not GetID("Residence") == GetID("InsideBuilding") then
			f_MoveTo("", "Residence")
		end
	else
		f_MoveTo("", "Residence")
	end	
	
	--idle behaviours
	local Action = Rand(4)
	if Action == 0 then	
		if GetFreeLocatorByName("Residence", "Play",1,3, "PlayPos") then
			if f_BeginUseLocator("","PlayPos",GL_STANCE_STAND,true) then
				PlayAnimation("","child_play_02_in")
				LoopAnimation("","child_play_02_loop",10)
				PlayAnimation("","child_play_02_out")
				f_EndUseLocator("","PlayPos",GL_STANCE_STAND)
			end
		end
	elseif Action == 1 then	
		if GetLocatorByName("Residence", "Apples", "PlayPos") then
			if f_BeginUseLocator("","PlayPos",GL_STANCE_STAND,true) then
				if Rand(100)>50 then
					PlayAnimation("","manipulate_middle_low_r")
					PlayAnimation("","eat_standing")
				else
					PlayAnimation("","cogitate")
				end
			end
		end
	elseif Action == 2 then
		if GetFreeLocatorByName("Residence", "ChildStroll",1,1, "PlayPos") then
			if f_MoveTo("","PlayPos") then
				Sleep(1)
			end
		end
		if GetFreeLocatorByName("Residence", "ChildStroll",2,2, "PlayPos") then
			if f_MoveTo("","PlayPos") then
				Sleep(1)
			end
		end
		if GetFreeLocatorByName("Residence", "ChildStroll",3,3, "PlayPos") then
			if f_MoveTo("","PlayPos") then
				Sleep(1)
			end
		end
		if GetFreeLocatorByName("Residence", "ChildStroll",4,4, "PlayPos") then
			if f_MoveTo("","PlayPos") then
				Sleep(1)
			end
		end
	else
		if GetLocatorByName("Residence", "BearRug", "PlayPos") then
			if f_BeginUseLocator("","PlayPos",GL_STANCE_SITGROUND,true) then
				Sleep(10+Rand(20))
				f_EndUseLocator("","PlayPos",GL_STANCE_STAND)
			end
		end
	end
	
	Sleep(1)
	
end

function CleanUp()
end
