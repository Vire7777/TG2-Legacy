function Run()
	local modval = 0  --other gender
	local modval2 = 0 --same gender

  
	if GetProperty("Actor", "perfume") == 6 then
	MsgQuick("Actor", "test")
			modval = -Rand(5)-5
			modval2 = -Rand(5)-5
			MsgQuick("Actor", modval)
	elseif GetProperty("Actor", "perfume") == 5 then
      modval = 5
      modval2 = 3
	elseif GetProperty("Actor", "perfume") == 4 then
			modval = 4
			modval2 = 2
	elseif GetProperty("Actor", "perfume") == 3 then
			modval = 3
			modval2 = 1
	elseif GetProperty("Actor", "perfume") == 2 then
			modval = 2
			modval2 = 1
	elseif GetProperty("Actor", "perfume") == 1 then
			modval = 1
	end

	if SimGetGender("") == SimGetGender("Actor") and modval2 ~= 0 then
			chr_ModifyFavor("","Actor",modval2)
	elseif modval ~= 0 then
			chr_ModifyFavor("","Actor",modval)
	end

	return ""
end

