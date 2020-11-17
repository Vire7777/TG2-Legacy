-------------------------------------------------------------------------------
----
----	OVERVIEW "dyn"
----
----	Script functions library for dynasty issues
----
-------------------------------------------------------------------------------

-- -----------------------
-- Init
-- -----------------------
function Init()
 --needed for caching
end

-- -----------------------
-- BlockEvilMeasures
-- -----------------------
function BlockEvilMeasures(BlockerDynAlias, BlockerDynID, Duration)

		if HasProperty(BlockerDynAlias, "NoEvilFrom"..BlockerDynID) then
			local ref = GetProperty(BlockerDynAlias, "NoEvilFrom"..BlockerDynID)
			SetProperty(BlockerDynAlias, "NoEvilFrom"..BlockerDynID, ref+1)
		else
			SetProperty(BlockerDynAlias, "NoEvilFrom"..BlockerDynID, 1)
		end
		
		-- This scriptcall will reset the effect
		
		CreateScriptcall("RemoveBlockEvilMeasures", Duration, "Library/dyn.lua", "RemoveBlockEvilMeasures", BlockerDynAlias, nil, BlockerDynID)
			
end

-- -----------------------
-- RemoveBlockEvilMeasures
-- -----------------------
function RemoveBlockEvilMeasures(BlockerDynID)

		if HasProperty("", "NoEvilFrom"..BlockerDynID) then
		
			local ref = GetProperty("", "NoEvilFrom"..BlockerDynID)
			
			if (ref == 1) then
				RemoveProperty("", "NoEvilFrom"..BlockerDynID)
			else
				SetProperty("", "NoEvilFrom"..BlockerDynID, ref-1)
				return true
			end
		end
		
		return false
end

-- -----------------------
-- EvilMeasuresBlocked
-- -----------------------
function EvilMeasuresBlocked(Blocked, Blocker)

		GetDynasty(Blocker, "DestDyn")
		if HasProperty("DestDyn", "NoEvilFrom"..GetDynastyID(Blocked)) then			
			GetDynasty(Blocked, "DestDyn")
			MsgQuick(Blocked, "@L_GENERAL_MEASURES_FAILURES_+17", GetID("DestDyn"))
			return true
		else
			return false
		end
						
end

function CleanUp()
end
