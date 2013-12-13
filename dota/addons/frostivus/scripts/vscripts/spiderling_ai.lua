--[[
Spiderling Spawn Logic
]]

function DispatchOnPostSpawn()
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
		ExecuteOrderFromTable({
			UnitIndex = thisEntity:entindex(),
			OrderType = DOTA_UNIT_ORDER_ATTACK_MOVE,
			Position = ancient:GetOrigin()
		})
	end
end
