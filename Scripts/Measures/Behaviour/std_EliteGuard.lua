function Run()
	--McCoy Got rid of these pesky guys who answer to no one and added more city guards	
	if (SimGetProfession("")==GL_PROFESSION_ELITEGUARD) then
		Kill("")
	end
end

function CleanUp()
end
