--[[
Buff Witch AI
]]

target = {}
offset = Vec3(0,0,0)
order = {}
disableAbility = {}
disableCast = false

function DispatchOnPostSpawn()
	AddThinkToEnt( thisEntity, "DisableWitchAIThink" )
	
	local heroes = FindUnitsInRadius( DOTA_TEAM_BADGUYS, thisEntity:GetOrigin(), nil, -1, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, 0, false )
	for _,hero in pairs(heroes) do
		if hero:HasModifier( "mark_of_doom" ) then
			target = hero

			print(target)

			disableAbility = thisEntity:FindAbilityByName("ability_witch_disable")
			order.UnitIndex = thisEntity:entindex()
			order.TargetIndex = target:entindex()
			order.AbilityIndex = disableAbility:entindex()
			order.OrderType = DOTA_UNIT_ORDER_CAST_TARGET

			break
		end
	end
end

function DisableWitchAIThink()
	if not target or target:IsNull() or not target:IsAlive() then
		thisEntity:ForceKill( false )
	end

	if thisEntity:IsNull() or not thisEntity:IsAlive() then
		target:RemoveModifierByNameAndCaster( "witch_disable", thisEntity )
		return nil -- deactivate this think function
	end

	if not disableCast and not disableAbility:IsFullyCastable() and not disableAbility:IsInAbilityPhase() then
		disableCast = true
		order.OrderType = DOTA_UNIT_ORDER_HOLD_POSITION
	end

	ExecuteOrderFromTable(order)

	return 1.0
end
