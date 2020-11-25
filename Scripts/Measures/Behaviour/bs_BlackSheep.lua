function Run()
  local	modval = -Rand(5)-5

	if SimGetReligion("") == SimGetReligion("Actor") and modval ~= 0 then
			chr_ModifyFavor("","Actor",modval)
	end

	return ""
end

