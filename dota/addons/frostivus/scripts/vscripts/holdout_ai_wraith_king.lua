--[[
Skeleton King AI
]]

behaviorSystem = {} -- create the global so we can assign to it

function DispatchOnPostSpawn()
	AddThinkToEnt( thisEntity, "AIThink_Protected" )
	behaviorSystem = AICore:CreateBehaviorSystem( { BehaviorNone, BehaviorAttackWeakest, BehaviorRitualSummoning, BehaviorHellfireEruption, BehaviorSummonTombstone } ) -- BehaviorAttackRandom
	GameRules:SetOverlayHealthBarUnit( thisEntity, 2 )
	behaviorSystem.FirstThink = true
end

function AIThink_Protected()
	local status, value = pcall( AIThink ) -- pcall AIThink so it doesn't fall off on a Lua error
	if status then return value end
	print( string.format( 'Error in WraithKing think! %s', value ) )
	return 1
end 

function AIThink() -- For some reason AddThinkToEnt doesn't accept member functions
	if behaviorSystem.FirstThink then
		SetTowersInvuln( true ) -- invuln towers so he won't attack them
		behaviorSystem.FirstThink = false
	end

	if thisEntity:IsNull() or not thisEntity:IsAlive() then
		local otherEnemies = FindUnitsInRadius( DOTA_TEAM_BADGUYS, thisEntity:GetOrigin(), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BASIC, 0, 0, false )
		for _,enemy in pairs(otherEnemies) do
			if not enemy:IsNull() and enemy:IsAlive() then
				enemy:ForceKill( false )
			end
		end

		if FrostivusGameMode.nExecutedRespawns > 0 then
			FrostivusGameMode.nExecutedRespawns = FrostivusGameMode.nExecutedRespawns - 1
			FrostivusGameMode.bQuestTextDirty = true
		end

		behaviorSystem:Deactivate()

		GameRules:SetOverlayHealthBarUnit( nil, 0 )

		SetTowersInvuln( false ) -- clean up invuln

		return nil -- deactivate this think function
	end

	if Time() > WraithKingStandStillUntil then
		return behaviorSystem:Think()
	else
		local order =
		{
			UnitIndex = thisEntity:entindex(),
			OrderType = DOTA_UNIT_ORDER_HOLD_POSITION
		}
		ExecuteOrderFromTable( order )
		return WraithKingStandStillUntil - Time()
	end
end

function SetTowersInvuln( bInvuln )
	local teamTowers = Entities:FindAllByClassname( "npc_dota_holdout_tower_heavyslow" )
	for i=1,#teamTowers do
		if ( bInvuln ) then
			teamTowers[i]:AddNewModifier( teamTowers[i], nil, "modifier_invulnerable", {} )
		else
			teamTowers[i]:RemoveModifierByName( "modifier_invulnerable" )
		end
	end
end

--------------------------------------------------------------------------------------------------------

BehaviorNone = { newTargetTime = 0 }

function BehaviorNone:Evaluate()
	return 1 -- must return a value > 0, so we have a default
end

function BehaviorNone:Begin()
	self.endTime = GameRules:GetGameTime() + 1

	if self.newTargetTime < GameRules:GetGameTime() then
		self.newTargetTime = GameRules:GetGameTime() + 10
		self.target = AICore:RandomEnemyHeroInRange( thisEntity, FIND_UNITS_EVERYWHERE )
	end

	self.order =
	{
		UnitIndex = thisEntity:entindex(),
		Position = self.target:GetOrigin(),
		OrderType = DOTA_UNIT_ORDER_ATTACK_MOVE
	}
	behaviorSystem.repeatedlyIssueOrders = false
end

function BehaviorNone:Continue()
	self.endTime = GameRules:GetGameTime() + 1
end

function BehaviorNone:Think(dt)
end

function BehaviorNone:End()
	behaviorSystem.repeatedlyIssueOrders = true
end

--------------------------------------------------------------------------------------------------------

BehaviorAttackWeakest = {}

function BehaviorAttackWeakest:Evaluate()
	self.ability = thisEntity:FindAbilityByName("frostivus_wraith_king_hellfire_blast")

	-- let's not choose this twice in a row
	if AICore.currentBehavior == self then return 0 end

	self.target = nil
	if not self.ability or not self.ability:IsFullyCastable() then
		return 0
	end

	local range = self.ability:GetCastRange()
	self.target = AICore:RandomEnemyHeroInRange( thisEntity, range )
	if not self.target then return 0 end

	local distanceToEnemy = (thisEntity:GetOrigin() - self.target:GetOrigin()):length()
	if distanceToEnemy < 300 then return 0 end -- looks bad if they're too close

	return RandomInt(5, 15)
end

function BehaviorAttackWeakest:Begin()
	self.endTime = GameRules:GetGameTime() + 5

	self.order =
	{
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		UnitIndex = thisEntity:entindex(),
		Position = self.target:GetOrigin(),
		AbilityIndex = self.ability:entindex()
	}
end

BehaviorAttackWeakest.Continue = BehaviorAttackWeakest.Begin --if we re-enter this ability, we might have a different target; might as well do a full reset

function BehaviorAttackWeakest:Think(dt)
	if self.target:IsNull() or not self.target:IsAlive() then
		self.endTime = GameRules:GetGameTime()
		return
	end

	if self.ability:IsFullyCastable() then
		self.order.OrderType = DOTA_UNIT_ORDER_CAST_POSITION
	else
		self.endTime = GameRules:GetGameTime()
	end
end

function BehaviorAttackWeakest:End()
	behaviorSystem.repeatedlyIssueOrders = true
end

--------------------------------------------------------------------------------------------------------

BehaviorAttackRandom = {}

function BehaviorAttackRandom:Evaluate()
	local desire = 0

	self.target = AICore:RandomEnemyHeroInRange( thisEntity, 1500 )

	if self.target then
		desire = RandomInt(5, 10)
	end

	return desire
end

function BehaviorAttackRandom:Begin()
	self.endTime = GameRules:GetGameTime() + 5

	self.order =
	{
		OrderType = DOTA_UNIT_ORDER_ATTACK_MOVE,
		Position = self.target:GetOrigin(),
		UnitIndex = thisEntity:entindex(),
	}

	behaviorSystem.repeatedlyIssueOrders = false
end

BehaviorAttackRandom.Continue = BehaviorAttackRandom.Begin --if we re-enter this behavior, we might have a different target; might as well do a full reset

function BehaviorAttackRandom:Think(dt)
	if not self.target:IsAlive() then
		self.endTime = GameRules:GetGameTime()
		return
	end

	self.order.Position = self.target:GetOrigin()
end

function BehaviorAttackRandom:End()
	behaviorSystem.repeatedlyIssueOrders = true
end

--------------------------------------------------------------------------------------------------------

BehaviorRitualSummoning = {}

function BehaviorRitualSummoning:Evaluate()
	local desire = 0

	-- let's not choose this twice in a row
	if currentBehavior == self then return desire end

	self.summonAbility = thisEntity:FindAbilityByName("ability_summon_buff_witches")
	
	if self.summonAbility and self.summonAbility:IsFullyCastable() then
		desire = RandomInt(1, 30)
	end

	return desire
end

function BehaviorRitualSummoning:Begin()
	self.endTime = GameRules:GetGameTime() + 20

	self.order =
	{
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		UnitIndex = thisEntity:entindex(),
		AbilityIndex = self.summonAbility:entindex()
	}

	self.doneCastingSummon = false
end

BehaviorRitualSummoning.Continue = BehaviorRitualSummoning.Begin

function BehaviorRitualSummoning:Think(dt)
	if not self.doneCastingSummon and not self.summonAbility:IsFullyCastable() and not self.summonAbility:IsChanneling() then
		-- right after we finish casting, go find all the witches
		self.doneCastingSummon = true

		self.witches = {}
		local creatures = FindUnitsInRadius( DOTA_TEAM_BADGUYS, thisEntity:GetOrigin(), nil, -1, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_CREEP, 0, 0, false )
		for _,creature in pairs(creatures) do
			if creature:GetUnitName() == "npc_dota_creature_buff_witch" then
				self.witches[#self.witches + 1] = creature
			end
		end

		self.order =
		{
			UnitIndex = thisEntity:entindex(),
			Position = Entities:FindByName( nil, "dota_goodguys_fort" ):GetOrigin(),
			OrderType = DOTA_UNIT_ORDER_ATTACK_MOVE
		}
		behaviorSystem.repeatedlyIssueOrders = false
	end

	if self.doneCastingSummon then
		local livingWitch = false
		for _,witch in pairs(self.witches) do
			if not witch:IsNull() and witch:IsAlive() then
				livingWitch = true
			end
		end

		if not livingWitch then
			self.endTime = GameRules:GetGameTime()
		end
	end
end

function BehaviorRitualSummoning:End()
	if ( self.witches ) then
		for _,witch in pairs(self.witches) do
			if not witch:IsNull() and witch:IsAlive() then
				witch:ForceKill( false )
			end
		end
	end
	behaviorSystem.repeatedlyIssueOrders = true
end

--------------------------------------------------------------------------------------------------------

BehaviorHellfireEruption = {}

function BehaviorHellfireEruption:Evaluate()
	local desire = 0
	
	-- let's not choose this twice in a row
	if currentBehavior == self then return desire end

	self.ability = thisEntity:FindAbilityByName("wraith_king_hellfire_eruption")

	if self.ability and self.ability:IsFullyCastable() then
		local radius = self.ability:GetSpecialValueFor("radius")
		local target = AICore:RandomEnemyHeroInRange( thisEntity, radius )
		if target then
			desire = RandomInt(5, 25)
		end
	end

	return desire
end

function BehaviorHellfireEruption:Begin()
	self.endTime = GameRules:GetGameTime() + 10

	self.order =
	{
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		UnitIndex = thisEntity:entindex(),
		AbilityIndex = self.ability:entindex()
	}
end

BehaviorHellfireEruption.Continue = BehaviorHellfireEruption.Begin

function BehaviorHellfireEruption:Think(dt)
	-- Once we cast, we're done
	if not self.ability:IsFullyCastable() and not self.ability:IsInAbilityPhase() then
		self.endTime = GameRules:GetGameTime()
	end
end

--------------------------------------------------------------------------------------------------------

function CollectTombstoneMarkers()
	local result = {}
	local i = 1
	local wp = nil
	while true do
		wp = Entities:FindByName( nil, string.format("waypoint_%d", i ) )
		if not wp then
			return result
		end
		table.insert( result, wp:GetOrigin() )
		i = i + 1
	end
end
POSITIONS_tombstone = CollectTombstoneMarkers()

BehaviorSummonTombstone = {}

function BehaviorSummonTombstone:Evaluate()
	-- let's not choose this twice in a row
	if currentBehavior == self then
		return 0
	end

	self.ability = thisEntity:FindAbilityByName("wraith_king_summon_tombstone")
	if not ( self.ability and self.ability:IsFullyCastable() ) then
		return 0 
	end

	local allCreatures = Entities:FindAllByClassname( "npc_dota_creature" )
	local nCurrentTombstoneCount = 0
	for _,creature in ipairs( allCreatures ) do
		if creature:GetUnitName() == "wraith_king_tombstone" then
			nCurrentTombstoneCount = nCurrentTombstoneCount + 1
		end
	end

	if nCurrentTombstoneCount >= 4 then
		return 0
	end

	chosenTombstonePosition = POSITIONS_tombstone[ RandomInt( 1, #POSITIONS_tombstone ) ]
	if (chosenTombstonePosition - thisEntity:GetOrigin()):length() < 1000 then
		return 0 
	end 
	local nearbyCreatures = Entities:FindAllByClassnameWithin( "npc_dota_creature", chosenTombstonePosition, 800 )
	for _,creature in ipairs( nearbyCreatures ) do
		if creature:GetUnitName() == "wraith_king_tombstone" then
			return 0 -- Too close, don't do this.
		end
	end

	self.targetPoint = chosenTombstonePosition
	return 100	
end

function BehaviorSummonTombstone:Begin()
	self.endTime = GameRules:GetGameTime() + 10

	self.order =
	{
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		UnitIndex = thisEntity:entindex(),
		AbilityIndex = self.ability:entindex(),
		Position = self.targetPoint
	}
end

BehaviorSummonTombstone.Continue = BehaviorSummonTombstone.Begin

function BehaviorSummonTombstone:Think(dt)
	-- Once we cast, we're done
	if not self.ability:IsFullyCastable() and not self.ability:IsInAbilityPhase() then
		self.endTime = GameRules:GetGameTime()
	end
end
