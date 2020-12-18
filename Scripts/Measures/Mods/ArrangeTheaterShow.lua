-------------------------------------------------------------------------------
----
----	OVERVIEW "ms_155_ArrangeDanceShow"
----
----	with this measure the player can let the worker at the tavern dance
----
-------------------------------------------------------------------------------

-- -----------------------
-- Run
-- -----------------------
function Run()
	if not SimGetWorkingPlace("","Tavern") then
		if IsPartyMember("") then
			--if SimGetGender("") == GENDER_FEMALE then
				if not GetInsideBuilding("","CurrentBuilding") then
					StopMeasure()
				end
				if BuildingGetType("CurrentBuilding")==GL_BUILDING_TYPE_TAVERN then
					CopyAlias("CurrentBuilding","Tavern")
				else
					StopMeasure()
				end
		--	else 
			--	MsgQuick("","@L_DANCE_FAILURE_+0")
			--	StopMeasure()
				
			--end
		else
			StopMeasure()
		end
	end

	if HasProperty("Tavern", "Show") then
		MsgQuick("", "@L_TAVERN_155_ARRANGETHEATERSHOW_FAILURES_+0",GetID(""))
		return
	end
	
	-- Set this property so that the filter for the measure can check if a dance show is in progress so that only one worker will dance
	GetInsideBuilding("", "Tavern")

	SetData("RemoveProperty", 1)
	SetProperty("Tavern", "Show", 1)
	
	local MeasureID = GetCurrentMeasureID("")

	-- The time in gametime-hours until the measure can be repeated
	local TimeUntilRepeat = mdata_GetTimeOut(MeasureID)
	
	-- Set (in gametime minutes) how often the guests will probably consume additional drinks due to the amusement
	local GuestComsumePeriod = 20
	
	-- Set the chance for guests which have the same sex as the dancer for buying a drink every "GuestComsumePeriod"
	local ConsumeChanceSameSex = 50
	
	-- Set the chance for guests which have the different sex than the dancer for buying a drink every "GuestComsumePeriod"
	local ConsumeChanceDifferentSex = 80
	
	-- The gender of the dancer
	local DancerGender = SimGetGender("")
	
	local ConsumePeriodStartTime = 0
	local TimeStep = 1
	
	-- Look out for the dance position
	if not GetLocatorByName("Tavern", "Dance1", "TheaterPosition") then
		return
	end
	
	SetData("IsProductionMeasure", 1)
	MeasureSetStopMode(STOP_CANCEL)
	-- move to dance position
	f_BeginUseLocator("", "TheaterPosition", GL_STANCE_STAND, true)
	SetData("DanceLocatorInUse", 1)
	
	-- Indicates if a dance animation is played
	local IsActing = false
	
	-- Number of guests during dance show
	local guests = 0
	
	-- Number of turns the script is running
	local turns = 0
	
	local CurrentTime = GetGametime()
	local GameTimeStep = Realtime2Gametime(TimeStep)	
	local AnimationEndTime = 0
	local ActName = ""
	ConsumePeriodStartTime = CurrentTime
	
	-- Get the gender of the dancer
	local Gender = 0
	if SimGetGender("") == GL_GENDER_MALE then
		Gender = 1
	end
	
	PlaySound3D("","Locations/tavern/tavern_aah_01.wav",1)
	Sleep(1)
		
	local playTimes = {2.21, 1.24, 1.5, 2.01, 1.58, 2.55, 3.07, 4.32}
	local timeToPlay = 0
	
	local randomTheater = Rand(4)
	if Gender == 0 then
		timeToPlay = playTimes[randomTheater]
		PlaySound3D("", "theater/leg_TheaterSketch_Female_0"..randomTheater..".ogg", 1)
	else
		timeToPlay = playTimes[randomTheater+3]
		PlaySound3D("", "theater/leg_TheaterSketch_Male_0"..randomTheater..".ogg", 1)
	end
	
	local EndTime = CurrentTime + timeToPlay
		
	-- theater loop
	while CurrentTime < EndTime do
	
		turns = turns + 1
	
		CurrentTime = GetGametime()

		-- start a new dance animation if not dancing
		if IsActing == false then
			
			-- Start the next dance
			--ActName = arrangetheatershow_FindAnimation()
			local anims = {"devotion", "curtsy", "giggle", "cogitate", "threat", "talk", "knee_pray", "preach", "shake_head", "nod", "giggle"}
			local animNumber = Rand(11)

			ActName = anims[animNumber]
			
			local AnimationLength = Realtime2Gametime(GetAnimationLength("", ActName))
			AnimationEndTime = CurrentTime + AnimationLength
		
			if AnimationEndTime > EndTime then
				-- the next anim would last longer than the measure. Do nothing or play a bow-animation.
				PlayAnimationNoWait("", "bow")
				IsActing = true
			else
				PlayAnimationNoWait("", ActName)
				IsActing = true
			end
		end

		-- check if the theater animation still lasts
		if CurrentTime >= AnimationEndTime then
			IsActing = false
		end

		-- Do timing corrections if the next timestep would be longer than the theater show should last
		if (CurrentTime + GameTimeStep) > EndTime then
			TimeStep = EndTime - CurrentTime
			CurrentTime = CurrentTime + 1
		end
		
		-- Increase the amusement if the period is over
		if CurrentTime >= ConsumePeriodStartTime  then
			local Count = BuildingGetSimCount("Tavern")
			
			for l=0,Count do
				if BuildingGetSim("Tavern", l, "Guest") then
			
						-- consume drinks by chance				
						if not (GetDynastyID("Tavern") == GetDynastyID("Guest")) then
							guests = guests + 1
			
							if DancerGender == SimGetGender("Guest") then
								if Rand(100) < ConsumeChanceSameSex then
									SimConsumeGoods("Guest", true, 0)
									arrangetheatershow_Comment("Guest")
								end
							else
								if Rand(100) < ConsumeChanceDifferentSex then								
									SimConsumeGoods("Guest", true, 0)
									arrangetheatershow_Comment("Guest")
								end
							end
							
						end
											
					--end
				end
			end
			
			ConsumePeriodStartTime = CurrentTime + (GuestComsumePeriod / 60)
		end
		
		Sleep(TimeStep)
		
	end

	if guests == 0 then
		feedback_MessageWorkshop("Owner", 
			"@L_TAVERN_ARRANGETHEATERSHOW_MSG_SUCCESS_HEAD_+0", 
			"@L_TAVERN_ARRANGETHEATERSHOW_MSG_SUCCESS_BODY_+0", GetID("Owner"), GetID("Tavern"))
	else
		feedback_MessageWorkshop("Owner", 
			"@L_TAVERN_ARRANGETHEATERSHOW_MSG_FAILED_HEAD_+0", 
			"@L_TAVERN_ARRANGETHEATERSHOW_MSG_FAILED_BODY_+0", GetID("Owner"), GetID("Tavern"), guests)
	end
	
	SetMeasureRepeat(TimeUntilRepeat)
		
end

-- -----------------------
-- The comment during the dance show if the character has the same gender as the dancer
-- -----------------------
function Comment(Guest)
	local random = Rand(2)
	--feedback_OverheadComment(Guest, "L_TAVERN_COMMENT_+"..random, false, true)
	MsgSay(Guest, "L_TAVERN_COMMENT_+"..random)
end

-- -----------------------
-- CleanUp
-- -----------------------
function CleanUp()
	StopAnimation("")
	if HasData("RemoveProperty") then
		-- Remove the property so that another worker will now be able to start a new dance
		RemoveProperty("Tavern", "Show")
	end
end

function GetOSHData(MeasureID)
	--can be used again in:
	OSHSetMeasureRepeat("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+2",Gametime2Total(mdata_GetTimeOut(MeasureID)))
	--active time:
	OSHSetMeasureRuntime("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+0",Gametime2Total(mdata_GetDuration(MeasureID)))
end