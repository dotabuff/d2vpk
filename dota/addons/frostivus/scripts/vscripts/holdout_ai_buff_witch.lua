--[[
Buff Witch AI
]]

skeletonKing = {}
offset = Vec3(0,0,0)
order = {}
buffAbility = {}
buffCast = false

function DispatchOnPostSpawn()
	AddThinkToEnt( thisEntity, "BuffWitchAIThink" )
	
	local creatures = FindUnitsInRadius( DOTA_TEAM_BADGUYS, thisEntity:GetOrigin(), nil, -1, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_CREEP, 0, 0, false )
	for _,creature in pairs(creatures) do
		if creature:GetUnitName() == "npc_dota_creature_boss_skeleton_king_1" or creature:GetUnitName() == "npc_dota_creature_boss_skeleton_king_2" or creature:GetUnitName() == "npc_dota_creature_boss_skeleton_king_3" then
			skeletonKing = creature
			
			local summonAbility = skeletonKing:FindAbilityByName( "ability_summon_buff_witches" )
			local desiredLength = summonAbility:GetSpecialValueFor( "spawn_radius" )

			offset = thisEntity:GetOrigin() - skeletonKing:GetOrigin()
			offset.z = 0
			offset = offset * ( desiredLength / offset:length() )

			buffAbility = thisEntity:FindAbilityByName("ability_witch_buff")
			order.UnitIndex = thisEntity:entindex()
			order.TargetIndex = skeletonKing:entindex()
			order.AbilityIndex = buffAbility:entindex()
			order.OrderType = DOTA_UNIT_ORDER_CAST_TARGET 
		end
	end
end

function BuffWitchAIThink()
	if not skeletonKing or skeletonKing:IsNull() or not skeletonKing:IsAlive() then
		thisEntity:ForceKill( false )
	end

	if thisEntity:IsNull() or not thisEntity:IsAlive() then
		skeletonKing:RemoveModifierByNameAndCaster( "witch_buff", thisEntity )
		--skeletonKing:AddNewModifier( thisEntity, nil, "modifier_stunned", { duration = 1 } )
		thisEntity:Remove()
		return nil -- turn off the think
	end

	if not buffCast and not buffAbility:IsFullyCastable() and not buffAbility:IsInAbilityPhase() then
		buffCast = true
		order.OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION
		order.Position = skeletonKing:GetOrigin() + offset
	end

	if buffCast then
		local targetPosition = skeletonKing:GetOrigin() + offset
		if ( thisEntity:GetOrigin() - targetPosition ):length() > 150 then
			order.Position = targetPosition
			order.OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION
		else
			order.OrderType = DOTA_UNIT_ORDER_NONE
		end
	end

	ExecuteOrderFromTable(order)

	return 0.2 -- think frequently to get fairly quick motion
end
