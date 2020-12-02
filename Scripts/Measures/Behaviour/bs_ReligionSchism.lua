function Run()

	-- if religion is different, then mutual hate
	if SimGetReligion("") ~= SimGetReligion("Actor") then
  		local modval = -Rand(math.floor(SimGetFaith("")/2.5))
		chr_ModifyFavor("","Actor",modval)
	end

	return ""
end

