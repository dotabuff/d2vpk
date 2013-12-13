--[[
AI Wraith King Zombie
]]

order = {}

function DispatchOnPostSpawn()
	local creatures = FindUnitsInRadius( DOTA_TEAM_BADGUYS, thisEntity:GetOrigin(), nil, -1, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_CREEP, 0, 0, false )
	for _,creature in pairs(creatures) do
		if creature:GetUnitName() == "npc_dota_creature_boss_skeleton_king_1" or creature:GetUnitName() == "npc_dota_creature_boss_skeleton_king_2" or creature:GetUnitName() == "npc_dota_creature_boss_skeleton_king_3" then
			local healAbility = thisEntity:FindAbilityByName("wraith_king_ghost_heal")
			order.UnitIndex = thisEntity:entindex()
			order.TargetIndex = creature:entindex()
			order.AbilityIndex = healAbility:entindex()
			order.OrderType = DOTA_UNIT_ORDER_CAST_TARGET
			AddThinkToEnt( thisEntity, "AIThink" )
			return
		end
	end

	thisEntity:ForceKill( false )
end

function AIThink()
	-- Got to keep issuing it in case the order drops
	ExecuteOrderFromTable(order)

	return 2.0
end