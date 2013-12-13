--[[-------------------------------------------------------------------------
	Wraith King Reincarnate bookkeeping
-----------------------------------------------------------------------------]]
function WraithKingReincarnateBegin( keys )
	FrostivusGameMode.nExecutingRespawns = FrostivusGameMode.nExecutingRespawns + 1
end

function WraithKingReincarnateEnd( keys )
	FrostivusGameMode.nExecutingRespawns = FrostivusGameMode.nExecutingRespawns - 1

	FrostivusGameMode.nExecutedRespawns = FrostivusGameMode.nExecutedRespawns + 1
	FrostivusGameMode.bQuestTextDirty = true

	keys.caster:AddNoDraw()
	keys.target_entities[1]:SetForwardVector( keys.caster:GetForwardVector() )
end