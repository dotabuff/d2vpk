--[[
Broodmother Spawn Logic
]]

function DispatchOnPostSpawn()
	AddThinkToEnt( thisEntity, "BroodmotherThink" )

	-- Find the closest waypoint, use it as a goal entity if we can
	local waypoint = Entities:FindByNameNearest( "path_invader*", thisEntity:GetOrigin(), 0 )
	if waypoint then
		thisEntity:SetInitialGoalEntity( waypoint )
		ExecuteOrderFromTable({
			UnitIndex = thisEntity:entindex(),
			OrderType = DOTA_UNIT_ORDER_ATTACK_MOVE,
			Position = waypoint:GetOrigin()
		})
	else
		local ancient =  Entities:FindByName( nil, "dota_goodguys_fort" )
		thisEntity:SetInitialGoalEntity( ancient )
		ExecuteOrderFromTable({
			UnitIndex = thisEntity:entindex(),
			OrderType = DOTA_UNIT_ORDER_ATTACK_MOVE,
			Position = ancient:GetOrigin()
		})
	end
end

ABILITY_spawn_spider = thisEntity:FindAbilityByName( "creature_spawn_spider" )

function BroodmotherThink()
	if not thisEntity:IsAlive() then
		return nil
	end

	-- Spawn a broodmother whenever we're able to do so.
	if ABILITY_spawn_spider:IsFullyCastable() then
		ExecuteOrderFromTable({
			UnitIndex = thisEntity:entindex(),
			OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
			AbilityIndex = ABILITY_spawn_spider:entindex()
		})
		return 1.0
	end
	return 0.25 + RandomFloat( 0.25, 0.5 )
end