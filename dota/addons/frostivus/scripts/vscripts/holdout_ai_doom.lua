--[[
Doom AI
]]

behaviorSystem = {} -- create the global so we can assign to it

function DispatchOnPostSpawn()
	AddThinkToEnt( thisEntity, "AIThink" )
	behaviorSystem = AICore:CreateBehaviorSystem( { BehaviorNone, BehaviorAttackWeakest, BehaviorDisableSummoning } )
end

function AIThink() -- For some reason AddThinkToEnt doesn't accept member functions
	if thisEntity:IsNull() or not thisEntity:IsAlive() then
		return nil -- deactivate this think function
	end
	return behaviorSystem:Think()
end

--------------------------------------------------------------------------------------------------------

BehaviorNone = {}

function BehaviorNone:Evaluate()
	return 1 -- must return a value > 0, so we have a default
end

function BehaviorNone:Begin()
	self.duration = 1
	self.order =
	{
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_STOP
	}
end

function BehaviorNone:Continue()
	self.duration = 1
end

function BehaviorNone:Think(dt)
	-- we only want to issue the stop command once
	self.order.OrderType = DOTA_UNIT_ORDER_NONE
end

--------------------------------------------------------------------------------------------------------

BehaviorAttackWeakest = {}

function BehaviorAttackWeakest:Evaluate()
	self.stunAbility = thisEntity:FindAbilityByName("skeleton_king_hellfire_blast")
	local target
	local desire = 0

	-- let's not choose this twice in a row
	if AICore.currentBehavior == self then return desire end

	if self.stunAbility and self.stunAbility:IsFullyCastable() then
		local range = self.stunAbility:GetCastRange()
		target = AICore:WeakestEnemyHeroInRange( thisEntity, range )
	end

	if target then
		desire = RandomInt(5, 10)
		self.target = target
	end

	return desire
end

function BehaviorAttackWeakest:Begin()
	self.duration = 5

	self.order =
	{
		OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
		UnitIndex = thisEntity:entindex(),
		TargetIndex = self.target:entindex(),
		AbilityIndex = self.stunAbility:entindex()
	}
end

BehaviorAttackWeakest.Continue = BehaviorAttackWeakest.Begin --if we re-enter this ability, we might have a different target; might as well do a full reset

function BehaviorAttackWeakest:Think(dt)
	if not self.target:IsAlive() then
		self.duration = 0
		return
	end

	if self.stunAbility:IsFullyCastable() then
		self.order.OrderType = DOTA_UNIT_ORDER_CAST_TARGET
	else
		--it's ok to leave the ability in place; it is ignored by the C code when we do this type of order
		self.order.OrderType = DOTA_UNIT_ORDER_ATTACK_TARGET
	end
end

--------------------------------------------------------------------------------------------------------

BehaviorDisableSummoning = {}

function BehaviorDisableSummoning:Evaluate()
	local desire = 0
	
	-- let's not choose this twice in a row
	if currentBehavior == self then return desire end

	self.summonAbility = thisEntity:FindAbilityByName("ability_summon_disable_witches")
	
	if self.summonAbility and self.summonAbility:IsFullyCastable() then
		self.target = AICore:RandomEnemyHeroInRange( thisEntity, self.summonAbility:GetCastRange() )
		if self.target then
			desire = 20
		end
	end

	return desire
end

function BehaviorDisableSummoning:Begin()
	self.duration = 10

	self.order =
	{
		OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
		UnitIndex = thisEntity:entindex(),
		TargetIndex = self.target:entindex(),
		AbilityIndex = self.summonAbility:entindex()
	}

	self.doneCastingSummon = false
end

BehaviorDisableSummoning.Continue = BehaviorDisableSummoning.Begin

function BehaviorDisableSummoning:Think(dt)
	if not self.doneCastingSummon and not self.summonAbility:IsFullyCastable() and not self.summonAbility:IsChanneling() then
		-- right after we finish casting, go find all the witches
		self.doneCastingSummon = true

		self.witches = {}
		local creatures = FindUnitsInRadius( DOTA_TEAM_BADGUYS, thisEntity:GetOrigin(), nil, -1, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_CREEP, 0, 0, false )
		for _,creature in pairs(creatures) do
			if creature:GetUnitName() == "npc_dota_creature_disable_witch" then
				self.witches[#self.witches + 1] = creature
			end
		end

		self.order.OrderType = DOTA_UNIT_ORDER_NONE
	end

	if self.doneCastingSummon then
		local livingWitch = false
		for _,witch in pairs(self.witches) do
			if not witch:IsNull() and witch:IsAlive() then
				livingWitch = true
			end
		end

		if livingWitch then
			self.duration = 10
		else
			self.duration = 0
			self.target:RemoveModifierByName( "mark_of_doom" )
		end
	end
end
