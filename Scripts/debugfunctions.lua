function EnableWrappers()
	LogMessage( "Function wrappers enabled" )
	-- Replace GetName calls
	RealGetName = GetSettlement
	GetSettlement = function ( a,b )
		local result = RealGetName( a,b )
		if GetID(b) == (-1 or nil) then
			LogMessage("{Fail} BuildingOrPerson("..a..") NewSettlementName="..b)
			return a,b
		end
	end
	

	-- Replace GetID calls
	RealGetID = GetID
	GetID = function ( what )
		local result = RealGetID( what )
		if result == (-1 or nil) then
			LogMessage("{Fail} GetID: ".. what .." = ".. result )
			return result
		end
	end
end